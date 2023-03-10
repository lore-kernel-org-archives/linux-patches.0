Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419478481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE65C433A0;
	Fri, 10 Mar 2023 14:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456987;
	bh=gMVmOxEg0kG8TXM4Vu1EEI9zczKzCBnsDJYRDRaoARQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D67hAukDB9BxhNDjbm9uLHdskWClryY4wPiI0IH7tk2CUz6lnHI3JqV6eYV3zRGXJ
	 3pwVbezDkvGFo3g0WtIzRXJNr8DCQRpon16BMgUxUnOCTvLhTc6r360cTfNwgcMv3I
	 fYYDPupX1q0T4qRgoCgnKiGso2dEFhCtTkQ5oxlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 176/211] tty: pcn_uart: fix memory leak with using debugfs_lookup()
Date: Fri, 10 Mar 2023 14:39:16 +0100
Message-Id: <20230310133724.170654347@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 04a189c720aa2b6091442113ce9b9bc93552dff8 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20230202141221.2293012-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pch_uart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index 9576ba8bbc40e..cc83b772b7ca9 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -1775,7 +1775,7 @@ static void pch_uart_exit_port(struct eg20t_port *priv)
 	char name[32];
 
 	snprintf(name, sizeof(name), "uart%d_regs", priv->port.line);
-	debugfs_remove(debugfs_lookup(name, NULL));
+	debugfs_lookup_and_remove(name, NULL);
 	uart_remove_one_port(&pch_uart_driver, &priv->port);
 	free_page((unsigned long)priv->rxbuf.buf);
 }
-- 
2.39.2



