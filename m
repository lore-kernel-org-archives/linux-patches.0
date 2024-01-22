Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4512B9AA;
	Tue, 23 Jan 2024 01:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974089; cv=none; b=tyhAJpIihFezLFZlsf8NYMznVI6bBnku8JzeCm16MD5tRSlsmUkolLSkLo4LKSdKAxoJq/1LYk+3kuGmNlNjXs9kIpoBblsgKecK3HUrIoEQXHKGScjj4lV0/LIdpnh0Qd5k+5M0z2FZznZZkTMDJ1r6a++DK4HWupd1cHnJc5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974089; c=relaxed/simple;
	bh=wBedX9ERFdvS/q2IaPwacMBvGvi7cYOwrNm1xa6eHHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H72oarjz+8gjYpLkRUw09nu4fJK1SaS4XaH0/NOCWDTBn1O1hZiIEFhhZ/RtzUbVRwjk/kdq6tlQuL4BV+raFct2qL86y/LaIjSk6meL8XIkMkndCSV9/3IybbCfohSC3mvA6DrhsZUL8KtZ5DpxaKfij6TGGoYf1l93XtNQ/f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucrhS0Gc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucrhS0Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A1AC433C7;
	Tue, 23 Jan 2024 01:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974089;
	bh=wBedX9ERFdvS/q2IaPwacMBvGvi7cYOwrNm1xa6eHHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucrhS0GcHqbJOWGfrMLXE40v9rcLd/PisdjKPYct89x3vCoWalTk0wkpVgeVZORvD
	 xjhkrUVPyFz68Gw9sqgDdLQf6UV1Y4Ii0a6kf+mVGrLX9qhyLcgL8f9tV2MHR7YC1I
	 h7N9/QgoQ7iDIrEZ7dIQyI3DnUoA9mvOF3KLlAIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Vinarskis <alex.vinarskis@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/583] ACPI: LPSS: Fix the fractional clock divider flags
Date: Mon, 22 Jan 2024 15:51:25 -0800
Message-ID: <20240122235813.211629915@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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
index 539e700de4d2..a052e0ab19e4 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -465,8 +465,9 @@ static int register_device_clock(struct acpi_device *adev,
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



