Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B430C347FCC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302442; cv=none; b=tplXhTjQy9bn2QJ/tjln/4U7TU3HWzukU9GdYv9O8I+TD+QZtFSY1pGU9qhbL5465bSGfANVRWBcQvKPDuceuoeO2tNaivvvoRL7pV1wVQ6y31QoZFOe6F6NcW+fpm6avYQSHRRDomKrEOLbt8Yz5NIJP7j98XlAWvRpRm4gFLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302442; c=relaxed/simple;
	bh=gbPNgNDgOgm+eXqeTKFJUHl5NGkaidZVERVkR0m2ZVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7lUBlxohlNdUq0OqswW5uStFXAzLr0tzoMNauW2FkV7qZvS9eJ/jFGaisi5ygxOTubVKdZwkaI3FZaIQDj5PIRsfaCT5v7YziJ6hICjXDP3y6+IyY+ay/TaSgwTastSMAokwbiTHTcHSinxz3cPSq+p/1/T1iymmlQ4ubsq8Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ilhsfP2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ilhsfP2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07FDCC116D0;
	Sat, 28 Feb 2026 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302442;
	bh=gbPNgNDgOgm+eXqeTKFJUHl5NGkaidZVERVkR0m2ZVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ilhsfP2ot5elvG0DZeOc3an3M2PhOC9/vlNb0ApxFJLf29St/JlbeXRmGfP55mPVH
	 //SSXbT21lBmAACHPXGAhz7L2GqJCpy+xUAOn6SNCWZ7Y/wkVyZblgZHSRbZAVhXEt
	 BcSKVE3nppWkZbqdVbOTMG8KIWlagpb2OISk+hgLPs6BhO8b4D188/SnGy3VwDmyfj
	 mqTpkO/EP73SU1hMUXhSQWEHXq5RTjabnOERiUV314st8osC/f71cZgWHJH5zK9qFe
	 4n6JVUd5sTep6Ed4KmPWklo3JAG7EkPSuOaPq4gvU39XkMsv94omo1XbnDSKw4SjhZ
	 t2fTn84Ut6HnQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
	kernel test robot <lkp@intel.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 181/232] clk: Move clk_{save,restore}_context() to COMMON_CLK section
Date: Sat, 28 Feb 2026 13:10:34 -0500
Message-ID: <20260228181127.1592657-181-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

