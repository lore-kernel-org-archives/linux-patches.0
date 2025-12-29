Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B092222CB;
	Mon, 29 Dec 2025 16:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025426; cv=none; b=qi/0jEDWcVMydjjH9mNg6LNFJiyFotJm1OIdeMuPRPtactPqkT97+4O29qqiGg580V0BL6ifYfPcUQ4Ch5if3YmQCaTNaYbhiAXcwHPfJFCs//j+Ll0HgcthpdcW3OJ5ua5qCKzJXvYmZaN/X0h4Li15AveVtqau6/BdvIOKU4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025426; c=relaxed/simple;
	bh=Y2C78+EYGoJRyx2cCrwsiw2J00uwXpLBHvNyLzDnetg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMSizB9S7cv8DCbCsNxQaFB0j0ylZPtRYLC4IZiQRRHJxCv8AoaQ6sKU1UpRxpTP3DvWahRcw6amIrzkLBA1JPSRXfLcB0HltWJ3L1ShsXogyIkOHPxDP83SHts+lE3DlOndHsnptnR5oSix5+CAYBs6KRJORjaiKcOOZRMBTkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGjVDVYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGjVDVYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3445DC4CEF7;
	Mon, 29 Dec 2025 16:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025426;
	bh=Y2C78+EYGoJRyx2cCrwsiw2J00uwXpLBHvNyLzDnetg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGjVDVYkF511TCtyvmmnQYbjFzS9zncFcedbkZJBZO7vWNXaiDQZ4QRn6IS9Mbtch
	 jeeUZKmC52DD8Sb6gcmCmFvVOEh5b77iO0dQyIMezV6hH/aLoFK9XHxtGbu+7Sckou
	 rVgtqGJXz5RxP0fwv8sELjbN0+3+xh/YNs/w33Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenhua Lin <Wenhua.Lin@unisoc.com>,
	Cixi Geng <cixi.geng@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 202/430] serial: sprd: Return -EPROBE_DEFER when uart clock is not ready
Date: Mon, 29 Dec 2025 17:10:04 +0100
Message-ID: <20251229160731.788467378@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Wenhua Lin <Wenhua.Lin@unisoc.com>

[ Upstream commit 29e8a0c587e328ed458380a45d6028adf64d7487 ]

In sprd_clk_init(), when devm_clk_get() returns -EPROBE_DEFER
for either uart or source clock, we should propagate the
error instead of just warning and continuing with NULL clocks.

Currently the driver only emits a warning when clock acquisition
fails and proceeds with NULL clock pointers. This can lead to
issues later when the clocks are actually needed. More importantly,
when the clock provider is not ready yet and returns -EPROBE_DEFER,
we should return this error to allow deferred probing.

This change adds explicit checks for -EPROBE_DEFER after both:
1. devm_clk_get(uport->dev, uart)
2. devm_clk_get(uport->dev, source)

When -EPROBE_DEFER is encountered, the function now returns
-EPROBE_DEFER to let the driver framework retry probing
later when the clock dependencies are resolved.

Signed-off-by: Wenhua Lin <Wenhua.Lin@unisoc.com>
Link: https://patch.msgid.link/20251022030840.956589-1-Wenhua.Lin@unisoc.com
Reviewed-by: Cixi Geng <cixi.geng@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sprd_serial.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/serial/sprd_serial.c b/drivers/tty/serial/sprd_serial.c
index 8c9366321f8e..092755f35683 100644
--- a/drivers/tty/serial/sprd_serial.c
+++ b/drivers/tty/serial/sprd_serial.c
@@ -1133,6 +1133,9 @@ static int sprd_clk_init(struct uart_port *uport)
 
 	clk_uart = devm_clk_get(uport->dev, "uart");
 	if (IS_ERR(clk_uart)) {
+		if (PTR_ERR(clk_uart) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
 		dev_warn(uport->dev, "uart%d can't get uart clock\n",
 			 uport->line);
 		clk_uart = NULL;
@@ -1140,6 +1143,9 @@ static int sprd_clk_init(struct uart_port *uport)
 
 	clk_parent = devm_clk_get(uport->dev, "source");
 	if (IS_ERR(clk_parent)) {
+		if (PTR_ERR(clk_parent) == -EPROBE_DEFER)
+			return -EPROBE_DEFER;
+
 		dev_warn(uport->dev, "uart%d can't get source clock\n",
 			 uport->line);
 		clk_parent = NULL;
-- 
2.51.0



