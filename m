Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC1814388D;
	Tue, 23 Apr 2024 21:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908500; cv=none; b=YqiqoANzG9SclWPF7S4crPJLyUoVs2mavOCYiokiWSQ57rNsXMuDzHvJhrUMur3acXEaiYm3TPufsxwY7wGO498a+iKEfvjA38G3lR9Lu5qaIzsQ1ZPMZHAcdmXL+xS1eKZexc4K83xqmSIU5P7e8OraJrwmyPhC1698F5g9NVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908500; c=relaxed/simple;
	bh=6wKS8C6H6bVYIvF/lBw7Aj+S178kbhCSKmieUG0c71s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7M9q9fQdmbHx3kB1q4YJt8k1g0Ki9F7bDwxy+rKOhquMxDthoU36Q2ccu8SPId5tu1uW8goEbrJSXrHFRDrRTbJ9/eNHYNMrRuP2Xd6N1NuYOk0wEIxIixFOtP8Dy4eihxInp78NnOky7x2SmlCOE5oyeD3CfyUXwYstgj0EYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhuWSg0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhuWSg0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7110FC32782;
	Tue, 23 Apr 2024 21:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908500;
	bh=6wKS8C6H6bVYIvF/lBw7Aj+S178kbhCSKmieUG0c71s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhuWSg0HPYn+DVMGatEmkbEvabGGaRuB4RstLXfBNLl+Dxjq9K0XmCMFftKfs5IOa
	 hO6CNQ8LI4lOXGB2KLzqiPjBLhxjXauhw+mZnIiQowFNzO37kCLuk9JIodkjzd1cKZ
	 fCKIuabGkwfYKMa6R5oS5K4KwkcBNOWrwhNKkhVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 079/158] clk: Initialize struct clk_core kref earlier
Date: Tue, 23 Apr 2024 14:38:21 -0700
Message-ID: <20240423213858.524644694@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index c6928dce50f23..d5a1e68ee20b7 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3962,8 +3962,6 @@ static int __clk_core_init(struct clk_core *core)
 	}
 
 	clk_core_reparent_orphans_nolock();
-
-	kref_init(&core->ref);
 out:
 	clk_pm_runtime_put(core);
 unlock:
@@ -4192,6 +4190,16 @@ static void clk_core_free_parent_map(struct clk_core *core)
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
@@ -4212,6 +4220,8 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
 		goto fail_out;
 	}
 
+	kref_init(&core->ref);
+
 	core->name = kstrdup_const(init->name, GFP_KERNEL);
 	if (!core->name) {
 		ret = -ENOMEM;
@@ -4266,12 +4276,10 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
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
@@ -4351,16 +4359,6 @@ int of_clk_hw_register(struct device_node *node, struct clk_hw *hw)
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



