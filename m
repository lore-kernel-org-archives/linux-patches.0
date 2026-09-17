Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535F84DEC05;
	Thu, 17 Sep 2026 18:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668109; cv=none; b=ZzVshidvKVhg4ahm6GgPlbu9rCYeqxAXBUyzrvAw+Oy9r5Zz+luacjYC7qSkHtyJvilFhzTyMzb8FzcRGUFtadr8xZDYbVdF4R34NL/kBoZskeFqbG6KgzmsVPZEGna8wz8l6bILAV76edW7w+fbxm3LfjTF9txBZR/pOIxDVcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668109; c=relaxed/simple;
	bh=OmMPxaIbKGej7t/cTcgQR7xHwxeUNHLIXrI3kD4KcY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lu0fwsIOrEuKZAGdAVWgIRixjMYOf2GC7uQu/VBQ75YM2AjsTEvXr7ddmuAUaxX3dyi0Ay8WIIjZAQXXDGA2v3PZIloPm3lldF6H+x6R2AqMWFRAgKxTDOHEvwUXlm0CO0EtOvCRp3xgLFP9y0Ya4GbU0X3esL2dO07bUf6mnOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niv+qSku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niv+qSku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0431F000FF;
	Thu, 17 Sep 2026 18:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668108;
	bh=lj5FPkyWhEDxeTcsSmL0poYV0pxf4kkU7wCDincKajU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=niv+qSkuQmffccaUg4Zms1kRfp+/W7+WfnilUy/TCw/v4kkWSRLMZzzZqcBJeS7bo
	 86giIDeP06BAG3pTKkklM0uzIrsOU5FIRsCPdoEMXALIqMw1kzSo1xh13RFLqUnHHU
	 wgH8APYmAH/v0fMnEm9ZdQQtqC7dKWJ+wHrr2As8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yung-Tse Cheng <mes900903@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0315/1102] virtio-fs: avoid double-free on failed queue setup
Date: Thu, 17 Sep 2026 16:04:18 +0100
Message-ID: <20260917151547.531310127@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yung-Tse Cheng <mes900903@gmail.com>

[ Upstream commit 6af3330ec5d5fb8c06c04eb520a71cf73ea5a765 ]

virtio_fs_setup_vqs() allocates fs->vqs and fs->mq_map before calling
virtio_find_vqs(). If virtio_find_vqs() fails, the error path frees both
pointers and returns an error to virtio_fs_probe().

virtio_fs_probe() then drops the last kobject reference, and
virtio_fs_ktype_release() frees fs->vqs and fs->mq_map again. This leaves
dangling pointers in struct virtio_fs and can trigger a double-free during
probe failure cleanup.

Set fs->vqs and fs->mq_map to NULL immediately after kfree() in the
virtio_fs_setup_vqs() error path so that the later kobject release sees an
uninitialized state and kfree(NULL) becomes harmless.

This can be reproduced when a broken virtio-fs device advertises more
request queues than the transport actually provides. In that case
virtio_find_vqs() fails while setting up the extra queue, and the probe
path reaches the double-free cleanup sequence.

Signed-off-by: Yung-Tse Cheng <mes900903@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/virtio_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index c81f7b888c385..c98e48d7220a1 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -985,7 +985,9 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
 	kfree(vqs);
 	if (ret) {
 		kfree(fs->vqs);
+		fs->vqs = NULL;
 		kfree(fs->mq_map);
+		fs->mq_map = NULL;
 	}
 	return ret;
 }
-- 
2.53.0



