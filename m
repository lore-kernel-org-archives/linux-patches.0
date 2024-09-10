Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9549319048A;
	Tue, 10 Sep 2024 10:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964073; cv=none; b=myurAL8KQMOe8z8kbw1DUl1sXft07xr28uxLekZ4o8ZfgF00eZjUpE64gi/59ixIc92C54ro66gO4r2MFGGuDu92AlqlDnJ7lnOJXo7GQTDu0nZYZwu/scSi1qaRxQbX7Q2byzgGGd1ri7BY3JWegO6K9q86J0u0tzk5LMOQkEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964073; c=relaxed/simple;
	bh=COO9JbYuDmUZTbButwbVAT5onZtqJXCsHxjUYWBen8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSJWzNKM2QQvnoasHa5v+MTQop5MmdspjjCBdmSWNtXjzxKX/djzJkdCiKj6z10i1nuCAoK3qCr8+HQ5AIapBxAGreHcvVFsqOtV9GDdyrHwOGPzsF6ycw3Ig9fSD/ExEr62vQYUnojiVLpgtaeoHVfoCC2D5+AT/c/2ufdBxpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zzeb8taf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zzeb8taf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEC1C4CEC3;
	Tue, 10 Sep 2024 10:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964073;
	bh=COO9JbYuDmUZTbButwbVAT5onZtqJXCsHxjUYWBen8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zzeb8tafeRxXSnxnVnYCkrIdcqQxtLTg3kBovtBC4S0EWYfnelr0Kuav1+6hLP1nO
	 7/ECTTabn39lnTLBHqINjaTmNSxsb6hUzZ9uuKt1rObokmykVZ2CbdlXOG08RDXxX1
	 Olsy1XAqyfttQPqlrT0X/jHed9O2rCOY4bB9ReuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Xingyu Wu <xingyu.wu@starfivetech.com>,
	Hal Feng <hal.feng@starfivetech.com>,
	Michael Jeanson <mjeanson@efficios.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.6 032/269] clk: starfive: jh7110-sys: Add notifier for PLL0 clock
Date: Tue, 10 Sep 2024 11:30:19 +0200
Message-ID: <20240910092609.390942612@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingyu Wu <xingyu.wu@starfivetech.com>

commit 538d5477b25289ac5d46ca37b9e5b4d685cbe019 upstream.

Add notifier function for PLL0 clock. In the function, the cpu_root clock
should be operated by saving its current parent and setting a new safe
parent (osc clock) before setting the PLL0 clock rate. After setting PLL0
rate, it should be switched back to the original parent clock.

Fixes: e2c510d6d630 ("riscv: dts: starfive: Add cpu scaling for JH7110 SoC")
Cc: stable@vger.kernel.org
Reviewed-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Signed-off-by: Xingyu Wu <xingyu.wu@starfivetech.com>
Link: https://lore.kernel.org/r/20240826080430.179788-2-xingyu.wu@starfivetech.com
Reviewed-by: Hal Feng <hal.feng@starfivetech.com>
Tested-by: Michael Jeanson <mjeanson@efficios.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../clk/starfive/clk-starfive-jh7110-sys.c    | 31 ++++++++++++++++++-
 drivers/clk/starfive/clk-starfive-jh71x0.h    |  2 ++
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/starfive/clk-starfive-jh7110-sys.c b/drivers/clk/starfive/clk-starfive-jh7110-sys.c
index 8f5e5abfa178..17325f17696f 100644
--- a/drivers/clk/starfive/clk-starfive-jh7110-sys.c
+++ b/drivers/clk/starfive/clk-starfive-jh7110-sys.c
@@ -385,6 +385,32 @@ int jh7110_reset_controller_register(struct jh71x0_clk_priv *priv,
 }
 EXPORT_SYMBOL_GPL(jh7110_reset_controller_register);
 
+/*
+ * This clock notifier is called when the rate of PLL0 clock is to be changed.
+ * The cpu_root clock should save the curent parent clock and switch its parent
+ * clock to osc before PLL0 rate will be changed. Then switch its parent clock
+ * back after the PLL0 rate is completed.
+ */
+static int jh7110_pll0_clk_notifier_cb(struct notifier_block *nb,
+				       unsigned long action, void *data)
+{
+	struct jh71x0_clk_priv *priv = container_of(nb, struct jh71x0_clk_priv, pll_clk_nb);
+	struct clk *cpu_root = priv->reg[JH7110_SYSCLK_CPU_ROOT].hw.clk;
+	int ret = 0;
+
+	if (action == PRE_RATE_CHANGE) {
+		struct clk *osc = clk_get(priv->dev, "osc");
+
+		priv->original_clk = clk_get_parent(cpu_root);
+		ret = clk_set_parent(cpu_root, osc);
+		clk_put(osc);
+	} else if (action == POST_RATE_CHANGE) {
+		ret = clk_set_parent(cpu_root, priv->original_clk);
+	}
+
+	return notifier_from_errno(ret);
+}
+
 static int __init jh7110_syscrg_probe(struct platform_device *pdev)
 {
 	struct jh71x0_clk_priv *priv;
@@ -413,7 +439,10 @@ static int __init jh7110_syscrg_probe(struct platform_device *pdev)
 		if (IS_ERR(priv->pll[0]))
 			return PTR_ERR(priv->pll[0]);
 	} else {
-		clk_put(pllclk);
+		priv->pll_clk_nb.notifier_call = jh7110_pll0_clk_notifier_cb;
+		ret = clk_notifier_register(pllclk, &priv->pll_clk_nb);
+		if (ret)
+			return ret;
 		priv->pll[0] = NULL;
 	}
 
diff --git a/drivers/clk/starfive/clk-starfive-jh71x0.h b/drivers/clk/starfive/clk-starfive-jh71x0.h
index 23e052fc1549..e3f441393e48 100644
--- a/drivers/clk/starfive/clk-starfive-jh71x0.h
+++ b/drivers/clk/starfive/clk-starfive-jh71x0.h
@@ -114,6 +114,8 @@ struct jh71x0_clk_priv {
 	spinlock_t rmw_lock;
 	struct device *dev;
 	void __iomem *base;
+	struct clk *original_clk;
+	struct notifier_block pll_clk_nb;
 	struct clk_hw *pll[3];
 	struct jh71x0_clk reg[];
 };
-- 
2.46.0



