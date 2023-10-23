Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0BC1C10
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jy6g2TMY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05BDBC433C8;
	Mon, 23 Oct 2023 11:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061271;
	bh=jzVAqPkA+DNmrW/PSzbuNJ/rLtzw7clVCGDMNC3nyBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jy6g2TMYVti8zEJBYxIRDHLEI5fo3ZcGaFuF9v1PXBcbVK5ulYjf3fTokgHDaiq1I
	 6oHBlrq4pk8BgrYSXYwlNq2KnhLpGbC7Ou5MbTFdC8SvaSopuBq8UXMTvf0e57iaVd
	 6fNxup4kcuyrUHuxGNdWxLLjUh4jXxhmN+McVvvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	noreply@ellerman.id.au,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.15 129/137] serial: 8250: omap: Move uart_write() inside PM section
Date: Mon, 23 Oct 2023 12:58:06 +0200
Message-ID: <20231023104825.060629730@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit c53aab20762255ee03e65dd66b3cba3887ad39d1 upstream.

If CONFIG_PM is not set (e.g. m68k/allmodconfig):

    drivers/tty/serial/8250/8250_omap.c:169:13: error: ‘uart_write’ defined but not used [-Werror=unused-function]
      169 | static void uart_write(struct omap8250_priv *priv, u32 reg, u32 val)
	  |             ^~~~~~~~~~

Fix tis by moving uart_write() inside the existing section protected
by #ifdef CONFIG_PM.

Reported-by: noreply@ellerman.id.au
Link: http://kisskb.ellerman.id.au/kisskb/buildresult/14925095/
Fixes: 398cecc24846e867 ("serial: 8250: omap: Fix imprecise external abort for omap_8250_pm()")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20230515065706.1723477-1-geert@linux-m68k.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_omap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -159,11 +159,6 @@ static u32 uart_read(struct omap8250_pri
 	return readl(priv->membase + (reg << OMAP_UART_REGSHIFT));
 }
 
-static void uart_write(struct omap8250_priv *priv, u32 reg, u32 val)
-{
-	writel(val, priv->membase + (reg << OMAP_UART_REGSHIFT));
-}
-
 /*
  * Called on runtime PM resume path from omap8250_restore_regs(), and
  * omap8250_set_mctrl().
@@ -1589,6 +1584,11 @@ static int omap8250_lost_context(struct
 	return 0;
 }
 
+static void uart_write(struct omap8250_priv *priv, u32 reg, u32 val)
+{
+	writel(val, priv->membase + (reg << OMAP_UART_REGSHIFT));
+}
+
 /* TODO: in future, this should happen via API in drivers/reset/ */
 static int omap8250_soft_reset(struct device *dev)
 {


