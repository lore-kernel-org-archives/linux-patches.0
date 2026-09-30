Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B663B3BE1;
	Wed, 30 Sep 2026 18:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791509; cv=none; b=dBMNOMkP/AWdIdhNX4F0hZ2NgpJGpsvvuob/M/tj8Ppuh8Q1j9vmg17WOFHVQDgU0J9lfmSmn73+m0A8EbJxHnbqK2Rkjg/JIMXTXg1TQpVGtf5JRviMhZkj9mImuHckVR6UEAqHjJyVf7glPv7tCa2T3MmgLoH/r4NR859zFAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791509; c=relaxed/simple;
	bh=qsOIVdUXyi1qPDf4ufDdCwMWABjREPdPdpefsR0CNMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfjCoqDhNSX4Mcnu2GzyfAd8A/5YiqXkgCH2U2VDJGjSHsEsQofYTI5azylme7zvVQiv5OBYpcZegLhXH9/doKvuVIRJjpE7A9anFxAfOpM/Z1LMjVebBWzH5K8JxpayYDGvM3pCkiCIM49hqNrulqi8NTfjICX0TEK8u+eI2Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BWCEj/Iy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BWCEj/Iy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08411F000FF;
	Wed, 30 Sep 2026 18:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791508;
	bh=hl8nXw6zE5viUwetMw8yC2LF5D6+W8fkpXf2Lqicsv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWCEj/IyC18rdzDILWnIuUu0mChR9/3gwqj3Gt6cftrkrGbl35aDhYE305JxSgev4
	 H2mEyR3ml8E/qfVnhIdj2WX+rwfPeQkMPV4s8phiYFuBVroJ4+i29N+Y54kmKKnjHY
	 ZU1BZgVxBlwXRTZJnVrt1f/T7FCcNCiF36YIIFas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianting Tian <xianting.tian@linux.alibaba.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 328/752] virtio-console: call scheduler when we free unused buffs
Date: Wed, 30 Sep 2026 17:23:18 +0200
Message-ID: <20260930152405.393708292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianting Tian <xianting.tian@linux.alibaba.com>

[ Upstream commit 56b5e65efe0001fb5f95e412ee4167363debfc46 ]

For virtio-net we were getting CPU stall warnings, and fixed it by
calling the scheduler: see f8bb51043945 ("virtio_net: suppress cpu stall
when free_unused_bufs").

This driver is similar so theoretically the same logic applies.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
Message-Id: <20230609131817.712867-3-xianting.tian@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 894f98e73983 ("virtio_console: do not free control-out buffers on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/virtio_console.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index bad2bc6c539b9..df48e5e906f85 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1940,6 +1940,7 @@ static void remove_vqs(struct ports_device *portdev)
 		flush_bufs(vq, true);
 		while ((buf = virtqueue_detach_unused_buf(vq)))
 			free_buf(buf, true);
+		cond_resched();
 	}
 	portdev->vdev->config->del_vqs(portdev->vdev);
 	kfree(portdev->in_vqs);
-- 
2.53.0



