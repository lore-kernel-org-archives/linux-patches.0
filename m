Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E056834389C;
	Sat, 12 Sep 2026 09:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204590; cv=none; b=l+SOLOGY1IlFXb+qTDFZ6XBJ+YVw7budRsbJ1wXwy8+c5I4F7iJGY2WRrfDW6QZpFn1TU9An0u30FYI4NeeZA6wYA03K+JHJQZ5NPrmLzvWVmDcamPN6Sj7GMOd6Jp/zNKjdoPE/lvyEp0N3yrenAj6Ls4SysY+B51WbWFdOSzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204590; c=relaxed/simple;
	bh=okKP0JEkHWzoB5eVB6R9hQG7fkj6Dn3enNv4tHWnd/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAMtL2syauc12hSet4yJ/+2rTj+VjWCbXfKUbH4AtAHa7SPFl/PX4cyvX/S/hyeYm9xV6Be47N0C1QVwp4r7bw5olSgwlLJqyAq4Cy/DGG5AFR29FnlMPP0UcUm6AEZvdlAthy2CbT5Efia9L631m+3wNtDG+ZQm8RhU2PFwwWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J0CLz8ES; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J0CLz8ES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4A71F000FF;
	Sat, 12 Sep 2026 09:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204588;
	bh=SZCD5pEsUjMipIm4pZGR6zoqCZ3fljYXZhqlebTmZlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0CLz8ESHG6pOPmCJwtco+ATFKfP0RVKQ8pspMbLMknWVcX8KwjqDBbT1I79R2ySS
	 9EhnqglMXjqmFecjKCOiQw+uAMzLJqR8PxJwl0XnJqLoVtO/K+H7HNp7W/XAbhWhSM
	 ykx1uHCXDq94NpO9/jk3HF0g5Kg9OS84ExAuAcF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1642/1815] clk: visconti: Make sure clk_init_data is fully initialized
Date: Sat, 12 Sep 2026 08:56:32 +0200
Message-ID: <20260912065727.540376349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



