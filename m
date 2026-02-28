Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C243D36C9CE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302215; cv=none; b=IAe5RMQ302TMM6I/3jcWEzMDjYvYmrFMFcqv0DSczVf7yjAc4j28T+5A1bElGEKkiVEZeQjh4e2jASCMxSzo0HZsGuQtM0ImAoiC50SPEqNVfsmbMtqzxUp+c15Hm05USeRKOucRu7qu0bfRTBQVgng5UE2OlOgpHCuiWlyHA6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302215; c=relaxed/simple;
	bh=gbPNgNDgOgm+eXqeTKFJUHl5NGkaidZVERVkR0m2ZVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eaWoMp3DG0lW0IefLeC5j/F9/V/fcrqGqdHnJ7c1Sf8FG96N8E4LnlLtHXsPRXKTXZgoWkWeIWe2yiiAzwP8Ha8cvGKU9ZleZFozcbbDtGjpEZ0y6bFgrwrY1BRj6XKsJdoGNaWGQoTVhL8xwiHDJ3bBAcZQaLq2qIxrQQ9tZ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BV+NDZN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BV+NDZN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3CFC2BC87;
	Sat, 28 Feb 2026 18:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302215;
	bh=gbPNgNDgOgm+eXqeTKFJUHl5NGkaidZVERVkR0m2ZVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BV+NDZN3hJve1iwMenAlvd6Ohhj6Cvroejdd+YuZcJDuW80kZeS0Y6tqYzLHOnGQ2
	 3QSP6e72fU6CWwDcvyqa54aUj/55DASDNphttb2E91hsUngC/JIs+NYelZ30NmdOMw
	 YovFoK1XNmUyexIL55M3ctG9n4hZQ14SH1cjgSy1A3AtbVA6mChmqsTb+Z6LqYP8aV
	 eVWWrnfKjEBdjmdvAGEtjn6pB24pX6GqPUBHngZXxvRCMrKuL6xoJ38qV4iwKQkI31
	 L7BG+tYDZ3UJyCia49DZn+Low6siz+oMkF50zmb11PoZaYhHeOREmxuvEqbk37XaT9
	 jian8kYESatSg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	kernel test robot <lkp@intel.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 222/283] clk: Move clk_{save,restore}_context() to COMMON_CLK section
Date: Sat, 28 Feb 2026 13:06:04 -0500
Message-ID: <20260228180709.1583486-222-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 06f1b292f8a00..862ef29ee5f0e 100644
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
@@ -872,23 +896,6 @@ struct clk *clk_get_parent(struct clk *clk);
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
@@ -1055,13 +1062,6 @@ static inline struct clk *clk_get_sys(const char *dev_id, const char *con_id)
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

