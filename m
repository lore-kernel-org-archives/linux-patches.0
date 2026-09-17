Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9940D539786;
	Thu, 17 Sep 2026 17:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664574; cv=none; b=rNWMpnhQOHfah1bXy7hfJRzuI13MbwCzMTmM74czkIRoQd3fHonbIJBwKAVef9mgALYYWfPZbtm3lT8SmGPmSsYKdnH3J7ml7EQDZlRYXiZD4gTEJn1g40VjXcKxxuTqFqiE6FdnsWS7AcUl3jsigbc6ztMoGFTlynlPfCwuCBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664574; c=relaxed/simple;
	bh=paPwn5TIJMejBaEOhJx1P+z4QKt1M8VzLabmEbSlRN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owjTMDEJTguTv7wTXcnPhB3i61Sx/9UoUJnb9m27ezqHP4OxJKg8U2MSMS/SJqENhQPDkFF6Uo5Le+DTE4BNCiK/YZKMLx94Zvm5YcCh+kl7sy5FyPb50ZErmqx7L3PSsFXjgsncMlGGXUBad3wjRanLHmZx+ZGJEi2djwYYxJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkTf1mpe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkTf1mpe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FBC1F000FF;
	Thu, 17 Sep 2026 17:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664573;
	bh=USaN/Qq3KQ9eEE1WVHEtNxTKdz2fNjF9UFBOLJQ9N7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pkTf1mpeGRT7Wfskm4v7MhVn9o5kieizi/sWGGWJLaCPxFsdSlk1jMJv46jot5GeF
	 U94FPVZ6+OmOczOn7qmB+hqfDduWalKU3eGLKm4f7TQmaO5JGYffq1OCpIs+VQVbgb
	 Tw3EjNvTAdzFBpC459hirCjG6aRvIc6TitbzAcZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Potin Lai <potin.lai.pt@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0390/1250] hwmon: (pmbus/lm25066) Fix PMBus coefficients for LM5064/5066/5066i
Date: Thu, 17 Sep 2026 16:03:05 +0100
Message-ID: <20260917151602.608931205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 7774d678022e2..de88ff5967a32 100644
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



