Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71606342146;
	Sat, 28 Feb 2026 17:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301498; cv=none; b=hu9AezhIsUpO5iwldb6VdkAirplNWGr8CUK49JZLnePHAfHGd5yHtxs/FBJYHc9t8m+vGiCoXeMM9+Fi+NQ2E43l3UrZQkRkogmJK02CX1/0IAmqt6qvITo2VqizFOE+XVG9wKB2f2A2QrI1DcDhWGz24DfWxJKTpTwkazUl3kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301498; c=relaxed/simple;
	bh=Ssi4ys2hsnK4l5iOGPWzKxKmZumXDR9aWBZNhATU+mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noiXrnXuKdmHCuKlWIq9Lqn95Enql79CVD6Ks8qxmuCGKoZRvYDrmF1bIe3+qTvsZPXa76qwqmXZKnaYbK8GXuOhHEJ17EAN+K6lEtYYlOqyPWgEiNF2310HoKCwp283/5FyIcDgw8Av2g3iRc9JC9LLrzbL0FAhBGzL/pDEQK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tPFY7WiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tPFY7WiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE41C2BC87;
	Sat, 28 Feb 2026 17:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301498;
	bh=Ssi4ys2hsnK4l5iOGPWzKxKmZumXDR9aWBZNhATU+mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tPFY7WiZ5lGqN8uwFhAAhkV61ZfvllDWil6Fq4x55fSGlMZWk1u7dgWZjeZx1pNWg
	 DajxJ4J8uVmBZF1/yAmsKwblOcwRO36Wg0NuwUDuj1N32C330BkeuSvfx4WsflO7yN
	 SQnPLTcOgrWnq4tPxtS6iA4LMCMn4GqkueSZp91escgwfVhfsi9qQN7LOuIqefhXo4
	 6sHZhckKtPx3ZtKV7wSYl0hfGbYNjO1uQMf8oo7jDC+XwoA6UHQ1Whf7uu2r7YmZKj
	 xfyfx7R0jITbwl86SGqXnH97PPREAbuEzKpmlCuJa/9Y2pD5O5S/BEEL2UOEyGgBza
	 HmgmGUoIoyNOA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>,
	stable@vger.kernel.org,
	Waldemar Brodkorb <wbx@openadk.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 682/752] MIPS: rb532: Fix MMIO UART resource registration
Date: Sat, 28 Feb 2026 12:46:33 -0500
Message-ID: <20260228174750.1542406-682-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

[ Upstream commit e93bb4b76cfefb302534246e892c7667491cb8cc ]

Since commit 6e690d54cfa8 ("serial: 8250: fix return error code in
serial8250_request_std_resource()"), registering an 8250 MMIO port
without mapbase no longer works, as the resource range is derived from
mapbase/mapsize.

Populate mapbase and mapsize accordingly. Also drop ugly membase KSEG1
pointer and set UPF_IOREMAP instead, letting the 8250 core perform the
ioremap.

Fixes: 6e690d54cfa8 ("serial: 8250: fix return error code in serial8250_request_std_resource()")
Cc: stable@vger.kernel.org
Reported-by: Waldemar Brodkorb <wbx@openadk.org>
Link: https://lore.kernel.org/linux-mips/aX-d0ShTplHKZT33@waldemar-brodkorb.de/
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/rb532/devices.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/rb532/devices.c b/arch/mips/rb532/devices.c
index b7f6f782d9a13..ffa4d38ca95df 100644
--- a/arch/mips/rb532/devices.c
+++ b/arch/mips/rb532/devices.c
@@ -212,11 +212,12 @@ static struct platform_device rb532_wdt = {
 static struct plat_serial8250_port rb532_uart_res[] = {
 	{
 		.type           = PORT_16550A,
-		.membase	= (char *)KSEG1ADDR(REGBASE + UART0BASE),
+		.mapbase        = REGBASE + UART0BASE,
+		.mapsize        = 0x1000,
 		.irq		= UART0_IRQ,
 		.regshift	= 2,
 		.iotype		= UPIO_MEM,
-		.flags		= UPF_BOOT_AUTOCONF,
+		.flags		= UPF_BOOT_AUTOCONF | UPF_IOREMAP,
 	},
 	{
 		.flags		= 0,
-- 
2.51.0

