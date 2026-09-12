Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588D737B00E;
	Sat, 12 Sep 2026 13:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218898; cv=none; b=rFVYok+r68OThNpvX5tZ+rt2CC8/r5gZ5VaXfZvvTBgvhg9DquZe9xhL8F3J74Gsz1Q7O319QR4gDWAYhh4X+N3G0P1oqz8q1EaUHkMcNRAlaq/TcK0e5hZlvMO3NbzHcWzsqKN00HB5fgmIU8hsOR1SZWN3+RqDpfqhWnoNBtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218898; c=relaxed/simple;
	bh=vYr7wZHqmVPuI5Sn8qTV3sLIMSwdSx9x0KLTF68hzf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jm7JPXaAYuSWJunQNyhT6X+ldCb7ZM89AtPBRQ2+ig5j1tw72EnIVrt8bQrI2pXmpur1ovn+5OZ+r5GC/edZKL58Tln0tglI3tAMzDV0/jBjQ1NgLbAn087gf+bCCjlHETpO2SpqyK09UvuhEScZEV1KIfniNwsnInEHSL5XE8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2omchrO+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2omchrO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2979B1F000FF;
	Sat, 12 Sep 2026 13:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218897;
	bh=8ZulsY2Dx5LlDX4bn/qh5jCKofWoe4efT+Z2BjCFQWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2omchrO+qDNrkaZzC+9V2qanMPtiveCoIlw5a2klHXcdinoYj7cbVwPTXMXHR+cbS
	 7yGd9emWHvpvCFpv1IPAZ3NUpclbT3BLomxm4ImRnqLcVrBQ9HVG2x23bKe8TByQwg
	 SaoTFwGTGhcdePd1aclymnzbMZKMLYB3wjN8Uc1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1239/1376] clk: ti: Make sure clk_init_data is fully initialized
Date: Sat, 12 Sep 2026 09:01:05 +0200
Message-ID: <20260912065635.159372798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 3ae1674975d48fb6d343d03ff7961abd6904af1a ]

The clk_init_data structure contains several mutually-exclusive members
for different methods to specify the possible parents of a clock,
prompting drivers to initialize only the members they need.  However,
not initializing all members may cause subtle issues, which are only
exposed when CONFIG_INIT_STACK_ALL_PATTERN or CONFIG_INIT_STACK_NONE is
enabled.

_register_mux() fills in init.parent_data, and assumes that
init.parent_names is NULL.  However, the latter is uninitialized, and
thus may cause a crash.

Make sure all members are fully initialized, to fix such bugs, and to
avoid future breakage when converting drivers to a different method for
specifying the parents.

Fixes: 667f420c09f1417c ("clk: ti: mux: resolve parent clocks by DT index, not by name")
Closes: https://lore.kernel.org/CAMuHMdU3yVqoyHC4eNF2NuYo8wy+6ODLoYat4R71X99Mxc_=kw@mail.gmail.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/adpll.c   | 4 ++--
 drivers/clk/ti/divider.c | 2 +-
 drivers/clk/ti/mux.c     | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/ti/adpll.c b/drivers/clk/ti/adpll.c
index e305fcbac6475..8885d28face50 100644
--- a/drivers/clk/ti/adpll.c
+++ b/drivers/clk/ti/adpll.c
@@ -483,7 +483,7 @@ static const struct clk_ops ti_adpll_ops = {
 
 static int ti_adpll_init_dco(struct ti_adpll_data *d)
 {
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	struct clk *clock;
 	const char *postfix;
 	int width, err;
@@ -576,7 +576,7 @@ static int ti_adpll_init_clkout(struct ti_adpll_data *d,
 				struct clk *clk1)
 {
 	struct ti_adpll_clkout_data *co;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	struct clk_ops *ops;
 	const char *parent_names[2];
 	const char *child_name;
diff --git a/drivers/clk/ti/divider.c b/drivers/clk/ti/divider.c
index ade99ab6cfa9b..3f30cb0806c1d 100644
--- a/drivers/clk/ti/divider.c
+++ b/drivers/clk/ti/divider.c
@@ -309,7 +309,7 @@ static struct clk *_register_divider(struct device_node *node,
 				     u32 flags,
 				     struct clk_omap_divider *div)
 {
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	const char *parent_name;
 	const char *name;
 
diff --git a/drivers/clk/ti/mux.c b/drivers/clk/ti/mux.c
index 91772c8be0414..1a0e12b3b3fd5 100644
--- a/drivers/clk/ti/mux.c
+++ b/drivers/clk/ti/mux.c
@@ -124,9 +124,9 @@ static struct clk *_register_mux(struct device_node *node, const char *name,
 				 struct clk_omap_reg *reg, u8 shift, u32 mask,
 				 s8 latch, u8 clk_mux_flags, u32 *table)
 {
+	struct clk_init_data init = {};
 	struct clk_omap_mux *mux;
 	struct clk *clk;
-	struct clk_init_data init;
 
 	/* allocate the mux */
 	mux = kzalloc(sizeof(*mux), GFP_KERNEL);
-- 
2.53.0



