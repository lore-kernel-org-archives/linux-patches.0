Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FE12FB08C;
	Wed, 25 Feb 2026 06:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002689; cv=none; b=l3GA2lHMD9GxEyeC1R/2bCV3fwxI2WyL1v6cWYG8AE7fMHTynn0tIHAo88xskTDme2jo0ItHmuBwAo1FTX0IySEgcREdHuoShvLwFK+0hvk1zQ+Y5EoTe/CotvfjEZdT6r2cIB4WuLCrQWBBD/yw2r2q18v+V/N7ufheM93pWH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002689; c=relaxed/simple;
	bh=7QJGrnD/aar1VUyTyVzgadLuMrvtqODfyZD8On8MREA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1c55XO3cbYTQ7koPfd4dIYNLYBzz9GxQULNErrvSpaYddhATimNmwJDzqX/lt66gLpX/q5642L24jzpV4StKH3DO7w+4buijYccdRvixe8Uo+B8+d/+2lrOFs6BbhGlE6wlzRqGeZk76M2NYxCEEMkoZGsQSlwLV2NwL8vJPjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPg0UQb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPg0UQb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BC3C116D0;
	Wed, 25 Feb 2026 06:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002689;
	bh=7QJGrnD/aar1VUyTyVzgadLuMrvtqODfyZD8On8MREA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPg0UQb2FIlFCgpvq4W1aR6UZNu3uaYaR8ylMUBYi6Ekz+zepUmeLThSlaNA19ke+
	 BB5G+U89zTTZ/H9xFc7i9nhXKywdVBzCGUom9NE1mrUCryMe8TdfFVa1AWMZ7mbkA4
	 9NsT+tM4z1WoVi2atgxJlhJD+dxcDn40L2zA9wKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 483/641] pinctrl: equilibrium: Fix device node reference leak in pinbank_init()
Date: Tue, 24 Feb 2026 17:23:29 -0800
Message-ID: <20260225012400.222651343@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 2d04829b29c99..48b55c5bf8d4f 100644
--- a/drivers/pinctrl/pinctrl-equilibrium.c
+++ b/drivers/pinctrl/pinctrl-equilibrium.c
@@ -846,6 +846,7 @@ static int pinbank_init(struct device_node *np,
 
 	bank->pin_base = spec.args[1];
 	bank->nr_pins = spec.args[2];
+	of_node_put(spec.np);
 
 	bank->aval_pinmap = readl(bank->membase + REG_AVAIL);
 	bank->id = id;
-- 
2.51.0



