Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA437330337;
	Sun,  7 Jun 2026 10:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829907; cv=none; b=lkR/GoRZQtPAGn3zOXQvzHNi9ly/LUoiofc84mmwHH15f+GUfZWYKX9GK86WkyITGC+lV23qbpyV20q6nl0O8a3t0wIO0pC7zypUnN+LN7OQiQCcLvr4vj3AgIsV11/pUdrBwInmgs3ThxcPYsKOf/wEGMNQDvei36XMMQgVJhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829907; c=relaxed/simple;
	bh=erz4dLrW3giBqEbXKs6VBWiHqy575AF6IWJJflztsAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txGklQ0X+zJ3Ocb97VAZsM21LpgvNGIeK70BAQWQw3WqRInkaCQvLAbnOe+GRx8zEForJt2Wmme/0r+RZWO3XjkN3SI3h+cNNy9mtLkS0sLncNNRuKZQzU6J/x9pqDG5P6ZUxeY2rK+76UCXKZZgR83MTsHFsKBOGKp4lCrtYbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkqXPayc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkqXPayc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9801F00893;
	Sun,  7 Jun 2026 10:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829906;
	bh=4HUbBZxgnW4UxZ9vR0R5nw8GgMPDEnkDyahvLW3Igmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkqXPaycRjuMB3pD9SCk6m+TgQnSSuEaBULeW7YM4ieJu+Dekafz8K33WnV/5WkX0
	 mXT3zm7DRFSWPAk4whW7qYZ8PDOrElfmuOb60lzbY08vsTFUGIjJ89sH3JfDFYQNCM
	 yoaYtqoI4kiPipvSD9RDweUqJk/axX5yOIOzw0sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH 6.18 265/315] serial: zs: Fix swapped RI/DSR modem line transition counting
Date: Sun,  7 Jun 2026 12:00:52 +0200
Message-ID: <20260607095737.307400909@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit d15cd40cb1858f75846eaafa9a6bca841b790a92 upstream.

Fix a thinko in the status interrupt handler that has caused counters
for the RI and DSR modem line transitions to be used for the other line
each.

Fixes: 8b4a40809e53 ("zs: move to the serial subsystem")
Cc: stable <stable@kernel.org>
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://patch.msgid.link/alpine.DEB.2.21.2604101747110.29980@angie.orcam.me.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/zs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/zs.c
+++ b/drivers/tty/serial/zs.c
@@ -680,9 +680,9 @@ static void zs_status_handle(struct zs_p
 			uart_handle_dcd_change(uport,
 					       zport->mctrl & TIOCM_CAR);
 		if (delta & TIOCM_RNG)
-			uport->icount.dsr++;
-		if (delta & TIOCM_DSR)
 			uport->icount.rng++;
+		if (delta & TIOCM_DSR)
+			uport->icount.dsr++;
 
 		if (delta)
 			wake_up_interruptible(&uport->state->port.delta_msr_wait);


