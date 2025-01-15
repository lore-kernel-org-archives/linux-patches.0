Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020BC248BCB;
	Wed, 15 Jan 2025 10:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938295; cv=none; b=rdiVAzPYGCR71ySRgE+l40km9eOgrGDDp4VhB4u5d7l3ApLbXRgjKYk1AG3lD2ZUuzlKIB90rUty4UBYoT3exAKYU9+JnQM9lHRacWl8f7HpaMsrd3b/H/siZFipKQRnH78ORxkVMbNWHq0lK9tn4OmJlh3iJiA10wbs0z79Cd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938295; c=relaxed/simple;
	bh=sERtP/DV7D1hIGVPMop43dFSheKN7RnCCE1FQ+ZUDs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7bUo89LfyIN+oz9OSV1EI7TsEs3hFF5hVzCEn63+UKihSKCgxeMg1MsgM4v0CnZ5GWACX2hBLngCZ1ZcE6cyq53Z2Iu+sb5FTOBdGo3DiB9aCaZNESlc77gEjjfRbg6/5i/CkV/aWvD3FwBXpL9JGzkmPVassf1xu720TIWy1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qKVeQtBd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qKVeQtBd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BA4C4CEDF;
	Wed, 15 Jan 2025 10:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938294;
	bh=sERtP/DV7D1hIGVPMop43dFSheKN7RnCCE1FQ+ZUDs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qKVeQtBdsWNmB4pYj6/FSvP06A06I7jRu54+tj6k0ugIxtjvk9qFTg6S7rwaa590T
	 cUiIjixNdpO+ECg0EfvZRmPlzv3Yk1u6bTZf2+BxItI1pL1MFcsQcA2baJJaUnuWiG
	 l+jSDU4HPwbg7KlugR2oOsp5iaQSop1Wl2PKDuWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ben Wolsieffer <ben.wolsieffer@hefring.com>,
	John Ogness <john.ogness@linutronix.de>
Subject: [PATCH 6.12 141/189] serial: stm32: use port lock wrappers for break control
Date: Wed, 15 Jan 2025 11:37:17 +0100
Message-ID: <20250115103612.051650471@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Wolsieffer <ben.wolsieffer@hefring.com>

commit 0cfc36ea51684b5932cd3951ded523777d807af2 upstream.

Commit 30e945861f3b ("serial: stm32: add support for break control")
added another usage of the port lock, but was merged on the same day as
c5d06662551c ("serial: stm32: Use port lock wrappers"), therefore the
latter did not update this usage to use the port lock wrappers.

Fixes: c5d06662551c ("serial: stm32: Use port lock wrappers")
Cc: stable <stable@kernel.org>
Signed-off-by: Ben Wolsieffer <ben.wolsieffer@hefring.com>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Link: https://lore.kernel.org/r/20241216145323.111612-1-ben.wolsieffer@hefring.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/stm32-usart.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -1051,14 +1051,14 @@ static void stm32_usart_break_ctl(struct
 	const struct stm32_usart_offsets *ofs = &stm32_port->info->ofs;
 	unsigned long flags;
 
-	spin_lock_irqsave(&port->lock, flags);
+	uart_port_lock_irqsave(port, &flags);
 
 	if (break_state)
 		stm32_usart_set_bits(port, ofs->rqr, USART_RQR_SBKRQ);
 	else
 		stm32_usart_clr_bits(port, ofs->rqr, USART_RQR_SBKRQ);
 
-	spin_unlock_irqrestore(&port->lock, flags);
+	uart_port_unlock_irqrestore(port, flags);
 }
 
 static int stm32_usart_startup(struct uart_port *port)


