Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624273;
	b=5Rn6yZp/J6apVbb+fy4q6iC27EtRjMyJxJEZ/FbgfWagpmX0ID94vyqhb7vE0ZHVHcQG
	 BvK+sl3OQhQVbILlmjssu4AjKd2h/XcVatmlQUIQl4uo1elyUraP9j3YUOOIIc+W9JCcg
	 3Tao7Qvs6R1V0+EWux599RSV+r/I+rAonlrEP9MoEe6rI7vmwJTjmvzTCgHm6hQD5qSZU
	 0Ocr6ulVFbibXRY5TTGM/+PToSSLINmm8jK9ynQOQeUlpG6sBfxdEBzLeMfk9V6L8Nw6o
	 IlHYk2DvZ02YkbJE96ScPhKWLN5ryiE9k6v8ohwyKLj3MeuKdTQFN1ezS912EHHPFEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rD3MzSTD+iLOccIPNTqQ8kVJKD8jJU34AlgDaFAhlZ8=;
	b=hODC0JJdklyMO/qlTtNd7l/2mzLevITABhEBpDFhX0SYHcUNt91dBa5AbZOw+eYSqrnw
	 w54btJz9jBpvOUOdVgtOoVE0gcQ+tMlVvQaf0nqK8pNbmfPkPKRcWnqkaWAUK4CaC43rf
	 EbuCBJk7k3ur8Q7bcVDKfx1ZZp/c23bOpdJFHP7VxMHw/JlQOH8XetA0nZi84p+Sfd8RN
	 CplMMXcZPUlzUhbEri16obnkA34/j4DETSp8VwbXlb1dB9Ww7Qykd1ohheVNztGHSNN4X
	 7MnpRuW0FD6mSR+4KcIXwoEA1biAEI97kozmqsTP65NX59j7a2VGVjOlovBlnxX2T4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XphwAjC3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC035606A695;
	Wed, 25 Nov 2026 16:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XphwAjC3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF3B41F000C4;
	Wed, 25 Nov 2026 16:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624273;
	bh=rD3MzSTD+iLOccIPNTqQ8kVJKD8jJU34AlgDaFAhlZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XphwAjC3FZhaOJMyYZGAvRXmjzRLkWQs5KkWzYEdOLmmaI89pCS3a+fJMXV24hoqh
	 j6ZchsUsI/EqJ1CMHXJm/oOFLQ19O8gJn/zh/yAvuKFZPGlIMRhvunfJ2BKDyrxgvU
	 oHh4bRSWn7hrFEZhoRmholKAhcHpcGMCTiuNjkkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <oss.patchbox@gmail.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 141/816] virtio_blk: Reset device on probe error paths after DRIVER_OK
Date: Wed, 25 Nov 2026 15:28:09 +0100
Message-ID: <20261125143852.464436928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <oss.patchbox@gmail.com>

[ Upstream commit f4f6e9a9cb349003d333f0776de94f12ac95b8d2 ]

virtblk_probe() marks the device ready before revalidating zones and
adding the disk, and either of those can fail.  The out_cleanup_disk path
they take goes on to delete the virtqueues, but nothing tells the device
to stop first, so it is still live when the rings are freed.

Reset the device at out_cleanup_disk, which is only reachable after
virtio_device_ready().  virtblk_remove() and virtblk_freeze_priv() both
reset before deleting the virtqueues for the same reason.

Fixes: dbb301f91fc8 ("virtio_blk: add error handling support for add_disk()")
Signed-off-by: Yuho Choi <oss.patchbox@gmail.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260922211207.523999-1-oss.patchbox@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/virtio_blk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 81d9ac1c4869d..8b01011599a78 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -1584,6 +1584,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 	return 0;
 
 out_cleanup_disk:
+	virtio_reset_device(vdev);
 	put_disk(vblk->disk);
 out_free_tags:
 	blk_mq_free_tag_set(&vblk->tag_set);
-- 
2.53.0



