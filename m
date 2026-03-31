Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B253033C9;
	Tue, 31 Mar 2026 17:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976763; cv=none; b=J2TRxKqtbNeHGOa2AsQTGFT0CysF1LFZCpEDe8tsXqwg92bUfeSjR0IO6T0WX3rONgFeWtBYCjkIBsZPE7m/hqKBh8lwxlGnhTQHhRadVL6n1da4yNs+/X7iDinEgpDAaqNBWaZVsYDQpkqMDRou1unI2owhDcyNkLmh1HzznAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976763; c=relaxed/simple;
	bh=S+yh2XhfuvBOS5JEM2aMJ/k/rc/yT9iW5xZfp1id3/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hdZnSCUdVwLU2KpCUKQZx3glg8NqROQ3vka1ZSa77Fxsoy2D9XdY/6MekM6OsLTULinR4dfn2HB8Geb8xBKRPV6pO1LqEcObsHUxgyR7NnNY784ckjkqokGS5BDYmsND+fCpm3maLxwtHaRk4wc4fJ8gN//LCcAOKZrC/1lIEmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FePhX5Gd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FePhX5Gd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BBAC19424;
	Tue, 31 Mar 2026 17:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976763;
	bh=S+yh2XhfuvBOS5JEM2aMJ/k/rc/yT9iW5xZfp1id3/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FePhX5GdbZZ2nQ0sqNxMWOV39KKLnfaBDzM61PATbUkRtcx3aCWIX+XIVYWLHyiGT
	 +xU2GXxmJj1LKBMbW1imgEop8Qle39joeOOVLuj2D6wvgYxklwT1IR50RoQ5sOuWJS
	 uQdAYnFLo7y7YxJWpsTjPRW4sV7cRpGCB5TxAgr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 201/309] hwmon: (peci/cputemp) Fix crit_hyst returning delta instead of absolute temperature
Date: Tue, 31 Mar 2026 18:21:44 +0200
Message-ID: <20260331161800.851325101@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

commit 0adc752b4f7d82af7bd14f7cad3091b3b5d702ba upstream.

The hwmon sysfs ABI expects tempN_crit_hyst to report the temperature at
which the critical condition clears, not the hysteresis delta from the
critical limit.

The peci cputemp driver currently returns tjmax - tcontrol for
crit_hyst_type, which is the hysteresis margin rather than the
corresponding absolute temperature.

Return tcontrol directly, and update the documentation accordingly.

Fixes: bf3608f338e9 ("hwmon: peci: Add cputemp driver")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260323002352.93417-2-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/hwmon/peci-cputemp.rst |   10 ++++++----
 drivers/hwmon/peci/cputemp.c         |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/Documentation/hwmon/peci-cputemp.rst
+++ b/Documentation/hwmon/peci-cputemp.rst
@@ -51,8 +51,9 @@ temp1_max		Provides thermal control temp
 temp1_crit		Provides shutdown temperature of the CPU package which
 			is also known as the maximum processor junction
 			temperature, Tjmax or Tprochot.
-temp1_crit_hyst		Provides the hysteresis value from Tcontrol to Tjmax of
-			the CPU package.
+temp1_crit_hyst		Provides the hysteresis temperature of the CPU
+			package. Returns Tcontrol, the temperature at which
+			the critical condition clears.
 
 temp2_label		"DTS"
 temp2_input		Provides current temperature of the CPU package scaled
@@ -62,8 +63,9 @@ temp2_max		Provides thermal control temp
 temp2_crit		Provides shutdown temperature of the CPU package which
 			is also known as the maximum processor junction
 			temperature, Tjmax or Tprochot.
-temp2_crit_hyst		Provides the hysteresis value from Tcontrol to Tjmax of
-			the CPU package.
+temp2_crit_hyst		Provides the hysteresis temperature of the CPU
+			package. Returns Tcontrol, the temperature at which
+			the critical condition clears.
 
 temp3_label		"Tcontrol"
 temp3_input		Provides current Tcontrol temperature of the CPU
--- a/drivers/hwmon/peci/cputemp.c
+++ b/drivers/hwmon/peci/cputemp.c
@@ -133,7 +133,7 @@ static int get_temp_target(struct peci_c
 		*val = priv->temp.target.tjmax;
 		break;
 	case crit_hyst_type:
-		*val = priv->temp.target.tjmax - priv->temp.target.tcontrol;
+		*val = priv->temp.target.tcontrol;
 		break;
 	default:
 		ret = -EOPNOTSUPP;


