Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026057;
	b=nC4ec+zpJSQI19yO214EaezrCpr7CfSvxAZAtT/m+QQvtPD29+6a/Z6Xt6sWovbLgPXU
	 zAxf0mIqVi/Jdb4W44HoephaEmNnE+TqbGsfw3pMOmxBclSf3yfXSDNemniz4nvV9gQjk
	 IoGfz5cFXFlLWp08YebivHABkh5AaWpdgVWLa/EcQ/hynEVMlPWybVIuNLdfy254+Lvxx
	 bjD2XTNMLzmOiE2S97k5PYs9ynuBx/bo5qF2ltvJYIE6n1blK7kPqo0i9IMCVJc7VtGlM
	 oIKCXhFN45akbIxneaHPSJKwqj4HNzi31DGD6mAMonSLjqzMErqK6zxyyrQzkcZBjXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EYG9tVSKd18Flzpd0KLBrGYbwceSsebvPWppsFSMBPs=;
	b=nAiJPjuSNjv/6PvkTWCEDRau6NBqz4kSdRYT/hrA/T+R/iCQZoqfUXJmpuTdLiasixI3
	 8WHj9E4BFXUxDZcGpj42sg0+tBnPd+E2ddeca2AkDj+WnFnwxQ9vv/94wCu7w1xZB6Lcr
	 CNhF+AYnuSPQGTXVZ1QfNEhGScJSxGNCtpbyU/8mOmgaBRCRxwzOTNyAjBG94LFAkoEsf
	 WDR71m8pRlyGfhW7kRIPg+Q9MST9Y73A/4bDC8KhsPQTDSa+26BxyUsESUS+4SPhWwf/O
	 Z5TgPLdSdugwlkCL3e2+g31v83dFWJowmkLTFe3IQ0C3xMdXzIwuQDAXHzxYM+yo4lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l0MiA9gE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0992606A31C;
	Wed, 18 Nov 2026 18:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l0MiA9gE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC3E1F000C4;
	Wed, 18 Nov 2026 18:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026057;
	bh=EYG9tVSKd18Flzpd0KLBrGYbwceSsebvPWppsFSMBPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0MiA9gEDwLzZEEpyQiQ14crtvNn9KL9D9NqQrbUVXWsQl5WyWjTYpJHLAMBAb5Vo
	 nq142gkMmuUW+240qKBKb5Tmi6HUem9wTn9Qs/XBdWkDF8N9e3MCvtHgxytGyd+P87
	 rvzJK7EbMnJ4rkJxWQQVk6XqD9XAgyWsfNP1e8ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1300/2151] rtc: abx80x: fix error check after i2c_smbus_read in read_alarm()
Date: Wed, 18 Nov 2026 15:50:35 +0100
Message-ID: <20261118150209.464842719@linuxfoundation.org>
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
index 862833519d7f4..ce0bcb03bfbdb 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -294,8 +294,10 @@ static int abx80x_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 
 	err = i2c_smbus_read_i2c_block_data(client, ABX8XX_REG_ASC,
 					    sizeof(buf), buf);
-	if (err)
+	if (err < 0)
 		return err;
+	if (err < ARRAY_SIZE(buf))
+		return -EIO;
 
 	irq_mask = i2c_smbus_read_byte_data(client, ABX8XX_REG_IRQ);
 	if (irq_mask < 0)
@@ -311,7 +313,7 @@ static int abx80x_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 	t->enabled = !!(irq_mask & ABX8XX_IRQ_AIE);
 	t->pending = (buf[6] & ABX8XX_STATUS_AF) && t->enabled;
 
-	return err;
+	return 0;
 }
 
 static int abx80x_set_alarm(struct device *dev, struct rtc_wkalrm *t)
-- 
2.53.0



