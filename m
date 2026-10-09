Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A65219F40B;
	Fri,  9 Oct 2026 14:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556866; cv=none; b=uhYpdUsB2SSYEKk/P1UjWUWQnPIk8bXqNWAZjwTB0jpEbvsXO/dz9cD2jyfuRbTepbpGPBEfdQ7eyMJul2PvzHm3C/jrhFQDAiEcXfLaZoUJzSCAtmqd/5ZTiFR8xbw/nR720z7SQpDDecG03yrztiMJup08PdRjt4GSlWQl9HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556866; c=relaxed/simple;
	bh=KNWkknzxrkLFZJ6ahgHFQqskKZVu+klXbmdSCUSie3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyyyIdBv+tng3kjOIg4GXfyS1vmJaiS7axmNM34WBXgzIleu8Sbbzl3gW817ubF2n3Vz2JVqWXaNbj0RiFOXvZJDExpM0UJixeyu2bN+H7VaiOy29vGk/8htIZxFETMcIjWepFTl/A8U/7C7e6qnQ9iIWLwUcLxeg2IpD5eSAnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSV7dMI9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSV7dMI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FE41F000FF;
	Fri,  9 Oct 2026 14:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556865;
	bh=byASadAOkgaCqz7wdBZJ2FH6Nt795JGpz/Tj0jvk6ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BSV7dMI9agcshpefcT0Zp0DOf7riu3IjplGaQMTImzGlgCTHB+D8DwIX1pwMNta1Y
	 eSuEwUIa6fXeGKDKm9DqYWOBASZzh1lsDcesQ4iixwBSyc/UpVR5vAiamafvP0maZO
	 A3X7fj8F3bGD9Zpl7eUHEQ/ZZ+8DiPOIpY9QlieU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	stable@kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.2 255/428] serial: fix TIOCMIWAIT race
Date: Fri,  9 Oct 2026 16:09:52 +0200
Message-ID: <20261009140951.706561248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1229,12 +1229,12 @@ static int uart_wait_modem_status(struct
 
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


