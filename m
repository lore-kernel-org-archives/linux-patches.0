Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F375E13B79F;
	Tue, 27 Feb 2024 13:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041951; cv=none; b=o1N7eAyuR4OYKynqLNRFDrG0KPRtVOnJf6Sr4hUGalq0Dz239IJbdLzqL3MqV+Nb7MFBuEtqzgLRxEnvqdu9iXiY/iThImJWF4kRP14jhCOhxsDhZlf3RbeADN3TqZ+UmGSgZqXjQllON7vdAGbJ1pEzXTolU6JYFgUglf/+gio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041951; c=relaxed/simple;
	bh=LWdL1QSop4Xk1ikzdu07XfGMVkzo6j4Sq2jzYRbT/aI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd7Xtm880kPbFDho70eAOd4LSBPSvkrpTqRlB+GFjLLOxy/QmqKhU3Lg32Y9G3wc1C4T7x3xB/tiWUHNYyWnGnUuKaiXuILC7EcWtnKx12OAu7MHRK72Qh31ehTlsPr1xA5CXStmWNz6sRgXcqPfL/wotY/FzP/Um251KYFWC7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2g7bUTZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2g7bUTZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825F4C433F1;
	Tue, 27 Feb 2024 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041950;
	bh=LWdL1QSop4Xk1ikzdu07XfGMVkzo6j4Sq2jzYRbT/aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H2g7bUTZBMTEyTQCXM4sHra9PVL7W76KcJZSW8vILr72rjjCc9t0Z1YVYcHScyVV6
	 cvGu/L04nkzsIgL7JRtp53mD5VikTL7cQ+Ivdh/brK0S1P3v1iyrSHIi7G7LyLl+0y
	 Nu6QMvOVRRnCGnZR8mmR6BKmpK6/1fAerN/N8AEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/299] hwmon: (coretemp) Enlarge per package core count limit
Date: Tue, 27 Feb 2024 14:23:29 +0100
Message-ID: <20240227131629.049500868@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 34cf8c657cf0365791cdc658ddbca9cc907726ce ]

Currently, coretemp driver supports only 128 cores per package.
This loses some core temperature information on systems that have more
than 128 cores per package.
 [   58.685033] coretemp coretemp.0: Adding Core 128 failed
 [   58.692009] coretemp coretemp.0: Adding Core 129 failed
 ...

Enlarge the limitation to 512 because there are platforms with more than
256 cores per package.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Link: https://lore.kernel.org/r/20240202092144.71180-4-rui.zhang@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 95f4c0b00b2d8..b8fc8d1ef20df 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -41,7 +41,7 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 
 #define PKG_SYSFS_ATTR_NO	1	/* Sysfs attribute for package temp */
 #define BASE_SYSFS_ATTR_NO	2	/* Sysfs Base attr no for coretemp */
-#define NUM_REAL_CORES		128	/* Number of Real cores per cpu */
+#define NUM_REAL_CORES		512	/* Number of Real cores per cpu */
 #define CORETEMP_NAME_LENGTH	28	/* String Length of attrs */
 #define MAX_CORE_ATTRS		4	/* Maximum no of basic attrs */
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
-- 
2.43.0



