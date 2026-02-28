Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BF735AC33
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302749; cv=none; b=aYHY+v/5HNHws1a2tR8V+d0CWfjL0gyn0ymy2C0sDIIJv2OTKtbqL+VJCVN4OgHMbIY/6EcB6l7zGI/9VtXhinkpOvGtSaFo2NSleBl78L233AXOnWQJ1rXFyWD51ZDRCgY1hfmTZNAPRlo4alSVMx565LE4hmEidDwSCsVtSAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302749; c=relaxed/simple;
	bh=PVCID+cTLCLzdMDi9KUs7oiEnNITbIKkSD65to2MLn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOtiZyQCCGb7/tHTLMqYyi21eo+Pz2RticJsIONAyZre0rqOb4sScUAluf/7EzOeMkN1AkFkQ8oe80Rm+fLqH3P2bem5rlUH9Cbqytf2wwKoKQssbB2+BKJKFqzWSER8KrxT7b6/sm6wD40zNpvRnJbT7PGURDFsa+eiPAR1jPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YQL+cuBk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YQL+cuBk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C2AC116D0;
	Sat, 28 Feb 2026 18:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302748;
	bh=PVCID+cTLCLzdMDi9KUs7oiEnNITbIKkSD65to2MLn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQL+cuBkHuyNpTbx/nNDViLevLs3EYD+YXKTf8SiC7BxYwcfsZTWH3pae5q0IZ9mG
	 JjvY3jxSgLYyh8Vr2OHRl4zqsTWn2hhGqcXZShzja/wCuuPeMLu28WZP0U5oc2DEfb
	 ZU6qmj5z+ceYXMJF6/MZn7HmPUfU27PG1RyitVTonwShKnkHQjc8ktMLLEkMl70q1A
	 qoWsXo+zTiXUe/V1+MM09lOdaKWe/Ri/BDGB6ZxZze7vJ/Z4JKQ7dCD7DAagcvH0PA
	 prEtO7mpZX4o2TnOnmKLKKl/Y9RJwoukoxwXYzGcB/a6aQ3iOK04qMEikm75MkxXQ6
	 8g7JuYcxl4P0w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	kernel test robot <lkp@intel.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/147] clk: Move clk_{save,restore}_context() to COMMON_CLK section
Date: Sat, 28 Feb 2026 13:17:04 -0500
Message-ID: <20260228181736.1605592-116-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 12c85ba606ec5..cfa53819276ec 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -205,6 +205,23 @@ int clk_rate_exclusive_get(struct clk *clk);
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
@@ -258,6 +275,13 @@ static inline int clk_rate_exclusive_get(struct clk *clk)
 
 static inline void clk_rate_exclusive_put(struct clk *clk) {}
 
+static inline int clk_save_context(void)
+{
+	return 0;
+}
+
+static inline void clk_restore_context(void) {}
+
 #endif
 
 /**
@@ -819,23 +843,6 @@ struct clk *clk_get_parent(struct clk *clk);
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
@@ -1002,13 +1009,6 @@ static inline struct clk *clk_get_sys(const char *dev_id, const char *con_id)
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

