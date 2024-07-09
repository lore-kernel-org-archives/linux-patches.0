Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35BC6155A25;
	Tue,  9 Jul 2024 11:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524193; cv=none; b=dT94U8MZCOJtvI/LXyY/9cNMRYvvllRDeLAWLlMadQNpvn5M33fqeCe+yOebyIXEdzuVNaw3JDipqvHoaPFsxrDCkIAq7QUoCadIbbXi+yZzHIfAzJo+o+wF2anzwTuzBRSd/PieJtcbpXS2FjJHtIXzvXrJSsETi1A8Gm4wib4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524193; c=relaxed/simple;
	bh=IEiheSfi6u2yE3zNRL3Q0BQDdFj1yHw5HPmENJMrxTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CwBRwf2sEz7IS44ILiAAhaLiRRwZr9XIFAVxwjhrrFKRQGrZLdmyHkNpnzwR0Yhq9IBPYn0BUB0JAv4SFyTKGMVv8JQ+53pHgeXEVIvDSS0y5c9wzYlz0xEiwxF9flJP2PqSozKgOv3LPz1ezMvaPxjmpFz4HZhekBAgNG0KiJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arDgZDqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arDgZDqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEEAC3277B;
	Tue,  9 Jul 2024 11:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524193;
	bh=IEiheSfi6u2yE3zNRL3Q0BQDdFj1yHw5HPmENJMrxTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arDgZDqPKQdkwMinhQjxqaHyTGrLqbQ7c/SeWGvSXBjCVrCgsgEZ1V3md4X574+1I
	 bI+oMP2ffnJdSAVc1CgBic+1nyizapmpFopRLgHkucgYDafUjGf1dGg3KReZQ0Efp6
	 6jDJz8LhRVk162MV4eGAv1jW0Lh6jmWcBm2mkIAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Krummsdorf <michael.krummsdorf@tq-group.com>,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 070/197] serial: imx: Raise TX trigger level to 8
Date: Tue,  9 Jul 2024 13:08:44 +0200
Message-ID: <20240709110711.672300087@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 9552228d21614..f63cdd6794419 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1314,7 +1314,7 @@ static void imx_uart_clear_rx_errors(struct imx_port *sport)
 
 }
 
-#define TXTL_DEFAULT 2 /* reset default */
+#define TXTL_DEFAULT 8
 #define RXTL_DEFAULT 8 /* 8 characters or aging timer */
 #define TXTL_DMA 8 /* DMA burst setting */
 #define RXTL_DMA 9 /* DMA burst setting */
-- 
2.43.0



