Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681DC359A98
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302455; cv=none; b=iZ0NTnH1Y5cpX69Wxekf/caHlUy0j6uoZHx3qpoiVsWxDyvpwQHcP7rX/M4D96V9o3pshFHNBhk4q+TJVbW80LQLkjOskGBnz7omAjvKn7ROq0CaYF3806WQkFbyk6fCZZpoolbmpKaGg2s5ehCdEuHXrOGkIk9pUiODp+/cz3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302455; c=relaxed/simple;
	bh=7DW2sjh9aEkHz0r7DH4RhqcosPpZG40dKfPu+onOj78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVMTKJjSEdg8hOsom3pRuhFNJDp3/HY2ErF6my5rjECgh7FoVgoO0KScN4l1OjprqD0jCbozVRc/wx79U5Z5RIA2+PliKNLH+1A9Jvxtqxm2eDtDVFUCfRzoy2LVzhhCCpQp1t1oFeXVvQnx3VWFlZrni+avoTnKvU4YzZKhGMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQf8LxMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQf8LxMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B6BC19423;
	Sat, 28 Feb 2026 18:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302455;
	bh=7DW2sjh9aEkHz0r7DH4RhqcosPpZG40dKfPu+onOj78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQf8LxMa4CPfVzBTILqhJxMd1SLzX7rBkfxX4j3rejDMvFg+/dBdDA3DwtezyXQLg
	 n+SHwD4OEi2UEVvbUpmwBj4heX8/uwjAFTloOe4wPMV2j8bM/14IHYZTDE0ObngBgK
	 8HJL0pBkmB5GheSPs4lK8czMG1kyWKT5yyP51/cWinS45SCkikMkDg2i52g6l5YFVX
	 tIv1kEVzOPAhXctHEpY7RfQK9YOVGCi2nsSczX6FEjbElVlaVMglMBpLtJvSKbBzMu
	 bOK8lmjfXRp4HHJSlMkaHYpl6hnnkUi1UZd6bcjyg5V8CeUmYracJOdwtgQQoAm7y0
	 MMC2lFDecxWLQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/232] pinctrl: equilibrium: Fix device node reference leak in pinbank_init()
Date: Sat, 28 Feb 2026 13:10:49 -0500
Message-ID: <20260228181127.1592657-196-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 99cf24eb67ae6..9d140ec58b3b9 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -844,6 +844,7 @@ static int pinbank_init(struct device_node *np,
 
 	bank->pin_base = spec.args[1];
 	bank->nr_pins = spec.args[2];
+	of_node_put(spec.np);
 
 	bank->aval_pinmap = readl(bank->membase + REG_AVAIL);
 	bank->id = id;
-- 
2.51.0

