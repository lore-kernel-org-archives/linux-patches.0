Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9522C12D1FC;
	Tue, 30 Apr 2024 11:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474956; cv=none; b=dwE61s0Noml8d9BQC0WsaIwn8pyiLRtL9FL0YEysiwsJwYtrv/rsjvtKsWee+u5o4pyff6MWvLk6XW9TVCbw5WA2RxyPsf/oD90spvOI5mH5Y7JhAI3LuEviqP9W54B0cMDYM/TrGlvlD1mlnn2fGPIDUuzeDXbMHShtzZaN/PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474956; c=relaxed/simple;
	bh=Zn/hqPe71RkA7ic/DpLf+gAcJgL/nvONLVqizo+bvIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bknuj8oPu23aXBxLT6gOD/yNygZCvXkurcdIYqCCSmOgiQBFOGTuNQcGnxcCdbfXtt+h7WygZ2UamflUAlLhp+fD0ucs9yTj2a+IiCfCXsfxf8uLpIIFPdduD5RzHVxA8qSkM1l1sXcxONx6VuBdE1vlpuTdWscF5tH9Q5f3Rv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfO+8qcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfO+8qcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A319C4AF1A;
	Tue, 30 Apr 2024 11:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474956;
	bh=Zn/hqPe71RkA7ic/DpLf+gAcJgL/nvONLVqizo+bvIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kfO+8qcXa2zEibSYoXqdP0NNcJ39gcMM54pP5s1p2Ln8sKxfJ2B7dwr1WJQgq0PQM
	 IFdF8xfCA6dKYa0hNEpEHJM72KlYacXsbY4a8CZ8W1QzrtN+76trz5oY8WbObZwpa1
	 LeppBwpVRONTBGDGAfnsVqrHgwsGAdJ7TAQZ6Wj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/138] clk: Initialize struct clk_core kref earlier
Date: Tue, 30 Apr 2024 12:38:53 +0200
Message-ID: <20240430103050.842748562@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bcaaadb0fed8d..d2b6c374c3f95 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -3632,8 +3632,6 @@ static int __clk_core_init(struct clk_core *core)
 	}
 
 	clk_core_reparent_orphans_nolock();
-
-	kref_init(&core->ref);
 out:
 	clk_pm_runtime_put(core);
 unlock:
@@ -3843,6 +3841,16 @@ static void clk_core_free_parent_map(struct clk_core *core)
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
@@ -3863,6 +3871,8 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
 		goto fail_out;
 	}
 
+	kref_init(&core->ref);
+
 	core->name = kstrdup_const(init->name, GFP_KERNEL);
 	if (!core->name) {
 		ret = -ENOMEM;
@@ -3917,12 +3927,10 @@ __clk_register(struct device *dev, struct device_node *np, struct clk_hw *hw)
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
@@ -4002,16 +4010,6 @@ int of_clk_hw_register(struct device_node *node, struct clk_hw *hw)
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



