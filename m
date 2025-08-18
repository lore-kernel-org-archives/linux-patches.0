Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C592F3218C2;
	Mon, 18 Aug 2025 13:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522595; cv=none; b=TiNCpPst6qkpK7anEs7/34b8ZeFppaL7XMI3U+TqG5qHkoBnXvivND8iC3ZRMu4BUhQA2B3u/KkUVSfZp5oZb5aFujOlO0ekX3ag6ctk0kdrCYRraiHVzOaKiSaOMqkmx6aPbmj3+1vRDK8d90XyL1zYF5tgBxN4G7v0odlhJwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522595; c=relaxed/simple;
	bh=H4e2lzp0us3Ya3BW5lDlYF+YwfWc9vTN43hXv7U3X6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIkXuu5Zw07GaoF2L706k8dTPbLWe0VQDe7ake/SVdsuP9uWmkmTTF5rUkZNIBL/36CqhdexGwWMfMIbx82SQw4uUakGqIoFwne8e0FbOZZfRiLUz2L93pOW/hiNDOy2GJf/SAAKkJsC9E+AqElWa1jmqT3nsW2zY8/0Baykizo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQuUwIb0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQuUwIb0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000D6C4CEEB;
	Mon, 18 Aug 2025 13:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522595;
	bh=H4e2lzp0us3Ya3BW5lDlYF+YwfWc9vTN43hXv7U3X6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQuUwIb04No7P1XNQtq8GjXtc/sQ4eXTseBNiXWnfa9VtHa8nr504KkNj3ba8GYq8
	 RMpkfGkd7ggZQqALxQppuFj7rKX1hIjUNm1PGEqSbRmBklvxExtCM6zDVdEvDc65vw
	 Td6nEWrcbV1VXJLZBK427PY43s/sgBETFfVV4qmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meagan Lloyd <meaganlloyd@linux.microsoft.com>,
	Tyler Hicks <code@tyhicks.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 330/444] rtc: ds1307: handle oscillator stop flag (OSF) for ds1341
Date: Mon, 18 Aug 2025 14:45:56 +0200
Message-ID: <20250818124501.306278296@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



