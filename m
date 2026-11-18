Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059392;
	b=5s2QT7PHMM91hNfqrGzrei2gmOM22uCidjN03Lyu7ufe/VnDbNVlL2wpciw/+Gq8H3ws
	 cxIaMwOLvl9xZzOUUITA+7/cWoOQ1JC3lbhmuGMqk8EQj3sssTqRlIzJIOw9q74a0ad1G
	 ABE90EG+znAQ7Lo3bcop0Y8O1c075d3C/1o5m5K6HZQz6AJuttaD93Wa9YmPchD+uckrj
	 HsWQrEcd6Ziiasnc8Gj3w4vuLi2tBmiNc1XEJm96zp2Xhmq+gbPVjD8b4vaC7P0Dm+ia6
	 MfbDS5QtJlHE+4N6lLbi43X16bZjva1em5lAKhJ1j7wUvQl4owp2/2/uNKv/rc6bFsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059392;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h21FWTEsZlgP8N97JkvDswvUhmdmBKSW0Iyin5RhHyE=;
	b=ng58izoLbAwqSNWAfQZUvnb/kTAmsoQkfroNhDKUUU7SI/jjUcgi5LroQw2SknBC67ja
	 uF6IQTJDxAsd4tZD/4UDK38CvD+R7FQBWS8L9tlU7JqncGU0BzfKFz8qftVed8v9Rw9oI
	 Q9hk6ybigpcirWPaYqdvnXG4aNY46DibnxisiXyNLvvVq4zihF20lhKCdIUDaPrdvBLFO
	 IogK6S9J0pKin7QTdgrlQFmA5SkSkyzkZiAKIQnbOrOUAdr38lepAA/N5bThR02C2LPX9
	 55vBMh79utTsj7lc4xnRjjmwT1yfve+HIwt++10FgQzz4mq/Ff5hi8dBVOaaodEfImg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xwscxi0t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFFA606A320;
	Thu, 19 Nov 2026 03:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xwscxi0t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9793B1F000C4;
	Thu, 19 Nov 2026 03:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059392;
	bh=h21FWTEsZlgP8N97JkvDswvUhmdmBKSW0Iyin5RhHyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xwscxi0t6BjUCHIxWLd33VtCaq8Esxw3x3K/EaT3rnVWKjsltVZR1hNhvJK4qayRZ
	 BWEonLbZAD4m4rsiJny1UDqSFpyHI6PMwbW/AykUjHaQMPXsZmwqVtmBXMJ7e2ubIc
	 raK5tqZSUMs7mde2f/L2NL+UbEISDqDJNvkS4amo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0825/1848] media: redrat3: Error path leaves device in transmitting state
Date: Wed, 18 Nov 2026 15:47:43 +0100
Message-ID: <20261118145951.272644063@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 81dd6b9a938b7..4a1189676e551 100644
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



