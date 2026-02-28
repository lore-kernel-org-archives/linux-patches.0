Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCABA33A713
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302233; cv=none; b=Uc39TaJIDrsqxRBQ8zcLExKFkwXl2Va+A861I7ckDtHjZm0mhGBIdByGKvbrzvMKsGodwhtnjRPnLViTd8FUzHaATUclkgXCcjP9YqDQ7gpIfAd2lEy0wUU8x05v4SE9ehaVcQHTwV++oPSSvbYzIsqrsk6MibgMbOJ41ydbdj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302233; c=relaxed/simple;
	bh=hTNs72C7ULYWoyq33/sdV8JG5+2iCi9fnohOClQi77A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sv+24u9UFAWYzqxBqIJddLoATHNiyjTZpsBPk87aVm1xVv4huiojzyG0HmGjylGMi0mUHE+fBjlwq9BMbDzAagv7ujLE0EXD1xyorjJNpdkQfUaUZBNtdrLw6RYjESDm7WyqTuJZ3jDTSScMLcAXOCFv5IH7AXTSdH9w40B9G+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tx7UTlWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tx7UTlWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E14C116D0;
	Sat, 28 Feb 2026 18:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302233;
	bh=hTNs72C7ULYWoyq33/sdV8JG5+2iCi9fnohOClQi77A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tx7UTlWpd/h9htV0wazNVbbCUYcmsuoTbKNUNLgnPoPIXoHp1e74/gaNRdPV/zHNO
	 tJcIRxt0utodpaAY9MXc+vXhHWQu/jDSaM82NMd3zuOIc2IgzeKZ6pEf7s7cjeBoZL
	 GfSEkEJ7L2y1/Uj2DdqKWcSSCUvuAzTy+J2abUGo57P/v6KZGD06uKEDSkMXxT/ZR2
	 VIWao8FzfY/HETBFBw5qL10ludnSCNWKtaM7A3i6Fke29yvz7NL+LMKqvHtx/fjY3J
	 6kX5IwTZ0NCu/HapVlHco0K7BoRW/jvdkoELFLjYAYHVXqzCT8viHcqyXxyC0twHrC
	 gLSK8UlnnLldg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 244/283] pinctrl: equilibrium: Fix device node reference leak in pinbank_init()
Date: Sat, 28 Feb 2026 13:06:26 -0500
Message-ID: <20260228180709.1583486-244-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 5b5ddf7e5d0eb..d7c89c310b373 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -850,6 +850,7 @@ static int pinbank_init(struct device_node *np,
 
 	bank->pin_base = spec.args[1];
 	bank->nr_pins = spec.args[2];
+	of_node_put(spec.np);
 
 	bank->aval_pinmap = readl(bank->membase + REG_AVAIL);
 	bank->id = id;
-- 
2.51.0

