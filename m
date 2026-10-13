Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542DA3655D1;
	Tue, 13 Oct 2026 12:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895097; cv=none; b=BHI5+xfSFISioNCUqa+tITpxTmERSD6rmZm/hj74k+jRslZKbc1LVeHgGowAeGOqig4h6sRbOmtrJFrjDh/nDiB732ESrK4NIHRK+plsO8uiYBMaqn3B9PvdF37MuJxq71NLmWxlX8RXViWRwm6nxECA+DETDkTQuWtIxjlXJeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895097; c=relaxed/simple;
	bh=6Nq8Xn7DzY/q2L5NxdrSz8Mwj6JYoKM3+QIf7sOc0OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfI/zMdii1TMKx3v7T8mgERtpIeAWeZgM8DLEFWDHsDbWz13STSnrFGIZzGuG88OijlpJE8n2TOfk9iPL1nRNEzOz7KyTwwi8H5ycG01QLTFyzevpRA4MNihiKdXiy8MkWrvl6cQEikLqb2HW/wjDRNgnL2GDOSdsg7B2n8faCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBy99h+E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBy99h+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABEB41F000FF;
	Tue, 13 Oct 2026 12:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895096;
	bh=Sgri/vlBv6Hy0UVpcM6WvahMTC6MmN/y2cYlne5tAWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBy99h+E/IkGbJ/9ZOpgT8/yLUfvj6/gfq1HD9/bRCPZfGv04kSqEw1SSiNAVUOqA
	 17sIQ1FE/NlveGzQZiDUsyJ/1/hrmnX3DDXIkgWMkVEr1xulovTGy8pLw1odNYHqcX
	 7FEsDo1JzJ0+OFGpeYPoha3J/XihgZ4ueOVT/vJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Johan Hovold <johan@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.12 160/497] tty: amiserial: fix broken TIOCMIWAIT
Date: Tue, 13 Oct 2026 13:35:27 +0200
Message-ID: <20261013112911.686831484@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

commit 615f35fd5aee169cc4881a8594f2fa234a4d0bb8 upstream.

A change replacing interruptible_sleep_on() inadvertently broke the
TIOCMIWAIT implementation which now immediately returns -EIO (unless
there is a racing modem status update).

Replace the old hangup (and signal) detection with a check for the
TTY_IO_ERROR flag which is set on hangup.

Fixes: 591cee0a3563 ("tty/amiserial: avoid interruptible_sleep_on")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/20260910132029.D80801F00898@smtp.kernel.org
Cc: stable@kernel.org	# 3.14
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://patch.msgid.link/20260911090132.723531-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/amiserial.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -1138,11 +1138,6 @@ static int rs_ioctl(struct tty_struct *t
 				local_irq_save(flags);
 				cnow = info->icount; /* atomic copy */
 				local_irq_restore(flags);
-				if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr && 
-				    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts) {
-					ret = -EIO; /* no change => error */
-					break;
-				}
 				if ( ((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
 				     ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
 				     ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
@@ -1150,6 +1145,10 @@ static int rs_ioctl(struct tty_struct *t
 					ret = 0;
 					break;
 				}
+				if (tty_io_error(tty)) {
+					ret = -EIO;
+					break;
+				}
 				schedule();
 				/* see if a signal did it */
 				if (signal_pending(current)) {


