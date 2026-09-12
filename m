Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EBF2EC09B;
	Sat, 12 Sep 2026 11:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211828; cv=none; b=dFVrZN2ODa37Ak58+sQajbImiMYyGHRwSbVGiQ6XB7hgjTSnyqhGjBVPic6lmjv1BVEaxw/3G5vZ3zoMkT16gAkO5MNawEse4gVQ6XRoRWGEu80bzde5FuPdWau7ANgxVAmEAYmZVO3Ns8+bWlSSlS+TZC++4nZZi6sUEyryceY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211828; c=relaxed/simple;
	bh=4Ic+UE+Q1bQkfI+mgKN8wk+ey3QvWGOhNYJ8SHfrx/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrfywS959qCl+YSYvfI0zcsaV3kzqJLIgpPCFAUtGAX11A+3eRmJx2UXLR1pNq/QjRT05E4bwLjprPbQJvX5GTVz6Y1ZqqWhpleDnFSbzh57jLAaE7Li898rxoNW2KbzMh+g3HlzWBhmtuHTGI1OGlIsPFq0Ee3ndBHjUzVOnRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1yFIf09; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1yFIf09"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD4B21F000FF;
	Sat, 12 Sep 2026 11:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211827;
	bh=tyGUc0xwloBQt0pgNfBwdHu06UVggwZqAzbrmGhmNZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1yFIf09wog2+6psyMKYdjD8qDsB+jRQxqLi13j8r8VeRsH0kjvdAVMhSSPCiCPYg
	 dx8dYXBgtmlMUeObdzRIQYs2gSjBfrEUX70jAKYhMsT8HvUSzkkgBnqL4YWHIYqOJF
	 LIsCr9g4YgSA1fYJutvT2vTVjteXF5neIUBh2b1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1311/1518] clk: visconti: Make sure clk_init_data is fully initialized
Date: Sat, 12 Sep 2026 08:58:00 +0200
Message-ID: <20260912065653.184118910@linuxfoundation.org>
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



