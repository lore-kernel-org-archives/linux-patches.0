Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2210944CF52;
	Tue, 16 Jun 2026 15:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624459; cv=none; b=sl6iFYxbMSAyHUwKeb+pWjbqeu8NXilhGrvXP44mSvWLt3aKmDWlQNQyM59WV8Td2EPf6D+elRyX6trVDBZ8iAsSLEREBMxrviTbfZ0+VjYDdlENGORaKxAtlaqLUfsYKOuqzWNBF8hryg/XjesgFhufRJ4z+VRC+xI00zzJHBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624459; c=relaxed/simple;
	bh=+LJJdJUo5lIpsTXz+cLDtHgSvqPyLrb96loKrNLfzz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlmvZ1URMygQPAIKF1iriDiXOHOS6t2v+bw560Bd3tpRHdncL3M8U8lEP+kDDRz8xpZJl7kiYSmpmOUUefpRGktbpFCXPpXwjy6XAJw9oY+QrSjv9UiMIRTtJXYCD0irImESoqhthsu2+miwogGkYqzoqKL764inqeskgvvh4sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ErgMbcmH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ErgMbcmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EE41F000E9;
	Tue, 16 Jun 2026 15:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624457;
	bh=l999t9KLZ3rrRbUyapqTLXMx9UdB7t0kGV0lQT5pm78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ErgMbcmHQLh0S9TdMxMSVkhZyTqtigPfPah6R9Hdv8aJ6VddEG20x4cu9xZN8rGpG
	 1IkVz/nJLnkTBxXd7Y3n7ndUd3BKRljtWchLPYURs9nMftp5dQV6RH9yYo8nLbIUTG
	 +PB4udMtw3x7lkK14JbmPcaESmpxjT178/Q/0uoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 7.0 307/378] mmc: core: Fix host controller programming for fixed driver type
Date: Tue, 16 Jun 2026 20:28:58 +0530
Message-ID: <20260616145126.348653863@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1371,7 +1371,9 @@ static void mmc_select_driver_type(struc
 
 	card->drive_strength = drive_strength;
 
-	if (drv_type)
+	if (fixed_drv_type >= 0 && drive_strength)
+		mmc_set_driver_type(card->host, drive_strength);
+	else if (drv_type)
 		mmc_set_driver_type(card->host, drv_type);
 }
 


