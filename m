Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CD3125AE
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 15:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A03C8C433C8;
	Thu, 24 Aug 2023 15:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889364;
	bh=+Xy8nYP3pURNFq4RCmIqccSjrQnQNkmrb3DbD8+4wM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0N3aTIW+wlUVxoqOc0uz1B0QeAI3P5iTi+u2N2EGAmqHlglRkoji6UY17BRpndjke
	 v6J5CmZQGnjn83sgOdsGt6bZdbaBrkPUAflXPxFaUmHwqoO40zZqpUlO3XZvwk+xRC
	 /CrfWonYETVHe5dsCqYFMCezizbUqFyCxzatXRdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/135] serial: 8250: Fix oops for port->pm on uart_change_pm()
Date: Thu, 24 Aug 2023 16:50:52 +0200
Message-ID: <20230824145031.669940195@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit dfe2aeb226fd5e19b0ee795f4f6ed8bc494c1534 ]

Unloading a hardware specific 8250 driver can produce error "Unable to
handle kernel paging request at virtual address" about ten seconds after
unloading the driver. This happens on uart_hangup() calling
uart_change_pm().

Turns out commit 04e82793f068 ("serial: 8250: Reinit port->pm on port
specific driver unbind") was only a partial fix. If the hardware specific
driver has initialized port->pm function, we need to clear port->pm too.
Just reinitializing port->ops does not do this. Otherwise serial8250_pm()
will call port->pm() instead of serial8250_do_pm().

Fixes: 04e82793f068 ("serial: 8250: Reinit port->pm on port specific driver unbind")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20230804131553.52927-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
index 432a438929e64..7499954c9aa76 100644
--- a/drivers/tty/serial/8250/8250_port.c
+++ b/drivers/tty/serial/8250/8250_port.c
@@ -3231,6 +3231,7 @@ void serial8250_init_port(struct uart_8250_port *up)
 	struct uart_port *port = &up->port;
 
 	spin_lock_init(&port->lock);
+	port->pm = NULL;
 	port->ops = &serial8250_pops;
 	port->has_sysrq = IS_ENABLED(CONFIG_SERIAL_8250_CONSOLE);
 
-- 
2.40.1



