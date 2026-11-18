Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039373;
	b=kKJRivZaMuLV3KQejfQbLnIeJsyYn2IMHTIstOcy/4Z8ACN8d5+5Hnr8VYD+WL6CFCn2
	 n1OigwhUCLiUlV9438HY3EOwkaIxztiCyl6iFR7EsUEHWcsepByOFvLaiuomnhqmmUqgC
	 BNMcobq/+XpXHFngeKVqMZGfwpt8Hbp1IwwYZYL/D1UnHjCyRXn6/WUJH2cZkKb2twtPM
	 YQ0xslBwCVbmTm0qTAS+5TlaRcSdaln7NbZGfMVI0DEZpIOoxPs4pvUhxnvdcwN0A146I
	 0EOOQOb03Ct9YXA8XPTkPTR9vHb5EebAcQ1ZG66c0Acz6OXShogN6HbbTRyr0DOoTPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2RCG6NNZtSH9BnuvmbaqPMIwTCmBcihU0GFK8LM207I=;
	b=Xv9RMc0XoMo5+lmlZSy5SQbze58bv1oR+y2NKEpB5bN7O+ClT3ak3HLVtGuumy1JSyLi
	 hQ552dciO8bG1sB3tEs4aC9wDr/XdVr3HkmRZVL9g4wQwpVjJ5ncOk8zoC7qKU3sE2s51
	 OnEEl0x5LkRMjJfGwKE8dBACQAmmKrvsw+qq9lJ0oljLYxK10P+zo5xi7pyY2v+1EyQzF
	 JiJ+KrBsbcbaDHwVwDKEDGBGSS0JhYLuX0jS19KjAMbON5ISb4FfT7fQH6E1XfMas/hZr
	 ReKMTOfqsk1jedo8eXRZtdtjNh9STWRYYFSrZ18iDzQR+4eo1tSE5mW2JWJx5kP5rCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qahPxKaS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C36606A335;
	Wed, 18 Nov 2026 22:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qahPxKaS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D730A1F000C5;
	Wed, 18 Nov 2026 22:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039373;
	bh=2RCG6NNZtSH9BnuvmbaqPMIwTCmBcihU0GFK8LM207I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qahPxKaSywP9feK6ZUePc+HDRAVe8lQOQp1716LAohwAh6DWa9bTYXOy6dfl+48lx
	 T4nn5NLbuSf/yn/a3UMVpZYIIp6455R+3eLbYDZqNZuqW3FdgGxMRbQDYSUe+yP3Gz
	 PsjfPISDJfnwneUufMF62Pv05uUYz4UqTn24zthg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2077/3318] virtio_ccw: always take irq_lock in the classic interrupt handler
Date: Wed, 18 Nov 2026 15:44:59 +0100
Message-ID: <20261118150424.394748155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 48a355cf5b382570975e60857450ff3d42f268e9 ]

virtio_ccw_int_handler() takes vcdev->irq_lock around its
vring_interrupt() calls only when VIRTIO_HARDEN_NOTIFICATION is enabled.

The virtio shutdown path calls synchronize_cbs() even when notification
hardening is disabled. virtio_reset_device() now does so after the
transport reset too.

For classic interrupts, synchronize_cbs() takes vcdev->irq_lock for
writing, but the interrupt handler does not take the matching read
lock in that configuration. synchronize_cbs() can return while a
callback is still running.

Take the read lock unconditionally so the write side can synchronize
with the callbacks.

Fixes: 8bd2fa086a04 ("virtio: break and reset virtio devices on device_shutdown()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260908053817.26065-3-kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/virtio/virtio_ccw.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index e83262ef56e10..1b46ea6b09cc6 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -1158,13 +1158,11 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
 			vcdev->err = -EIO;
 	}
 	virtio_ccw_check_activity(vcdev, activity);
-#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 	/*
 	 * Paired with virtio_ccw_synchronize_cbs() and interrupts are
 	 * disabled here.
 	 */
 	read_lock(&vcdev->irq_lock);
-#endif
 	for_each_set_bit(i, indicators(vcdev),
 			 sizeof(*indicators(vcdev)) * BITS_PER_BYTE) {
 		/* The bit clear must happen before the vring kick. */
@@ -1173,9 +1171,7 @@ static void virtio_ccw_int_handler(struct ccw_device *cdev,
 		vq = virtio_ccw_vq_by_ind(vcdev, i);
 		vring_interrupt(0, vq);
 	}
-#ifdef CONFIG_VIRTIO_HARDEN_NOTIFICATION
 	read_unlock(&vcdev->irq_lock);
-#endif
 	if (test_bit(0, indicators2(vcdev))) {
 		virtio_config_changed(&vcdev->vdev);
 		clear_bit(0, indicators2(vcdev));
-- 
2.53.0



