Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99088431E6D;
	Mon, 17 Aug 2026 14:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977991; cv=none; b=h/0Pby3+Ch93VF3PxUHBXnBY6krfybC9xhTPpbpAjfejARe4R7R7US67lvfSUbCzdxHkE2ytWXOrobBo9XYjXV2RlnOPF5pjHeRyfO68Eor9pGEpU/N8TDtdN+3kFeZVbOy3Bxj3JqQmTUr2hn0OIBOkmFQJqfknilMihKMZ6fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977991; c=relaxed/simple;
	bh=ToCCwpb11+5EtsJIUCOX6gdxWhfikI7XG+6lerh86HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLBQVfyTlQ+QD8lKO1pgcAs8Vb4QL0Bzkr9PkGfvtUGE6BfyOybb1XoiLIuT9jGVHs6CuAXIoZGmoQdcVLNKwxdVmtlONXsR6g8Eqcj67NBh1Fj7lh0w/wXK8pIC7MdHfe2Q63ODa90FZIt+OQJN0JwAKYnvAjzmy7BlXiIpSZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBY6n/d3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBY6n/d3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A77A1F000E9;
	Mon, 17 Aug 2026 14:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977990;
	bh=GeXR35xiNvx7xH5REum3R6eV4xua97tH5GUujqJ4J20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KBY6n/d3jiyaAZGIPlYq3LVbKsgdmgjlPorRQ7tYt1atn9EV2rgToDReX2W7MHeFB
	 nGA7xKn6M9zAHWGyOI/NuGBA8P6gpWizEJsrO3Uv3+5DeM6/P7laarpAgDnrxSNgHr
	 cOEMGCbbdm5MyARy72cf/MsZPvOCgrDcWMtyOX/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/181] hwmon: (ads7828) Fix external VREF regulator handling
Date: Mon, 17 Aug 2026 15:32:37 +0200
Message-ID: <20260817132537.905877723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

[ Upstream commit fddb5ceaf901b050ed2a1a7deeecbf97e003435a ]

The driver currently has two issues with the external VREF regulator
handling in ads7828_probe():

1. All errors from devm_regulator_get_optional() are ignored, causing the
   driver to incorrectly fall back to internal VREF even for transient
   errors like -EPROBE_DEFER or genuine failures like -ENOMEM.

2. The external regulator is never enabled. The driver calls
   regulator_get_voltage() without first calling regulator_enable(),
   so the VREF pin may remain unpowered if the regulator is not
   configured as always-on.

Fix both issues by switching to devm_regulator_get_enable_read_voltage(),
which handles regulator get, enable, and voltage read in one call.
Only -ENODEV (no regulator specified in device tree) should trigger the
fallback to internal VREF. All other errors are propagated to the caller.

Fixes: a8ddfea09566 ("hwmon: (ads7828) Accept optional parameters from device tree")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Link: https://lore.kernel.org/r/20260805061645.1331652-1-fffsqian@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ads7828.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
index 436637264056c..20ef4992f5bb8 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -106,12 +106,11 @@ static int ads7828_probe(struct i2c_client *client)
 	struct ads7828_data *data;
 	struct device *hwmon_dev;
 	unsigned int vref_mv = ADS7828_INT_VREF_MV;
-	unsigned int vref_uv;
+	int vref_uv;
 	bool diff_input = false;
 	bool ext_vref = false;
 	unsigned int regval;
 	enum ads7828_chips chip;
-	struct regulator *reg;
 
 	data = devm_kzalloc(dev, sizeof(struct ads7828_data), GFP_KERNEL);
 	if (!data)
@@ -125,9 +124,11 @@ static int ads7828_probe(struct i2c_client *client)
 	} else if (dev->of_node) {
 		diff_input = of_property_read_bool(dev->of_node,
 						   "ti,differential-input");
-		reg = devm_regulator_get_optional(dev, "vref");
-		if (!IS_ERR(reg)) {
-			vref_uv = regulator_get_voltage(reg);
+		vref_uv = devm_regulator_get_enable_read_voltage(dev, "vref");
+		if (vref_uv < 0) {
+			if (vref_uv != -ENODEV)
+				return vref_uv;
+		} else {
 			vref_mv = DIV_ROUND_CLOSEST(vref_uv, 1000);
 			if (vref_mv < ADS7828_EXT_VREF_MV_MIN ||
 			    vref_mv > ADS7828_EXT_VREF_MV_MAX)
-- 
2.53.0



