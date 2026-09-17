Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D3553A386;
	Thu, 17 Sep 2026 17:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664587; cv=none; b=JjOlvxkh8gpmbCZUrHhZrB3cHhoRETNNknAdiHU3VwbMT2txOsYI4Ps5tsGgvwt7de9l3VuQOKPip4RrLvZ8ZjRvQDKpLHXAlQEsYUkRX/AE9mwIghBouOFFRk2E/i648Y6VI4vjrw/Dl2s03cR0+hiB/KRIK6Lcl8yRIRHmf1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664587; c=relaxed/simple;
	bh=FJH1WsMJx/5JK9vkRqw2YX7JNxwU8r6aMwEqCc7zyzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blxaUp3ZOr9nTxU4D2imHgmvNh4dSGeIs/xXtcbP56mz+SZ02q1KAjdfD7+DZS1fi5of1iMQyxDwetB+0afJYlbjo6G7Izvqs+FIfyP6m/1f2u4o3tFSkasCsBp+zRUxFpzOlnUN/LnBrcqBl9q8GVTj0Gz2U9jkDCoZMXWVtO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2L8lmiu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2L8lmiu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B21C21F00893;
	Thu, 17 Sep 2026 17:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664585;
	bh=mb5O31YZ4+1PSl4oqoAn93i0WPqLNQSndHZH9F76S+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g2L8lmiuzmIFGqzaZoEin2ISwQk88G2GNHJ9OrB6oFgCOjXcpTF+i1tu6nkk6GXCI
	 kZQSLMkdXv7SJZcA/LmL5qEfEW13w8mXa3NHDpUQrOwv1j8rdNp8DdVn6iiDoLe/6e
	 yTTP2YV0WyOUgM9XEzRcrUVgm+Q3hyeasW8aXRsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yung-Tse Cheng <mes900903@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0420/1250] virtio-fs: avoid double-free on failed queue setup
Date: Thu, 17 Sep 2026 16:03:35 +0100
Message-ID: <20260917151603.403280077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b2f6486fe1d56..2b3daa93e299a 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -988,7 +988,9 @@ static int virtio_fs_setup_vqs(struct virtio_device *vdev,
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



