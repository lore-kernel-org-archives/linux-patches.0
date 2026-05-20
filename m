Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04352372EDE;
	Wed, 20 May 2026 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296246; cv=none; b=n3rfirBmwGrjpZvLHpmCOL2zN0sM6Y+i3oygSF/IH+ObzWWhKGv98QLXX7qyKOgWHRDYDdyt393PdIBRzm7M24uhfutOVdvXXvAlpMPsUFccg5dzmmP99Na2qPGPiFbewGu9k3P1OW/P9QilKPcinVkwE3P1u/zDf1ToFhC+KOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296246; c=relaxed/simple;
	bh=fhO6JAj0f1URW96SxuRld1IRkU3gLdyzuEfx0SkWyl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gXnA4Lajh60dIDyEtqNdj143WUfhmsgd+/346/cfB5/7HhDr3jp6igf8gWq0AO6wvDkMJZ3RTvxhBY7ojJiqVywfkv9SuNOu0yp9Hpn+0SGuTwvhFAs3HJxhjERsTCT5eowT00aEKeato3i4hdRhDTTZavYiG6LfcmOPJiLWTsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4aszrkt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4aszrkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AFDB1F000E9;
	Wed, 20 May 2026 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296244;
	bh=BIK2/oiRMj0oi8wXOM7p1jwbrn+9gH+T7nvT8jWsY4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4aszrkthWkFfILbkC8bdWmy6nCJUOQdkh7t1AfPm7GA/CCsnKgMmEX1PWMG5wNum
	 g1g6LM+UnEZerB+95Tagln2FTPGcgq2qLW9jom7WbNHAQp+aLRWCzj4uw01XSd1fQh
	 cMeDFYUTRjshxt6BHYtQ9ZthKKN6YTmfDJ0SZwIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <kees@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0725/1146] clk: qoriq: avoid format string warning
Date: Wed, 20 May 2026 18:16:15 +0200
Message-ID: <20260520162204.611707576@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 096abbb6682ee031a0f5ce9f4c71ead9fa63d31e ]

clang-22 warns about the use of non-variadic format arguments passed into
snprintf():

drivers/clk/clk-qoriq.c:925:39: error: diagnostic behavior may be improved by adding the
      'format(printf, 7, 8)' attribute to the declaration of 'create_mux_common' [-Werror,-Wmissing-format-attribute]
  910 | static struct clk * __init create_mux_common(struct clockgen *cg,
      | __attribute__((format(printf, 7, 8)))
  911 |                                              struct mux_hwclock *hwc,
  912 |                                              const struct clk_ops *ops,
  913 |                                              unsigned long min_rate,
  914 |                                              unsigned long max_rate,
  915 |                                              unsigned long pct80_rate,
  916 |                                              const char *fmt, int idx)
  917 | {
  918 |         struct clk_init_data init = {};
  919 |         struct clk *clk;
  920 |         const struct clockgen_pll_div *div;
  921 |         const char *parent_names[NUM_MUX_PARENTS];
  922 |         char name[32];
  923 |         int i, j;
  924 |
  925 |         snprintf(name, sizeof(name), fmt, idx);
      |                                              ^
drivers/clk/clk-qoriq.c:910:28: note: 'create_mux_common' declared here
  910 | static struct clk * __init create_mux_common(struct clockgen *cg,

Rework this to pass the 'int idx' as a varargs argument, allowing the
format string to be verified at the caller location.

Fixes: 0dfc86b3173f ("clk: qoriq: Move chip-specific knowledge into driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-qoriq.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/clk-qoriq.c b/drivers/clk/clk-qoriq.c
index f05631e553106..2524c5c0eb460 100644
--- a/drivers/clk/clk-qoriq.c
+++ b/drivers/clk/clk-qoriq.c
@@ -907,13 +907,11 @@ static const struct clockgen_pll_div *get_pll_div(struct clockgen *cg,
 	return &cg->pll[pll].div[div];
 }
 
-static struct clk * __init create_mux_common(struct clockgen *cg,
-					     struct mux_hwclock *hwc,
-					     const struct clk_ops *ops,
-					     unsigned long min_rate,
-					     unsigned long max_rate,
-					     unsigned long pct80_rate,
-					     const char *fmt, int idx)
+static struct clk * __init __printf(7, 8)
+create_mux_common(struct clockgen *cg, struct mux_hwclock *hwc,
+		  const struct clk_ops *ops, unsigned long min_rate,
+		  unsigned long max_rate, unsigned long pct80_rate,
+		  const char *fmt, ...)
 {
 	struct clk_init_data init = {};
 	struct clk *clk;
@@ -921,8 +919,11 @@ static struct clk * __init create_mux_common(struct clockgen *cg,
 	const char *parent_names[NUM_MUX_PARENTS];
 	char name[32];
 	int i, j;
+	va_list args;
 
-	snprintf(name, sizeof(name), fmt, idx);
+	va_start(args, fmt);
+	vsnprintf(name, sizeof(name), fmt, args);
+	va_end(args);
 
 	for (i = 0, j = 0; i < NUM_MUX_PARENTS; i++) {
 		unsigned long rate;
-- 
2.53.0



