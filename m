Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1826635B30
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26386C433D2;
	Wed,  7 Jun 2023 20:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171081;
	bh=ASzFjCfIe5jPs1j7C4ZpA3edszPlyHMww/guUVtdfaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/zXQWLrAEi/7ISK+WgojASDLLqCv/9b8i02fgYwf2VHLRivxRRvcLTTVngTdAubu
	 BR0hapKp4YmU0q+Qzi/5W1nHqDBQT4RByISboGs+MhW490SlcOuCxrgc9FrWFAByjd
	 N0Iwi3xpM9nBx3qYiEgJcHx/vC+g57zJdzwLegkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 5.10 104/120] serial: 8250_tegra: Fix an error handling path in tegra_uart_probe()
Date: Wed,  7 Jun 2023 22:17:00 +0200
Message-ID: <20230607200904.195480971@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.915613242@linuxfoundation.org>
References: <20230607200900.915613242@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 134f49dec0b6aca3259cd8259de4c572048bd207 upstream.

If an error occurs after reset_control_deassert(), it must be re-asserted,
as already done in the .remove() function.

Fixes: c6825c6395b7 ("serial: 8250_tegra: Create Tegra specific 8250 driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/f8130f35339cc80edc6b9aac4bb2a60b60a226bf.1684063511.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_tegra.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/8250/8250_tegra.c
+++ b/drivers/tty/serial/8250/8250_tegra.c
@@ -111,13 +111,15 @@ static int tegra_uart_probe(struct platf
 
 	ret = serial8250_register_8250_port(&port8250);
 	if (ret < 0)
-		goto err_clkdisable;
+		goto err_ctrl_assert;
 
 	platform_set_drvdata(pdev, uart);
 	uart->line = ret;
 
 	return 0;
 
+err_ctrl_assert:
+	reset_control_assert(uart->rst);
 err_clkdisable:
 	clk_disable_unprepare(uart->clk);
 


