Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B205B1487C1;
	Tue, 23 Apr 2024 21:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908618; cv=none; b=sOJtB5TuXLL9K8wus3RI0bKh1u8ILjipm9Ej1AGv2dlcf/6lOoTsN4uDFGBKzrC9j7QDE3foUEs4qkxJJIA+2q6b0NtJcmp7YwI5v14/lHSuS+PXAdpiUbF/riebKv2oe7RbyNWmu+bfEzNHYV097OlVuzik6clUJwoQRDp6qwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908618; c=relaxed/simple;
	bh=E7BfcHXuDKdyT7P20zL3hqd/hmuuXLmnvO9V9a46whA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJJW6WEqGkpn3Xf7NZRBY+F87B3Bju8emB/yEzMfE+Dt6jlrP294obMWPcVnPuUAKixJM2Qa21xWtAku6+SbaGX0ReEiYaZQ1EEq6LuZRA7xrAysBafH1OSQdDwK7w0pDyIJkEcmQhbUIpE/phnTUrC/xSg07g+i5Xg02qH4Gno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xc5XntyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xc5XntyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877A1C32782;
	Tue, 23 Apr 2024 21:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908618;
	bh=E7BfcHXuDKdyT7P20zL3hqd/hmuuXLmnvO9V9a46whA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xc5XntyCUWeUIF1x9ex6tO/zxQ70ts+5xvuixHEeXM3TPaA8w+d+V8LGJH+Kzed7z
	 M3EeCHINcbddTSZmqrAvmOYmdK+e1rgXppNiitHNYHXd3r2kMZaGixXSyvs6PQ67uA
	 hdf+S9/XXhNyIKKNEJjWJQxt/6eGfuUgNCbtD4yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 092/158] clk: Initialize struct clk_core kref earlier
Date: Tue, 23 Apr 2024 14:38:49 -0700
Message-ID: <20240423213858.731476112@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

From: Stephen Boyd <sboyd@kernel.org>

[ Upstream commit 9d05ae531c2cff20d5d527f04e28d28e04379929 ]

Initialize this kref once we allocate memory for the struct clk_core so
that we can reuse the release function to free any memory associated
with the structure. This mostly consolidates code, but also clarifies
that the kref lifetime exists once the container structure (struct
clk_core) is allocated instead of leaving it in a half-baked state for
most of __clk_core_init().

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Link: https://lore.kernel.org/r/20240325184204.745706-4-sboyd@kernel.org
Stable-dep-of: e581cf5d2162 ("clk: Get runtime PM before walking tree during disable_unused")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index ac5be561ccdc9..56b8f540e8abe 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3919,8 +3919,6 @@ static int __clk_core_init(struct clk_core *core)
 	}
 
 	clk_core_reparent_orphans_nolock();
-
-	kref_init(&core->ref);
 out:
 	clk_pm_runtime_put(core);
 unlock:
@@ -4149,6 +4147,16 @@ static void clk_core_free_parent_map(struct clk_core *core)
 	kfree(core->parents);
 }
 
+/* Free memory allocated for a struct clk_core */
+static void __clk_release(struct kref *ref)
+{
+	struct clk_core *core = container_of(ref, struct clk_core, ref);
+
+	clk_core_free_parent_map(core);
+	kfree_const(core->name);
+	kfree(core);
+}
+
 static struct clk *
 __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
 {
@@ -4169,6 +4177,8 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
 		goto fail_out;
 	}
 
+	kref_init(&core->ref);
+
 	core->name = kstrdup_const(init->name, GFP_KERNEL);
 	if (!core->name) {
 		ret = -ENOMEM;
@@ -4223,12 +4233,10 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
 	hw->clk = NULL;
 
 fail_create_clk:
-	clk_core_free_parent_map(core);
 fail_parents:
 fail_ops:
-	kfree_const(core->name);
 fail_name:
-	kfree(core);
+	kref_put(&core->ref, __clk_release);
 fail_out:
 	return ERR_PTR(ret);
 }
@@ -4308,16 +4316,6 @@ int of_clk_hw_register(struct device_node *node, struct clk_hw *hw)
 }
 EXPORT_SYMBOL_GPL(of_clk_hw_register);
 
-/* Free memory allocated for a clock. */
-static void __clk_release(struct kref *ref)
-{
-	struct clk_core *core = container_of(ref, struct clk_core, ref);
-
-	clk_core_free_parent_map(core);
-	kfree_const(core->name);
-	kfree(core);
-}
-
 /*
  * Empty clk_ops for unregistered clocks. These are used temporarily
  * after clk_unregister() was called on a clock and until last clock
-- 
2.43.0



