Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E53B74502F;
	Tue, 16 Jun 2026 16:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627552; cv=none; b=fEtFxYnICS8+cf7XpHfb6dnV6I4N7MfCrh6/XolFPtr3oU8hXXF6AvdKARG3IQM+QgDHEctJrA0Yx2YP5H8y0VNP9w7wFDShtLs05P41YZ4lwQZJhA/544MYvcj0cvQibii9guGfoUmVVPjr6HSn3cz+aPw8PVLlq5HR31KB9eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627552; c=relaxed/simple;
	bh=5bYjoi2PlNhuyADBsRt0iJ5jGgK89HwF5Br39vihBWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ol5Coi/VODGpihpAUEYTRY8iucSpifx/gHWP08s9gDbuEq03j9TJ7vblZ+Ph9lmqUaEY9bjZKpeCUtULfQgKIu/FMLem3yvB/f9TO1K4o6DoeRVApRKwvQAFMQZG3G3ds6LnFgy4oyQyWItgTRr1/NsMuKJy+Sdt1eXA+Am8CB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LvFZFuOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LvFZFuOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9848C1F00A3A;
	Tue, 16 Jun 2026 16:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627551;
	bh=76Jt9NjE2aADoKkztSOFkp8Cb06OJcQcfsaQ756kZmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LvFZFuOkCYRT8UZA8lOb0D6c8gpgfuwCYylHVpCSBfojQU25aQFk0P+uWEhk2GQI4
	 HUs3lRrbWrRrSkQ3Y+BkJNF3XMsZkVtj5yQPbsLbyVwyc4yaHc/JpB+jXxuhuH7V7d
	 pAHL7O33cEe7QOeY+P0ltDY4AWRG9uqFa7mYSdEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 192/261] mmc: core: Fix host controller programming for fixed driver type
Date: Tue, 16 Jun 2026 20:30:30 +0530
Message-ID: <20260616145053.960237881@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1348,7 +1348,9 @@ static void mmc_select_driver_type(struc
 
 	card->drive_strength = drive_strength;
 
-	if (drv_type)
+	if (fixed_drv_type >= 0 && drive_strength)
+		mmc_set_driver_type(card->host, drive_strength);
+	else if (drv_type)
 		mmc_set_driver_type(card->host, drv_type);
 }
 


