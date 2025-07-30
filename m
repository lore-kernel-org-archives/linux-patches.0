Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262BE273D95;
	Wed, 30 Jul 2025 09:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868668; cv=none; b=p536LB4qjdlxuXVet4QuHBvgjHWCzdWhbKKDa2LdRYm9Fl8UUY7kDw74kUyx0I0cVGSoEmcoz04Kpv+8//ogPsm0O7buo9mFoarmdWMkpq0T7h9Gfx6aeMZGWs3r/lZ7aSm8x6jVHs+xa2AEh1x453YGCup2dlk64G0QElwLGxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868668; c=relaxed/simple;
	bh=4kuJL0EBRaLmUkN37pM+EgF7SupzDs5TqxV5KBro4dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZzw0hjkRpy/i2FEtUMwULg8nsWQdW/c3+z4yrR/Axxo5ZOgNPVDBzMUQCa59eUkEKX2G9UR12qPaGJuqqQUE20Y/Tafo8oe0VfR2blsutVB/+KYD52dThIBLnBEW5S80sQIgFZtjoBrlNrS740JRs/aiX9ifca8BR2o5zBZtEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ux/axNLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ux/axNLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C8EC4CEF6;
	Wed, 30 Jul 2025 09:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868668;
	bh=4kuJL0EBRaLmUkN37pM+EgF7SupzDs5TqxV5KBro4dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ux/axNLqgi/gvyCQx8q0w5cE0Bb1Pp5Nu/8YTUNa68t/zmNBcZUhrMQ8O5909GfBf
	 ScLbKL80ixK7+d99CkQktpH+GXymjExAybJCKMJ+iDeAvdNHuBOfU/VU6ySVQuKnaK
	 5y7tuxcsSlj0rHz0/MVlHsOOd1CXUCC4dyXE8+9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Akhil R <akhilrajeev@nvidia.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 047/117] i2c: tegra: Fix reset error handling with ACPI
Date: Wed, 30 Jul 2025 11:35:16 +0200
Message-ID: <20250730093235.386261204@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


