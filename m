Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0B81CAA4;
	Tue, 14 May 2024 11:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687962; cv=none; b=MbqbmPOcO991uiBqak/h+Z7qA0h9iLqN/+5GlZZMUfYmZc02Hhkga15H1vgLwnnea/SwX854yM5uDISEQdrtfoGPy3vOnWqOTW9EyvyKsp3vULawQ4CqFcA0qBsNARJedRBpAz+3wGSa6VRdC3h+lf1CaxAtKSPOFsYGqOO4AI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687962; c=relaxed/simple;
	bh=q9GLo/cmguTcwEqm8xqEzUSHRry0SRzkMWybhy0Mjhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyNrkbnPidSUoM3dtCrgvb0LncH5wh0BHqRSUC6u4z7ys58gcHlyvpWm46EE9/t4oIozefCNZ6d66tA6KHfxCuChL3zfYd+g8O1OO44xLUEeiZn62oGg5xg8nk1zkV2NMftN34Nn2RrC0sk3PY9mRmrVQZ0b8U1w/5XM4UzPQbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJfBQw4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJfBQw4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7130C2BD10;
	Tue, 14 May 2024 11:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687962;
	bh=q9GLo/cmguTcwEqm8xqEzUSHRry0SRzkMWybhy0Mjhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJfBQw4Ij3+QaPeKp8Pr/GME+aYFwkiN8EDc3+r3FI8OIEeJeNojWT3yx5b9FiImf
	 JVUo0y9rQ0uPh7M7Xw5uf4p3ykFpB3vqOl0SbwOTmPsNoY8EMTeT6/6fBQnt0sYrCo
	 13e0i3mMMSXZ9eBfKYK1kGNxUtO6a5QPal6yCHEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 165/168] regulator: core: fix debugfs creation regression
Date: Tue, 14 May 2024 12:21:03 +0200
Message-ID: <20240514101012.984388740@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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
@@ -1872,19 +1872,24 @@ static struct regulator *create_regulato
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


