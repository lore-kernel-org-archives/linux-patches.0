Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED5E622257E;
	Mon, 13 Oct 2025 15:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368220; cv=none; b=ZVqLHbvuM2sJupZ/DrixbhG/BLytqQ4eV5Lc/N8grmbDlsxropVgAmYXUKTGXZcjKJz06dIgkNi4lPO1+d4/MZDji3E/LESs5055gO6ZMOtPN0uFwA6Csc0wjM4EudCsHZHtXjE1FKj4VdR59xV6ZZM/uBFByPHsQOMrKtIcUL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368220; c=relaxed/simple;
	bh=HVO6rMWpcIK0Ba7CCUG6171n1bLaz3SGThzxY+gmNMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lyiV5aWz+7e7g/GAIQ85O0MX3PXSr9uhQeS5e5i0hdupuMpGctTjlJCU07MdTlVB/0ElGbJaemQTCjWYJ1Z8YZz82DxncFiInf6EVJyw8EQjPw0ocLi0PInGzRDhGONym90keyHWQhO+dUm13W7vUsFK1j2XQgzlIesFNmJOX54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kv47ijl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kv47ijl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7699DC4CEE7;
	Mon, 13 Oct 2025 15:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368219;
	bh=HVO6rMWpcIK0Ba7CCUG6171n1bLaz3SGThzxY+gmNMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kv47ijl/Evu54qmfuzsLhqJYcYrSOME5ZUICRCLbP9HdIaZczDP+mUN/ieHpU6wWg
	 1pDO7rsZTCH/ke682YZUnit7tkwvVe7wtd74wL92pWt2uAGmTLCFhAO91Q5xqBzGDd
	 59DHySaTQVf2vMo2fcdrT4bS6wi8IJyaY9adymGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Ito <ito.kohei@socionext.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/262] i2c: designware: Fix clock issue when PM is disabled
Date: Mon, 13 Oct 2025 16:43:48 +0200
Message-ID: <20251013144329.227146220@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 70e633bedeeb4a7290d3b1dd9d49cc2bae25a46f ]

When the driver is removed, the clocks are first enabled by
calling pm_runtime_get_sync(), and then disabled with
pm_runtime_put_sync().

If CONFIG_PM=y, clocks for this controller are disabled when it's in
the idle state. So the clocks are properly disabled when the driver
exits.

Othewise, the clocks are always enabled and the PM functions have
no effect. Therefore, the driver exits without disabling the clocks.

    # cat /sys/kernel/debug/clk/clk-pclk/clk_enable_count
    18
    # echo 1214a000.i2c > /sys/bus/platform/drivers/i2c_designware/bind
    # cat /sys/kernel/debug/clk/clk-pclk/clk_enable_count
    20
    # echo 1214a000.i2c > /sys/bus/platform/drivers/i2c_designware/unbind
    # cat /sys/kernel/debug/clk/clk-pclk/clk_enable_count
    20

To ensure that the clocks can be disabled correctly even without
CONFIG_PM=y, should add the following fixes:

- Replace with pm_runtime_put_noidle(), which only decrements the runtime
  PM usage count.
- Call i2c_dw_prepare_clk(false) to explicitly disable the clocks.

Fixes: 7272194ed391f ("i2c-designware: add minimal support for runtime PM")
Co-developed-by: Kohei Ito <ito.kohei@socionext.com>
Signed-off-by: Kohei Ito <ito.kohei@socionext.com>
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-platdrv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index ef9bed2f2dccb..1615facff29c6 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -328,9 +328,11 @@ static void dw_i2c_plat_remove(struct platform_device *pdev)
 	i2c_dw_disable(dev);
 
 	pm_runtime_dont_use_autosuspend(device);
-	pm_runtime_put_sync(device);
+	pm_runtime_put_noidle(device);
 	dw_i2c_plat_pm_cleanup(dev);
 
+	i2c_dw_prepare_clk(dev, false);
+
 	i2c_dw_remove_lock_support(dev);
 
 	reset_control_assert(dev->rst);
-- 
2.51.0



