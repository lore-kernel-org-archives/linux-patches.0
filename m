Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063810;
	b=VrS/J5M2dhqZIEUUk8Jd54cuZmf3NKSldOszjrr50jYX4XqM+d0Dj0lf7x4Y8EqTijpH
	 5IA+e6grFWTAokNgh1TvLfNyG6IEErFw4qw2WuRUQLKhAg18AocMvW44ZN2cKAC05teAe
	 o6DbcOfC45cOMlriYOIFybkIcyTupyymyJRQOasrMVy3NkpBUa8MAtvzNJDExzilPSLQw
	 O54qoS0GX19Cebtm19xFDS/fBXxT5NwGkjAPvfyBJfylUMoZVu9gWxBtB51PN1Jszt4Bh
	 asfUFqHwQcz9LJnPe9i3Uo60yJy203yPUwVmVDX4wM02itdyCKsd76d28Obf4UiGkSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DJ11ImIzeqkdrjejsV5H+oJrYDAsLfyPqXmkZwItblo=;
	b=pQ5669UdeLdjjpk5tvRyRmthldbsfUt/3irnlhMcX+PmBLpcp8bF5uLPD1uaQqtfh0yW
	 Vxe7zAa5FONn+dS8sRXNrMACTSPxcZT4VoavU06G+Lkuc+ZTHca4iZR4DypfdHVMerLA2
	 vj5yb468JnB/vurszV+NExEXc08zdWpmR6u5mQ5qN8C8dDDb0FDME2Or1NSceDm0TUsmp
	 91wtMUb5eeUJklvtBgkTADQHbxQ9lsc3yyZlg5PqqxZj0dFj/iaOAsaOc3Bg9mUGjT6Ct
	 8n6ZOFGiZtQVntzQEEsdW9u2xsLW7+pXVo8MOisaPNsNJD+Bmn+vC23YFK5JqqndEuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3IMsHSH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51565606EE81;
	Sat,  7 Nov 2026 15:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x3IMsHSH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008401F0089F;
	Sat,  7 Nov 2026 15:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063810;
	bh=DJ11ImIzeqkdrjejsV5H+oJrYDAsLfyPqXmkZwItblo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x3IMsHSHdEWymW1Jza1B0GTdifk2aMj7M5jPzUFo4SPzjmdI64tqRlfUE+oUUolXA
	 g3vfYkYpV4/fW5RIPpxieYLxnA3jk2RX2qIdv6P+gKkruwsne9iVsr1/gU94FbRNBU
	 42g5X5SCBapykKB2Lzbm+96VfvfVtxLiKePQxlls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0028/1257] media: redrat3: Error path leaves device in transmitting state
Date: Sat,  7 Nov 2026 08:38:44 -0500
Message-ID: <20261107134940.183581740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index fc514d9f868b1..3e82b5e66477e 100644
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
 	sample_lens = kzalloc_objs(*sample_lens, RR3_DRIVER_MAXLENS);
 	if (!sample_lens)
 		return -ENOMEM;
@@ -794,6 +786,9 @@ static int redrat3_transmit_ir(struct rc_dev *rcdev, unsigned *txbuf,
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



