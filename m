Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266F72248A5;
	Mon, 13 Oct 2025 14:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367578; cv=none; b=JtyKjR8wLRLJbw4By/tz7X1HOdnMvM0MFQTILn0jnyl8YBO90q5s3SG4gBmA7wM4RsZr5XEosfThpyTv72fWi6KpJNazBRTpU97O87WV9eU2lFhyN/Iys/vg4qvHJk1K5HJgmzEzkf0i3ICSks7DBaku9Gaj3TbPaC3W095Ivek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367578; c=relaxed/simple;
	bh=XnuOr/RmAVBt5WijjpKFXlDIGoFNH89zU85Qo13jdRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O23hJUKRBn1JIkd7jw7i1U6Xo7zm7vu3I2P2G0wsMVSKQ/MLROBDWvBsJgw++D5Bl5rIG7fIw9XZ7M59snCcouVqJNEfr3ZLi1Xnk0U6hJdFwTnnaQ5xe+RAFMDl1DsRfKRGj/JEIsXJZDCteCDiIZAZbP6J6SCKW7zcU9kJ7gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxPPz8Vm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxPPz8Vm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D82EC4CEFE;
	Mon, 13 Oct 2025 14:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367578;
	bh=XnuOr/RmAVBt5WijjpKFXlDIGoFNH89zU85Qo13jdRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxPPz8Vm6UDPhCtTB1UTooHBQX2YwkGgX+P3njzTT3w0+YjG4HQEfrVYAUYh5+nJ7
	 1rsTjfGqKiyUujhmTaDIzWRg+zTfwSIdFVKr2JmVyJclzQaoafhrlSNpBWL7KY+fkv
	 lvCHYz6ObkyasXjUIFM6zvU1VsBIpTUg0hy7a0rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Ito <ito.kohei@socionext.com>,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/196] i2c: designware: Fix clock issue when PM is disabled
Date: Mon, 13 Oct 2025 16:44:10 +0200
Message-ID: <20251013144317.331323260@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1ebcf5673a06b..ca6e1991ad13f 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -411,9 +411,11 @@ static void dw_i2c_plat_remove(struct platform_device *pdev)
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



