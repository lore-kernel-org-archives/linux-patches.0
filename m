Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591356;
	b=WY6Phyx7zZh+G27cL0S9Za4X+/sSoJpiC6g+o5WQJ2o3WLHU7FWEmaT1IF2HFknwOuHG
	 G9Iv3c4sDXLjk+Bdix0/SfCZx6IhAXU+KKljlYI+oHAzcNX9s67VummI9kK9En199O5Hg
	 EUh1QZZiQfuDLM9mRcsf6xTFdTEv+5d2ewWLx21nZ6YUrrN1hVlxX2XtIKlv1i7iIpLHJ
	 Wh9tNMdZdglApuxhtdeo6D1sLaHAgmZbWR4fsPE1hi0Vcc7tz9Z8jImYOD+6378Jj5F70
	 wrjTBrsaX5bQSJK4kUIVt2ztLuX7H4jTxFJy32xtX6j5dRm6RIW+74DOMp0Q2aSy2gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591356;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WvaiatgA4AA7RSxjJL9xHQ179CkB315TWtGcUepfnjE=;
	b=mRpftfjnWceiQBBFy/wPpuYFDcWjFNU/lIG7SnxLL2XIib+RE8TleOhTdDLZQTPzKv3G
	 +OTBnmNue8hdEH2dZbOrcipDsRiZvTaaHfX3yoliE5x73kzdhYgtsiE/qXUByLdqT3EmO
	 ow6WN+q+oXDcGnvGPhPbeFvsYhrLEQWCXuwxWRDSDCCL7MT5YDnC3dpfSy6YZ9if2/l6K
	 JHzk0NOfUbAVvxtuZLUh1vi3Ionhyp7GxO7GJE6bj9svXW6UNm586EvkPZrP6MnGdRb3k
	 3rWAahv6m+pL3ujA2TddReVZVYOmy9BWOB+g6X06wY3DOCcI8RPNnz429w9mNV2NKWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ms5IRHl3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FDA606CEEC;
	Fri, 13 Nov 2026 17:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ms5IRHl3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F09A1F000C5;
	Fri, 13 Nov 2026 17:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591356;
	bh=WvaiatgA4AA7RSxjJL9xHQ179CkB315TWtGcUepfnjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ms5IRHl3/pDmOAI4mskbiedebZiTL7OgYnC5HsdqKlliTdOSH61ADC/th5bkF9+pU
	 xi3eD9hn7f98TE9oVMk2LibZdTieb04MSfwhRr+Zfbvu9AKBee7GQOdp0/zb16aGAi
	 /GmLr4qmyaHnZnFSdcnrW/TnyJMUWr7V9iNncQic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 461/670] media: redrat3: Error path leaves device in transmitting state
Date: Fri, 13 Nov 2026 10:50:25 -0500
Message-ID: <20261113153827.585358545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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



