Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048539;
	b=dswJnsbHpYr7iPtoqP81oxt0GfN2PCHTsnKRZNkmMFVcQS8Wzkgfxs/lSwWVEeiOjdRu
	 qpuxdCoXJct6S2KbGviajL+XgQ7wlz4X42mZHgBLPxgRztrf61UYDf8x+IC1QjtnYyNbc
	 l9CwOWuILxDZ79adFrpSLdiQFRImALF3rPnNpOyBAE/unLpKYfp2hvBuahEXgzjyBB0aO
	 e1K8Oyj2lrDlkYcGfafSChI1hs9jbe42e37kTSkn3qszQxK8NNn++Z8Q/nnCJCCQcer+l
	 tDCTHIeSAzI9uIDjPCHEbRCfHTQp1kSFLETVV1ihsqVpSB3X1eGaZAty1372qnUWTBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ztxBl380V/mi+LQXTuaoB1x7pW39awL7G1OSeqwaCs=;
	b=u2SkxIL3zn7Th+MkJJ7PHxjxZNvtuwq+Z1LwCcoeonRZTERWVY1JP0jbDbfhGtGY68ZF
	 REsQj1qFrDnFa/r/VibXF4qOryQx/zbqd/MN5rIfX2KUQPNI6EufTJr8HakrMQu/QB/sJ
	 k4GHwOwqm0+BQCZL4top8UEcYZEklqJibBr7GGNbdscKP0xvHP0EX07uaCyUsYJM6PeFg
	 Frvm+uFyQ8NYoQ3PjNtNnZRhTJiF33GArQ88bc31ik8Gr/sY2XtYMZmaC56OGrQyX11xr
	 FneT4eAKPhR2udnfucuUN47COqRs3vhgcflfCNOUTijQ09Btu1lGZ8MnTxupzuejfoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0uJqcpaq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01034606A31C;
	Thu, 19 Nov 2026 00:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0uJqcpaq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5597C1F000C4;
	Thu, 19 Nov 2026 00:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048538;
	bh=5ztxBl380V/mi+LQXTuaoB1x7pW39awL7G1OSeqwaCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0uJqcpaqnRgVQxQJqlBpSQ0DKepCTztPLBdeEBCvCjJxtc+k/+v5oRrXxPhmxQdvF
	 5Oj49lldw8tKhYyI98OyI6OvZNMobI5Kwtuj31S1CkK/ZqY+Wp2T3AtPZpmnygefuC
	 0v76hD39qe2hg1xNRN9AK9F8JnTUyq5K0K/DSakU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Vivier <laurent@vivier.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Stan Johnson <userm57@yahoo.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2028/2857] swim: Revisit delays
Date: Wed, 18 Nov 2026 15:51:02 +0100
Message-ID: <20261118150314.426006131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

[ Upstream commit bbcd3e38a4f355d6b0320f3f6916df96c109f2ad ]

AFAIK, timing requirements for the various FDHD drive mechanisms aren't
well documented. But we do have the UPD72070 spec and secondary sources
like swim3.c and mkLinux source code. This patch is needed to satisfy
the requirements in the UPD72070 spec and follows mkLinux.

Change the LSTRB pulse to 2 microseconds, because this is what mkLinux
does. Inside Macintosh says, "Hold LSTRB high for at least one usec but
not more than one msec".

When a disk is ejected, pause before de-asserting /ENBL. Wait 150 us after
the STEP command for valid signalling. Pause for 1 us after setting the
step direction before sending the STEP command.

Fixes: 8852ecd97488 ("m68k: mac - Add SWIM floppy support")
Reviewed-by: Laurent Vivier <laurent@vivier.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Link: https://patch.msgid.link/af356248a1e6a4fd956f71acf17feead27ba4918.1788513997.git.fthain@linux-m68k.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index d75897d473c6f..6b9a07d0f7c5a 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -291,7 +291,7 @@ static inline void swim_action(struct swim __iomem *base, int action)
 	swim_select(base, action);
 	udelay(1);
 	swim_write(base, phase, LSTRB | action | PHASE_PIN_DIR);
-	udelay(1);
+	udelay(2);
 	swim_write(base, phase, action | PHASE_PIN_DIR);
 	udelay(1);
 
@@ -338,6 +338,7 @@ static inline void swim_drive(struct swim __iomem *base,
 		swim_write(base, mode0, EXTERNAL_DRIVE);
 		swim_write(base, mode0, MOTON);
 	}
+	udelay(1);
 }
 
 static inline void swim_motor(struct swim __iomem *base,
@@ -356,6 +357,7 @@ static inline void swim_eject(struct swim __iomem *base)
 {
 	swim_action(base, EJECT);
 	swim_readbit_timeout(base, DISK_IN, false, 2000 * 1000);
+	msleep(1);
 }
 
 static inline void swim_head(struct swim __iomem *base, enum head head)
@@ -369,6 +371,7 @@ static inline void swim_head(struct swim __iomem *base, enum head head)
 static inline int swim_step(struct swim __iomem *base)
 {
 	swim_action(base, STEP);
+	udelay(150);
 	return swim_readbit_timeout(base, STEP, false, 20 * 1000);
 }
 
@@ -399,6 +402,7 @@ static inline int swim_seek(struct swim __iomem *base, int step)
 		step = -step;
 	} else if (step > 0)
 		swim_action(base, SEEK_POSITIVE);
+	udelay(1);
 
 	swim_READY_timeout(base);
 
-- 
2.53.0



