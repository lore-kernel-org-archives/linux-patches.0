Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019366;
	b=Q0goYoJZFPv0siVPMhLtKNIpWVn6FUsL+pXBo95Jh6ZynD2OayKsD0cmRoOjz7daacpm
	 gT30xkAyew73Kczyhh/TLonySvdUkdHjOmahPNRW8W6fYPtJfSl8mJXu30XgD3lgNSh5H
	 AKMgfZaSKtrAnAf0GEpbbKZmL5y+Yi0TjR1WqIYgDZGPrlHpAFDCgfSTjRfcq0nSGFCHA
	 IYjkHBJ6Qj9qU7AuFEh3MTo/P/qEcoVsxBJy/jtJqhZFz/eQP+w0eR0UW5Q8gymXCur4p
	 cBML8tYi+aRolwcm58wvYoA4TjnbSfHjl6d3P2UZ7x2FlJSnHfDbFewPwLna1ATvt2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vvjMHHxNMCHGfIcre8bgbeP4qjjfbHDDUaPdDkn6Czc=;
	b=QVze9qfIQmSIejeckE3Gxl/MYsoFhIcKADCrqABLzSG+7bhiVDqsUoNlSYUeEA+SJmPK
	 8WetvdY8jspmz4UIuqXuL45wIQy/5oQVT+wc2zII5lfoToeJeiViHCo3RIHxnWii3NUIt
	 QTNbGPqHfWJlQDSnSnkigSXghbu6zj99uVTZMu+QlBTpPdvgjldm0Vtf/loVL9p0z4lMT
	 6j9QVqItY2hQRdQ1OghOtisGRw7+kYhO3cvc3uP0GQOCDsedprmKYXGa7fNeoqY0J460G
	 DWlRPQ2wzlUliS4IM/J0q0tVVYmbKRttbFQD+lfIAwtQeKViflCR2YIKg1n5a+UNTVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1zHkAefs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E3560A2609;
	Wed, 18 Nov 2026 16:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1zHkAefs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B89B31F000C4;
	Wed, 18 Nov 2026 16:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019366;
	bh=vvjMHHxNMCHGfIcre8bgbeP4qjjfbHDDUaPdDkn6Czc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1zHkAefsuWbtFILNObKgunrQEVhp981gBZ62Dpxla93NShoeEjKd63gKDlHzRmsIW
	 V5xZSy636X+iOf2zMtjPW8XbWFbHoWEApmDclFTlrg2zYkxCvGVelMeHk4mNCzf835
	 IvvmXhodTGbqewznynL94gUaeCSbXZ0pLy8W7QtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1568/2651] rtc: abx80x: fix error check after i2c_smbus_read in read_alarm()
Date: Wed, 18 Nov 2026 15:46:48 +0100
Message-ID: <20261118150344.393725653@linuxfoundation.org>
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
index 5486d9d0b1e5d..e4fd7b5d4b110 100644
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



