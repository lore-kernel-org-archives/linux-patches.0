Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528D580C04;
	Tue, 14 May 2024 11:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686694; cv=none; b=bsQiDgHEkwhPceQL8xQl0C7aoeDtTsr8X2J7saa5a109jfwm0hfomBl/Um5b4ZZ+NynvHGXBWaBjZ5XxmK2gTBX7QsWhvpyVpqmGvrlYsAwF8+HRwsh1A760AwhUegssxGGC8lOaNZxMUl/cCntU1oxi72eo7yeex0jYuxAIMi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686694; c=relaxed/simple;
	bh=+CUIkPdL/NdKxH4JLOjtZXZ2FTrgt0+uf39SvOIbffM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jStIUvkOWK02lOLaC3KyPE+eE967EaYym0Nbp5Rk3Ir4eQnUDXX/lk0XV7pq4l1C/31rLMmDf2cij97OEn2ALDj6EKHOBLY4RDZicoeGjpk6QNOEee6aoREpJ+Q7amm7SsedpgexCXv2ScmI8vT3pVbaYUwIQ3m2dn/wxRTlwtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pK0owB6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pK0owB6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A420C2BD10;
	Tue, 14 May 2024 11:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686694;
	bh=+CUIkPdL/NdKxH4JLOjtZXZ2FTrgt0+uf39SvOIbffM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pK0owB6BBJC5DDG25ooMXhpF2QneGXG05n4jru1D8BmmMEx+9iOAMzcduXokoSZXg
	 mLqjsNpS84ZNcz0KjYuqMvgkY1T8qTmozwH5w7fwx4lpRHYRBlASxfTPE4WqOfiSP5
	 4ygZVYCa5XbvOiJ9p63NvRJ6jjoag0O971kYDDv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 227/236] regulator: core: fix debugfs creation regression
Date: Tue, 14 May 2024 12:19:49 +0200
Message-ID: <20240514101028.974711145@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 2a4b49bb58123bad6ec0e07b02845f74c23d5e04 upstream.

regulator_get() may sometimes be called more than once for the same
consumer device, something which before commit dbe954d8f163 ("regulator:
core: Avoid debugfs: Directory ...  already present! error") resulted in
errors being logged.

A couple of recent commits broke the handling of such cases so that
attributes are now erroneously created in the debugfs root directory the
second time a regulator is requested and the log is filled with errors
like:

	debugfs: File 'uA_load' in directory '/' already present!
	debugfs: File 'min_uV' in directory '/' already present!
	debugfs: File 'max_uV' in directory '/' already present!
	debugfs: File 'constraint_flags' in directory '/' already present!

on any further calls.

Fixes: 2715bb11cfff ("regulator: core: Fix more error checking for debugfs_create_dir()")
Fixes: 08880713ceec ("regulator: core: Streamline debugfs operations")
Cc: stable@vger.kernel.org
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240509133304.8883-1-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/core.c |   27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1916,19 +1916,24 @@ static struct regulator *create_regulato
 		}
 	}
 
-	if (err != -EEXIST)
+	if (err != -EEXIST) {
 		regulator->debugfs = debugfs_create_dir(supply_name, rdev->debugfs);
-	if (IS_ERR(regulator->debugfs))
-		rdev_dbg(rdev, "Failed to create debugfs directory\n");
+		if (IS_ERR(regulator->debugfs)) {
+			rdev_dbg(rdev, "Failed to create debugfs directory\n");
+			regulator->debugfs = NULL;
+		}
+	}
 
-	debugfs_create_u32("uA_load", 0444, regulator->debugfs,
-			   &regulator->uA_load);
-	debugfs_create_u32("min_uV", 0444, regulator->debugfs,
-			   &regulator->voltage[PM_SUSPEND_ON].min_uV);
-	debugfs_create_u32("max_uV", 0444, regulator->debugfs,
-			   &regulator->voltage[PM_SUSPEND_ON].max_uV);
-	debugfs_create_file("constraint_flags", 0444, regulator->debugfs,
-			    regulator, &constraint_flags_fops);
+	if (regulator->debugfs) {
+		debugfs_create_u32("uA_load", 0444, regulator->debugfs,
+				   &regulator->uA_load);
+		debugfs_create_u32("min_uV", 0444, regulator->debugfs,
+				   &regulator->voltage[PM_SUSPEND_ON].min_uV);
+		debugfs_create_u32("max_uV", 0444, regulator->debugfs,
+				   &regulator->voltage[PM_SUSPEND_ON].max_uV);
+		debugfs_create_file("constraint_flags", 0444, regulator->debugfs,
+				    regulator, &constraint_flags_fops);
+	}
 
 	/*
 	 * Check now if the regulator is an always on regulator - if


