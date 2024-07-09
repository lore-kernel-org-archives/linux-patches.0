Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3EF158205;
	Tue,  9 Jul 2024 11:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523710; cv=none; b=H0EoO+MVflkevTSB+OHi97eYh+J5NDg/aINxCRqrIilo5mEaJ7RcI01w/LXp2Z2azaKRs/SEoqgOE0VvM6GiF6iifEQv1v05v0vOLIXV4bS0ACmKAvkd915cX/Lg3LIW/sLtPrGzJvjG0/hNZd3Aw6MORRElsbXI6O801Kb9bq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523710; c=relaxed/simple;
	bh=T2oeH3RaLUWWC6Mw/o6Lb5OS9F1VUyRaEbLXbrp7j9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SidkR1Dm7VkHkXlElq88pSzBK/6TtE3UboMJiGkdwvwBGSz2St9X2Im0v8qBphsgiUdGjDDBv2WwUrqqX8Fn3D2DORECTuzCxd51FTmH4Ou7iwNial/8/gkVkCEjgYOePlyPozq/tAP5Kb49mWv+aT9JM4GtgN+MJUUHnJc1hmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+MSWAqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+MSWAqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A328C4AF0A;
	Tue,  9 Jul 2024 11:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523709;
	bh=T2oeH3RaLUWWC6Mw/o6Lb5OS9F1VUyRaEbLXbrp7j9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+MSWAqclY2PrkY5FZ46vy9ADBh6JjX3QE4wHf92LLNNG5OF+Nz5lbNA6/EVDL1qH
	 5zUKFJf3szX8M4pA/uuvQCCZ5tJx27VUAMULVCyC7NNJEahhS0wlZnlYG2LZ9VJ6AX
	 Vq7YAyRk8osDa3kMdAwRPBL9fknn9FLVa6+CuhME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Krummsdorf <michael.krummsdorf@tq-group.com>,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/139] serial: imx: Raise TX trigger level to 8
Date: Tue,  9 Jul 2024 13:09:11 +0200
Message-ID: <20240709110700.141768734@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit a3d8728ab079951741efa11360df43dbfacba7ab ]

At the default TX trigger level of 2 in non-DMA mode (meaning that an
interrupt is generated when less than 2 characters are left in the
FIFO), we have observed frequent buffer underruns at 115200 Baud on an
i.MX8M Nano. This can cause communication issues if the receiving side
expects a continuous transfer.

Increasing the level to 8 makes the UART trigger an interrupt earlier,
giving the kernel enough time to refill the FIFO, at the cost of
triggering one interrupt per ~24 instead of ~30 bytes of transmitted
data (as the i.MX UART has a 32 byte FIFO).

Signed-off-by: Michael Krummsdorf <michael.krummsdorf@tq-group.com>
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Link: https://lore.kernel.org/r/20240508133744.35858-1-matthias.schiffer@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 285e0e1144c4c..a5d0df2ba5c55 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1320,7 +1320,7 @@ static void imx_uart_clear_rx_errors(struct imx_port *sport)
 
 }
 
-#define TXTL_DEFAULT 2 /* reset default */
+#define TXTL_DEFAULT 8
 #define RXTL_DEFAULT 8 /* 8 characters or aging timer */
 #define TXTL_DMA 8 /* DMA burst setting */
 #define RXTL_DMA 9 /* DMA burst setting */
-- 
2.43.0



