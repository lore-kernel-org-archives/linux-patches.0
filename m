Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E112FDC36;
	Tue, 12 Aug 2025 17:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020371; cv=none; b=Nnic2eRdVZJnxFj4vvGSvwMA4Z6gmlCjlPrueq07Hq1s8ZUNYa3qULolwmQmEpBg7hjzP3dd68pSSsjdpptft2YWVSW0DPBNvxsxsnSLCDWM6nINsr+xRaHSnm4Y2ReN9KbcVofMkHqwbikP7XWHvn53eicN00b8GnLAAgLMoOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020371; c=relaxed/simple;
	bh=JvA8HAgGOE03s6/zjgbVQVRJIOQmtabco0lVZzHkCl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g25wYhOFonbgHpG2mmG1nyFsSiKCaCOR3yPqdJQ8Pd2kudluocE5/RfHR1JOUxrHACmlYBWmRDbD4ZTnrHoy+m1wEbEThX3vpE2ZSaMPgj1y2NvQy+luG8oQ326WhBeffGlsztEVo2paMDnpeW1IHf8CzXZolTJthEag/Jguusw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gwIuXUMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gwIuXUMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A0AC4CEF0;
	Tue, 12 Aug 2025 17:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020370;
	bh=JvA8HAgGOE03s6/zjgbVQVRJIOQmtabco0lVZzHkCl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gwIuXUMVjZ8/v6mV1Sj8AOXhxudjzQyImE6M61jgHnAmuxrIdjpYQjO7/6m12Bf4D
	 YiAy5JfQa7/+JlIK40AJcarg4oxmOnqxztFj3LKdtqG3JUKtREuJcQ5ePWVMV/xueX
	 dCITzfNDZ/CgEGHTqbczcDfUioZIjA382MPg5Y6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Akhil R <akhilrajeev@nvidia.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 028/253] i2c: tegra: Fix reset error handling with ACPI
Date: Tue, 12 Aug 2025 19:26:56 +0200
Message-ID: <20250812172949.929745632@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -623,7 +623,6 @@ static int tegra_i2c_wait_for_config_loa
 static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
 {
 	u32 val, clk_divisor, clk_multiplier, tsu_thd, tlow, thigh, non_hs_mode;
-	acpi_handle handle = ACPI_HANDLE(i2c_dev->dev);
 	struct i2c_timings *t = &i2c_dev->timings;
 	int err;
 
@@ -635,11 +634,7 @@ static int tegra_i2c_init(struct tegra_i
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
@@ -1696,19 +1691,6 @@ static void tegra_i2c_parse_dt(struct te
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
@@ -1818,10 +1800,6 @@ static int tegra_i2c_probe(struct platfo
 
 	tegra_i2c_parse_dt(i2c_dev);
 
-	err = tegra_i2c_init_reset(i2c_dev);
-	if (err)
-		return err;
-
 	err = tegra_i2c_init_clocks(i2c_dev);
 	if (err)
 		return err;


