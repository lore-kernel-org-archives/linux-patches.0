Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A99B348895
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302624; cv=none; b=GvTvooDBADFlfS5X/2iZg+CzbLgkWkxrMW/F/W2o1HPvvKxngaixxDAvQCrH0cudQ9IgI5cRxg3HrXKQcZFxqfXBZ38HG8UwUonsQjy1hmW32ajKrtnnTbzSGnshMEbbj1V9WMzWnSINYaeXUg7Hkse805PiaR1QN6guueFpts4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302624; c=relaxed/simple;
	bh=jhCUFVuk8NviThIGU6CqmWFWvVGn9uKYav3yhVauHUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwWt+h8Y9sblvfJhpVO1ZWcWAyiH963CY9lxZ9SSZ2L8iMzPVhTom4qEl9rIIPAXjUY7lwKS69jGDOcL9fByFbtJ+6QMaTPfL5a7fj3IHRoWFBT+wWkMT75r9r1oyAv+jE6wQgk7gCp8AFscCLr4XMrHeTgFy38grs5dU+IJsmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A8VIX7L3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A8VIX7L3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA524C19423;
	Sat, 28 Feb 2026 18:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302624;
	bh=jhCUFVuk8NviThIGU6CqmWFWvVGn9uKYav3yhVauHUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8VIX7L3q/VI6sQDANoj1Mm+Tb3BmvcPnRX/ZE95659CzXORKO/koRjaarEbNC7RE
	 hOOxibOCCrpiReEoc3cWcsknS58lTib8dpHDiakuKHEW/1qd78t69crlebJbOHlVhb
	 NYDzvpmGtBZ+WP8TeGCdVXVEUy7mrF+LB18spz4hLcyyDRnQh1MZ3kgnNInoWo+nJy
	 MGb/Aqs6pRnZudHVND3f1GRZ8348Rs+KOjRqsy3yntKl6QR1pm+NwSKuwHv0iYI7FI
	 qh6gUbOA9JyvklsP1PCp+xhRJ3BYqC4chLqXkzNwyOEv9nz5rETTJKmRSeMePY58JL
	 OZPIuJCH8Bvmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Felix Gu <ustc.gu@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/164] pinctrl: equilibrium: Fix device node reference leak in pinbank_init()
Date: Sat, 28 Feb 2026 13:14:42 -0500
Message-ID: <20260228181505.1600663-143-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 3f0143087cc77..5de9c7dfe5555 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -845,6 +845,7 @@ static int pinbank_init(struct device_node *np,
 
 	bank->pin_base = spec.args[1];
 	bank->nr_pins = spec.args[2];
+	of_node_put(spec.np);
 
 	bank->aval_pinmap = readl(bank->membase + REG_AVAIL);
 	bank->id = id;
-- 
2.51.0

