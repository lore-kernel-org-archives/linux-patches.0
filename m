Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE9333AD85
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302761; cv=none; b=qLEgxPDZCNDMci7Ow00HhNQiziE9cCaVHKPTi+FqbxxvrA+38SAlPnjLFhfowdAQNSKRttwNxJoZc5c2rY3V1TMmhDmbQyMFhXBXDZDS4bUX7bZYtBsW7ouwmx1fZoYTmKgJTeBvILIV5DZN2G/fyq/AfeLItGHp1IUIZCbkxHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302761; c=relaxed/simple;
	bh=YmhZtpCPYSJlLtJF+CshU+I+IAYmTStwoe6KCMeCZgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvNmr+ocW5UgKPxxhWA4eac/bhtxodbHvR1YRe8fizUQnjLrYXfnSGWkQ2E3alDOAOwO97pJi/NFEmvKgqXfTXIMm49CAffHHA9y9Hh0uXusfYlT9bgN619AybCJ7Cu6DXpk0VQx56Tvk39GD4ETqGInC6fBznk4pVhjcS+NND0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=crgHcMz7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="crgHcMz7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0ACC19423;
	Sat, 28 Feb 2026 18:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302761;
	bh=YmhZtpCPYSJlLtJF+CshU+I+IAYmTStwoe6KCMeCZgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=crgHcMz72DV8yz9SfQ/R0Lh/Gyg7KQ88nUtOkMGUQsCNYusl1nBTTldTn8lBwjXU2
	 q8OsYVQKCQ7J58eGxIDtX/miNpwU8UNnu9A8IwfFaFRI9Mh00TopjnNXo8J5VM835M
	 9aIKUnMutm3mEADpjzErIRORvn65PdeX+kZYsLPkdWpIqX+ulauU3njbCuaiD0jRbL
	 x7Wj95u6RdUZ37Pyttxwn/buzasTp9ipt0otmRwhCqWCNByiBvDkf/nyXrj88kbasQ
	 ZZUz1hD91OXaEBs9OgcwA1nwWjBqpXsuSf7t/2/8C15KmLRHaiMCxen2g5QQj25iyA
	 KGdvTS8FD93DA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/147] pinctrl: equilibrium: Fix device node reference leak in pinbank_init()
Date: Sat, 28 Feb 2026 13:17:20 -0500
Message-ID: <20260228181736.1605592-132-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 3b6dcaa80e000..55fc9aa61f55a 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -835,6 +835,7 @@ static int pinbank_init(struct device_node *np,
 
 	bank->pin_base = spec.args[1];
 	bank->nr_pins = spec.args[2];
+	of_node_put(spec.np);
 
 	bank->aval_pinmap = readl(bank->membase + REG_AVAIL);
 	bank->id = id;
-- 
2.51.0

