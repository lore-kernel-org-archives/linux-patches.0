Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D30281353;
	Thu, 13 Feb 2025 14:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457265; cv=none; b=jflbmDrzJg2G7SlFtnm9c40HMH0Nr76bynFOiH4t+eH1wCnePxVFMSTyf8efy7gKjpunWuDQK+ztVzuxD5SH5IUBiKju7qmapEEonkPYvJB8MgNoCUYRxDa3x+Nc9zRcl9X7gTbSE22SJGxSJwSVJQ1DkdvkRs2YPxfmQ5WEm7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457265; c=relaxed/simple;
	bh=7KDmnERmc7PPOX7NXwb63Tp+E3GZjrDQoF/bD0odZuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPAlTfgeQip3tGfVcxNb/hGuEKwvbO6Qa5Aqiain9G4pRrd2jCpFGGT0qxxYvrynpayF94aVC+OlxsPe+prGsl3cVFvpE4oEKu28LU+H+6p9236IWtX5psKxVy9I8SgKJc32Y1kUW6khpXSFJjOrotHF1IUTqHyukNZXJjrVem4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R7klFvE1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R7klFvE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EF3C4CEE4;
	Thu, 13 Feb 2025 14:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457264;
	bh=7KDmnERmc7PPOX7NXwb63Tp+E3GZjrDQoF/bD0odZuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R7klFvE1TBikuYP4Vh+ZipcH/2bHEFC+24ZmgEyQYs88cRiXiJnSNZ3/uiUWU04km
	 /MCDIsAwBTdgveR4HImyzgenciYQme2KZqBA0+8Ub09LGWnBtZHW3zbEGnXNwYh1Bk
	 mfKBtiPlRSpqNOgZCqIzCEYAaRyMa+B3qeLn57BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randolph Ha <rha051117@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 063/422] i2c: Force ELAN06FA touchpad I2C bus freq to 100KHz
Date: Thu, 13 Feb 2025 15:23:32 +0100
Message-ID: <20250213142438.993613728@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Randolph Ha <rha051117@gmail.com>

[ Upstream commit bfd74cd1fbc026f04446e67d6915c7e199c2bffd ]

When a 400KHz freq is used on this model of ELAN touchpad in Linux,
excessive smoothing (similar to when the touchpad's firmware detects
a noisy signal) is sometimes applied. As some devices' (e.g, Lenovo
V15 G4) ACPI tables specify a 400KHz frequency for this device and
some I2C busses (e.g, Designware I2C) default to a 400KHz freq,
force the speed to 100KHz as a workaround.

For future investigation: This problem may be related to the default
HCNT/LCNT values given by some busses' drivers, because they are not
specified in the aforementioned devices' ACPI tables, and because
the device works without issues on Windows at what is expected to be
a 400KHz frequency. The root cause of the issue is not known.

Signed-off-by: Randolph Ha <rha051117@gmail.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 14ae0cfc325ef..d2499f302b508 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -355,6 +355,25 @@ static const struct acpi_device_id i2c_acpi_force_400khz_device_ids[] = {
 	{}
 };
 
+static const struct acpi_device_id i2c_acpi_force_100khz_device_ids[] = {
+	/*
+	 * When a 400KHz freq is used on this model of ELAN touchpad in Linux,
+	 * excessive smoothing (similar to when the touchpad's firmware detects
+	 * a noisy signal) is sometimes applied. As some devices' (e.g, Lenovo
+	 * V15 G4) ACPI tables specify a 400KHz frequency for this device and
+	 * some I2C busses (e.g, Designware I2C) default to a 400KHz freq,
+	 * force the speed to 100KHz as a workaround.
+	 *
+	 * For future investigation: This problem may be related to the default
+	 * HCNT/LCNT values given by some busses' drivers, because they are not
+	 * specified in the aforementioned devices' ACPI tables, and because
+	 * the device works without issues on Windows at what is expected to be
+	 * a 400KHz frequency. The root cause of the issue is not known.
+	 */
+	{ "ELAN06FA", 0 },
+	{}
+};
+
 static acpi_status i2c_acpi_lookup_speed(acpi_handle handle, u32 level,
 					   void *data, void **return_value)
 {
@@ -373,6 +392,9 @@ static acpi_status i2c_acpi_lookup_speed(acpi_handle handle, u32 level,
 	if (acpi_match_device_ids(adev, i2c_acpi_force_400khz_device_ids) == 0)
 		lookup->force_speed = I2C_MAX_FAST_MODE_FREQ;
 
+	if (acpi_match_device_ids(adev, i2c_acpi_force_100khz_device_ids) == 0)
+		lookup->force_speed = I2C_MAX_STANDARD_MODE_FREQ;
+
 	return AE_OK;
 }
 
-- 
2.39.5



