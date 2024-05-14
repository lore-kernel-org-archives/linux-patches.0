Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11562D60A;
	Tue, 14 May 2024 11:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687144; cv=none; b=F1KATmeFdE2iMofOknE4HSKDT6rKM/mcmJ03NbeJeskLE4vPzKomHiRvPLqkTi4j2ONJJuQww3/TXGE7ny4B47cUXHfJqxh1cORemBWnio6sFF0x3vDdzdt5mHV1V3zuGpnQ3RkbnVMksCf4IDRyAEJ7j+65sz6a0640QncnRis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687144; c=relaxed/simple;
	bh=6WTL/wXB8wSOz7pXa9SwQ1PhrSR4/McqxR6UVNYYK+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1uWbevVejXHsp69gTcWSBAIwyOXf1ytS89U2c86WB5gIBClnd9dSs9QRVMBhVJppCXkH8gZIXBpVmOcEVDvMjDm5JLlijfNpohiSiXXTWyyotB8rbNfWMCdWFP+Hbyl6r3wLldKqZElRu6XeNXQh9EMSbCRGxVqsmHr5G8chMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0J0119xr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0J0119xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A7BC32786;
	Tue, 14 May 2024 11:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687143;
	bh=6WTL/wXB8wSOz7pXa9SwQ1PhrSR4/McqxR6UVNYYK+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0J0119xrzO1Otxe77b3zeexBRK3CBGJdmisNnmCqFPKdWwdbuZN39sm85L7AU1wOd
	 swTZryU+YOgNj+7PecA05c+AH06dKcX0c2Ip+37kvfmnuz/WQXZZfPSJcu/ZCwjhc2
	 0c52zhIfPTF6BuqA+DwYUvGQCBIkSrIW7eqdqdnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 80/84] regulator: core: fix debugfs creation regression
Date: Tue, 14 May 2024 12:20:31 +0200
Message-ID: <20240514100954.692503109@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1708,19 +1708,24 @@ static struct regulator *create_regulato
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


