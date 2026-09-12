Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C9B208D0;
	Sat, 12 Sep 2026 09:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204586; cv=none; b=EcgXcm9neacNatyHGikK43j+obhyjmnBakjxFoQOexiJnjH9c74KKfvXApUuhwqnAJ3cPoeW8k7d6cm7/uGQqvIGqKZp7n8TUbK2LK7RvbFiekBI57v0I9CPs042iBIeDaX2z/qvJwKHw5k4fKMH8jUApSWA3sSRDUNt/tvGzuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204586; c=relaxed/simple;
	bh=q5M0sKqaWa+Wsq71b0dStIDh1MctYcJIzb6vbcVKpG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lG1JaZ87lej4xEnhhm+CBHm12wDndjWwgNrvJh8Z1w5rFrmpYnJvPY23dOX5F/AgYi8VwUM8lhUUleC39r5CSEAdonBj9iP68TbmulkzABCEkFY6rqF+GO+gVXo+5Hzgzy98MW7gPll3omX2St0RY/A7KaYNSJHQA2AdvrWv33Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLEcxQD4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLEcxQD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF4D1F000FF;
	Sat, 12 Sep 2026 09:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204584;
	bh=KfVUq1ocDo5EXDvPOiVr3OWSW9tzx+CAififBZVXBnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLEcxQD4DUTQnCC3lkMPiRRtKiLOU7B858a30QxPYUejh0E1u0ImqguDW2pqbGDXN
	 71khqYr2mUWa7f8kMskHhc3l3syQw4De45h8wa4jLsoG2yGXoT9vA1OWlOPw9xUlpd
	 15XHaRB2OXBa7GFe/gqyPFaZHraPisaZ1QJ4cghM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1641/1815] clk: ti: Make sure clk_init_data is fully initialized
Date: Sat, 12 Sep 2026 08:56:31 +0200
Message-ID: <20260912065727.517248665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index af923b8cb0ed8..3b438c2d68aac 100644
--- a/drivers/clk/ti/divider.c
+++ b/drivers/clk/ti/divider.c
@@ -311,7 +311,7 @@ static struct clk *_register_divider(struct device_node *node,
 				     u32 flags,
 				     struct clk_omap_divider *div)
 {
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	const char *parent_name;
 	const char *name;
 
diff --git a/drivers/clk/ti/mux.c b/drivers/clk/ti/mux.c
index ded4432f7528c..0fef60e82107a 100644
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
 	mux = kzalloc_obj(*mux);
-- 
2.53.0



