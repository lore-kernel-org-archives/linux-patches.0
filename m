Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3805213AA2C;
	Wed,  3 Jul 2024 11:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005835; cv=none; b=bMrhoresrlGQ/XsWlv2XACVVX5kIiXMF/zW03irU/xTszXei5+X0nq9uWhnQ6AOvpcwbH18Rv7WNOmXAXV28cGNZ0nl6VjrFC2Z+LxcVGP3o3wTfp5NR8NpjKepO6OxTKh/mEY1/Z/pRDmygF6hFx7ejBDDfPW9NcQF35YhKHqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005835; c=relaxed/simple;
	bh=6bmeTJkxAlYsMC/OupvPsXe+gSBhw7FPLY1RNu46P4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4dVKeYX1b7+9obG7+PiA/TGABIwpGdwFYEFRCxeha4zMEjRamRFZ2Hu0e32J1ZXSwEk8c9bbiMUu6WF8afhSOif1usPbxBseR/YFLogb+tuvcPQmQVACsauGCCr8xwShcSBqC0a6UObSvQCS62geErcQkteZCXi3Df83+JTUBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dim8UMND; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dim8UMND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20A2C2BD10;
	Wed,  3 Jul 2024 11:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005835;
	bh=6bmeTJkxAlYsMC/OupvPsXe+gSBhw7FPLY1RNu46P4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dim8UMNDz7O6oytopI6iOXqNNk6wkfOjGu4N5qutT4SWlZf8N9eA5yqYalt/XNaHm
	 SDV81Mn2BQxru3qlUova7DrM8w1rblPdQ2Jj9fqsaix0sTn9MZzJjoZ3XAPBlgTfK+
	 tZQnbtfrPl3HPxj7epNRNj/vj/rzPOaPxbmc/MWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/356] serial: imx: Introduce timeout when waiting on transmitter empty
Date: Wed,  3 Jul 2024 12:38:37 +0200
Message-ID: <20240703102919.953833679@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit e533e4c62e9993e62e947ae9bbec34e4c7ae81c2 ]

By waiting at most 1 second for USR2_TXDC to be set, we avoid a potential
deadlock.

In case of the timeout, there is not much we can do, so we simply ignore
the transmitter state and optimistically try to continue.

Signed-off-by: Esben Haabendal <esben@geanix.com>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/919647898c337a46604edcabaf13d42d80c0915d.1712837613.git.esben@geanix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 0587beaaea08d..b9ef426d5aae3 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -27,6 +27,7 @@
 #include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/dma-mapping.h>
 
 #include <asm/irq.h>
@@ -2024,7 +2025,7 @@ imx_uart_console_write(struct console *co, const char *s, unsigned int count)
 	struct imx_port *sport = imx_uart_ports[co->index];
 	struct imx_port_ucrs old_ucr;
 	unsigned long flags;
-	unsigned int ucr1;
+	unsigned int ucr1, usr2;
 	int locked = 1;
 
 	if (sport->port.sysrq)
@@ -2055,8 +2056,8 @@ imx_uart_console_write(struct console *co, const char *s, unsigned int count)
 	 *	Finally, wait for transmitter to become empty
 	 *	and restore UCR1/2/3
 	 */
-	while (!(imx_uart_readl(sport, USR2) & USR2_TXDC));
-
+	read_poll_timeout_atomic(imx_uart_readl, usr2, usr2 & USR2_TXDC,
+				 0, USEC_PER_SEC, false, sport, USR2);
 	imx_uart_ucrs_restore(sport, &old_ucr);
 
 	if (locked)
-- 
2.43.0



