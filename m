Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239CE4F3936;
	Thu, 17 Sep 2026 15:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660296; cv=none; b=mnP+v8H6AU8lvichgIDloY4b+qfMAGT0Psy+iY+sI6XnWc6tKcUfv7Jtb32un8083CZzESGPmMc6TavooE/LH5ci0qRlmZL0CM8JF4FXq/xGz1k2dAwf1ldNmhpCHqRbPht8TUPFA5vVcZgBmsHL+3raKvc3Skv3C7V/CRUp8+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660296; c=relaxed/simple;
	bh=OkgcprRNSNzSg0EDOYAfAzG4T90GSEhOZyfVTD9/BZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQPuzaDO06OqAAWLZ3iOCK6JRtc4694QO1PGkzO3gFpcfOJtNELjGjvWKh9YybLlwgRunPJ0/+OSc6qX6Uvza7liSBu5nh/0VkB89ldfA6aWUTv35AqoR/eshXXQWHEPmhKbbnwneH0RtIcAM7JJPblEeKu+XtPn0tkeSpUbTpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CBq2J7vF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CBq2J7vF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667691F000FF;
	Thu, 17 Sep 2026 15:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660295;
	bh=ohqD8kxL/oQj0YcCswcrS4tM4udvuL3Di7H+hqkDGkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CBq2J7vFSMxGoyDNmZ1ZiD/ZBSG4qiVqErHpnT8poVlJMQ75JWUl/MMFEG3j+hwSc
	 ypv4RAVQ1AASqwe0eBvRTBRe/ot89IH/RGQOFBt3YscLiIdT+zkCz/oShzEXjpWoEU
	 ajZrTbXQxHHkG+QNuFEM85aeWiUHFSPWFueDCXIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 545/733] net: hso: fix TIOCMIWAIT race
Date: Thu, 17 Sep 2026 16:14:13 +0100
Message-ID: <20260917151405.819231324@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
@@ -1547,10 +1547,10 @@ hso_wait_modem_status(struct hso_serial
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


