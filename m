Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4590260586;
	Tue, 26 Aug 2025 14:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219458; cv=none; b=sSxsMWLcXbEqxCPFznsMrQdOVLw+BC24B43wGa8F3JTbfIIITCgobovKif/qunTHBfB+SmwzZlYO97uSLIOWQgUPN7qzYaIr1HRFbLOabJhhPqC/BJXr0m1BWuqzRuFM+qNoNgLQvHxzMRvOs1H8feeuTOhZON5H3FCAoZCeq+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219458; c=relaxed/simple;
	bh=7R7qkQzF4JrwktBAWypXs3iVrbUfzNKofc0k/HeNSA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHgbFEqAk8p3ox1CV1m+EU+qfoWuBOlEjoq0QIHLrxUO1UaPUM3NR2Nh4G+RFT4ge+zDP4l1LCXuVSiSSlP5cN88b0TK1/t4oK0EfdoP/bu5XnHdYsM2496EW3/CxSwx1O2DritqGBwv5WoE3w8kdEa3kHEdMOiX9nZeq4ESDtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OI42PMQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OI42PMQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32306C4CEF1;
	Tue, 26 Aug 2025 14:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219458;
	bh=7R7qkQzF4JrwktBAWypXs3iVrbUfzNKofc0k/HeNSA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OI42PMQPaIgQEivLul8bSgknz7MQ9CvBmVkQZYTfG8JqnOhF2mT9euSK5MZc+SseF
	 2RmKeOdKWzsmcU8WhwoGKGF4BKnl+HaoYJITU7DGA4amRATPFJD+/YNZ+crHz49JVl
	 ZByTpCoUclcVApLhqMwTf9rbpQWKEYJzoyWcdeRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	sashal@kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meagan Lloyd <meaganlloyd@linux.microsoft.com>,
	Tyler Hicks <code@tyhicks.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.4 359/403] rtc: ds1307: handle oscillator stop flag (OSF) for ds1341
Date: Tue, 26 Aug 2025 13:11:25 +0200
Message-ID: <20250826110916.913829002@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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

[ Git was trying to insert the code above the ds_1388 case statement block (in
each respective function) which don't exist in the v5.4.296 rtc-ds1307 driver,
thus a manual fixup was required. ]
Signed-off-by: Meagan Lloyd <meaganlloyd@linux.microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Here's the backport of patch 2/2 of the series for v5.4.
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-ds1307.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -252,6 +252,13 @@ static int ds1307_get_time(struct device
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
 	case mcp794xx:
 		if (!(tmp & MCP794XX_BIT_ST))
 			return -EINVAL;
@@ -343,6 +350,10 @@ static int ds1307_set_time(struct device
 		regmap_update_bits(ds1307->regmap, DS1340_REG_FLAG,
 				   DS1340_BIT_OSF, 0);
 		break;
+	case ds_1341:
+		regmap_update_bits(ds1307->regmap, DS1337_REG_STATUS,
+				   DS1337_BIT_OSF, 0);
+		break;
 	case mcp794xx:
 		/*
 		 * these bits were cleared when preparing the date/time


