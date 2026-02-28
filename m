Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B7B33A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301912; cv=none; b=t/HKxDgXCX3D2phrTlMjP7Lik/KsUWlF+k6OiLZDPMvTjkLzOSsQwkcGtdTds/YIuI3FNdq4ofWqnj9Z0v9Qy+1V0h0ajMXmqaiP4tzYYxl7KGMNyWC0XSb+W+C65w+9rhF+VqgyCUq7FxVpLoNh7zZbSuZN3MMgVdtsHRx40kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301912; c=relaxed/simple;
	bh=q6f+CGalWBP3sfeYf3nLCbrOtkiiqR16eMFggPcVqmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIMbYYDe+SJgQgRRAdg+/jeb4ZcuD0QAS2WZe/4diNRPKC6Vss/q3d9Pr0flMASBJ8LfylvZMC+STsDPSTpwFvvbKsPLwC0ftEY9l0ygDuRQY9imT0leFh+qkn6QqxTvm4R71Z83bZIPDojLCpzK7Uo4nKVZUZO/ILmgCbx83wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nr6hCqch; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nr6hCqch"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EEBC19423;
	Sat, 28 Feb 2026 18:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301912;
	bh=q6f+CGalWBP3sfeYf3nLCbrOtkiiqR16eMFggPcVqmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nr6hCqch5zpqJkOAy7i5fv5vEA9hgDDqwJ/5Aee+FR4GnLPP4q5tO3OeWTFvoFANv
	 8GHHFFEIKoHEwuBOhF2MkbGN4SE3rD8qHu/wXcPBOGfgkl2AKHzdNvrSgNq6KjXaG9
	 EoLx6oZK7PNcAK3SeXf0bArjfee3HWo1DMdn5dyTKSXERkyP5HOHYkkJKKBNVwWXRE
	 NwcZ1pSAtk4+UwDBK2eAtOY8rCNaofYmNe0Hi4w0/MGgk+yxXXzBpvaeUM+LxNA2BA
	 SGZ2fzTsDaJfVlBRxkoPpYyyixAh1PBRM5Ig4zuAOaZqqQTyQGqA5NODIMuQ6C4AKQ
	 VxWje1tiiZ0UA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 344/385] pinctrl: equilibrium: Fix device node reference leak in pinbank_init()
Date: Sat, 28 Feb 2026 12:59:26 -0500
Message-ID: <20260228180011.1568201-344-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit c0b4a4feeb43305a754893d8d9c6b2b5a52d45ac ]

When calling of_parse_phandle_with_fixed_args(), the caller is
responsible to call of_node_put() to release the reference of device
node.

In pinbank_init(), the reference of the node obtained from the
"gpio-ranges" property is never released, resulting in a reference
count leak.

Add the missing of_node_put() call to fix the leak.

Fixes: 1948d5c51dba ("pinctrl: Add pinmux & GPIO controller driver for a new SoC")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-equilibrium.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/pinctrl-equilibrium.c b/drivers/pinctrl/pinctrl-equilibrium.c
index 3a9a0f059090f..c82491da2cc9f 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -841,6 +841,7 @@ static int pinbank_init(struct device_node *np,
 
 	bank->pin_base = spec.args[1];
 	bank->nr_pins = spec.args[2];
+	of_node_put(spec.np);
 
 	bank->aval_pinmap = readl(bank->membase + REG_AVAIL);
 	bank->id = id;
-- 
2.51.0

