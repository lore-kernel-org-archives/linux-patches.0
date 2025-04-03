Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C2C2505DD;
	Thu,  3 Apr 2025 15:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693946; cv=none; b=NRvDXaN2+brtPd/PvKLPEij6iKzuzCg1fGNCcgNtAvgegfOVNlccil6DBcnYus9YOlMfHOrOa9arZMC93/pg8yHVXzh4e5KQBzO6xrC1fAazZBF1YmnMRzD/a2Kd1oGAL7tbTHOk6WhSu9JbcRtN0uZbB7WNDZnwuRBBG8gq0XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693946; c=relaxed/simple;
	bh=My7WQz5GxVFAH1VtP154X+WGPAWTpR2ztGArcWIzCeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QByWaGGaUHhi34FewsIN7kIM0ANrIzcY77QNuceoP0tsKCK1gnyJ1iU/GwH98qJ2uZrhHEV1AJzQ0KojFy/kVQmSlPzH07MAnvPGQ/LK3mng5h6PRCzJZZN05F7qBeDaqXV47FptUH4cE9RfyZcrzuyLDUxZGtD1Oh8NtRFS2+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KUpry9Qp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KUpry9Qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE543C4CEE3;
	Thu,  3 Apr 2025 15:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693946;
	bh=My7WQz5GxVFAH1VtP154X+WGPAWTpR2ztGArcWIzCeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KUpry9Qp6vGg2DNeQwAEcBcEwehRh1ou46UseQZLE0224s++pc/+CzoOSe0AW2ijm
	 qenXv0Jnbkmdz87X13j3x5uaX4WmBVbsODYXDzALYvyIzJ4kpgJAVd4qkpZTe3xb11
	 9dGPncSJ7nBobfhwCf+iPIsZ9+ipMHNLApi59aOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Cheick Traore <cheick.traore@foss.st.com>
Subject: [PATCH 6.13 21/23] serial: stm32: do not deassert RS485 RTS GPIO prematurely
Date: Thu,  3 Apr 2025 16:20:38 +0100
Message-ID: <20250403151622.894026722@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.273788569@linuxfoundation.org>
References: <20250403151622.273788569@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheick Traore <cheick.traore@foss.st.com>

commit 2790ce23951f0c497810c44ad60a126a59c8d84c upstream.

If stm32_usart_start_tx is called with an empty xmit buffer, RTS GPIO
could be deasserted prematurely, as bytes in TX FIFO are still
transmitting.
So this patch remove rts disable when xmit buffer is empty.

Fixes: d7c76716169d ("serial: stm32: Use TC interrupt to deassert GPIO RTS in RS485 mode")
Cc: stable <stable@kernel.org>
Signed-off-by: Cheick Traore <cheick.traore@foss.st.com>
Link: https://lore.kernel.org/r/20250320152540.709091-1-cheick.traore@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/stm32-usart.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -965,10 +965,8 @@ static void stm32_usart_start_tx(struct
 {
 	struct tty_port *tport = &port->state->port;
 
-	if (kfifo_is_empty(&tport->xmit_fifo) && !port->x_char) {
-		stm32_usart_rs485_rts_disable(port);
+	if (kfifo_is_empty(&tport->xmit_fifo) && !port->x_char)
 		return;
-	}
 
 	stm32_usart_rs485_rts_enable(port);
 


