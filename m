Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E812E540B;
	Tue,  8 Jul 2025 16:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993085; cv=none; b=t8moeATDxafXbrZtICbEK0pgUyA/TvZXwLAwdPm5KMPsA9os7q6tfBNZ9z871DJnobptO5+NObhiI8G6dHh/EKGTSpy5izRkd2bnl60AAKjliDXvrABYoaY9u5S4GY9RGBBnIRuVb8OEpgmzH5iwa0jwJIy4GzQ8oKgunmuXyTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993085; c=relaxed/simple;
	bh=mNDiYz6fFI+MK4h8yXJEmtjDT1Vivk7hVTbM+275rbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbbptMwcsioGDpxIAkwu38p8f594IGfIhQMd/IHd5f/u21UMQ/N/9yqcDID1TakBUBvv+e6HvcWu3djkMiBG9dDtRDHnoq0Wd89ilgPXJ96eMTUBZIpZI7kac2yiBv+uwVxJgcR4gLB2+GMy41+QSGa9NFxc3uznbosd4uCthNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cgvg5/w1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cgvg5/w1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6920C4CEED;
	Tue,  8 Jul 2025 16:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993085;
	bh=mNDiYz6fFI+MK4h8yXJEmtjDT1Vivk7hVTbM+275rbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cgvg5/w1JcvHIOhqLJYfwrZozl5l1mNIX1HWetBefcycWZR/dZiQwja95rkFTGPnj
	 eY8nVwyNMAp63WWU61ZhQZV+svZVFru/JOUKB9SDXEE5dPqDAgFA4U3GRilcb/q6Bj
	 2A/fmTHDz4rC3BcdU2tggUT90s+q3uCIUYLHslWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/232] regulator: fan53555: add enable_time support and soft-start times
Date: Tue,  8 Jul 2025 18:22:58 +0200
Message-ID: <20250708162246.196805465@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 8acfb165a492251a08a22a4fa6497a131e8c2609 ]

The datasheets for all the fan53555 variants (and clones using the same
interface) define so called soft start times, from enabling the regulator
until at least some percentage of the output (i.e. 92% for the rk860x
types) are available.

The regulator framework supports this with the enable_time property
but currently the fan53555 driver does not define enable_times for any
variant.

I ran into a problem with this while testing the new driver for the
Rockchip NPUs (rocket), which does runtime-pm including disabling and
enabling a rk8602 as needed. When reenabling the regulator while running
a load, fatal hangs could be observed while enabling the associated
power-domain, which the regulator supplies.

Experimentally setting the regulator to always-on, made the issue
disappear, leading to the missing delay to let power stabilize.
And as expected, setting the enable-time to a non-zero value
according to the datasheet also resolved the regulator-issue.

The datasheets in nearly all cases only specify "typical" values,
except for the fan53555 type 08. There both a typical and maximum
value are listed - 40uS apart.

For all typical values I've added 100uS to be on the safe side.
Individual details for the relevant regulators below:

- fan53526:
  The datasheet for all variants lists a typical value of 150uS, so
  make that 250uS with safety margin.
- fan53555:
  types 08 and 18 (unsupported) are given a typical enable time of 135uS
  but also a maximum of 175uS so use that value. All the other types only
  have a typical time in the datasheet of 300uS, so give a bit margin by
  setting it to 400uS.
- rk8600 + rk8602:
  Datasheet reports a typical value of 260us, so use 360uS to be safe.
- syr82x + syr83x:
  All datasheets report typical soft-start values of 300uS for these
  regulators, so use 400uS.
- tcs452x:
  Datasheet sadly does not report a soft-start time, so I've not set
  an enable-time

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20250606190418.478633-1-heiko@sntech.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fan53555.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index bd9447dac5967..c282236959b18 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -147,6 +147,7 @@ struct fan53555_device_info {
 	unsigned int slew_mask;
 	const unsigned int *ramp_delay_table;
 	unsigned int n_ramp_values;
+	unsigned int enable_time;
 	unsigned int slew_rate;
 };
 
@@ -282,6 +283,7 @@ static int fan53526_voltages_setup_fairchild(struct fan53555_device_info *di)
 	di->slew_mask = CTL_SLEW_MASK;
 	di->ramp_delay_table = slew_rates;
 	di->n_ramp_values = ARRAY_SIZE(slew_rates);
+	di->enable_time = 250;
 	di->vsel_count = FAN53526_NVOLTAGES;
 
 	return 0;
@@ -296,10 +298,12 @@ static int fan53555_voltages_setup_fairchild(struct fan53555_device_info *di)
 		case FAN53555_CHIP_REV_00:
 			di->vsel_min = 600000;
 			di->vsel_step = 10000;
+			di->enable_time = 400;
 			break;
 		case FAN53555_CHIP_REV_13:
 			di->vsel_min = 800000;
 			di->vsel_step = 10000;
+			di->enable_time = 400;
 			break;
 		default:
 			dev_err(di->dev,
@@ -311,13 +315,19 @@ static int fan53555_voltages_setup_fairchild(struct fan53555_device_info *di)
 	case FAN53555_CHIP_ID_01:
 	case FAN53555_CHIP_ID_03:
 	case FAN53555_CHIP_ID_05:
+		di->vsel_min = 600000;
+		di->vsel_step = 10000;
+		di->enable_time = 400;
+		break;
 	case FAN53555_CHIP_ID_08:
 		di->vsel_min = 600000;
 		di->vsel_step = 10000;
+		di->enable_time = 175;
 		break;
 	case FAN53555_CHIP_ID_04:
 		di->vsel_min = 603000;
 		di->vsel_step = 12826;
+		di->enable_time = 400;
 		break;
 	default:
 		dev_err(di->dev,
@@ -350,6 +360,7 @@ static int fan53555_voltages_setup_rockchip(struct fan53555_device_info *di)
 	di->slew_mask = CTL_SLEW_MASK;
 	di->ramp_delay_table = slew_rates;
 	di->n_ramp_values = ARRAY_SIZE(slew_rates);
+	di->enable_time = 360;
 	di->vsel_count = FAN53555_NVOLTAGES;
 
 	return 0;
@@ -372,6 +383,7 @@ static int rk8602_voltages_setup_rockchip(struct fan53555_device_info *di)
 	di->slew_mask = CTL_SLEW_MASK;
 	di->ramp_delay_table = slew_rates;
 	di->n_ramp_values = ARRAY_SIZE(slew_rates);
+	di->enable_time = 360;
 	di->vsel_count = RK8602_NVOLTAGES;
 
 	return 0;
@@ -395,6 +407,7 @@ static int fan53555_voltages_setup_silergy(struct fan53555_device_info *di)
 	di->slew_mask = CTL_SLEW_MASK;
 	di->ramp_delay_table = slew_rates;
 	di->n_ramp_values = ARRAY_SIZE(slew_rates);
+	di->enable_time = 400;
 	di->vsel_count = FAN53555_NVOLTAGES;
 
 	return 0;
@@ -594,6 +607,7 @@ static int fan53555_regulator_register(struct fan53555_device_info *di,
 	rdesc->ramp_mask = di->slew_mask;
 	rdesc->ramp_delay_table = di->ramp_delay_table;
 	rdesc->n_ramp_values = di->n_ramp_values;
+	rdesc->enable_time = di->enable_time;
 	rdesc->owner = THIS_MODULE;
 
 	rdev = devm_regulator_register(di->dev, &di->desc, config);
-- 
2.39.5



