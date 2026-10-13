Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 413A5319601;
	Tue, 13 Oct 2026 12:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895121; cv=none; b=UV0R0gTnO6zey90NeP72iybTLbh5Ka/SrvYPlUifSQtJKBayY6DdEpKBudDMy8+4/ih2JYRf60B2I6EIBBTKRVWRgFG96DYByxsGckDIggkG9Lsvf0G/TN1sYIJ7BHnzn7qDW4ktkZ1TEBX6o7bEVZz3ZbiHsGWEvkzxeU/Da1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895121; c=relaxed/simple;
	bh=SODjIv0oN6VjC0WFj7DZp9w26pSA5c61tBsxtJSv4T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elOmIwpD6s50WxxQrjD6N/ChitSeBtWSYt5RNV9wy4NZfqxNZKIAq+OivrFvTfHmpzutjgdsRZv2J2uPQaMHjf9oWSF/ckKKbJxERIyYz41LoEcYY9+oVfFHVVMaIl+cEQNVC+a/UCXLg0y6ot1s55w+tAjJP3AlTMqT3dqbOOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wlv6G+TZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wlv6G+TZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4191F000FF;
	Tue, 13 Oct 2026 12:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895120;
	bh=RtJVV2oYMLU5q4UNk5W6L1gn/62W7WgYuFmha2vSRoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wlv6G+TZiKQ89TzWDBvpysywjZfLYe0EbXLtHFsysh7Ece0YNpmroFca23bdbECVN
	 w6GF0Ws81fLGkWAHUbz0cg0x73xvZmr0GU+YYkK1r0336VhpYOtYkHP4VcNsNGNPMH
	 v3BwKiY/tx4F4JfbkWbw6/cPBDdo1O4wOYr13XMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	stable@kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 167/497] serial: fix TIOCMIWAIT race
Date: Tue, 13 Oct 2026 13:35:34 +0200
Message-ID: <20261013112911.853798997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1248,12 +1248,12 @@ static int uart_wait_modem_status(struct
 
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


