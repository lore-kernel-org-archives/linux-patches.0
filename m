Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E78954BD2;
	Tue, 23 Jan 2024 00:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970587; cv=none; b=sH+bfVjuBZMKfgmjcHrTrNBYpRyKKPYv4Mtg/Q4+KvUil9oqxLkyetwfnGGAolBtQP3FEa8zp7nMVOYu3Trt1DX5dmyG3tKEOwWfphDzQCSY8NJSwNF0Jp9b7v9XC4Kna/yaEzDJX3JYF0MVnq0Ma9g9nzpHEJk046xnpSv0lyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970587; c=relaxed/simple;
	bh=XUl5SCxzYDnF2ynwg8JHTSrr/llL3R9yU/HssKUULVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2en06cVp8kpvETC+oU7tB6poK9PidU1jdrfiz6fQcG1Sk8cTOWDAJGs9xqnSRKSBGPdePAwkyCC6KjSJLuYRVS2VoTSrkopB75Ygds4jitl60g6HZw/KTIv1YlK+ihndX3xhv5DYU9o8GFRiXImHXQ2/Bw7+ZmkQizskOl8XEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jgP7xJD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jgP7xJD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F31CC433F1;
	Tue, 23 Jan 2024 00:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970586;
	bh=XUl5SCxzYDnF2ynwg8JHTSrr/llL3R9yU/HssKUULVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jgP7xJD61DLq6rDtUnm4rQ0pFutAq+p6fAMAFaeCdr+Dt8Bm8QbtK4AToG5DuZkiu
	 RMm3g1U9L+RPcXIaNNHHrV+dAX1SHLGQeTeIEgpEDHsw9DjRFryIS+6yrVh6tGpWrM
	 SPYvNcX32gk9lv34yrQK7/1p/Svrhfp+DvJErr2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Vinarskis <alex.vinarskis@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/417] ACPI: LPSS: Fix the fractional clock divider flags
Date: Mon, 22 Jan 2024 15:53:17 -0800
Message-ID: <20240122235752.588672904@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f08ffa75f4a7..8b44743945c8 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -450,8 +450,9 @@ static int register_device_clock(struct acpi_device *adev,
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



