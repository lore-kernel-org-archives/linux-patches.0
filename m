Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8796133435;
	Tue, 23 Jan 2024 01:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971885; cv=none; b=Sn/tFVghHUgszNIrwmlPz2mOVp3D0vmC6AAjZRtk/ampb2GTkjUvOEM2S0dHEHq9Ex66Qb+o79U4ohxIGrNHaQMpxKEmbh7S4XgRsCnoN7zaPv/5su4H915CpXrj90FSB8XKn3EmYW+WsPRHqBYFc2ERXRXy2fpuz67QWcPSW3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971885; c=relaxed/simple;
	bh=wyhhG9bsTvmXLChX9H6XNUozh3y8Yzj00LRoPcWM40U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8wUoFbN8V9ACWKkI+1CE4yA/cwzQKan4wN6RDOrCKGaEdB+xUb27pFNWJ9pvrZT3osQgQRcNBKm8uU+soBQNhsrOKi2hPRWWDX9Q9ZnRLMYc6iDcnDNOCqd3nE20N88YfIg19cqv5SrRvPptKWXUSC6538O7Ns0g+soCeCfFYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaVzNJaR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaVzNJaR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F57C433C7;
	Tue, 23 Jan 2024 01:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971885;
	bh=wyhhG9bsTvmXLChX9H6XNUozh3y8Yzj00LRoPcWM40U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaVzNJaRgd6R69sFX02Z4qFE+p6H5TEyxYDR9EiKqJH+m0lq0EwFBIDPOF2+hbdGk
	 oP6MbYSW7iVsMrYlQ/r3IJvwhBxU9ysO38c+2ah/6NtveFsjHSZSkqIK1efO56qibe
	 eMZP47hXH0sA16bi04uDKkewCiMpwDX12Ngl4Msc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/286] tty: early return from send_break() on TTY_DRIVER_HARDWARE_BREAK
Date: Mon, 22 Jan 2024 15:59:20 -0800
Message-ID: <20240122235741.822205054@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 66619686d187b4a6395316b7f39881e945dce4bc ]

If the driver sets TTY_DRIVER_HARDWARE_BREAK, we leave ops->break_ctl()
to the driver and return from send_break(). But we do it using a local
variable and keep the code flowing through the end of the function.
Instead, do 'return' immediately with the ops->break_ctl()'s return
value.

This way, we don't have to stuff the 'else' branch of the 'if' with the
software break handling. And we can re-indent the function too.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20230919085156.1578-14-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 66aad7d8d3ec ("usb: cdc-acm: return correct error code on unsupported break")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 38877489f700..145c26401218 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2470,22 +2470,24 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
 		return 0;
 
 	if (tty->driver->flags & TTY_DRIVER_HARDWARE_BREAK)
-		retval = tty->ops->break_ctl(tty, duration);
-	else {
-		/* Do the work ourselves */
-		if (tty_write_lock(tty, false) < 0)
-			return -EINTR;
-		retval = tty->ops->break_ctl(tty, -1);
-		if (retval)
-			goto out;
-		if (!signal_pending(current))
-			msleep_interruptible(duration);
-		retval = tty->ops->break_ctl(tty, 0);
+		return tty->ops->break_ctl(tty, duration);
+
+	/* Do the work ourselves */
+	if (tty_write_lock(tty, false) < 0)
+		return -EINTR;
+
+	retval = tty->ops->break_ctl(tty, -1);
+	if (retval)
+		goto out;
+	if (!signal_pending(current))
+		msleep_interruptible(duration);
+	retval = tty->ops->break_ctl(tty, 0);
 out:
-		tty_write_unlock(tty);
-		if (signal_pending(current))
-			retval = -EINTR;
-	}
+	tty_write_unlock(tty);
+
+	if (signal_pending(current))
+		retval = -EINTR;
+
 	return retval;
 }
 
-- 
2.43.0



