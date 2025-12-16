Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F0E37C10A;
	Tue, 16 Dec 2025 12:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888600; cv=none; b=llyGxYn4KWtw9kf5IH/yKXU6MMcCEnokNhgsreBE6TuRK292W+NAFjqvo1k/QS/LXUfJLNuWtYjnX7cI+Dptb4uDmo6NOATjjoXsCAJjH4WgyUNDXAhotEO2ZtxVKG5OGER8Y0K6apYP7tGiWudhYwuiWMG5M2t+FjkxQK2Wve0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888600; c=relaxed/simple;
	bh=sRrRbLkHt3n4WYt9V2VG7wFCfM7QWFXjcH+iod93U9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dY76wO71jfDAVXroSHwnbol243tqIducRwRVAPKwuCSYwZhH9P9wbauR6IPVP7wWTVO7ly/60P18twm74z1u0uyiklLgzcKGVOSV0mGGBQs/uqvzlBsx6SYXK9/rOgVxm7r9WCVg+HKLUQOh0X15sxDLAnAu62U9JNvMxcjtC2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iP7eDP8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iP7eDP8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FA0C4CEF5;
	Tue, 16 Dec 2025 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888600;
	bh=sRrRbLkHt3n4WYt9V2VG7wFCfM7QWFXjcH+iod93U9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iP7eDP8Fme7m4bUCQwNAwCvdUKHyU2d/wVXCfC4u47EyRkh9k8n2lWOrxU6eBZ4gI
	 n6LKMi13da+dMghbgvzJduyo4SEP/pbmxjnXTDPwCbW9GpQrh2PbwUEanoXsjbguse
	 76DC1fvVUydvBA/QIHHgwdipQ8sZmYfl4lKjTXPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Martinez Canillas <javierm@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 582/614] regulator: spacemit: Align input supply name with the DT binding
Date: Tue, 16 Dec 2025 12:15:49 +0100
Message-ID: <20251216111422.475245541@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Martinez Canillas <javierm@redhat.com>

[ Upstream commit 99f0c3a654c4a762aca4fadc8d9f8636b36d570a ]

The Device Tree binding schema for the SpacemiT P1 PMIC defines the main
input supply property as "vin-supply", but the driver defines the supply
name for BUCK and ALDO regulators as "vcc".

This causes the regulator core to lookup for a non-existent "vcc-supply".
Rename the supply from "vcc" to "vin", to match the DT binding and ensure
that the regulators input supplies are correctly resolved.

After this change, the regulators supply hierarchy is correctly reported:

  $ cat /sys/kernel/debug/regulator/regulator_summary
   regulator                      use open bypass opmode voltage current     min     max
  ---------------------------------------------------------------------------------------
   regulator-dummy                  1    0      0 unknown     0mV     0mA     0mV     0mV
   dc_in_12v                        2    1      0 unknown 12000mV     0mA 12000mV 12000mV
      vcc_4v                        7   10      0 unknown  4000mV     0mA  4000mV  4000mV
         buck1                      1    0      0 unknown  1050mV     0mA   500mV  3425mV
         buck2                      1    0      0 unknown   900mV     0mA   500mV  3425mV
         buck3                      1    0      0 unknown  1800mV     0mA   500mV  1800mV
         buck4                      1    0      0 unknown  3300mV     0mA   500mV  3300mV
         buck5                      3    7      0 unknown  2100mV     0mA   500mV  3425mV
            dldo1                   0    0      0 unknown  1200mV     0mA   500mV  3125mV
            dldo2                   0    0      0 unknown   500mV     0mA   500mV  3125mV
            dldo3                   0    0      0 unknown   500mV     0mA   500mV  3125mV
            dldo4                   1    0      0 unknown  1800mV     0mA   500mV  3125mV
            dldo5                   0    0      0 unknown   500mV     0mA   500mV  3125mV
            dldo6                   1    0      0 unknown  1800mV     0mA   500mV  3125mV
            dldo7                   0    0      0 unknown   500mV     0mA   500mV  3125mV
         buck6                      1    0      0 unknown  1100mV     0mA   500mV  3425mV
         aldo1                      0    0      0 unknown  1800mV     0mA   500mV  3125mV
         aldo2                      0    0      0 unknown   500mV     0mA   500mV  3125mV
         aldo3                      0    0      0 unknown   500mV     0mA   500mV  3125mV
         aldo4                      0    0      0 unknown   500mV     0mA   500mV  3125mV

Fixes: 8b84d712ad84 ("regulator: spacemit: support SpacemiT P1 regulators")
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patch.msgid.link/20251206133852.1739475-1-javierm@redhat.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/spacemit-p1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/spacemit-p1.c b/drivers/regulator/spacemit-p1.c
index d437e6738ea1e..2bf9137e12b1d 100644
--- a/drivers/regulator/spacemit-p1.c
+++ b/drivers/regulator/spacemit-p1.c
@@ -87,10 +87,10 @@ static const struct linear_range p1_ldo_ranges[] = {
 	}
 
 #define P1_BUCK_DESC(_n) \
-	P1_REG_DESC(BUCK, buck, _n, "vcc", 0x47, BUCK_MASK, 254, p1_buck_ranges)
+	P1_REG_DESC(BUCK, buck, _n, "vin", 0x47, BUCK_MASK, 254, p1_buck_ranges)
 
 #define P1_ALDO_DESC(_n) \
-	P1_REG_DESC(ALDO, aldo, _n, "vcc", 0x5b, LDO_MASK, 117, p1_ldo_ranges)
+	P1_REG_DESC(ALDO, aldo, _n, "vin", 0x5b, LDO_MASK, 117, p1_ldo_ranges)
 
 #define P1_DLDO_DESC(_n) \
 	P1_REG_DESC(DLDO, dldo, _n, "buck5", 0x67, LDO_MASK, 117, p1_ldo_ranges)
-- 
2.51.0



