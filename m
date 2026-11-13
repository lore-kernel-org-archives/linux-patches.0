Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590588;
	b=qhdhXZisVr+dPrNBUhqmpjEfcsFQbkNCQWytf3a1Bkf6StyXrF2zOd67YXqee7rhlKfb
	 K7TFnmnJXlaAqDCUUlQDfMpB1nP+IcoeJ/eLNlphGaZeLILw1mTHB5Z/e8a/WzgEmElwq
	 eJrpvtz9SGYTThuJ9fSbZbhxlLjo5jp8zBR0wuNC641Z5rcuhFnlTYQBNLOi1O6XP4OBZ
	 9Hb6MqavBonXF14cbaLi/cKh8yRxdBlxkjQUOs//NKvz2lfzbCqA9u99BdkYLJP/VDMHr
	 AcxSfOsCf3Ry+mCiiGGG+k0Osx1sYz6Cp4kYLzdzpisEJTJ9XBEt+IHaEDH/8gmzNjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zz/6U018h8uzn3skGcj1QEEXflpbCOpedKwBN33gX4M=;
	b=2hPGgKpmcOdNgYDz1lxMzy7LqaPU6kR1/0DjuDD5Ewsj5khKSgpLpzxVL5864qeUtqQW
	 GbzFmcej9jj2wJsy0Z5qHVyUf+XujIFiSaUck0ckymba/8I8ZtXzYMAazirybscrQ3YxM
	 ZvhxPziJ4hfVCSe0SA8OfbMgm9fq8CPEfIW/UI1+4poMlySEtD+4CMpbT23XwErnO+Ctx
	 bO9dAMrFev8Ao+84q+6UYvF2YusZY1pB5Dhwwi07cO2YxP5V0reRXBB6vq98RhCAdv8vA
	 +FBkrQcbiNLGlDpXNlkPxnh7SPX31uTCD5/lvR2Ar8mnZDtLJpYG6MiOV48WEfJb4EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jB3Qtu/f";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246D5606C098;
	Fri, 13 Nov 2026 17:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jB3Qtu/f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50C61F000C6;
	Fri, 13 Nov 2026 17:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590588;
	bh=zz/6U018h8uzn3skGcj1QEEXflpbCOpedKwBN33gX4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jB3Qtu/fYhjKi//4DZ89OUJc7ViP0M9CAdEY5YpXo1P6dxUI3snatUH7fHOHJUBfK
	 7s1PnnCVz/sJpzphe+4/czHvNzjCsrnxN9tN2N4BZOx/FbzceAEzLVxnrVXib7OOdC
	 IFoN0OkNVNiV6oq7VzcEFPqEiux6q8lXTtV0ydxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 520/686] media: redrat3: Error path leaves device in transmitting state
Date: Fri, 13 Nov 2026 10:50:53 -0500
Message-ID: <20261113153838.766677131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
[ sashal: Adjusted allocation context to retain existing kcalloc() and kzalloc() calls instead of kzalloc_objs() and kzalloc_obj(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index c9a5c030f7726..080207aa888ce 100644
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



