Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038130;
	b=SRatSut/iZwU3HvRp0Qe+KEIJ8fLuzPukTVnI/H4/tqGw09HHfJmoW/5Wh+c5zYwNe2U
	 twrqaDZ3TAVyp7jL2R+mnFGCyQDuhtLOP+ZY9GaMs+pa1CedkTVJnKJdXXHCPfn7dvL2j
	 CjdtJAwjH6hQsHJamHsI/lIkRdcoI9hQiZTwQmA/v39AI9t02emcT079vo18TObwsMcoX
	 59HOD0jI8ql4UbzIB2nzQXRYWf9lGlK1OduwqAXSoQQ0/sVMw4yZV44O5SM4360JfhyE0
	 4r2TweyYL9xV9NwMQSDC/IABwX9FtHOBMHTsB3OVWkLotDWS+MyhoO8lFVLdRzQDRgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Rk51nNhVLz0IIVf35QubdMMuQBUGsAedQoDAeLLvqY=;
	b=PDw+C3a0opysHYZ2OYjJVE26WGMgkg0XeI/at+y2wAPJT2WRKwGiJ9vMdJpgBD4L2E8h
	 7dZ1LAVZrnqWXXOCT3SB2hEjDenoPVLd2jIwqpOf5NZVEemAhr8S9dAW7DqF7w7YtCcgc
	 hLU3kvpXJsjdItn9oSBVT9qEMRRPgQVxAafpNNjxrSM9sFKN7INk5deA81p5EpuPp3rEb
	 NknN3TOrjsAVZxmOghmVLkEXU1zG7iYkkZt5RpmwzUHXTYsyztMgfxxjyg8DyWqKP1kBR
	 Gdc3sAeFMMb9R8s8zB1fpjn4+k56l2ODyhUQcccNvc+bL9nitLKwW87BTMD6bzBCPUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MSZ6ES+B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E72B606A32F;
	Wed, 18 Nov 2026 21:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MSZ6ES+B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463CA1F000C4;
	Wed, 18 Nov 2026 21:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038129;
	bh=4Rk51nNhVLz0IIVf35QubdMMuQBUGsAedQoDAeLLvqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSZ6ES+B4Ruk6HlacbIBhbg8qDcL+kEAxrISyan+zaAzBCiW5ggXeMfDXrtfiOTAu
	 MsMvvTc/zSNJHwXFF1fXWCW2RZvkj852UHGMRTpvfFhpPxbeK9PQjW9DRFfEaj1WKK
	 KZT+A3brjNdpRKmqysczV0bElj2DXPBXNor7S33I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1635/3318] media: redrat3: Error path leaves device in transmitting state
Date: Wed, 18 Nov 2026 15:37:37 +0100
Message-ID: <20261118150410.802196047@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 8024d5e84531d828535365718278f1cf0ce67db0 ]

In the allocation failure error path, the transmitting boolean is not
cleared. If this error path is followed the transmitter cannot be
used again until the device is replugged or the module reloaded.

Fix the error path by moving the assignment statement.

Remove the check for the transmitting state in transmit, since rc-core
ensures there is never a reentrant call to the driver transmit function;
the transmit function is always called with dev->lock held.

The transmitting boolean is only used for interpretting firmware errors.

Fixes: fac59136bc22 ("[media] RedRat3: Return directly after a failed kcalloc() in redrat3_transmit_ir()")"
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: adjusted allocation context for kcalloc() instead of kzalloc_objs() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index aa9242bc604b0..e7407d1ed9dca 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -773,17 +773,9 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 	u8 curlencheck = 0;
 	unsigned i, sendbuf_len;
 
-	if (rr3->transmitting) {
-		dev_warn(dev, "%s: transmitter already in use\n", __func__);
-		return -EAGAIN;
-	}
-
 	if (count > RR3_MAX_SIG_SIZE - RR3_TX_TRAILER_LEN)
 		return -EINVAL;
 
-	/* rr3 will disable rc detector on transmit */
-	rr3->transmitting = true;
-
 	sample_lens = kcalloc(RR3_DRIVER_MAXLENS,
 			      sizeof(*sample_lens),
 			      GFP_KERNEL);
@@ -796,6 +788,9 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
 		goto out;
 	}
 
+	/* rr3 will disable rc detector on transmit */
+	rr3->transmitting = true;
+
 	for (i = 0; i < count; i++) {
 		cur_sample_len = redrat3_us_to_len(txbuf[i]);
 		if (cur_sample_len > 0xffff) {
-- 
2.53.0



