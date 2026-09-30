Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC0134E75A;
	Wed, 30 Sep 2026 19:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795621; cv=none; b=HxrowHEny3jsrO6wItj6L+53qaJAzTo6N8QIAKsGDB1Y9Oee0v7PgeWeLOIO59cvcCM0EuPHJSTuL++Yzgd0OytHos26tUMOzKRiDEAdG0Y5DtA7ZDASLVovWpMYRdkCZY8DrQ2oa24aFXPX1YneSm+v5dtQWAnS5XzNck9VM+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795621; c=relaxed/simple;
	bh=un8AkR6XbDOWDcHJAm3iD3S3lSF9yPuldMx7/+V53a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLBbqceVvwmH910p0mBYIeKA7W4nOQe4EqtYYRwLR5l07VczIjz5x4QKaxrDrmMbuLOcPNCSTmPx/Sdwg+UFpJOKd41lGVDsh6ltC3YbMiFCBkBER+Vvm16O6YSYkpAGROkw5QbXzGTfp/b80xHiPS/ZLb88AgghaIhSHlIwq1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iz2ZkxFh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iz2ZkxFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E671F000FF;
	Wed, 30 Sep 2026 19:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795620;
	bh=KqV5L+6pxykisNIDlVGVqkK+Yzda4Al79DGPQfphwR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iz2ZkxFhlvn/JKWB3TFS2Jpb+o12RN9KOYUzxm8lZJGJIROUANmgKbAeYxe9K0lbR
	 0ANEKRVMIAy9As9e2PWvj8SrSfIWIjTId1xW/jPQ1IWkh+f+rzEJnxU/41N/k9lUvQ
	 VmCLeJDtcMtf34qUHNe4XHVE6r9d7a4xTkdwv4Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 0626/1193] net: hso: fix TIOCMIWAIT race
Date: Wed, 30 Sep 2026 17:21:50 +0200
Message-ID: <20260930152448.153024759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1550,10 +1550,10 @@ hso_wait_modem_status(struct hso_serial
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


