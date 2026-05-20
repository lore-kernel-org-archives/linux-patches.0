Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E696402B8E;
	Wed, 20 May 2026 18:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302494; cv=none; b=roNm2y1hGFuLdiqJGnLfL/nrAs8q/5kSyw/NvIClD+fIvMmYdxd2HAVIjHzU0pbAJLZXvpuXjhuHIwsreCRLSoSUU/1EeVpCzVW6JIWnfWuzV4C6yt587hrYbsxLbaf2HhqmeBehbe7IVcGq9/lh8eMe9QFkBmpst2jge1rRyPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302494; c=relaxed/simple;
	bh=IbSO4ixGG27XYIpezuN1RQwzunyhHATAfTtwjc5+sIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+DniYqVGANe7FpyUv2w8tPNv4GFIYAxLb5WsiL/H4DLt4LErefuCeuilTKZuxqH/2ckf1ijrMBREMZEctxW2hP8g6G25X5bBKmYqj7MKshbc61fpM8oVyvKWywFFklzGBnUDUEolTcxtNstYrRMVUTdVI4ZqFoK8MoJltDHX/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0HkI21Gu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0HkI21Gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71D61F000E9;
	Wed, 20 May 2026 18:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302493;
	bh=LgFIb6TQLcDiv/knYffaAUsPRtZHC7ViqB9l/ro5dtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0HkI21GuEjIPJP00XFQG45sc+1dy6z9TGZof/8tekMJe4fwiLXotrH38zRUf3V+TZ
	 b+Kiyr/rStEB8VPYbSHd+vR6U4H6IR9Ux7+boIUQpE1eMg7iKxZXWrHjZ8ksrNb7sW
	 p7+6ZrkQN30OCkjL7PGflcyx84U2cIadrCvN/rtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <kees@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 287/508] clk: qoriq: avoid format string warning
Date: Wed, 20 May 2026 18:21:50 +0200
Message-ID: <20260520162104.861520939@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4dcde305944c4..318acd176a2ef 100644
--- a/drivers/clk/clk-qoriq.c
+++ b/drivers/clk/clk-qoriq.c
@@ -906,13 +906,11 @@ static const struct clockgen_pll_div *get_pll_div(struct clockgen *cg,
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
@@ -920,8 +918,11 @@ static struct clk * __init create_mux_common(struct clockgen *cg,
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



