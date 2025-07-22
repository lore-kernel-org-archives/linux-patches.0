Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E412E1724;
	Tue, 22 Jul 2025 14:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193105; cv=none; b=ZcGbZbu6g6kRKZKGd8GHIIdnKw51BYRL1Rrn8oegely6gDnuRwCPPhB+yPN9QnAdQ7gHOe+UXAvJbyJaVKXmHuAFAWgbn9XOuMrjivgNMyU5G8dkpON/48SPRi98PcNjieA9pFfPEBBoZkh7yVmFRIRTxf64x6hijCb14I61UnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193105; c=relaxed/simple;
	bh=AOEp3aBYa2Is8ViAw41UFhoqzZ2qeZCVWEdZHawBHyw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SMZOpdKUmQOWxBIyaiMbvdD5fKMMS2K6+1hWVNxGYJWHScJBp8BSvr2UYrVpRda5UqO67uCrttJS6QACZXOum6CQaDIPes100n/WrPd094x8M1LEF+7WfrI5SP3FRX9OcuT3ZSyHOdMJHQZgLPN2D/a/OLmuSllbSrzOGWwJEwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GT7Adx8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GT7Adx8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F00C4CEF1;
	Tue, 22 Jul 2025 14:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193105;
	bh=AOEp3aBYa2Is8ViAw41UFhoqzZ2qeZCVWEdZHawBHyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GT7Adx8a1qKzNWwDCq313WrIe78qf7z9ajmhOhbi3XKAQ8zixV6kzNno402YXbPVr
	 qovUx7gyk2ZSbLGxXUFtSnV9vstoAwv2ZurmR2QllbrdY0SH3QilZdM6gBYVGI2XZ+
	 rr68eBN5ODYo5y17a2Ikc9qQqTksCBLSGNy0oQ/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/158] i2c: omap: Fix an error handling path in omap_i2c_probe()
Date: Tue, 22 Jul 2025 15:45:36 +0200
Message-ID: <20250722134346.383785228@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 666c23af755dccca8c25b5d5200ca28153c69a05 upstream.

If an error occurs after calling mux_state_select(), mux_state_deselect()
should be called as already done in the remove function.

Fixes: b6ef830c60b6 ("i2c: omap: Add support for setting mux")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <stable@vger.kernel.org> # v6.15+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/998542981b6d2435c057dd8b9fe71743927babab.1749913149.git.christophe.jaillet@wanadoo.fr
Stable-dep-of: a9503a2ecd95 ("i2c: omap: Handle omap_i2c_init() errors in omap_i2c_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-omap.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -1461,13 +1461,13 @@ omap_i2c_probe(struct platform_device *p
 		if (IS_ERR(mux_state)) {
 			r = PTR_ERR(mux_state);
 			dev_dbg(&pdev->dev, "failed to get I2C mux: %d\n", r);
-			goto err_disable_pm;
+			goto err_put_pm;
 		}
 		omap->mux_state = mux_state;
 		r = mux_state_select(omap->mux_state);
 		if (r) {
 			dev_err(&pdev->dev, "failed to select I2C mux: %d\n", r);
-			goto err_disable_pm;
+			goto err_put_pm;
 		}
 	}
 
@@ -1515,6 +1515,9 @@ omap_i2c_probe(struct platform_device *p
 
 err_unuse_clocks:
 	omap_i2c_write_reg(omap, OMAP_I2C_CON_REG, 0);
+	if (omap->mux_state)
+		mux_state_deselect(omap->mux_state);
+err_put_pm:
 	pm_runtime_dont_use_autosuspend(omap->dev);
 	pm_runtime_put_sync(omap->dev);
 err_disable_pm:


