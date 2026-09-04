Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9034B3DAAB7;
	Fri,  4 Sep 2026 05:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499687; cv=none; b=f2WRr16XTP3mq1NesQ1yOmwjqtAbHsLSLGSzvXaAl2+L0u81+k7lTOY5tixV9aHsYlXLvBkK0PvV7mpOsqlt7BmCC4id3uIelZveug206ovBNORyEqUSS4PF67Eg+sc74McJLUbrqt4cvH8z7FaNJqf0d1bc6eexaECNoqgTeTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499687; c=relaxed/simple;
	bh=gfcj+8+lv07y2JpApLcAuI4/9TgyGrNJg7Fzw+Z+SWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IM6Oqpo4ZX0rw23zNEWzjZ7oj6vH9Domz20H1cGym0MJieFrs9EYghzFEggPm503zWCok8ia9eJXDmWIDkP3fTEJcXMwbFP8tRbd0YSgfKT/kwTt9dNMVEu8KNfvHnfxKB8oS5Eo8o+M3Znk/bzgWSuuXIPLZugu+LLcQJC/EaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pc+npqAc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pc+npqAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A4E1F00A3D;
	Fri,  4 Sep 2026 05:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499686;
	bh=yDrn/zlacMOecMFuGjb1l4Fd1zGsu0cVtK0wi/+daKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pc+npqAcfimtY6OONDV8qFd6GwTKOEWpeK1Pqc1/Wvt7cTKi7Lla/Hmij0CHoWIfI
	 c6fp8oHwqHXO2zbeJIz6XL6w6v6LXDoveexyjD5zLsQybYz2dJqY9lV23yUV+P7AsZ
	 WI6cU4LwpF8X0N8FpcKr4pHC69HlGKzpzIg1UEhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.2 506/713] power: supply: pf1550: enable charging when battery profile exists
Date: Fri,  4 Sep 2026 06:57:54 +0200
Message-ID: <20260904045815.165124533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit af4ee48a09cfb7a2440cc4822e9fda43a76cfbe5 upstream.

PF1550 starts in charger mode 1, where charging is disabled. The driver
comment says that mode 2 should be selected for applications using a
battery, but the condition is inverted: PF1550_CHG_BAT_ON is written only
when power_supply_get_battery_info() fails.

Consequently, a board with a valid monitored-battery profile is left in
the default charger-off mode, while a board without battery information
enables charging with fallback settings.

Select mode 2 when battery information is available.

Fixes: 4b6b6433a97d ("power: supply: pf1550: add battery charger support")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/097F0559A936ACCB+20260724095437.368905-1-raoxu@uniontech.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/pf1550-charger.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/pf1550-charger.c
+++ b/drivers/power/supply/pf1550-charger.c
@@ -514,7 +514,7 @@ static int pf1550_reg_init(struct pf1550
 	 * a battery. The other supported mode is mode 2, the charger is turned
 	 * on to charge a battery when present.
 	 */
-	if (power_supply_get_battery_info(chg->charger, &info)) {
+	if (!power_supply_get_battery_info(chg->charger, &info)) {
 		ret = regmap_write(chg->pf1550->regmap,
 				   PF1550_CHARG_REG_CHG_OPER,
 				   PF1550_CHG_BAT_ON);


