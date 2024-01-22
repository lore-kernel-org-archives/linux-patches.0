Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4286313F;
	Tue, 23 Jan 2024 01:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975018; cv=none; b=JymU4dsnmXRbJFZIW67+3cYqy9YePRGOarDMFdRvNrKUPrK7d6S1gbtINsRDEiN+Lpn4/MgRfl1xdSq+bRa+HsahB3B1RCKOPo5wUtwc/T2zndCsjL2yLi3QuCQX+ez0DYpYg4wq4Q/GiZFAlIGpQuyCvZLEoWF3xMp+JrWKN/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975018; c=relaxed/simple;
	bh=ghEQhmhZPdqjYl8DW2op/ZZOR6fyKEl0lFbBjMPiTmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsgwBd6ghO/ARVCNcRemv5xjHJFdL6/UQz1LMoupjrvN3stm+SDwJ2uL7vrm74nScDqVpTNrw7CYTNowAIu7lNyr01W6lT9kOe46hwVahK4AK3fvVm1lGzUZXV7ROFlQWTIt4bQssOQeGZJ2Zgf8q1gE0WK/ja4wlsJHjmVCDgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=obPCGzW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="obPCGzW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EBCC433C7;
	Tue, 23 Jan 2024 01:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975017;
	bh=ghEQhmhZPdqjYl8DW2op/ZZOR6fyKEl0lFbBjMPiTmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=obPCGzW/AaoSnh6+7awHjHaZBUTOkyjeLYMRs/+rw/LABkWLKCZzu03W154C795xD
	 Yh5TOlRlE+brwq3gMhxPMr9zJ9+FiPMt7aRJEPSkNsPVI1q/So3S5SpgciMDPG6Bdu
	 QMbzujBzR7t/R9hXP2zn+HhrE7cYFuTPhl1W8CL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 317/374] tty: early return from send_break() on TTY_DRIVER_HARDWARE_BREAK
Date: Mon, 22 Jan 2024 15:59:33 -0800
Message-ID: <20240122235755.904100414@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 12f6ef8d0f45..a18138ce67b2 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2504,22 +2504,24 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
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



