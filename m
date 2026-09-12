Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD9747AF6D;
	Sat, 12 Sep 2026 16:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231817; cv=none; b=c1RGSzJTlvSvro+vrpKTvkuSME1QUPL+rsdgCj/wv4QgaiDv6ATvW+KswwgPahHG6z16s3LyUklE/rnP+cfnvVmoLvcb59SuxCE48XtX20TO+dVq6sc86NoEQV2VggDw9eZahgweoT8XDYJ4ATHrmEdddMVxbPmUif6y4lXQEdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231817; c=relaxed/simple;
	bh=58EmE5+DspNNQjdqiOdsysjjnRXsgoJrjbynXHNudiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IujNxeF7nXm251S+z53b20WL6xoby/JHzsQif3Jz7pF3gpLDCvq3nTWcI772DBEQXid3QOQayT77royZpCBvXOm81oQ91o2N5y3phZQyd4g13yH6nqZX8uj2TqYAib7fxON5KaInDZcy6A9md4eoNq8KeWNBsfaxr94ELmj4s04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQnKAMfZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQnKAMfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEB81F000FF;
	Sat, 12 Sep 2026 16:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231815;
	bh=ULzpPptJTFGZFMwR7bzKqEAiFMdCKCilrabLiGlMrqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQnKAMfZBsY5WZuG2jNPiZfNSRP9IRHWV9w6IvvXKHDiLWaWDS+YXFe1a3Bw4iRvT
	 ANqu5pEeFhGu6t/99jtF/YykmWM+NgOOI5JN/varCw9gybvUbI+KvR6eylmtPRbCt/
	 pDWZmV/sXX9IVoX1bBaz+EPXrS6k9PONPAVqRxf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1076/1191] clk: ti: Make sure clk_init_data is fully initialized
Date: Sat, 12 Sep 2026 09:03:24 +0200
Message-ID: <20260912065612.337908174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f5e7e20492418..34d72f81a4a82 100644
--- a/drivers/clk/ti/adpll.c
+++ b/drivers/clk/ti/adpll.c
@@ -481,7 +481,7 @@ static const struct clk_ops ti_adpll_ops = {
 
 static int ti_adpll_init_dco(struct ti_adpll_data *d)
 {
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	struct clk *clock;
 	const char *postfix;
 	int width, err;
@@ -574,7 +574,7 @@ static int ti_adpll_init_clkout(struct ti_adpll_data *d,
 				struct clk *clk1)
 {
 	struct ti_adpll_clkout_data *co;
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	struct clk_ops *ops;
 	const char *parent_names[2];
 	const char *child_name;
diff --git a/drivers/clk/ti/divider.c b/drivers/clk/ti/divider.c
index 5d5bb123ba949..262764df54667 100644
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
index 3733480fccedb..0c81ef9e56a62 100644
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



