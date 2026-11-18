Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026790;
	b=c8pt/oXdYOXdS3IHHbOIqLKLxZ7u6WTE2jWiGudCXC7CTrEkE+y4PZKR6pJotAaCYoXs
	 Wq4tdtjojsDMdugJa0QTNWkaMNBH/tFvY3IUlqGeKDa3I5ku4+N9nLSvS49cBZliWHc5u
	 1BAhMKw2x16XB8UQF/gLXerx/GsX200/GLed+CxqVM8lwr6Sugkyb6Bod6tetrZmrWDV7
	 7PGwRWCwW6RnvuJ+6S3800aDZ2olcRg7fIsXu3wDVHcQykkBxgUtlDDRyZnkLsCigVFtU
	 oRoHnTD4/bbLRoqtVRX7gIrSHDTmmLw+yAMWUrIhqevTf0KSicfqEtG7A4ZbWx6wyXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hGg2AaP0tiqv5p6zk9tOFMUKrhqAWFV/e80IQfuWG3Q=;
	b=RnRlIGtnK3B0+kXqDtPOsyL4SPFCcDIRcjt/GGQJb+OSaab07KDLGkuOQUE4T0LSYQTZ
	 7R9DcPqsJfkdPBOmTyft8W+9IhGfYXfq5H+K67f+VmIuiczFHJb5iX1UqdLcXUK+DFdNV
	 r/+6W4Cqf5UCZJkObbx4wu/oqmTPd5BSfoZcJD8sdmqiOGfERJWrwfngAmffv6fIITVT2
	 Omhnpx14b7/n44+NqCm+KnJBS2eY9kXWLM0kRiPQwgpYcbb2r1r0soHY5mMYkY25Dyg4b
	 YrQ6Aao9A1726fz9G2luRREFIwkHFba9huohKyUx+2P3oTmLTW7dZ52fueL2KiJiV6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Lz/rczb9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB00606A320;
	Wed, 18 Nov 2026 18:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lz/rczb9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1C91F000C4;
	Wed, 18 Nov 2026 18:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026790;
	bh=hGg2AaP0tiqv5p6zk9tOFMUKrhqAWFV/e80IQfuWG3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lz/rczb9VmhNbOGOZI0KFFsCLcEKU6wkD7/vsGO9iYdTCe7mqYNjg2fusWuqdJyn+
	 XyafqZfil///EFYO8X9+7aMeV6wvWXensiPxLpLhdFFClBd2avejao71doiFDEhf+Q
	 dBtt57rXQOPpA4L2M6pL1E21siwElxqgoXfo7arE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Atul Akella <atul.akella@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1518/2151] rpmsg: virtio: fix error handling in TX buffer wait
Date: Wed, 18 Nov 2026 15:54:13 +0100
Message-ID: <20261118150217.146169178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atul Akella <atul.akella@gmail.com>

[ Upstream commit 7dd4cffdf4c2a496ccf783303a03d687a2127baf ]

The TX buffer wait loop in rpmsg_send_offchannel_raw() ignores the
possibility of wait_event_interruptible_timeout() returning a
negative value, which happens when the wait is interrupted by a
signal. In that case the loop spins back around and re-arms the
wait instead of propagating the signal, which can stall a task
that is trying to be killed.

Separately, on a genuine timeout (return value 0) the function
returns -ERESTARTSYS, which is reserved for signal-interrupted
syscalls that the kernel may restart. A timeout is not a signal
and should not be treated as restartable; return -ETIMEDOUT
instead.

Handle both cases explicitly: return err directly when negative,
and return -ETIMEDOUT on timeout.

Fixes: bcabbccabffe ("rpmsg: add virtio-based remote processor messaging bus")
Signed-off-by: Atul Akella <atul.akella@gmail.com>
Link: https://lore.kernel.org/r/20261013160055.1362-1-atul.akella@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/virtio_rpmsg_bus.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index efc4ae029ecb9..7aa70d4efe706 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -535,10 +535,13 @@ static int rpmsg_send_offchannel_raw(struct rpmsg_device *rpdev,
 					(msg = get_a_tx_buf(vrp)),
 					msecs_to_jiffies(15000));
 
+		if (err < 0)
+			return err;
+
 		/* timeout ? */
 		if (!err) {
 			dev_err(dev, "timeout waiting for a tx buffer\n");
-			return -ERESTARTSYS;
+			return -ETIMEDOUT;
 		}
 	}
 
-- 
2.53.0



