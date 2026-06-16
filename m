Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995A7331A44;
	Tue, 16 Jun 2026 17:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631900; cv=none; b=f4o13/DF6tdh4ScuWSVMY6t9vuZZBK31cQQeRzw1koaiGNw4qBF8tsdMlAXgMRnDFMHIBR3oJuYfjYhlZ9WtHMm54nkkxVh5BvGJj+4j/StcGeKBL6J8fcg3X7vC5Xr2Ox1SGBJo2qB2sMZl4oo7SFF5WuvTciN9gpfA4NyIAB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631900; c=relaxed/simple;
	bh=9pnad41aAVBadcIK1bPpQm9mATOfPzL7UjDaMTFxa9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QN+7R0iQbOPuJXUKOQHU9T5xTt/HwiN8ElFDH7rxbKXSTa2hNiIYcT0QMa7801Qt0L7dgaT9uR0djWy8xNdhGZ7x0ZSfVRyF7tiwfqac8UgK9jnPTQcAdfOPzlYAhE8MjkkJZDXghThebgAcIUT/hqk5WZp+plUKfbH1HJCx1Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltgjSykF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltgjSykF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A8E1F000E9;
	Tue, 16 Jun 2026 17:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631899;
	bh=L4oAPEGOFA1NnS8yvc6p5Yj+MrOB66owRILkOADukiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ltgjSykFAlBLzENeAHPty93UA4VBj4hBZGrhGI80yOuFs1rFEWVDiG9/FdDfdPidC
	 28fYHcdnNrIXNpw+HWQZ+9+DfjMjK+Md2foY1PYUtC8l3o+5JIhdzqwuZSX8KH1Go+
	 vs858pvI46PLlbIWn9SeyoQdYzNL/fnz/na/VikY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamal Dasu <kamal.dasu@broadcom.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 309/522] mmc: core: Fix host controller programming for fixed driver type
Date: Tue, 16 Jun 2026 20:27:36 +0530
Message-ID: <20260616145140.330695504@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


