Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D23830E82A;
	Mon, 13 Oct 2025 15:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369296; cv=none; b=q8Trzn+L2SssXvp/sGtwLS3j99pmbxgE1NLkl9VKWbVBN0z78hgNLM13LGTGLv8ov/WDweUfESrQlxehe3z6lg2NW41mhzqEMzVEwYU8QG9q3biw7mJ6sPbwNty5iESLXoYXVSeoYScFFGitTAhWGofTP7hgH1bZird04Eu4XBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369296; c=relaxed/simple;
	bh=sheLHEuDuu4EdynuqsF/SKg5fFFqVIPC6zyCJjE39cE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqPECoGz/twUAk8XUcHd286ySCjKQVj3N3d+BHnVj719MNIi8c1okRhkHpJVRDPkWvBaT8ONRqmjnq41YX/sR8jxZFzDGsmnSr62+teNdsMlb52z5ac9WrL0lnLrg/KYQu9M/+MsgrX5/y49smVKjsd6KnRcvCpwUQxWnE0eDxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nhcx2ZlN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nhcx2ZlN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DF4C4CEFE;
	Mon, 13 Oct 2025 15:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369295;
	bh=sheLHEuDuu4EdynuqsF/SKg5fFFqVIPC6zyCJjE39cE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nhcx2ZlNvPJRc50SrKqXQUiWMpgxSpRVzqYreDR8bdObDuSsrxY0fx+fyUexQufTV
	 LIgOZqZIwbyx5sVYniTY3aXRZbcY9Qpq092ngtcgZP+1dve6ZnTRIsNHrG15BPbWDq
	 mO0gO04Obnf/K0A85xwh1jfjEMNocy3NmCE5szXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@nvidia.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 195/563] hwmon: (mlxreg-fan) Separate methods of fan setting coming from different subsystems
Date: Mon, 13 Oct 2025 16:40:56 +0200
Message-ID: <20251013144418.346825189@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit c02e4644f8ac9c501077ef5ac53ae7fc51472d49 ]

Distinct between fan speed setting request coming for hwmon and
thermal subsystems.

There are fields 'last_hwmon_state' and 'last_thermal_state' in the
structure 'mlxreg_fan_pwm', which respectively store the cooling state
set by the 'hwmon' and 'thermal' subsystem.
The purpose is to make arbitration of fan speed setting. For example, if
fan speed required to be not lower than some limit, such setting is to
be performed through 'hwmon' subsystem, thus 'thermal' subsystem will
not set fan below this limit.

Currently, the 'last_thermal_state' is also be updated by 'hwmon' causing
cooling state to never be set to a lower value.

Eliminate update of 'last_thermal_state', when request is coming from
'hwmon' subsystem.

Fixes: da74944d3a46 ("hwmon: (mlxreg-fan) Use pwm attribute for setting fan speed low limit")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20250113084859.27064-2-vadimp@nvidia.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/mlxreg-fan.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/mlxreg-fan.c b/drivers/hwmon/mlxreg-fan.c
index c25a54d5b39ad..0ba9195c9d713 100644
--- a/drivers/hwmon/mlxreg-fan.c
+++ b/drivers/hwmon/mlxreg-fan.c
@@ -113,8 +113,8 @@ struct mlxreg_fan {
 	int divider;
 };
 
-static int mlxreg_fan_set_cur_state(struct thermal_cooling_device *cdev,
-				    unsigned long state);
+static int _mlxreg_fan_set_cur_state(struct thermal_cooling_device *cdev,
+				     unsigned long state, bool thermal);
 
 static int
 mlxreg_fan_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
@@ -224,8 +224,9 @@ mlxreg_fan_write(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 				 * last thermal state.
 				 */
 				if (pwm->last_hwmon_state >= pwm->last_thermal_state)
-					return mlxreg_fan_set_cur_state(pwm->cdev,
-									pwm->last_hwmon_state);
+					return _mlxreg_fan_set_cur_state(pwm->cdev,
+									 pwm->last_hwmon_state,
+									 false);
 				return 0;
 			}
 			return regmap_write(fan->regmap, pwm->reg, val);
@@ -357,9 +358,8 @@ static int mlxreg_fan_get_cur_state(struct thermal_cooling_device *cdev,
 	return 0;
 }
 
-static int mlxreg_fan_set_cur_state(struct thermal_cooling_device *cdev,
-				    unsigned long state)
-
+static int _mlxreg_fan_set_cur_state(struct thermal_cooling_device *cdev,
+				     unsigned long state, bool thermal)
 {
 	struct mlxreg_fan_pwm *pwm = cdev->devdata;
 	struct mlxreg_fan *fan = pwm->fan;
@@ -369,7 +369,8 @@ static int mlxreg_fan_set_cur_state(struct thermal_cooling_device *cdev,
 		return -EINVAL;
 
 	/* Save thermal state. */
-	pwm->last_thermal_state = state;
+	if (thermal)
+		pwm->last_thermal_state = state;
 
 	state = max_t(unsigned long, state, pwm->last_hwmon_state);
 	err = regmap_write(fan->regmap, pwm->reg,
@@ -381,6 +382,13 @@ static int mlxreg_fan_set_cur_state(struct thermal_cooling_device *cdev,
 	return 0;
 }
 
+static int mlxreg_fan_set_cur_state(struct thermal_cooling_device *cdev,
+				    unsigned long state)
+
+{
+	return _mlxreg_fan_set_cur_state(cdev, state, true);
+}
+
 static const struct thermal_cooling_device_ops mlxreg_fan_cooling_ops = {
 	.get_max_state	= mlxreg_fan_get_max_state,
 	.get_cur_state	= mlxreg_fan_get_cur_state,
-- 
2.51.0



