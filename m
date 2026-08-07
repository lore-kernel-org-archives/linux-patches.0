Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CDC18E02A;
	Fri,  7 Aug 2026 15:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115904; cv=none; b=jVblenHk3d18zA+7+EonOigHshs4bnRPB8CiAOqTmR61lrNgGF1MAYalh0VIHoJ5qkD0HOUSkbWbDg6PSgM9aLbWxS7YHgWr5SC+AIKqIt2JZlfhqfAU3GAd9uio7+UJHunI9KoXo/RdDPyDzp1Ki/ngzbu00Om2Z/sgmxa+Doc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115904; c=relaxed/simple;
	bh=3JEm8wfMvcrO5Oldm97CoMW8JPWwm51faKx2WNAukPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SsUj321LniLxtx61QbnKC6Vpd0vRFlELJfCnbfprho1mhknIcClj/4nWSGbuYqUue6by5E64cbGEAbe18MDZeOmSbwwPsYhp9rrqbnCGqbLe57qrsi2QtXNmyJLlW1+mq77D4AXLpQwHu68KUIUI4dIFDyL/2eanWgnTTK+7U8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOJfsaK5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOJfsaK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0907D1F000E9;
	Fri,  7 Aug 2026 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115903;
	bh=F1h3vPiPSiyMExeUngyF71eLJVcoZLqKp34vAfNd3MU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOJfsaK5HHKsrAw9Dp6SzJk9/3qBoksFiqiXXg9TooV2dXFIwdv7XpDNI9VFCIFfd
	 h/NUUNFo5Kzy8RIsViNEe5MW9c+lv5cnOGDXXG0PJJDe/oCHYNIDNN4CgXUOoIirZd
	 /gdk27Sl0ARUCQtAqefRvcAXdKs18tJJTtE3ByqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Bezdeka <florian.bezdeka@siemens.com>,
	=?UTF-8?q?Bj=C3=B6rn=20Gerhart?= <gerhart@posteo.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/261] hwmon: (nct6775-core) Fix number of temperature registers for NCT6116
Date: Fri,  7 Aug 2026 16:36:40 +0200
Message-ID: <20260807143416.314412139@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit b0e8adb2ccb43009796897ced09f91636685c9d3 ]

Unlike NCT6106, NCT6116 only has three temperature registers, and with
it only three temperature source and temperature source configuration
registers. The register addresses match those of NCT6106 and can be
re-used.

The code used a separate array to list the temperature source registers
for NCT6116, but used the size of the NCT6106 register array to set
the number of registers. The NCT6106 register array provides six addresses,
while the temperature source register array for NCT6116 only provides three
addresses. This causes a KASAN report.

BUG: KASAN: global-out-of-bounds in nct6775_probe+0x936/0x46f0 [nct6775]
Read of size 2 at addr ffffffffc19561a6 by task modprobe/954
...
Call Trace:
 dump_stack+0x7d/0xa7
 print_address_description.constprop.0+0x1c/0x220
 ? __kasan_kmalloc.constprop.0+0xc9/0xd0
 ? __kmalloc_node_track_caller+0x194/0x5b0
 ? nct6775_probe+0x936/0x46f0 [nct6775]
 ? nct6775_probe+0x936/0x46f0 [nct6775]
...

Fix the problem by hard-coding the number of temperature and temperature
configuration registers to three for NCT6116. Drop the unnecessary
NCT6116_REG_TEMP_SOURCE array and re-use NCT6106_REG_TEMP_SOURCE.

Reported-by: Florian Bezdeka <florian.bezdeka@siemens.com>
Closes: https://lore.kernel.org/linux-hwmon/57cfc3fa-d4e9-4c10-8aa7-4ad0af7ebebe@roeck-us.net/T/#t
Fixes: 29c7cb485b32 ("hwmon: (nct6775) Integrate new model nct6116")
Cc: Björn Gerhart <gerhart@posteo.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index da4c3425d2d1d..d47ba7cd97727 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -846,8 +846,6 @@ static const u16 NCT6116_FAN_PULSE_SHIFT[] = { 0, 2, 4, 6, 6 };
 static const u16 NCT6116_REG_PWM[] = { 0x119, 0x129, 0x139, 0x199, 0x1a9 };
 static const u16 NCT6116_REG_FAN_MODE[] = { 0x113, 0x123, 0x133, 0x193, 0x1a3 };
 static const u16 NCT6116_REG_TEMP_SEL[] = { 0x110, 0x120, 0x130, 0x190, 0x1a0 };
-static const u16 NCT6116_REG_TEMP_SOURCE[] = {
-	0xb0, 0xb1, 0xb2 };
 
 static const u16 NCT6116_REG_CRITICAL_TEMP[] = {
 	0x11a, 0x12a, 0x13a, 0x19a, 0x1aa };
@@ -3650,7 +3648,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		  = NCT6106_CRITICAL_PWM_ENABLE_MASK;
 		data->REG_CRITICAL_PWM = NCT6116_REG_CRITICAL_PWM;
 		data->REG_TEMP_OFFSET = NCT6106_REG_TEMP_OFFSET;
-		data->REG_TEMP_SOURCE = NCT6116_REG_TEMP_SOURCE;
+		data->REG_TEMP_SOURCE = NCT6106_REG_TEMP_SOURCE;
 		data->REG_TEMP_SEL = NCT6116_REG_TEMP_SEL;
 		data->REG_WEIGHT_TEMP_SEL = NCT6106_REG_WEIGHT_TEMP_SEL;
 		data->REG_WEIGHT_TEMP[0] = NCT6106_REG_WEIGHT_TEMP_STEP;
@@ -3664,13 +3662,13 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 
 		reg_temp = NCT6106_REG_TEMP;
 		reg_temp_mon = NCT6106_REG_TEMP_MON;
-		num_reg_temp = ARRAY_SIZE(NCT6106_REG_TEMP);
+		num_reg_temp = 3;
 		num_reg_temp_mon = ARRAY_SIZE(NCT6106_REG_TEMP_MON);
 		num_reg_tsi_temp = ARRAY_SIZE(NCT6116_REG_TSI_TEMP);
 		reg_temp_over = NCT6106_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6106_REG_TEMP_HYST;
 		reg_temp_config = NCT6106_REG_TEMP_CONFIG;
-		num_reg_temp_config = ARRAY_SIZE(NCT6106_REG_TEMP_CONFIG);
+		num_reg_temp_config = 3;
 		reg_temp_alternate = NCT6106_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6106_REG_TEMP_CRIT;
 		reg_temp_crit_l = NCT6106_REG_TEMP_CRIT_L;
-- 
2.53.0



