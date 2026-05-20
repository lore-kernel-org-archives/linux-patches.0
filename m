Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8EF36405A;
	Wed, 20 May 2026 17:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298902; cv=none; b=KrxUQQuBy4Bir4Rg/VdArnvjg9IlfBxpjbkMVMSxZCuopvcAlAaUyzH8SUj75VLlokt7G140RmH6P3atL+Ehb9xrE8c/a8RO7t6fYClxIk9Z5t5YhgHRM+Ugt/kZDTFZHMbP2bu2C2viPcYM2SyIKCKoYZgixkEj3qEuDDWcWpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298902; c=relaxed/simple;
	bh=UqGo7yNkGUzYRK3/co9AtGGtkhtxHv9UZBKow1yd1SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C/rg6a9+h2HH2FD4BYu/0lBZaO7t5kcrE5z7DR3HgAJbavmcf8II64xDuTSu1XyiX6KA3fauRNo9Q5jJJ1jjmqfrxcSR/UYyxOUakWlxY5IGFlCQ6zO4ZQLOo2xc/l9rG+e9VpvTygShZkNBRnMlg7xyqj3j7b5z11MSjOmOQec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wANrNoVk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wANrNoVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10911F00893;
	Wed, 20 May 2026 17:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298901;
	bh=/WYV/aX0R9yfkdZ47hwCn7UaJKIsFHoMo5fgVjpK2mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wANrNoVkmzNWcY9U6UNGb5i9HpuUbQAbzREmcl+ExcTJIX8GEhNMZfmz/BaAgCNgK
	 ZG605qPjgwJc0c/aYoRrSFDiNdk4lpm0Lbz3UXH9MdDXt0OE3UelR7FeewR8ed6h/d
	 pjTHeg7DPV1BchMca6BLAy5XuEqwQvzbZNVpkc/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Masney <bmasney@redhat.com>,
	=?UTF-8?q?Beno=C3=AEt=20Monin?= <benoit.monin@bootlin.com>,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 588/957] clk: visconti: pll: initialize clk_init_data to zero
Date: Wed, 20 May 2026 18:17:51 +0200
Message-ID: <20260520162147.283633020@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 1603cbb64173a0e9fa7500f2a686f4aa011c58b9 ]

Sashiko reported the following:

> The struct clk_init_data init is declared on the stack without being
> fully zero-initialized. While fields like name, flags, parent_names,
> num_parents, and ops are explicitly assigned, the parent_data and
> parent_hws fields are left containing stack garbage.

clk_core_populate_parent_map() currently prefers the parent names over
the parent data and hws, so this isn't a problem at the moment. If that
ordering ever changed in the future, then this could lead to some
unexpected crashes. Let's just go ahead and make sure that the struct
clk_init_data is initialized to zero as a good practice.

Fixes: b4cbe606dc367 ("clk: visconti: Add support common clock driver and reset driver")
Link: https://sashiko.dev/#/patchset/20260326042317.122536-1-rosenp%40gmail.com
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Benoît Monin <benoit.monin@bootlin.com>
Reviewed-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/visconti/pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/visconti/pll.c b/drivers/clk/visconti/pll.c
index 681721d850320..9d088239a1b2c 100644
--- a/drivers/clk/visconti/pll.c
+++ b/drivers/clk/visconti/pll.c
@@ -249,7 +249,7 @@ static struct clk_hw *visconti_register_pll(struct visconti_pll_provider *ctx,
 					    const struct visconti_pll_rate_table *rate_table,
 					    spinlock_t *lock)
 {
-	struct clk_init_data init;
+	struct clk_init_data init = {};
 	struct visconti_pll *pll;
 	struct clk_hw *pll_hw_clk;
 	size_t len;
-- 
2.53.0



