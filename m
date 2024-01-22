Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD3F54BCE;
	Tue, 23 Jan 2024 01:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974008; cv=none; b=bRs8Pzp2C+joUkfqtb4OqxtKrvrLtTUQ7jY2/kmTtr7lrneEMufMsQJR/cU9oiTODMa/phWwOKsdcLlUBrL5ZOVA5unWPkZvIgkW+BbIJQNlaOwzaIdB6rN7qzGY8KXCde/CBgVSL9DXPLd7pQ5fdSbVWlW1a6fd0qYvEiC2xBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974008; c=relaxed/simple;
	bh=K6JPH35hNIKgK4ySHRZws6uTkfcipBQ6SKYuqI91PrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHVIXZPT/4O4yncvy/OgsI+ZVtd/CX0GykPpVLpc62cp1aGj27vyUXP+riLlHYymTtn3Lwyxf7mEj3DeWquuZHu82jY703e9fAH+B2Ffu002e5BJLHWWcsfVVubW9FlwC1DK3h9oWKZXyavvZoAr2Blm9c39s3w1vKHqCBcJNTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udYDdQt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udYDdQt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1419DC433C7;
	Tue, 23 Jan 2024 01:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974008;
	bh=K6JPH35hNIKgK4ySHRZws6uTkfcipBQ6SKYuqI91PrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udYDdQt2558+vk4YmfgQy/qVupVAQ51tbwC4EyCANeMJ98xuvbwzO6xDAkX5i+6bO
	 K5ysXPOepSqcWYN0252FESi6JuIxZ5E7NJpnx1lJ12rw55p0qV1gzYLj9bICEkerVJ
	 rUvsPJt0AD2/Lg8HZB58ySD/ZLnwgqfywxWukFfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Vinarskis <alex.vinarskis@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/374] ACPI: LPSS: Fix the fractional clock divider flags
Date: Mon, 22 Jan 2024 15:55:45 -0800
Message-ID: <20240122235747.711027210@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f609f9d62efd..332befb5f579 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -439,8 +439,9 @@ static int register_device_clock(struct acpi_device *adev,
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



