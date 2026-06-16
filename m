Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FEE44CAF5;
	Tue, 16 Jun 2026 18:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634259; cv=none; b=HyQimXF1cbl+I8raPkJq/1w+BZhVJidcH0yFT0zhnojJJL7VlIsg5QtwoVR/v7mxnTTTPTLpUHIXBQ+Iucm30r06m7lv4tKRzf6KRbLDo5IOEzwr8iZeTgLZFkHjykQxnFf2OqMXKoDl9bLOF4nHfHPrHr72Nzshaik+4O0nHkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634259; c=relaxed/simple;
	bh=lELsn283IpVqnawYVvshJKY4WaihOEUgwiRTpH6w93M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhLV7I435++fkqwxH5vdS1uJTJrCIoeAmwP1njF4jwOkHlzTSm1BUxyshZdDmtgeOUxy8RlTYl06t+UutopMjo65spnjAxwe0XiGUSxlmTBYjT7lmYosKog4RT+lxrMuJ4xUX5U9PX2KIFxQ/H8s+bWIlNbqrxkd4BN6+10Qhx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URQu307r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URQu307r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF36E1F000E9;
	Tue, 16 Jun 2026 18:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634258;
	bh=I9UwopcsS7NNhSERGT2Gzbid3TBrBNGwcUY30fXBZD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URQu307rUyOgGH9Rcy8RxhlahI1yVlqacL+okDjYbqHxz/aXa4SdNgP6Ou2e194hT
	 94WvU7wLj9EtMg7SRf2S+Bvgx8rL8+mgrQLkuD0ceCPUyklm8MfMSYH/wTwbJSIwaJ
	 AsYnqBD0fDlrr+7yRNzle5CntA3vWZGuiZ9l1M5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 232/411] mmc: core: Fix host controller programming for fixed driver type
Date: Tue, 16 Jun 2026 20:27:50 +0530
Message-ID: <20260616145113.159106450@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1339,7 +1339,9 @@ static void mmc_select_driver_type(struc
 
 	card->drive_strength = drive_strength;
 
-	if (drv_type)
+	if (fixed_drv_type >= 0 && drive_strength)
+		mmc_set_driver_type(card->host, drive_strength);
+	else if (drv_type)
 		mmc_set_driver_type(card->host, drv_type);
 }
 


