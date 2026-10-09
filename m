Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1DEE2AF1D;
	Fri,  9 Oct 2026 14:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556241; cv=none; b=AxpVllpev86wOhFd80fIna8gyhAyP95KXUas4Zr4y5QfWOieKrB+eZROLaogq2SBpmM8RCc2Ro4hYcGJHtcJBd/IIkzkhXK8DPgon3UuPy1yWI8ZlXZ2Isxm4Ze7fszsYhHlh7yatK+B+l0qDAG08ibl/HE2Fw0iCB3Rpig1H0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556241; c=relaxed/simple;
	bh=qIPKr4OBCs2vR0BzZk7bd4xpTOm3dmHL2qE5mWCaX0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNaJ9xeq1kzwHw2kLcHzCQqFb47KJ7TLrn0J7kuNa9DbdfMvYS6PILVm8IfEuKhla6HRMxfv6dvlusChw4BtdI4g83bpninzx+rxwPdgq36vfJ+BJPtKbWq6XsuiWvMxr/Ex4NArJhHUVXINyPkQ8B4JwmsHL1Ku20GhuaOYo78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOy0h24C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOy0h24C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBD61F000FF;
	Fri,  9 Oct 2026 14:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556240;
	bh=+OBP9WrZ20bWNXxYLIqlXiYbkyothNISlUmyHnRnK1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOy0h24CJdQRg2LwBVA/EaPIgVjfn8y0h8fFJkQVuNihU/V/YKpuvdkIKQ0s++LPv
	 Nfcx0HVhWdoIifsoAFPoOjQNYNlXA6+uZ+PdVz7u0eYKJCBdHIyoNGmhTsl/48M0Gi
	 FG4njQD4rEImEoOYFLqp6XHJ/vXBZSaO+xCklJ/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	stable@kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 202/403] serial: fix TIOCMIWAIT race
Date: Fri,  9 Oct 2026 16:09:23 +0200
Message-ID: <20261009140956.859962099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 40adffec8c0090533dfaa863ced7901b60bbf1dc upstream.

The task state must be updated before checking the wakeup condition to
avoid missing a racing modem status update.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/r/20260904115542.E20D11F00A3D@smtp.kernel.org
Cc: stable@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260910130816.642699-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1227,12 +1227,12 @@ static int uart_wait_modem_status(struct
 
 	add_wait_queue(&port->delta_msr_wait, &wait);
 	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
+
 		uart_port_lock_irq(uport);
 		memcpy(&cnow, &uport->icount, sizeof(struct uart_icount));
 		uart_port_unlock_irq(uport);
 
-		set_current_state(TASK_INTERRUPTIBLE);
-
 		if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 		    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 		    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||


