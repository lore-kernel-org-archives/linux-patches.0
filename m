Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD615381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D67E1C433C8;
	Mon, 19 Jun 2023 10:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171623;
	bh=v3zHjLvEo+AfNXUvrJl3Ua8pNEyiCqt6CoCyLaVrUdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCBW8MP74sk7xapFaIzT0ec3hsy2v1dHyzhUIlMOkL1udRQx5CmhbzG6McKnlK5Mv
	 6TUeV9diAUw31PYTy5npNgOzs1XbW6TUMXqmXCmwBUgaGuKYm5wl7s74sw3RJqHzQM
	 yqirG70UT1QhRCW02xipiREy1PzQ4GmZs5g7lQOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.1 080/166] clk: pxa: fix NULL pointer dereference in pxa3xx_clk_update_accr
Date: Mon, 19 Jun 2023 12:29:17 +0200
Message-ID: <20230619102158.684421552@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

commit 23200a4c8ac284f8b4263d7cecaefecaa3ad6732 upstream.

sparse points out an embarrasing bug in an older patch of mine,
which uses the register offset instead of an __iomem pointer:

drivers/clk/pxa/clk-pxa3xx.c:167:9: sparse: sparse: Using plain integer as NULL pointer

Unlike sparse, gcc and clang ignore this bug and fail to warn
because a literal '0' is considered a valid representation of
a NULL pointer.

Fixes: 3c816d950a49 ("ARM: pxa: move clk register definitions to driver")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202305111301.RAHohdob-lkp@intel.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230511105845.299859-1-arnd@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/pxa/clk-pxa3xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/pxa/clk-pxa3xx.c
+++ b/drivers/clk/pxa/clk-pxa3xx.c
@@ -164,7 +164,7 @@ void pxa3xx_clk_update_accr(u32 disable,
 	accr &= ~disable;
 	accr |= enable;
 
-	writel(accr, ACCR);
+	writel(accr, clk_regs + ACCR);
 	if (xclkcfg)
 		__asm__("mcr p14, 0, %0, c6, c0, 0\n" : : "r"(xclkcfg));
 


