Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDFF23ABBE;
	Wed, 30 Sep 2026 18:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794431; cv=none; b=sGrVKI7JPFTYY2efRkr8upf8EeK6+wVzltI6JnxhLUua76DRLipeYcdkVPIcPGU8+2ea9RTA0Xdf00jlB7fNnqSPUjlfKBk9zCTuntMrgxqU0s7bk9iShRZoy2pfLdxMD2wWoPB712OvCWYyxwDAv3v7N8MSfOwcVBDUqdCtx88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794431; c=relaxed/simple;
	bh=CYr/x7qIW11N2OSB7UbUsuRv4feaNV/0VVdyoXauZPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQpdZLUoxcQomAGHoS17qbKdvbNCeN0IWSKuAL8KmCTXxjhjHxb7mvHsgcRVjyrcM2IyFXSWWVP4/nNpokc9g1x9aO6vpLr40oCBD0O8NleSwSRO3/LY+uYaWqopjOJRZLI/7HhB76xZlMAjecViYr6R0M9FJTUtybQaytJdFng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r3/xt27w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r3/xt27w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E681F000FF;
	Wed, 30 Sep 2026 18:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794430;
	bh=cXtzqYUNmnEQ1wZGKoeGxmroXpxp83iRnD6ztfTOaVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r3/xt27wBPNcy+xrMR+f8/ooe05cU8hKRm5ylOOP6phksMgwTF8mnbpE5Kyv/ymgo
	 NThI1QHny0R9fyGRtr2oWYx/0gGkJebtUYjeMejJuzO3fPo9irBatVtHSsIyMN4nnx
	 3jUu/dSbmHn0g8S9wetjwaMAx/pU4NXGKgBUKlgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Potin Lai <potin.lai.pt@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0209/1193] hwmon: (pmbus/lm25066) Fix PMBus coefficients for LM5064/5066/5066i
Date: Wed, 30 Sep 2026 17:14:53 +0200
Message-ID: <20260930152438.849356366@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Potin Lai <potin.lai.pt@gmail.com>

[ Upstream commit 83dda7ed185501ba1f8165aeca83ff4a8ef7c263 ]

Swap the high setting and low setting coefficients in the lm25066_coeff
table for LM5064, LM5066, and LM5066i. The coefficients were previously
mapped incorrectly, resulting in inverted current and power scaling.

Additionally, dynamically assign the exponent (R) registers inside the
probe's LM25066_DEV_SETUP_CL check. This ensures that the proper
exponent is applied (e.g., for LM25056, high setting power exponent
is -4, but low setting power exponent is -3).

Signed-off-by: Potin Lai <potin.lai.pt@gmail.com>
Link: https://lore.kernel.org/r/20260611-lm25066-driver-fix-v3-1-9d7d4b4e253d@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/lm25066.c | 54 ++++++++++++++++++-----------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/hwmon/pmbus/lm25066.c b/drivers/hwmon/pmbus/lm25066.c
index 8a94c4cfb5d19..fc636767a8b5a 100644
--- a/drivers/hwmon/pmbus/lm25066.c
+++ b/drivers/hwmon/pmbus/lm25066.c
@@ -133,23 +133,23 @@ static const struct __coeff lm25066_coeff[][PSC_NUM_CLASSES + 2] = {
 			.R = -2,
 		},
 		[PSC_CURRENT_IN] = {
-			.m = 10742,
-			.b = 1552,
+			.m = 5456,
+			.b = 2118,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN_L] = {
-			.m = 5456,
-			.b = 2118,
+			.m = 10742,
+			.b = 1552,
 			.R = -2,
 		},
 		[PSC_POWER] = {
-			.m = 1204,
-			.b = 8524,
+			.m = 612,
+			.b = 11202,
 			.R = -3,
 		},
 		[PSC_POWER_L] = {
-			.m = 612,
-			.b = 11202,
+			.m = 1204,
+			.b = 8524,
 			.R = -3,
 		},
 		[PSC_TEMPERATURE] = {
@@ -168,23 +168,23 @@ static const struct __coeff lm25066_coeff[][PSC_NUM_CLASSES + 2] = {
 			.R = -2,
 		},
 		[PSC_CURRENT_IN] = {
-			.m = 10753,
-			.b = -1200,
+			.m = 5405,
+			.b = -600,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN_L] = {
-			.m = 5405,
-			.b = -600,
+			.m = 10753,
+			.b = -1200,
 			.R = -2,
 		},
 		[PSC_POWER] = {
-			.m = 1204,
-			.b = -6000,
+			.m = 605,
+			.b = -8000,
 			.R = -3,
 		},
 		[PSC_POWER_L] = {
-			.m = 605,
-			.b = -8000,
+			.m = 1204,
+			.b = -6000,
 			.R = -3,
 		},
 		[PSC_TEMPERATURE] = {
@@ -203,23 +203,23 @@ static const struct __coeff lm25066_coeff[][PSC_NUM_CLASSES + 2] = {
 			.R = -2,
 		},
 		[PSC_CURRENT_IN] = {
-			.m = 15076,
-			.b = -504,
+			.m = 7645,
+			.b = 100,
 			.R = -2,
 		},
 		[PSC_CURRENT_IN_L] = {
-			.m = 7645,
-			.b = 100,
+			.m = 15076,
+			.b = -504,
 			.R = -2,
 		},
 		[PSC_POWER] = {
-			.m = 1701,
-			.b = -4000,
+			.m = 861,
+			.b = -965,
 			.R = -3,
 		},
 		[PSC_POWER_L] = {
-			.m = 861,
-			.b = -965,
+			.m = 1701,
+			.b = -4000,
 			.R = -3,
 		},
 		[PSC_TEMPERATURE] = {
@@ -520,18 +520,20 @@ static int lm25066_probe(struct i2c_client *client)
 	info->m[PSC_VOLTAGE_OUT] = coeff[PSC_VOLTAGE_OUT].m;
 	info->b[PSC_VOLTAGE_OUT] = coeff[PSC_VOLTAGE_OUT].b;
 	info->R[PSC_VOLTAGE_OUT] = coeff[PSC_VOLTAGE_OUT].R;
-	info->R[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN].R;
-	info->R[PSC_POWER] = coeff[PSC_POWER].R;
 	if (config & LM25066_DEV_SETUP_CL) {
 		info->m[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN_L].m;
 		info->b[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN_L].b;
+		info->R[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN_L].R;
 		info->m[PSC_POWER] = coeff[PSC_POWER_L].m;
 		info->b[PSC_POWER] = coeff[PSC_POWER_L].b;
+		info->R[PSC_POWER] = coeff[PSC_POWER_L].R;
 	} else {
 		info->m[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN].m;
 		info->b[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN].b;
+		info->R[PSC_CURRENT_IN] = coeff[PSC_CURRENT_IN].R;
 		info->m[PSC_POWER] = coeff[PSC_POWER].m;
 		info->b[PSC_POWER] = coeff[PSC_POWER].b;
+		info->R[PSC_POWER] = coeff[PSC_POWER].R;
 	}
 
 	/*
-- 
2.53.0



