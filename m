Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16E339B94E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302613; cv=none; b=I201CXwfaUQhNHn1x89htYXLNZ5xt9Y3YKO6J9KXGgQAjxpN6kBPRQ4PSwTIOXarr43vAkae82clLdtJ/Qln/BD/5zWpqR8Ah6YxPbKIlKVbg5nEF7yGShAU3wR3RJ5IO8avuHrtFB8SA3KSaF94WrsCFM9EPReKOO5k3pRvuG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302613; c=relaxed/simple;
	bh=XP6N5YXgtjQpRNibQG6StG7RKydx0bbQ+qDAWw+uAWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMsLEOwaguDe5pfs9V6z6Gex8pj5+EZ6s/dUizFV9zKExPJ3mITyandGAvIsUyzq1Sf9U+GxMZxVYoBYCObfa/nWOLGeL3aoy607U3YGlhJ/J2wy74ohQDk8CRQ2N77QQuBzjUb7w3EVBTcD59ylA83dqvgEixdqyuKqjEehLQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iy4/JMvI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iy4/JMvI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288A0C116D0;
	Sat, 28 Feb 2026 18:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302613;
	bh=XP6N5YXgtjQpRNibQG6StG7RKydx0bbQ+qDAWw+uAWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iy4/JMvIpTpFtIfTFBPLBMLMKtzIQxrowAPyZ+P/+3erVzcu5ExR0RRTgT2MvmCmX
	 GpsWL7UfCz4oMnQOl1eugoRHCmuZcyZ+S5DYWhQlLPojOOkbudTVCgnv45c0ilMYX/
	 9cCiU/+H/11MqvTN9rJj7oRs2piSZIhGNAqqvYwxOpv9tI621PePvc02rtHppWvIfM
	 gGmbpEK5sF47n0mWBpR/CR6NMixyfQ25pKLQHwbk7LYzIivH15yeQ1KWHt03T7BxA1
	 YyeOWC3M6IIWBglRcUOpDPEXhaizuOQkx3PsK7Fjcix9AVz83FvU75cOCxUNWgEt85
	 6h6pjHrfm/FkA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	kernel test robot <lkp@intel.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/164] clk: Move clk_{save,restore}_context() to COMMON_CLK section
Date: Sat, 28 Feb 2026 13:14:29 -0500
Message-ID: <20260228181505.1600663-130-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit f47c1b77d0a2a9c0d49ec14302e74f933398d1a3 ]

The clk_save_context() and clk_restore_context() helpers are only
implemented by the Common Clock Framework.  They are not available when
using legacy clock frameworks.  Dummy implementations are provided, but
only if no clock support is available at all.

Hence when CONFIG_HAVE_CLK=y, but CONFIG_COMMON_CLK is not enabled:

    m68k-linux-gnu-ld: drivers/net/phy/air_en8811h.o: in function `en8811h_resume':
    air_en8811h.c:(.text+0x83e): undefined reference to `clk_restore_context'
    m68k-linux-gnu-ld: drivers/net/phy/air_en8811h.o: in function `en8811h_suspend':
    air_en8811h.c:(.text+0x856): undefined reference to `clk_save_context'

Fix this by moving forward declarations and dummy implementions from the
HAVE_CLK to the COMMON_CLK section.

Fixes: 8b95d1ce3300c411 ("clk: Add functions to save/restore clock context en-masse")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511301553.eaEz1nEW-lkp@intel.com/
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/clk.h | 48 ++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/linux/clk.h b/include/linux/clk.h
index 05ab315aa84bc..47ab2d1adc4a1 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -216,6 +216,23 @@ int clk_rate_exclusive_get(struct clk *clk);
  */
 void clk_rate_exclusive_put(struct clk *clk);
 
+/**
+ * clk_save_context - save clock context for poweroff
+ *
+ * Saves the context of the clock register for powerstates in which the
+ * contents of the registers will be lost. Occurs deep within the suspend
+ * code so locking is not necessary.
+ */
+int clk_save_context(void);
+
+/**
+ * clk_restore_context - restore clock context after poweroff
+ *
+ * This occurs with all clocks enabled. Occurs deep within the resume code
+ * so locking is not necessary.
+ */
+void clk_restore_context(void);
+
 #else
 
 static inline int clk_notifier_register(struct clk *clk,
@@ -276,6 +293,13 @@ static inline int clk_rate_exclusive_get(struct clk *clk)
 
 static inline void clk_rate_exclusive_put(struct clk *clk) {}
 
+static inline int clk_save_context(void)
+{
+	return 0;
+}
+
+static inline void clk_restore_context(void) {}
+
 #endif
 
 #ifdef CONFIG_HAVE_CLK_PREPARE
@@ -859,23 +883,6 @@ struct clk *clk_get_parent(struct clk *clk);
  */
 struct clk *clk_get_sys(const char *dev_id, const char *con_id);
 
-/**
- * clk_save_context - save clock context for poweroff
- *
- * Saves the context of the clock register for powerstates in which the
- * contents of the registers will be lost. Occurs deep within the suspend
- * code so locking is not necessary.
- */
-int clk_save_context(void);
-
-/**
- * clk_restore_context - restore clock context after poweroff
- *
- * This occurs with all clocks enabled. Occurs deep within the resume code
- * so locking is not necessary.
- */
-void clk_restore_context(void);
-
 #else /* !CONFIG_HAVE_CLK */
 
 static inline struct clk *clk_get(struct device *dev, const char *id)
@@ -1042,13 +1049,6 @@ static inline struct clk *clk_get_sys(const char *dev_id, const char *con_id)
 	return NULL;
 }
 
-static inline int clk_save_context(void)
-{
-	return 0;
-}
-
-static inline void clk_restore_context(void) {}
-
 #endif
 
 /* clk_prepare_enable helps cases using clk_enable in non-atomic context. */
-- 
2.51.0

