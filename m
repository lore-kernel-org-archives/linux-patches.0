Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A451F6693;
	Tue,  3 Dec 2024 15:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240696; cv=none; b=bhFCKnY2JT6Jms3kKh6q278wYmKUQoz8i35DUcWDetC4CnW3xlFdI5cWy6m6pSN3l38fidLOCftiymmiYB65h2bBcXZP3fbKjvEWj9In7LprUSgNrW5w5gIYyNk++jn0li9LNF2Kytly4diCCsYmI1l3SG0T5eC76HptSKJVG8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240696; c=relaxed/simple;
	bh=HpyGsw22t0WrC8xPUdrZTKd/z+kljfkHRiirGgA2o80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fbx0zKSNTtitE1vbhDVRvpwMoiQHlKJEFvmoCNtwWGwbnfXfZBorxEE7vWBayBYYtMPGUaE29wyap+29PgLlfJlqKpwnUxfmorZv2p1k/QiQosV60p/WV6yKOYxytzG8yHbGoehduv4LgN6PUYtskyN68Shh+UOVMWy+mViD2yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPgzl1nC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPgzl1nC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CCDC4CECF;
	Tue,  3 Dec 2024 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240695;
	bh=HpyGsw22t0WrC8xPUdrZTKd/z+kljfkHRiirGgA2o80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPgzl1nCqT1wdksyXGAAReyC2tzzqIIwdQs2lDK57MuqGZQtoKN8B+laj9n2vgSQw
	 iQ6oPMQpJedvfEULTCrJLGx3ryWx7kyNOAvPKKupFOK7oDNaEQaHNfealfL9SUUnzq
	 TaWReD7N9sUbADWpvOW1BjxEZhLLqPKHyyTu4IcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Casey G Bowman <casey.g.bowman@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 178/826] platform/x86: asus-wmi: Fix inconsistent use of thermal policies
Date: Tue,  3 Dec 2024 15:38:25 +0100
Message-ID: <20241203144750.680615893@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 895085ec3f2ed7a26389943729e2904df1f88dc0 ]

When changing the thermal policy using the platform profile API,
a Vivobook thermal policy is stored in throttle_thermal_policy_mode.

However everywhere else a normal thermal policy is stored inside this
variable, potentially confusing the platform profile.

Fix this by always storing normal thermal policy values inside
throttle_thermal_policy_mode and only do the conversion when writing
the thermal policy to hardware. This also fixes the order in which
throttle_thermal_policy_switch_next() steps through the thermal modes
on Vivobook machines.

Tested-by: Casey G Bowman <casey.g.bowman@intel.com>
Fixes: bcbfcebda2cb ("platform/x86: asus-wmi: add support for vivobook fan profiles")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241107003811.615574-2-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 64 +++++++++++----------------------
 1 file changed, 21 insertions(+), 43 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index abdca3f05c5c1..89f5f44857d55 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -3696,10 +3696,28 @@ static int asus_wmi_custom_fan_curve_init(struct asus_wmi *asus)
 /* Throttle thermal policy ****************************************************/
 static int throttle_thermal_policy_write(struct asus_wmi *asus)
 {
-	u8 value = asus->throttle_thermal_policy_mode;
 	u32 retval;
+	u8 value;
 	int err;
 
+	if (asus->throttle_thermal_policy_dev == ASUS_WMI_DEVID_THROTTLE_THERMAL_POLICY_VIVO) {
+		switch (asus->throttle_thermal_policy_mode) {
+		case ASUS_THROTTLE_THERMAL_POLICY_DEFAULT:
+			value = ASUS_THROTTLE_THERMAL_POLICY_DEFAULT_VIVO;
+			break;
+		case ASUS_THROTTLE_THERMAL_POLICY_OVERBOOST:
+			value = ASUS_THROTTLE_THERMAL_POLICY_OVERBOOST_VIVO;
+			break;
+		case ASUS_THROTTLE_THERMAL_POLICY_SILENT:
+			value = ASUS_THROTTLE_THERMAL_POLICY_SILENT_VIVO;
+			break;
+		default:
+			return -EINVAL;
+		}
+	} else {
+		value = asus->throttle_thermal_policy_mode;
+	}
+
 	err = asus_wmi_set_devstate(asus->throttle_thermal_policy_dev,
 				    value, &retval);
 
@@ -3804,46 +3822,6 @@ static ssize_t throttle_thermal_policy_store(struct device *dev,
 static DEVICE_ATTR_RW(throttle_thermal_policy);
 
 /* Platform profile ***********************************************************/
-static int asus_wmi_platform_profile_to_vivo(struct asus_wmi *asus, int mode)
-{
-	bool vivo;
-
-	vivo = asus->throttle_thermal_policy_dev == ASUS_WMI_DEVID_THROTTLE_THERMAL_POLICY_VIVO;
-
-	if (vivo) {
-		switch (mode) {
-		case ASUS_THROTTLE_THERMAL_POLICY_DEFAULT:
-			return ASUS_THROTTLE_THERMAL_POLICY_DEFAULT_VIVO;
-		case ASUS_THROTTLE_THERMAL_POLICY_OVERBOOST:
-			return ASUS_THROTTLE_THERMAL_POLICY_OVERBOOST_VIVO;
-		case ASUS_THROTTLE_THERMAL_POLICY_SILENT:
-			return ASUS_THROTTLE_THERMAL_POLICY_SILENT_VIVO;
-		}
-	}
-
-	return mode;
-}
-
-static int asus_wmi_platform_profile_mode_from_vivo(struct asus_wmi *asus, int mode)
-{
-	bool vivo;
-
-	vivo = asus->throttle_thermal_policy_dev == ASUS_WMI_DEVID_THROTTLE_THERMAL_POLICY_VIVO;
-
-	if (vivo) {
-		switch (mode) {
-		case ASUS_THROTTLE_THERMAL_POLICY_DEFAULT_VIVO:
-			return ASUS_THROTTLE_THERMAL_POLICY_DEFAULT;
-		case ASUS_THROTTLE_THERMAL_POLICY_OVERBOOST_VIVO:
-			return ASUS_THROTTLE_THERMAL_POLICY_OVERBOOST;
-		case ASUS_THROTTLE_THERMAL_POLICY_SILENT_VIVO:
-			return ASUS_THROTTLE_THERMAL_POLICY_SILENT;
-		}
-	}
-
-	return mode;
-}
-
 static int asus_wmi_platform_profile_get(struct platform_profile_handler *pprof,
 					enum platform_profile_option *profile)
 {
@@ -3853,7 +3831,7 @@ static int asus_wmi_platform_profile_get(struct platform_profile_handler *pprof,
 	asus = container_of(pprof, struct asus_wmi, platform_profile_handler);
 	tp = asus->throttle_thermal_policy_mode;
 
-	switch (asus_wmi_platform_profile_mode_from_vivo(asus, tp)) {
+	switch (tp) {
 	case ASUS_THROTTLE_THERMAL_POLICY_DEFAULT:
 		*profile = PLATFORM_PROFILE_BALANCED;
 		break;
@@ -3892,7 +3870,7 @@ static int asus_wmi_platform_profile_set(struct platform_profile_handler *pprof,
 		return -EOPNOTSUPP;
 	}
 
-	asus->throttle_thermal_policy_mode = asus_wmi_platform_profile_to_vivo(asus, tp);
+	asus->throttle_thermal_policy_mode = tp;
 	return throttle_thermal_policy_write(asus);
 }
 
-- 
2.43.0



