Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931432E0B45;
	Tue,  8 Jul 2025 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992438; cv=none; b=Ozi74PvDRjQq7znRYioM3zu/4cvpIoVSKqza+MKIk9AK5MjFTx5MbxZynwQ7jb3BGJdnZw091KjYmqw6m4r4d03hqgFDRyMfXQPh402helOmoyApl6hnNp+YPSlcQaX+oCglZM6Clh929st95iCrtIkczVMRwDn8tDtAKL0mxgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992438; c=relaxed/simple;
	bh=v1IpYQQcswDUzwFVq0fsCQSuNjxvq45z9FjyN1v1oao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=de503SQYrvt2dfyahSqqCXMyX9eWkz+8xyzR6KZMfeX+tZNkaFXGRbF3vHk5/lqLgdB0aGqdDIGofgbCztjXFz83EkI524t0SMxVKBeZm2iB4cqEOnke+GAOftSbWinrh2/sfpMYHHRg3EoR1mlVPWyrv0ZKxaMWoweUwu/d7gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XM11aW4G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XM11aW4G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFD8C4CEED;
	Tue,  8 Jul 2025 16:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992438;
	bh=v1IpYQQcswDUzwFVq0fsCQSuNjxvq45z9FjyN1v1oao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XM11aW4GQCTPBq8HBaMej8LULRMztF9iN3PnFENESbbfZ6dlWu+dckJBz4WgezMIp
	 VJi6I97EF07YX51gx0av0Xwa7qu17JCkztPo8giT3jZ2bwdtXIXz8DpvJWSm+Q75Su
	 xh8IqP2s3NN+zhUDCD2OrfmZ9h0mlV1vUBlGRd0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/132] regulator: fan53555: add enable_time support and soft-start times
Date: Tue,  8 Jul 2025 18:23:23 +0200
Message-ID: <20250708162233.313323641@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162230.765762963@linuxfoundation.org>
References: <20250708162230.765762963@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 48f312167e535..8912f5be72707 100644
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



