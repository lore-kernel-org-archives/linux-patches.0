Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4908E411661;
	Tue, 21 Jul 2026 19:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660993; cv=none; b=lD5maeMl1Dz0VkdCf+4h7lqIWRDKkkPWiLnarMBhFZy4hOvdtqHd8FpuPNTBrWTl9FQTPjNU+PuTauZLtyv/dCAsOnvS324PWnXaddPaeKkcrGAt3rPnutqUG7qnIlWZOd7SjqHaRl3u4p2hf2ogYJ/MshNRBvKRTAekfMP4HuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660993; c=relaxed/simple;
	bh=nhIvYLgskoTpvg0BdNaB52g/RE2537syE5cY/dmzpMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dw8lVvBR+KBFU5IWAkqe6OC3VBkceUk6LSiEYuSn2jdIDqAM1ka9me1u7nAD/793aYkzGvPMFgVQDoYNStWWs6S2HJe3b3mhXIi9Cf8EbDnQ3BwhMFBUsu/DzCDd+6tLnvozLDthD5FLw+F7L2teyYPrWsfE5iwattCAucb+iW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdI7BMC9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdI7BMC9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93E51F000E9;
	Tue, 21 Jul 2026 19:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660992;
	bh=WCm0qWZ7s7WMQG2AJldL/2hKfqDKShk/Ggk7QtSQoY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QdI7BMC9nJnFRfbxELSDaVVb0GMR/skrGDqBpHVlHYleskrslzXpQ6e2sDyB76oZ8
	 0HAAnWyRw9IZxPzmUT6ARAra9azUCgefgg4PYxzWVG5iw90bmoIBSssYROjO1qf1F8
	 mz0oCjKfrEdbohMdOjK70AVHyAgeIGogArlr4u4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1189/2077] rtc: abx80x: fix the RTC_VL_CLR clearing all status flags
Date: Tue, 21 Jul 2026 17:14:22 +0200
Message-ID: <20260721152620.862854558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 00d7de64ed3e72..008a70baa69fea 100644
--- a/drivers/rtc/rtc-abx80x.c
+++ b/drivers/rtc/rtc-abx80x.c
@@ -545,7 +545,8 @@ static int abx80x_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 
 		status &= ~ABX8XX_STATUS_BLF;
 
-		tmp = i2c_smbus_write_byte_data(client, ABX8XX_REG_STATUS, 0);
+		tmp = i2c_smbus_write_byte_data(client, ABX8XX_REG_STATUS,
+						status);
 		if (tmp < 0)
 			return tmp;
 
-- 
2.53.0



