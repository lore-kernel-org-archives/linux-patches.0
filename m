Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397D44D179C;
	Thu, 17 Sep 2026 18:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671136; cv=none; b=cn61U82FfWJkOuR3nXZpcAJLAqJJJHzC6fCmhlPpbY0wwkeNR3K0swSTdhQxziUXR5QYyEWsL5FR2KnRW3bHIZ6huZ1dYrNcLDHT2bQZ7p4Z96thbvC2HOHa1T3AEFlk03bm7OU9UEIZdlKE1E05U7JSAhtct4JYxCY3FWfeNcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671136; c=relaxed/simple;
	bh=lHdEHwKB0FmjJElPlaDudcTB6UEnxr5xfgonFYOgVHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X97rL7rxXgJ1a6cR0mJ51Qk6EAj7mMJWY52sXb553DTBY+rmVtUJ0RZAkIhWULnmv+QBCmLBDrsaSC9qYzWJPb8ajWfJ/JMKR9GIpPHYvLmRlqqltfS7J9tQQwuY1oImN3uUKYDKwiXmYi8LmZdfsssSEn+kH26TvtGcIffwJsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pS/X5tOW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pS/X5tOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D2951F000FF;
	Thu, 17 Sep 2026 18:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671135;
	bh=bPj0s2MCi0BlwA/rRzWUcm5rmpYHL2dMFWnWUDFCc3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pS/X5tOWIA7TqXjN1aiq76SoSF5/FOK3WDbJM2kVU+dm4La9Cd0xGUfmHks8FleQ7
	 QN/DWYMJVTEtdo9ErqnsHWko7Op9BatoGjphsFtWY3cc75czy5kGzn5IfhvGeU6x1B
	 x7SbrZ7dWe159IpP44gsQYo/sniWzw5Cnv/GnUfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 0842/1102] net: hso: fix TIOCMIWAIT race
Date: Thu, 17 Sep 2026 16:13:05 +0100
Message-ID: <20260917151601.663056495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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


