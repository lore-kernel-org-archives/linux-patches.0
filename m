Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED629321425;
	Mon, 18 Aug 2025 14:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525988; cv=none; b=UHZ/5559oRd8AplDvDRShfopeasgn+21f63hUxEuOcJAoa1oaAopfVpbGfIiYqwFKk8ETVIk2QFJNRhVhBUQa/kC4ZJR5/k1FnEHtkTmub7EJ7qG/zKzvCCiEwqfdPdLptHtMer1ejIqOkM/XaeNKQSZVtevFDU31DLzPEoFcyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525988; c=relaxed/simple;
	bh=bmN+UDpggAVCwUl/XiZsS3Wp32NLNp9I/7jkCC3Sj8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBpxAAX9kH5VOAol43+Ql9iFu+NT5bKUW5NBdi+suTVYBPQFXzVFG8h0YIQ1Z+WoGAij4iBSWrpBJ5xXrkHC1pXKesPqE6NK4d4azHx+XDu3UwZJ6mlxmqPvBymU63+z70bSyycKVTvcI+U7chX/MukBrQyOaXxS1IuSF3tuzwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3HIfu0f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3HIfu0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FBA9C4CEEB;
	Mon, 18 Aug 2025 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525987;
	bh=bmN+UDpggAVCwUl/XiZsS3Wp32NLNp9I/7jkCC3Sj8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3HIfu0fGOSy83/Pen+/VU674+joy2jPtmoOIifiiOBrxQu5Wqsqtmfe/iVzNpasN
	 cPAP521ET1wsO6ztMeXJwktdnKaVcW/4yCaOGLVOCp3+wrGhqmOuHBN9dnEU/kNaPk
	 aVv44a4rIOhOeCqgWHmlTgz+0SCE2lwU78t9l7f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meagan Lloyd <meaganlloyd@linux.microsoft.com>,
	Tyler Hicks <code@tyhicks.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 426/570] rtc: ds1307: handle oscillator stop flag (OSF) for ds1341
Date: Mon, 18 Aug 2025 14:46:53 +0200
Message-ID: <20250818124522.248971181@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Meagan Lloyd <meaganlloyd@linux.microsoft.com>

[ Upstream commit 523923cfd5d622b8f4ba893fdaf29fa6adeb8c3e ]

In using CONFIG_RTC_HCTOSYS, rtc_hctosys() will sync the RTC time to the
kernel time as long as rtc_read_time() succeeds. In some power loss
situations, our supercapacitor-backed DS1342 RTC comes up with either an
unpredictable future time or the default 01/01/00 from the datasheet.
The oscillator stop flag (OSF) is set in these scenarios due to the
power loss and can be used to determine the validity of the RTC data.

This change expands the oscillator stop flag (OSF) handling that has
already been implemented for some chips to the ds1341 chip (DS1341 and
DS1342 share a datasheet). This handling manages the validity of the RTC
data in .read_time and .set_time based on the OSF.

Signed-off-by: Meagan Lloyd <meaganlloyd@linux.microsoft.com>
Reviewed-by: Tyler Hicks <code@tyhicks.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://lore.kernel.org/r/1749665656-30108-3-git-send-email-meaganlloyd@linux.microsoft.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index c8a666de9cbe..c6d388bb4a19 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -279,6 +279,13 @@ static int ds1307_get_time(struct device *dev, struct rtc_time *t)
 		if (tmp & DS1340_BIT_OSF)
 			return -EINVAL;
 		break;
+	case ds_1341:
+		ret = regmap_read(ds1307->regmap, DS1337_REG_STATUS, &tmp);
+		if (ret)
+			return ret;
+		if (tmp & DS1337_BIT_OSF)
+			return -EINVAL;
+		break;
 	case ds_1388:
 		ret = regmap_read(ds1307->regmap, DS1388_REG_FLAG, &tmp);
 		if (ret)
@@ -377,6 +384,10 @@ static int ds1307_set_time(struct device *dev, struct rtc_time *t)
 		regmap_update_bits(ds1307->regmap, DS1340_REG_FLAG,
 				   DS1340_BIT_OSF, 0);
 		break;
+	case ds_1341:
+		regmap_update_bits(ds1307->regmap, DS1337_REG_STATUS,
+				   DS1337_BIT_OSF, 0);
+		break;
 	case ds_1388:
 		regmap_update_bits(ds1307->regmap, DS1388_REG_FLAG,
 				   DS1388_BIT_OSF, 0);
-- 
2.39.5



