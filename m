Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B0537F8C2;
	Wed,  8 Apr 2026 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671858; cv=none; b=Nec49CGrcSwdOS67ZXcU5Flh6H/SL242ED5Lh7QuN1d10LJNQU2LmVmhqcrTwDSJQYtykYy6v2QbL5bjfn1+sVPYIpTl8bXhMKNN084IG42x0MNXRowyU0eZxTNM2zJyAp84jTTwKkZnXjfcO0SpF1nDIGTScvgrzJfH973IPNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671858; c=relaxed/simple;
	bh=LzpA0uNotGTfnorKGXT/eTRfWJ98eIeKILXj4dxtatQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVnxwSFeODHplF0NQRxs6/IBF4v+PgL+zfZ7sojL3tHcxNJrbX8ifxBKBqVqm8uXfRwT6b7XYUZ6wmtbf8VSj030QF/q2OsvRcAVdrv4FnatEa6aqOj5Np1AXxqJKHCilnWUO5r94hdJB05o5GecpjCahHFjP/i5qoqPWj5bmu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJ/BlDAn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJ/BlDAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEDEC19421;
	Wed,  8 Apr 2026 18:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671858;
	bh=LzpA0uNotGTfnorKGXT/eTRfWJ98eIeKILXj4dxtatQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJ/BlDAnNaGVxE7o1yoZMveYbdbnbYfjurkvRS5cVN8wgwLVcJMZzuoQ+W3wCvmDX
	 9geFQtgjeUEtvE3hYR5bqIrLpm318B1O2q2PoezM8OjPTcF+YWBwYE+LlBdK6gilbT
	 U6Z/HP3QgsFVvL41w/FQMcWM3hwiKMHD4BMvQi7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.1 096/312] hwmon: (peci/cputemp) Fix crit_hyst returning delta instead of absolute temperature
Date: Wed,  8 Apr 2026 20:00:13 +0200
Message-ID: <20260408175937.348811015@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


