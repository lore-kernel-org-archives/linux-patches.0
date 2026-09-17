Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323BE51CF50;
	Thu, 17 Sep 2026 17:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666382; cv=none; b=rd1UyEKfw5wdeT14+BMBlFLx6cNvx0/iar1ap6kbA4rfuPU0OMcjXZB+mZNW/zVsMoMbTstVPEotk5w/FympBgtFz8WY9DxzbghVUmep7g4LIiUqBFTD/Qsg3gVYKQymkZag4yPyAbH78KWvC0wYxwggSbdupLNj+XZBT6dVCNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666382; c=relaxed/simple;
	bh=3AM/Akj15ylumTmFtGh9F7azx0/Q7PN3y2ClAsRK5Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYNGqY3ygSTzB7UkT4GI3CASPixPQ774OwTMqADAvGKwY+cj6Vht4NDgA+w6H7OnZqYGsHqi6szWHRz9ciNPCO79fOUnCj7jP6DEcbpJDBgfxddSU7EuncAr1V+ODd2ItTiSmv6H6O85PQPM8IAJYhos3hMTWXzpilA3cGC6lh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DXfqilw9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DXfqilw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411C61F000FF;
	Thu, 17 Sep 2026 17:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666380;
	bh=c/RsDcBdstc7b36dYqIgY05JNG2DSC5tgJGkgQ9nCCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DXfqilw9pP8Xxvdm27P5Ubkyj+eTBHASY6Hdhm7FWNDJet3p0NpXgwwzdI7lK62fp
	 gOQ1hOE7Vr0E3v2ypS899DlA5GgkdAklqOX8+WPQcbG4A6Lk2MjEByXQ0NZedCSP3O
	 A6M1nNWlFeZ7TdJ44BfQAvPtOORuol0/bQsf3DEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 1017/1250] net: hso: fix TIOCMIWAIT race
Date: Thu, 17 Sep 2026 16:13:32 +0100
Message-ID: <20260917151619.613103894@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
@@ -1549,10 +1549,10 @@ hso_wait_modem_status(struct hso_serial
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


