Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920EA47A0DA;
	Tue, 16 Jun 2026 17:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629764; cv=none; b=sxRX6D33HyPDan+qT51EY+X0ujQhNboTLSsDwtZCGasMY4N5E+JlwW/d2SL86AhcbGskz1lULRK9vfiLUNvZEM+KB/KpCd9BdKKQRoKWb+8Q/uF+3royBna+3x6j5AQj86cFElmhnBMpzGHPQfkQBJzTM/xXAoubEejED2GT7Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629764; c=relaxed/simple;
	bh=cxw9FnKqWZ+TbIKDUw+mfc5TRxcjCGmDu1WtMHJ8w/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t39k2HZTKzUQiiVcrqBR3O2R1hjJO3Zvukywddygv4JNOLjnLGUtJugvyDacFPWEXh2wb7mADIlht6dnOxi3bAa4vJo0Pcvd8KrYhD5yLX6xvmp2tgO0Ur/vhf28Hnsfh4KU186ZhUAKav7/ekF12RG9dcmYLN+ga1kW9StkvD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2N3b2oee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2N3b2oee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139421F000E9;
	Tue, 16 Jun 2026 17:09:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629762;
	bh=O+lvnl4CRh2gdgwuacPQVZu+jVlKlcsuejt4pYmZS+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2N3b2oee1VDL80ipF3VkX0a1+Uc6AJFZcpXV5MFtQAkD78BIlnvQb9EbYR1eUwdTI
	 b3TqygM0cbrVtdU+NqTun1jjTcU03k3z1Vn/pmK7DFjguOYrBgEARXWSTLFqTbyCLE
	 b7C0HfpcrnInoqCdn8+O4aKJhE2zUJ5gSIPMEgXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 348/452] mmc: core: Fix host controller programming for fixed driver type
Date: Tue, 16 Jun 2026 20:29:35 +0530
Message-ID: <20260616145135.507550524@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Kamal Dasu <kamal.dasu@broadcom.com>

commit 5a52c5701a67d5176eb1afbf1bdaf7d6dfeec597 upstream.

When using the fixed-emmc-driver-type device tree property, the MMC core
correctly selects the driver strength for the card but fails to program
the host controller accordingly. This causes a mismatch where the card
uses the specified driver type while the host controller defaults to
Type B (since ios->drv_type remains zero).

Split the driver type programming logic to handle both fixed and dynamic
driver type selection paths. For fixed driver types, program the host
controller with the selected drive_strength value. For dynamic selection,
use the existing drv_type as before.

This ensures both the eMMC device and host controller use matching driver
strengths, preventing potential signal integrity issues.

Fixes: 6186d06c519e ("mmc: parse new binding for eMMC fixed driver type")
Signed-off-by: Kamal Dasu <kamal.dasu@broadcom.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/mmc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mmc/core/mmc.c
+++ b/drivers/mmc/core/mmc.c
@@ -1354,7 +1354,9 @@ static void mmc_select_driver_type(struc
 
 	card->drive_strength = drive_strength;
 
-	if (drv_type)
+	if (fixed_drv_type >= 0 && drive_strength)
+		mmc_set_driver_type(card->host, drive_strength);
+	else if (drv_type)
 		mmc_set_driver_type(card->host, drv_type);
 }
 


