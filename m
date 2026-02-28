Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3654E33F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301178; cv=none; b=PJSyTgGrUbCS6w1O/jHrXBrQVWEb4UBabubJDUs6IJb6cJ56a25VeyJAn7CWVkXE2s6RFzpTNAN+hFXZ2RC7OlyY4YwPYFiH5HtyUzygeNZGNAkT7cIIY+yeH/fSkxlbWcEoM5n9wMdL9cJZa70ckjYMlOhk9AR5MxpnnukuFSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301178; c=relaxed/simple;
	bh=cMDqkK33dyeBBPrf5Ta6K24p+p4t+4mm1cDDdK4KIqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0YEQbe9b3Fi2jI2LVyeyusx4KLEwga6EuW7+l+fds8B9r0dsdUzNllzkIQSK8Ssv+s6Q3XKMQGILX+JvdGRk14fGBafDaQ6dYiwjhJp4nxb9T/Rx7m/i/HpLqKLhEVLPEOmS4XGy3bYO6rfbVPbd6HnXX3KXZgzBX5uttBKnnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DnXhZiW+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DnXhZiW+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B8BC19423;
	Sat, 28 Feb 2026 17:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301178;
	bh=cMDqkK33dyeBBPrf5Ta6K24p+p4t+4mm1cDDdK4KIqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DnXhZiW+w8N4r44qe9EHN0l2qIUL5eiNAZm2lBJ1anYXBasyIXrzInw4tuPRaMWzN
	 8aj7xEb4B/zMMyGz2PsYqDbkb4iBhqVlmNRKJV8/oXqop6OsfQ5atVDZ0PTqkQOTIf
	 pPwvo8Wk7kZyIZNoKX5dNDfqjvTJFm8mWDaMClvZfJOvTSHvdSXkipKk4G8DorudHv
	 PosCP1xdRIiwrerpRbJmJ17tCbBZL4dQ1F3O6vGl6GqC88JcLTPePQHw7qRXPzE/D2
	 PcjsknqeAtCZ9Pay8e5FAuOFuOktk2XbWX1ocGPKvgg+eSWBNyJekQF8UBxoIKnD7R
	 e8nEeN4sDTdAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Moteen Shah <m-shah@ti.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 346/752] serial: 8250: 8250_omap.c: Clear DMA RX running status only after DMA termination is done
Date: Sat, 28 Feb 2026 12:40:57 -0500
Message-ID: <20260228174750.1542406-346-sashal@kernel.org>
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

From: Moteen Shah <m-shah@ti.com>

[ Upstream commit a5fd8945a478ff9be14812693891d7c9b4185a50 ]

Clear rx_running flag only after DMA teardown polling completes. In the
previous implementation the flag was being cleared while hardware teardown
was still in progress, creating a mismatch between software state
(flag = 0, "ready") and hardware state (still terminating).

Signed-off-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260112081829.63049-3-m-shah@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_omap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
index e26bae0a6488f..272bc07c9a6b5 100644
--- a/drivers/tty/serial/8250/8250_omap.c
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -931,7 +931,6 @@ static void __dma_rx_do_complete(struct uart_8250_port *p)
 		goto out;
 
 	cookie = dma->rx_cookie;
-	dma->rx_running = 0;
 
 	/* Re-enable RX FIFO interrupt now that transfer is complete */
 	if (priv->habit & UART_HAS_RHR_IT_DIS) {
@@ -965,6 +964,7 @@ static void __dma_rx_do_complete(struct uart_8250_port *p)
 		goto out;
 	ret = tty_insert_flip_string(tty_port, dma->rx_buf, count);
 
+	dma->rx_running = 0;
 	p->port.icount.rx += ret;
 	p->port.icount.buf_overrun += count - ret;
 out:
-- 
2.51.0

