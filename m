Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAAA43AD3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1l7ZBWVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B4FC4E778;
	Wed, 15 Nov 2023 20:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081696;
	bh=9zu7kSdDTudoT9mn82ouWDpQuT09G/UYD989pC1335w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1l7ZBWVfSreG1Ehe+TN28+LM1EVo3JnH2uZrc8z5lmTott2OwgGpwfL3Cb6wHvhSe
	 B7RVeG2a4Kq0f6lAXYQicLJOhma/KE+jEXO25i2IlRxNGdcBbzPpShBU7KdkAe5LJW
	 gBuviGwl/m9Pb+GhiZ58AMzm5k+foorfCjEC6buE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	kernel test robot <lkp@intel.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/191] hwmon: (coretemp) Fix potentially truncated sysfs attribute name
Date: Wed, 15 Nov 2023 15:45:43 -0500
Message-ID: <20231115204648.672923212@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit bbfff736d30e5283ad09e748caff979d75ddef7f ]

When build with W=1 and "-Werror=format-truncation", below error is
observed in coretemp driver,

   drivers/hwmon/coretemp.c: In function 'create_core_data':
>> drivers/hwmon/coretemp.c:393:34: error: '%s' directive output may be truncated writing likely 5 or more bytes into a region of size between 3 and 13 [-Werror=format-truncation=]
     393 |                          "temp%d_%s", attr_no, suffixes[i]);
         |                                  ^~
   drivers/hwmon/coretemp.c:393:26: note: assuming directive output of 5 bytes
     393 |                          "temp%d_%s", attr_no, suffixes[i]);
         |                          ^~~~~~~~~~~
   drivers/hwmon/coretemp.c:392:17: note: 'snprintf' output 7 or more bytes (assuming 22) into a destination of size 19
     392 |                 snprintf(tdata->attr_name[i], CORETEMP_NAME_LENGTH,
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     393 |                          "temp%d_%s", attr_no, suffixes[i]);
         |                          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: all warnings being treated as errors

Given that
1. '%d' could take 10 charactors,
2. '%s' could take 10 charactors ("crit_alarm"),
3. "temp", "_" and the NULL terminator take 6 charactors,
fix the problem by increasing CORETEMP_NAME_LENGTH to 28.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Fixes: 7108b80a542b ("hwmon/coretemp: Handle large core ID value")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202310200443.iD3tUbbK-lkp@intel.com/
Link: https://lore.kernel.org/r/20231025122316.836400-1-rui.zhang@intel.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/coretemp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index eaae5de2ab616..5b2057ce5a59d 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -41,7 +41,7 @@ MODULE_PARM_DESC(tjmax, "TjMax value in degrees Celsius");
 #define PKG_SYSFS_ATTR_NO	1	/* Sysfs attribute for package temp */
 #define BASE_SYSFS_ATTR_NO	2	/* Sysfs Base attr no for coretemp */
 #define NUM_REAL_CORES		128	/* Number of Real cores per cpu */
-#define CORETEMP_NAME_LENGTH	19	/* String Length of attrs */
+#define CORETEMP_NAME_LENGTH	28	/* String Length of attrs */
 #define MAX_CORE_ATTRS		4	/* Maximum no of basic attrs */
 #define TOTAL_ATTRS		(MAX_CORE_ATTRS + 1)
 #define MAX_CORE_DATA		(NUM_REAL_CORES + BASE_SYSFS_ATTR_NO)
-- 
2.42.0



