Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD72CA6F;
	Sat, 12 Sep 2026 11:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211547; cv=none; b=qrKFM9SBLa4QHIupLFA7Yvj0SGLu+TFzq/FDrQnUUyRAp1s0X2P0wIN8+6FF8vwMCmX+6thdmllsn2rWMy6ePhyOSNhoKMLuTVD8xcOieOESJIm5U2k4bq4MLdi8n+yE6IWjFlaTLpMeEY6vqrC2XWaHe84A5rvR23VYiTPSBSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211547; c=relaxed/simple;
	bh=fKsIIjYHxtgUh+xGOoq8NDIitdl872ZkdPUM+7MJysA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGXTDoxzu4asgCmiiHzflFN8DSBKgRX3PTPYcLU/0W7edNVtDh8WnHvRHHnavIKi94BVMlkS2ltRJN6WK/1DSuqVBhMcF9FgFgIDCwJyqTGXePSUS7IGT6yMH13xB2YgXlg75qd//yps5jv7I2XmvSoPCjY1CxZGgVBnsenV+gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZDu1KWav; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZDu1KWav"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078691F000FF;
	Sat, 12 Sep 2026 11:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211546;
	bh=iROFyW8nELZh8hqWGeEnCf3BijzamJDbEYrrjBj8guE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZDu1KWavHfuwuuscrrobu0JyaznnliMZMaZYg7r1jf8UulIZIAb+QFeQJi8KBnIsG
	 X5sV0E4qvcWdbagdUXnTCxCW0qB3EuDCitUGVqH/qqh9LNxvzFyAXvrrl2hlzkvZ/4
	 L7og2bQoxTxwJf5esXkys6bdmoyIQLNYnBxxlMQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>,
	Brian Masney <bmasney@redhat.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1254/1518] clk: ti: mux: resolve parent clocks by DT index, not by name
Date: Sat, 12 Sep 2026 08:57:03 +0200
Message-ID: <20260912065651.878451427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>

[ Upstream commit 667f420c09f1417c9f07798e32432c901915209d ]

Resolve parent clocks by their index into the device tree "clocks"
property rather than matching names as strings. Name-based matching is
fragile because a clock's "clock-output-names" value in its provider
node can differ from the name used to reference it in a consumer node,
and because names must be globally unique across all clock providers.

On AM335x, this caused broken clock trees where some clocks failed to
enable because their parents could not be found.

Replace of_clk_parent_fill() with a clk_parent_data array that sets
.index to the array position.

Fixes: ec7aa25fa483 ("ARM: dts: Use clock-output-names for am3")
Signed-off-by: Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/mux.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/clk/ti/mux.c b/drivers/clk/ti/mux.c
index d6d247ff2be59..6f7a138c24b1a 100644
--- a/drivers/clk/ti/mux.c
+++ b/drivers/clk/ti/mux.c
@@ -119,7 +119,7 @@ const struct clk_ops ti_clk_mux_ops = {
 };
 
 static struct clk *_register_mux(struct device_node *node, const char *name,
-				 const char * const *parent_names,
+				 const struct clk_parent_data *parent_data,
 				 u8 num_parents, unsigned long flags,
 				 struct clk_omap_reg *reg, u8 shift, u32 mask,
 				 s8 latch, u8 clk_mux_flags, u32 *table)
@@ -136,7 +136,7 @@ static struct clk *_register_mux(struct device_node *node, const char *name,
 	init.name = name;
 	init.ops = &ti_clk_mux_ops;
 	init.flags = flags;
-	init.parent_names = parent_names;
+	init.parent_data = parent_data;
 	init.num_parents = num_parents;
 
 	/* struct clk_mux assignments */
@@ -167,24 +167,26 @@ static void of_mux_clk_setup(struct device_node *node)
 	struct clk *clk;
 	struct clk_omap_reg reg;
 	unsigned int num_parents;
-	const char **parent_names;
+	struct clk_parent_data *parent_data;
 	const char *name;
 	u8 clk_mux_flags = 0;
 	u32 mask = 0;
 	u32 shift = 0;
 	s32 latch = -EINVAL;
 	u32 flags = CLK_SET_RATE_NO_REPARENT;
+	int i;
 
 	num_parents = of_clk_get_parent_count(node);
 	if (num_parents < 2) {
 		pr_err("mux-clock %pOFn must have parents\n", node);
 		return;
 	}
-	parent_names = kcalloc(num_parents, sizeof(char *), GFP_KERNEL);
-	if (!parent_names)
-		goto cleanup;
+	parent_data = kcalloc(num_parents, sizeof(*parent_data), GFP_KERNEL);
+	if (!parent_data)
+		return;
 
-	of_clk_parent_fill(node, parent_names, num_parents);
+	for (i = 0; i < num_parents; i++)
+		parent_data[i].index = i;
 
 	if (ti_clk_get_reg_addr(node, 0, &reg))
 		goto cleanup;
@@ -207,7 +209,7 @@ static void of_mux_clk_setup(struct device_node *node)
 	mask = (1 << fls(mask)) - 1;
 
 	name = ti_dt_clk_name(node);
-	clk = _register_mux(node, name, parent_names, num_parents,
+	clk = _register_mux(node, name, parent_data, num_parents,
 			    flags, &reg, shift, mask, latch, clk_mux_flags,
 			    NULL);
 
@@ -215,7 +217,7 @@ static void of_mux_clk_setup(struct device_node *node)
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 
 cleanup:
-	kfree(parent_names);
+	kfree(parent_data);
 }
 CLK_OF_DECLARE(mux_clk, "ti,mux-clock", of_mux_clk_setup);
 
-- 
2.53.0



