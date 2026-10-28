Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208923;
	b=5h4LaBr2Jy5CFzB+oX+Cs+FJDfXkdlVGF9bAK8p5LMaDdQiB2qIsIUEeUtsxQZM2+PK5
	 tOfff6d8Gng7A6VSh1OPcPaOpKrPOT3PUrUc87CiGVBc9h7NIod2Eu4VS1EADyJ+27NE7
	 HTBP1FkpcD9LPG4KfAtpHRLdSaxvgv5fSoV134T/p4rqrDdXBWjG1asd0GzNbVwd2tQTT
	 7h2Iw36baVHnveCTg9wZaoIRC0HhIV1i0/Qdl34E1PSoIZiTRSY9gpk8KfyJXYf1fBfo1
	 tnY4RRqe7g09NBVLCl2IDr9C5T2ps0mF75fCLoKT4klneRds49/hLgKorbXI6g0iSbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=elrC0wK0GR5a0x1Bt+q6v2tfodOgN3mM79yc9v4vk+w=;
	b=WQ7d/rvHLCb6LMwD60qgB+6DOtXGe57pZgCtGpGP6fMVhgt8o+g9YzCaqb6pnG9TPIDa
	 7PXIBsMTJnpaWW2QSlseHfAESUYhwOmmGoen34Pw4McNFG91BaTNACqTnC1UXcTHwK+VK
	 W6CimtjUFMIZLHgUz3q+dlGiRD2TJcW93bamOkS9ZQCK2o+wbnOCE7jPY8HCL0/H902/y
	 RHd7ZBXHC9HndWpH7wZ0dPt1FT6dfUYgPGIjM/Jb2xHMzzMQ4+eG0t0BW5qAmO/SrBPKp
	 vdJVYPsok3ih7iQeCgXoISNcnLBt1rUVO4gatnc8L2b5YbhjQvz+w/uEViGSjgvfbUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqxijWXZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F880606A31D;
	Wed, 28 Oct 2026 17:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CqxijWXZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C751F01825;
	Wed, 28 Oct 2026 17:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208923;
	bh=elrC0wK0GR5a0x1Bt+q6v2tfodOgN3mM79yc9v4vk+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CqxijWXZENs8GBNxvlHjah3V4z6lNCvMF1o/EgVqqssWcKxdhhz1/Gla9qUmyC2pi
	 MdSXCSWSpuTaxYJQTY1Gs1vwQLVI/GLgy1+vtX1Yjd111DjkrZ2yTQnm3b1iNYWkgr
	 A3vNUD5xAStgty3Pm0WyKYDzOlkCtHlwKRBbXDbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	stable@kernel.org,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 291/516] serial: fix TIOCMIWAIT race
Date: Wed, 28 Oct 2026 17:57:23 +0100
Message-ID: <20261028170010.386766091@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 40adffec8c0090533dfaa863ced7901b60bbf1dc ]

The task state must be updated before checking the wakeup condition to
avoid missing a racing modem status update.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/r/20260904115542.E20D11F00A3D@smtp.kernel.org
Cc: stable@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260910130816.642699-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ sashal: adjusted context for spin_lock_irq()/spin_unlock_irq() instead of uart_port_lock_irq()/uart_port_unlock_irq() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 6d7d448d0fbf5..7e4cab742321c 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1240,12 +1240,12 @@ static int uart_wait_modem_status(struct uart_state *state, unsigned long arg)
 
 	add_wait_queue(&port->delta_msr_wait, &wait);
 	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
 		spin_lock_irq(&uport->lock);
 		memcpy(&cnow, &uport->icount, sizeof(struct uart_icount));
 		spin_unlock_irq(&uport->lock);
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 		    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 		    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
-- 
2.53.0



