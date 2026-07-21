Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B402A3AEF58;
	Tue, 21 Jul 2026 22:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673944; cv=none; b=krI+on8XTZodtH0pHwP6iu7CfZyWlydEc5AI9mSnovCoDPfgDOvrW9f+LqizFuFDHzku4JEAKMxKXrjdpdyKNLWrW+Fobi6tPA71nDB+/lbWcxVEWQf08TNsjTB0mpzia9PHbSq1IaG0tb+SUFMfHby+BBEtgUJUQoUlcNd/HXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673944; c=relaxed/simple;
	bh=nK4aJy8kJiVfu6udKtMdmAxhb+U/TSS++rgUKfkqod4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2dGdi7cqACKET2LCAgSuXCw6//6pEct1DsU9hTa6l3cZhtTVru4jN+DwUrpHvx2qAHSAUQ3wPtG4M+4MQKi9sTnJsqD+kQLdYtrj7YsKTdw1m9Bpo7ZeVVO9W1CqqBhAnzeNrEiQbUvRSQ1H+yaia92z2J83x7TdUm85nCusRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7H4Ay78; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7H4Ay78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253D41F000E9;
	Tue, 21 Jul 2026 22:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673943;
	bh=no6D6UA34cj3lImQZLjQP16OipjtIsEjBb4dTi3QF6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7H4Ay78zP8MkfrzEvn02OK+mbi+9TpWGkYF2ZLSJpGG5q1wcI0UgyPd/PybtD+df
	 XB1YXBlYYvyuIp4ftBj/CikYToMv7RXUZUjWNquK+X8QJrDskR+sJTFDhNMPFL6SAO
	 J4u9qHujn1MKxbEPyenvvnRVcJatcbl81JLwOdkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 352/699] rtc: abx80x: fix the RTC_VL_CLR clearing all status flags
Date: Tue, 21 Jul 2026 17:21:51 +0200
Message-ID: <20260721152403.635462752@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoni Pokusinski <apokusinski01@gmail.com>

[ Upstream commit 419719c514252a2dbb2e2976f564c83417dd6d0a ]

The RTC_VL_CLR ioctl intends to clear only the battery low flag (BLF),
however the current implementation writes 0 to the status register,
clearing all status bits.

Fix this by writing back the masked status value so that only BLF is
cleared, preserving other status flags.

Fixes: ffe1c5a2d427 ("rtc: abx80x: Implement RTC_VL_READ,CLR ioctls")
Signed-off-by: Antoni Pokusinski <apokusinski01@gmail.com>
Link: https://patch.msgid.link/20260415160610.127155-2-apokusinski01@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-abx80x.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-abx80x.c b/drivers/rtc/rtc-abx80x.c
index 8d15a68eedb814..280de9a9474dce 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -535,7 +535,8 @@ static int abx80x_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 
 		status &= ~ABX8XX_STATUS_BLF;
 
-		tmp = i2c_smbus_write_byte_data(client, ABX8XX_REG_STATUS, 0);
+		tmp = i2c_smbus_write_byte_data(client, ABX8XX_REG_STATUS,
+						status);
 		if (tmp < 0)
 			return tmp;
 
-- 
2.53.0



