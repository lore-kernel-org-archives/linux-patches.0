Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4CD47AF69;
	Sat, 12 Sep 2026 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231824; cv=none; b=RJbxJOmMN6TVFdqEdzbfB9dfRWVWAawbKvhvespCt95rnbAcu/4i8MRb0AwEBd8r9XtRgpfAXbs/suYfqKF3yXl0AD8RuSVohNlce1N+lvfRiE/AfvvTGh0O6M909lII+UQ926FmJ27VmUl9Y538W4iEB4bfoOd6j1Jji7rbkOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231824; c=relaxed/simple;
	bh=pyjHaebtFZZ3gqCvot4JWW/KFoq/hpr5U9YQggtQp04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcSs7ish9KeZI5FOQehtqnBspe5qzr0eE7xlwA8cZt38fZJPSKXkxhfsqG5WKDbb5expuK1e/7dP6fq5UzHBviKm7hZ87CZOCkox2Zw1gkuNYuPHSS5cUU4CRi5iX9KbLScMwC9i+Io5fTsR3jDtJVjMcfsgWqAWHNCJOW3Pmp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0ZWwCwp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0ZWwCwp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8304E1F000FF;
	Sat, 12 Sep 2026 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231820;
	bh=RNzpC1FKEYrHsW9n/wzeGrpIwh2dbfGRnYcug+ias8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G0ZWwCwpN07kPx83c+GeoXj/z4iQm+dB4Rkasz8EiittR5ai9nUJSyEKJfyzHcFc2
	 bSmk6jApndvWec5NnKGjCXimKEXNmJCKfOA9Bio+NTvJmlVGsMLfLlVn0/fDN2TQ2w
	 KI1pjh4SCJin4yJMx3fFdCL+kT8fuQZ+ubtDhZR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1077/1191] clk: visconti: Make sure clk_init_data is fully initialized
Date: Sat, 12 Sep 2026 09:03:25 +0200
Message-ID: <20260912065612.360401716@linuxfoundation.org>
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

[ Upstream commit 39c0e6c844a14945040cca4ccf6997792ab764c4 ]

The clk_init_data structure contains several mutually-exclusive members
for different methods to specify the possible parents of a clock,
prompting drivers to initialize only the members they need.  However,
not initializing all members may cause subtle issues, which are only
exposed when CONFIG_INIT_STACK_ALL_PATTERN or CONFIG_INIT_STACK_NONE is
enabled.

visconti_clk_register_gate() fills in init.parent_data, and assumes that
init.parent_names is NULL.  However, the latter in uninitialized, and
thus may cause a crash.

Make sure all members are fully initialized, to fix such bugs, and to
avoid future breakage when converting drivers to a different method for
specifying the parents.

Fixes: b4cbe606dc3674b2 ("clk: visconti: Add support common clock driver and reset driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/visconti/clkc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/visconti/clkc.c b/drivers/clk/visconti/clkc.c
index d0b193b5d0b35..4018d1298880d 100644
--- a/drivers/clk/visconti/clkc.c
+++ b/drivers/clk/visconti/clkc.c
@@ -81,9 +81,9 @@ static struct clk_hw *visconti_clk_register_gate(struct device *dev,
 						 u8	rs_idx,
 						 spinlock_t *lock)
 {
+	struct clk_init_data init = {};
 	struct visconti_clk_gate *gate;
 	struct clk_parent_data *pdata;
-	struct clk_init_data init;
 	struct clk_hw *hw;
 	int ret;
 
-- 
2.53.0



