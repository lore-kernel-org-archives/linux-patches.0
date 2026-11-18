Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015696;
	b=AdX8OJ6gCdGAu3ZOw31kDbX9YfDmg/6ziH8yLu0WfPuw2+YlLIDflNffrk/vj3IvXxc7
	 r78ytZj/mGbqsXDzSsrJ/BCdoZMYC2xEKDQfKgXxkbqonE15puq17Pl/13Rpht2gRz7Q+
	 fdLGvDjesX8Pdr9Fv/OPWqnnTPBZm6emTqcNXzkzkJnxk9EmEyCl9om8J1pAks0oN+951
	 HfOywjBq5UClSGTQBtaFKVw9/uXvuGEITJpW2YIsbYR2DWXf0S62SmSOYCNi7UolCbgkr
	 8oNr9K45WrsMAE8Fglg20obhGMHnk4Qado8t/Twu2x19nvMd4IL1/OaDqGE0Kg8C4ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gTlUK5wIeN/8gr6QUN8UyF9b+j+J62985QmikeaHYME=;
	b=cMBeziIci9A0V1tMW/m4F+lmltpDUC/Rgj3/stMgCEZP78sS80V2PNVfKzMvVkcTo83Q
	 MrVD7cx9MbG49qNJ0qZjDFndg2c6nzniJLEirJTNhrOlIVnzCTxx3j/z7B9rPe8mr4xP0
	 tAkH+wkuskOMmAH/3RB29ZZecc/qPASk6rWeu3kZhDhczXWz0Z762gH9BBKlbgFlCCPUa
	 bF/6IfrYWrhOiJQkZeoXpHcbOnpLb1lsHsXZKQrTFnXXXPg8do6rVPOX5S89ARBB4pYuV
	 jZLe2ps4GSJ6qoEZpHKJyX/rwqUjX4MZpTmPk3/XZHh9S2mhk8uezgCveXaq29u9J6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AR4isqw0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F019760A2603;
	Wed, 18 Nov 2026 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AR4isqw0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506B71F000C5;
	Wed, 18 Nov 2026 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015695;
	bh=gTlUK5wIeN/8gr6QUN8UyF9b+j+J62985QmikeaHYME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AR4isqw0kK5VJM77a2gfW9V5MUDrvbxXMDep4nEE/5RTkngO1O6g6vE//PFdXlrC4
	 Zolq7RDjv+bVM0R8buxV4baVkRCeXy76Tjo8ERw5cmNH9K0ONAaGM98OvXunaFXIU3
	 qgCc9Y3wRh90pdoek5O3bwDKtsCwM1XyYUtW16UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0266/2651] virtio_ccw: fix synchronize_cbs() after interrupt fallback
Date: Wed, 18 Nov 2026 15:25:06 +0100
Message-ID: <20261118150257.477311431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 6e484b870b71eb6acb3fa7a10b8e71098e242033 ]

virtio_ccw_synchronize_cbs() assumes the device uses adapter interrupts
when vcdev->airq_info is not NULL. If registering adapter indicators
fails, virtio_ccw_find_vqs() falls back to classic interrupts but can
leave airq_info set.

With VIRTIO_HARDEN_NOTIFICATION enabled,
virtio_ccw_int_handler() invokes callbacks under vcdev->irq_lock.
synchronize_cbs() instead takes the indicator area lock, so it does
not synchronize with those callbacks.

Use vcdev->is_thinint, which the fallback clears, to select the lock.
Keep the airq_info check because is_thinint can be set before the
first find_vqs() call, when airq_info is still NULL.

Fixes: 3a232277c1ac ("virtio-ccw: implement synchronize_cbs()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260908053817.26065-2-kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/virtio/virtio_ccw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index bab6cad3fd5ce..b90299205698b 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -1062,7 +1062,7 @@ static void virtio_ccw_synchronize_cbs(struct virtio_device *vdev)
 	struct virtio_ccw_device *vcdev = to_vc_device(vdev);
 	struct airq_info *info = vcdev->airq_info;
 
-	if (info) {
+	if (vcdev->is_thinint && info) {
 		/*
 		 * This device uses adapter interrupts: synchronize with
 		 * vring_interrupt() called by virtio_airq_handler()
-- 
2.53.0



