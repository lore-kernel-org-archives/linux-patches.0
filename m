Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BF53314B7;
	Sat, 12 Sep 2026 15:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226280; cv=none; b=oRZ9FG+z1CaMAT1isHL28lkRPE4/H2n+82Cx9ESqe4YDy3w8+UbZ3c13pyUAqA7R+yqRg8fDyEnT7ktB5RKs1ZZcueSeT5xYvsaIxqzK1HDKFSSIlGRGK1fXuZUtzbbeDZu7MXQtXDYe8gUcaW5Vd1Xo5aVNl4xysS/eCitn14I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226280; c=relaxed/simple;
	bh=QQvFodIqBOQiqMWoqnzxFFg8Bgk9tsoBzJd49E7bAUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lO5me3HeciC7pJiunkKrypySOG7NbKL4EGTqzyXyrvtmOGw5XmPXNyX/ERrhicMyuVfyxjw5YrRZyZzFXIdgAPDKWMKWzpKugG3q7nzgvPv32u3ZXV84e7AilVoBVm3cATuW2tsoeh4IZLsEoirjZRpcisacjC9Ii9BM/drfJx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpzZgppM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpzZgppM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CDC1F000FF;
	Sat, 12 Sep 2026 15:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226278;
	bh=gwh+E6F/Emnz6nRbYANy3xrfh1yeJUV2kCM/a90YNFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpzZgppM0RFEc5KcJYuZgAxudSK+v8q2K9JiqJ7cvgy9HNxoda/LXEfXDMYM1lnKI
	 QBFkVd7A2Naf264qagUpFbQ7YdkwYEVrT4zxqr8VrZgaDZmwlsjNB7ydjxVUBVrVup
	 7h1T8XB2XjnQHqnECyzol4Tcy7DJFV61A3id21kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Brian Masney <bmasney@redhat.com>,
	Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1318/1424] clk: visconti: Make sure clk_init_data is fully initialized
Date: Sat, 12 Sep 2026 09:02:30 +0200
Message-ID: <20260912065636.778633832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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



