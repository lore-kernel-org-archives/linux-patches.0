Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9F5242D7C;
	Tue, 20 May 2025 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750144; cv=none; b=vBMuzS193NXnKvg6pJ2GjjoWYoAH/CO+xbFv7gBRIPotPyFSepRRyIzEHaHPgtKJWycqU66YeWy02ydZaZVRN6nmSEgQIdXM4Z1crDq30FBSlT8lSSWxo4J+MUi4rGmCCVAbj2333YZDV0fYcqj8luj6MsrM11alRg6s4OOsT44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750144; c=relaxed/simple;
	bh=EFTkiE/sn8hvqFqKuf32t1sHkPSmgr2MkHpg2zn+Gi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQb2W1KOtaRZi81VHY+QNs1d1Lqf3xDs369RCVep3WXegmcvnmDZ+hhTlfvM5+HCk3r+HihZK6x/rjMpUXDXy9bgswOmRCP9xRYAlZS8yQ2ZMvSQOfjfY2o8LIhlppex1S3XlO5l3v6YMu6eJyTFsIkTHkjl1aAhMtw8TlCQ/xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kOabGrFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kOabGrFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765A6C4CEE9;
	Tue, 20 May 2025 14:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750143;
	bh=EFTkiE/sn8hvqFqKuf32t1sHkPSmgr2MkHpg2zn+Gi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kOabGrFVQ/skOYldGupbwftpITJB3gPWfsmlXisiwqLvmJ98oO6zJf8t/cMU8ER8F
	 tw5HvMgKR9UlSjZgQ+CCYk0ZZOJmWY+j6lUkeIpihBxeQPuRTWK7no7Qza1wvseu48
	 aFULOBiswe1kSXXMjh34Sd5yGxC2b8yaUuEDsqWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 056/143] regulator: max20086: fix invalid memory access
Date: Tue, 20 May 2025 15:50:11 +0200
Message-ID: <20250520125812.258921224@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
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

From: Cosmin Tanislav <demonsingur@gmail.com>

[ Upstream commit 6b0cd72757c69bc2d45da42b41023e288d02e772 ]

max20086_parse_regulators_dt() calls of_regulator_match() using an
array of struct of_regulator_match allocated on the stack for the
matches argument.

of_regulator_match() calls devm_of_regulator_put_matches(), which calls
devres_alloc() to allocate a struct devm_of_regulator_matches which will
be de-allocated using devm_of_regulator_put_matches().

struct devm_of_regulator_matches is populated with the stack allocated
matches array.

If the device fails to probe, devm_of_regulator_put_matches() will be
called and will try to call of_node_put() on that stack pointer,
generating the following dmesg entries:

max20086 6-0028: Failed to read DEVICE_ID reg: -121
kobject: '\xc0$\xa5\x03' (000000002cebcb7a): is not initialized, yet
kobject_put() is being called.

Followed by a stack trace matching the call flow described above.

Switch to allocating the matches array using devm_kcalloc() to
avoid accessing the stack pointer long after it's out of scope.

This also has the advantage of allowing multiple max20086 to probe
without overriding the data stored inside the global of_regulator_match.

Fixes: bfff546aae50 ("regulator: Add MAX20086-MAX20089 driver")
Signed-off-by: Cosmin Tanislav <demonsingur@gmail.com>
Link: https://patch.msgid.link/20250508064947.2567255-1-demonsingur@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/max20086-regulator.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/regulator/max20086-regulator.c b/drivers/regulator/max20086-regulator.c
index 59eb23d467ec0..198d45f8e8849 100644
--- a/drivers/regulator/max20086-regulator.c
+++ b/drivers/regulator/max20086-regulator.c
@@ -132,7 +132,7 @@ static int max20086_regulators_register(struct max20086 *chip)
 
 static int max20086_parse_regulators_dt(struct max20086 *chip, bool *boot_on)
 {
-	struct of_regulator_match matches[MAX20086_MAX_REGULATORS] = { };
+	struct of_regulator_match *matches;
 	struct device_node *node;
 	unsigned int i;
 	int ret;
@@ -143,6 +143,11 @@ static int max20086_parse_regulators_dt(struct max20086 *chip, bool *boot_on)
 		return -ENODEV;
 	}
 
+	matches = devm_kcalloc(chip->dev, chip->info->num_outputs,
+			       sizeof(*matches), GFP_KERNEL);
+	if (!matches)
+		return -ENOMEM;
+
 	for (i = 0; i < chip->info->num_outputs; ++i)
 		matches[i].name = max20086_output_names[i];
 
-- 
2.39.5



