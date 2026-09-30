Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B366430CD95;
	Wed, 30 Sep 2026 18:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791676; cv=none; b=nMM5VP0iVmVKU+GimXBDbhYN8c1yIB96ZPrTSx4akSnC4nKgn5w+aZK149DUn1QL/7kh6RMqZnmy6PLwbKGEawOPX+7gPWDDhNfsOQSiqxorBtViUvi8pUKCGTy6oTVN8vpRiIlnh5QHuXJtZlB+XTQSbUFLpBY20WpM1f6H954=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791676; c=relaxed/simple;
	bh=wB4v3W46E9dJRjyXYWRoXAmRoc8WHazysKPqoOCOaIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1UZPoUt2GHGAagRr53mLemaODxX0ExuRI0LFLTRdnR5gByLYtQ6hBQBqTXN4QBnLRcG8nTxt5PuEohO0sknkD/8JjVXtAqRHwIRxeM0+ML9jZxpDlMDQXeBxqYGV1BhW2R6XCsMMSKUkgn9+BeGFnSiX5HNHNup1xxwpE7uNQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dD+QJJdk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dD+QJJdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199FB1F000FF;
	Wed, 30 Sep 2026 18:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791675;
	bh=Nfx93EoyWnNsEfDQYpOKgfSNXT4FjgsXmdqYMsBDOj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dD+QJJdkNcnbgpKvqSMpI+YHPegmJ2CcCeHTzzYu7vK0ev008qnY0JEWTR5Wrs5vd
	 dYggVzY8bqgHvziGdcTNjYo3vDxpDAziFQq9ZyedgqXg+rdASov5XnFdoNvsxpEoUm
	 fzOkAwmcGPnEEZ+pL7EqbaRiBLzcsFi3P5MfCLIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 386/752] net: hso: fix TIOCMIWAIT race
Date: Wed, 30 Sep 2026 17:24:16 +0200
Message-ID: <20260930152406.629494925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1555,10 +1555,10 @@ hso_wait_modem_status(struct hso_serial
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


