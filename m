Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 163A01487CA;
	Tue, 23 Jan 2024 00:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969154; cv=none; b=nUzzvRykZkX3gaf31mqyireTD++u52Vi4eNWLGtFEaRjJxxUNoqVfp0x8szt4VTvfxnMe3RZ/44If+GCSO7RSvOlsmYoI5WKvHZjYMAweGxNXVBwhueu+EMfvqJGpgU9R28jeC7fikfLQ135lyGDfzOuB9NDA0HQ4GxMm1cy6fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969154; c=relaxed/simple;
	bh=Qzm/a4spslj1GqMq7OZweEqv8HzD2v/MUjIpTq3Epvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKbZiafR4rm20VXSSvwRTdrFNaUgERXwFfDVoOqzd0wCikGOowBYyXijhYp4sGmDupLCmjopjJZ5Ci9kTRuOjGH5rnRhPjaqAfoBHJcbX/41IW96noFM9SLZ4HZ94OaTtAUmD5UoaNi531+vywOa7JsyTid9y7Oo/Ot2+/HHFRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lj2bapHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lj2bapHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8838CC43399;
	Tue, 23 Jan 2024 00:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969153;
	bh=Qzm/a4spslj1GqMq7OZweEqv8HzD2v/MUjIpTq3Epvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lj2bapHypj5LCdMIcXV44RfaGY944um47HsB7FY1eQG7w6SZ+Av1wnuPDOjzdmOUU
	 Dv9x4VUDoDyxFN9dsCJffCjgqmLv1s/nhHWkX6eqsW3oRUCu6WKrEbV8yp1PPJ1WCo
	 d4T6B2zvTIjBYWdK5ZVNxZgoJ1GXgC703PWcSYcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Vinarskis <alex.vinarskis@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 034/641] ACPI: LPSS: Fix the fractional clock divider flags
Date: Mon, 22 Jan 2024 15:48:58 -0800
Message-ID: <20240122235819.149016242@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 3ebccf1d1ca74bbb78e6f8c38d1d172e468d91f8 ]

The conversion to CLK_FRAC_DIVIDER_POWER_OF_TWO_PS uses wrong flags
in the parameters and hence miscalculates the values in the clock
divider. Fix this by applying the flag to the proper parameter.

Fixes: 82f53f9ee577 ("clk: fractional-divider: Introduce POWER_OF_TWO_PS flag")
Reported-by: Alex Vinarskis <alex.vinarskis@gmail.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_lpss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 875de44961bf..d48407472dfb 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -461,8 +461,9 @@ static int register_device_clock(struct acpi_device *adev,
 		if (!clk_name)
 			return -ENOMEM;
 		clk = clk_register_fractional_divider(NULL, clk_name, parent,
+						      0, prv_base, 1, 15, 16, 15,
 						      CLK_FRAC_DIVIDER_POWER_OF_TWO_PS,
-						      prv_base, 1, 15, 16, 15, 0, NULL);
+						      NULL);
 		parent = clk_name;
 
 		clk_name = kasprintf(GFP_KERNEL, "%s-update", devname);
-- 
2.43.0



