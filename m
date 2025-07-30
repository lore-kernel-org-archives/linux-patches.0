Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FC52951D8;
	Wed, 30 Jul 2025 09:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869187; cv=none; b=Sa/ETsYCsSDjkTavjBxFz/pzedG4Xc5vV+qs4wyZ+B7knE48TrAOWed/zrV9yjq8OM5p/sj1iQDTPXwTFOOSbvAIFupsjO4Yi3aHCQE+0wS7fAs7hOR6dWvhS15wfajIdn9O7avaEtHJYI/yF6wmqOV8wmxALAICKa/hJ0VQeuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869187; c=relaxed/simple;
	bh=7u+CV2UlghMMjEV/7eJCdn1PGwdpsh4aPUhACUhvfcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/vE8svLXyRigaQhFWG2vuXTSHUqcSP1lqedVdpGfGNXuiqU86OmwOW1WmmePWIA11PoWhsOt+8WRUvctOkC/1IJkCIrNJqbZ3InIabhOQQbXew85AdmKFVSv2obVEsqIjyxZe/XTUyTs9Bs+w8OgO4KnDDl9+bPXZRUKv4+PLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XyViUHVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XyViUHVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF350C4CEFC;
	Wed, 30 Jul 2025 09:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869187;
	bh=7u+CV2UlghMMjEV/7eJCdn1PGwdpsh4aPUhACUhvfcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XyViUHVHVU0ho8Q4cpSvV636C2nQnduODftkU9NTRo6bLjFspcIO9LAyXLgbqoGl4
	 g0e+xQ4oANBak1yf8Mj8Y9j4QvQtHW+Ozyn2HonNE6168QUS4CosoQRpEKxTQp9ozK
	 YwBALYRraivl+gabO1P47BKqPTUaAzVi2Jeu29uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Akhil R <akhilrajeev@nvidia.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.15 57/92] i2c: tegra: Fix reset error handling with ACPI
Date: Wed, 30 Jul 2025 11:36:05 +0200
Message-ID: <20250730093232.956580497@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

commit 56344e241c543f17e8102fa13466ad5c3e7dc9ff upstream.

The acpi_evaluate_object() returns an ACPI error code and not
Linux one. For the some platforms the err will have positive code
which may be interpreted incorrectly. Use device_reset() for
reset control which handles it correctly.

Fixes: bd2fdedbf2ba ("i2c: tegra: Add the ACPI support")
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Cc: <stable@vger.kernel.org> # v5.17+
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250710131206.2316-2-akhilrajeev@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-tegra.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -607,7 +607,6 @@ static int tegra_i2c_wait_for_config_loa
 static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 {
 	u32 val, clk_divisor, clk_multiplier, tsu_thd, tlow, thigh, non_hs_mode;
-	acpi_handle handle = ACPI_HANDLE(i2c_dev->dev);
 	struct i2c_timings *t = &i2c_dev->timings;
 	int err;
 
@@ -619,11 +618,7 @@ static int tegra_i2c_init(struct tegra_i
 	 * emit a noisy warning on error, which won't stay unnoticed and
 	 * won't hose machine entirely.
 	 */
-	if (handle)
-		err = acpi_evaluate_object(handle, "_RST", NULL, NULL);
-	else
-		err = reset_control_reset(i2c_dev->rst);
-
+	err = device_reset(i2c_dev->dev);
 	WARN_ON_ONCE(err);
 
 	if (IS_DVC(i2c_dev))
@@ -1666,19 +1661,6 @@ static void tegra_i2c_parse_dt(struct te
 		i2c_dev->is_vi = true;
 }
 
-static int tegra_i2c_init_reset(struct tegra_i2c_dev *i2c_dev)
-{
-	if (ACPI_HANDLE(i2c_dev->dev))
-		return 0;
-
-	i2c_dev->rst = devm_reset_control_get_exclusive(i2c_dev->dev, "i2c");
-	if (IS_ERR(i2c_dev->rst))
-		return dev_err_probe(i2c_dev->dev, PTR_ERR(i2c_dev->rst),
-				      "failed to get reset control\n");
-
-	return 0;
-}
-
 static int tegra_i2c_init_clocks(struct tegra_i2c_dev *i2c_dev)
 {
 	int err;
@@ -1788,10 +1770,6 @@ static int tegra_i2c_probe(struct platfo
 
 	tegra_i2c_parse_dt(i2c_dev);
 
-	err = tegra_i2c_init_reset(i2c_dev);
-	if (err)
-		return err;
-
 	err = tegra_i2c_init_clocks(i2c_dev);
 	if (err)
 		return err;


