Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED029472074;
	Sat, 12 Sep 2026 11:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211824; cv=none; b=O30X7/yh6cxZWwZ/AcChoycglSHimpUB60Rtd4McYLGyFu/Ob/YVwydqYAFA14O7AJmNJ8GZueMX8sWIXTWXkkWXTpnar+b7PanE0mhnCoDTKA8I5GWEWoEX4att6O1RVLIVHM7ThMpjNZGexW6iO9tjUPeE8A3UdqcgLW487AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211824; c=relaxed/simple;
	bh=IaasfmgSzle0MirDIoJQ1yTzdVczK1kRwKGx6tt29jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NT5hQDttZHg4PkW19Xsx3/UM8prF3s2/wWuWvo9OYIWWeAgJaE0AOKD+r9RmsBFYuJdK2HGNnjTJDZIGp/Kzoi3DQutUtvF3hgEuQpJZloQpZd9E1imbIihnBSF8qkWgh0S1+lylYO0m4ydrABg3NPFNjTuY0vLmSrDJDceEQcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYWbyuSn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYWbyuSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E32A91F000FF;
	Sat, 12 Sep 2026 11:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211822;
	bh=hgPXmn2MflPxdLJvUjB3TYNPhspkayIJA3wDZUMCE8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VYWbyuSn4r7fbm+8DZt4+5gCNfBtUTcAn040TrS9Zf9F48sDbHBhzZX8Jlc27HTVX
	 UjQXjbiK7ZEwARG+B36+jI54UxynrfhNIGkV8CWABEXhjKoPBVsyF2lHmHEklMEO6O
	 ljZtyesf8BLoDD77M13hHQC80631v7RJxcudYj/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Mathieu Dubois-Briand <mathieu.dubois-briand@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1310/1518] clk: ti: Make sure clk_init_data is fully initialized
Date: Sat, 12 Sep 2026 08:57:59 +0200
Message-ID: <20260912065653.160373118@linuxfoundation.org>
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
index 6f58a0f2e74ae..ea744c343eac8 100644
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
index 6f7a138c24b1a..ef2a952a0afe5 100644
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



