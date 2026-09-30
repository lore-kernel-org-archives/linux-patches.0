Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8531C503BD0;
	Wed, 30 Sep 2026 15:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783174; cv=none; b=PF/PrVfOPX/f0uEml0VOq5aA3xCPfbfj6aSC4Ez0TTmxYzp03C1aJY0k0Q+eOi9VAj0q1Mbjp8esP8e33Z24/ltvyahR74a8chQupBRb4/IlZfugrCTqtD70SzFq7ek0TMWJcFqQEwFN8Oxei47ktCqkgSvmtSmN4QpOOS0NuBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783174; c=relaxed/simple;
	bh=/7vQwdnsn+X0H9LHV6VqQ7e5ndil9O6nzb63lAZEVPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7OTUm1cOJL8c0PezVTSoWM7BIZ9+suqfh4flrvX6D80wMQdf2cmL4tAfWPX85aWGN/Qmn/0lS2FKGurBOW8dSvWNPhQlfx5RISceS6ycf2l8YKHpkBDmQ8Fd1RlywWVqRfy/w9SnnkmcHMRhIIQOz3HV45zVKkSKnBsuhFBAD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cjsa0Hx5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cjsa0Hx5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2351E1F00899;
	Wed, 30 Sep 2026 15:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783168;
	bh=X1QWtHl+zVLFII3qVmrqqKyFd3ZgZ30R/ybT62e8nTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cjsa0Hx58wmDbxjLlaYrw2XaoZv8afOzzPpDybWe0vBco22yZ6MdneTdJkhB1NQdw
	 idfF3Ifcdr3mdTBFusX7uhcWPR0HJNpVKYA2h7/JuyQi+u1Lwy/q8A+OUElaXy2Q/w
	 ZGBVZBjewxmubBbN2XoALdbaFiIZTm23QfXO+ZhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 302/595] net: hso: fix TIOCMIWAIT race
Date: Wed, 30 Sep 2026 17:23:15 +0200
Message-ID: <20260930152354.185703296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 00f9fbc12320253bfc576fb7539d860029c82d0f upstream.

The task state must be updated before checking the wakeup condition to
avoid missing a racing modem status update.

Fixes: 542f54823614 ("tty: Modem functions for the HSO driver")
Cc: stable@vger.kernel.org	# 2.6.29
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260907065235.100848-1-johan@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/hso.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1557,10 +1557,10 @@ hso_wait_modem_status(struct hso_serial
 	spin_unlock_irq(&serial->serial_lock);
 	add_wait_queue(&tiocmget->waitq, &wait);
 	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
 		spin_lock_irq(&serial->serial_lock);
 		memcpy(&cnow, &tiocmget->icount, sizeof(struct uart_icount));
 		spin_unlock_irq(&serial->serial_lock);
-		set_current_state(TASK_INTERRUPTIBLE);
 		if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 		    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 		    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd))) {


