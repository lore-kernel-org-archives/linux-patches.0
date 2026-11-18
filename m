Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049431;
	b=kAz+7Jn31DsogW7p0ymQax/rTjFqZa9fBFEP4wVUQ4fjcUkt0QHmNzkhtfe+V0MF48bk
	 WalUs5L+JMCQ3xNit/PyayEpB8c8ykVMMf5ULjYZfmaci6EUcypIx94FWZjoVcvgQ8joh
	 HcB+ZOAOY6PWUgQiG6UUMN9EGCRckOVLAgFG481FXpQ/Fle6f9FPzqW1jn4i9d06m4v5E
	 cHLi54ulqfs5kM2OepkqhLgLCwiSp+ogT776cZxDeh0EbtD50c2kfKUiO+t1PNISIzALu
	 DEUTkobBcWFGeFOVEWRCIXMtvtEt69ZZOzp5Jk94C0xkpUwgRaYMLagrgUrXAfvk0aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zcQelGhk+0j9yLpKfplQhOTHJw4rVV2aJm/RKI3WC7g=;
	b=KuvoFCCKmef9xbSNQEl9X427VrOhCdt56rOnznZ1svoLYXVaVQjhhwSJGABzVTnKUAq+
	 KQ3hfLZyVXE0JvoopWt+aIIONFbTh0H14CgWUN0oXO2mXz2yHzDzI3uOOpAfKR6jjPBXT
	 bHxwaQiq2yba3SoaHXAiMQKwPdy+dlppshqszO04tqqnlnwDxgJyYYQIUPEcFrrl/11/C
	 DvuFE/5aq7fOex/bchYGtN6C/Mc3wVoZVVoAHMwvVyJRv2rGmZAmFgLfXCZmtQjg1uj7h
	 RkwMRTE0k2ewab1RIuBPZVbdspbZrq2pZFce+iYWvX4d/cM1lAEo/DpBvf/LkwNHVYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrEIbuxo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4749606A325;
	Thu, 19 Nov 2026 00:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rrEIbuxo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469961F000C5;
	Thu, 19 Nov 2026 00:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049430;
	bh=zcQelGhk+0j9yLpKfplQhOTHJw4rVV2aJm/RKI3WC7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rrEIbuxoBPyqR+jTVXjNp7iFWkcYAKRGXy0XEEmW1B1v8xchBpfiHkifxIIYxO1bT
	 9At1tkeQA/iz7vBgixe1Qj4AbzDweSOufj713MhRPVuQhR4FqGnkq5QBrzNGvYW+3W
	 6QArPRfsG5k4OFpGLglgY8eDnoXwIbGkELxA6hnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2348/2857] rtc: abx80x: fix error check after i2c_smbus_read in read_alarm()
Date: Wed, 18 Nov 2026 15:56:22 +0100
Message-ID: <20261118150326.069808276@linuxfoundation.org>
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

From: Antoni Pokusinski <apokusinski01@gmail.com>

[ Upstream commit 07c57022afb3afc0d7c20efef45a4d3c7389b1c0 ]

i2c_smbus_read_i2c_block_data() returns the number of bytes read on
success and a negative error code on failure. The existing code treated
any non-zero return value as an error.

Fix the error handling by checking only for negative return values.

Fixes: 718a820a303c ("rtc: abx80x: add alarm support")
Signed-off-by: Antoni Pokusinski <apokusinski01@gmail.com>
Link: https://patch.msgid.link/20260916205138.16771-3-apokusinski01@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-abx80x.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-abx80x.c b/drivers/rtc/rtc-abx80x.c
index fa5f51d7f527a..6b3a47c6d0108 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -282,8 +282,10 @@ static int abx80x_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 
 	err = i2c_smbus_read_i2c_block_data(client, ABX8XX_REG_ASC,
 					    sizeof(buf), buf);
-	if (err)
+	if (err < 0)
 		return err;
+	if (err < ARRAY_SIZE(buf))
+		return -EIO;
 
 	irq_mask = i2c_smbus_read_byte_data(client, ABX8XX_REG_IRQ);
 	if (irq_mask < 0)
@@ -299,7 +301,7 @@ static int abx80x_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	t->enabled = !!(irq_mask & ABX8XX_IRQ_AIE);
 	t->pending = (buf[6] & ABX8XX_STATUS_AF) && t->enabled;
 
-	return err;
+	return 0;
 }
 
 static int abx80x_set_alarm(struct device *dev, struct rtc_wkalrm *t)
-- 
2.53.0



