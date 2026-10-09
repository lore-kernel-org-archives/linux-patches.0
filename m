Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A214E5355;
	Fri,  9 Oct 2026 14:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556208; cv=none; b=fVVMtCEzH1GvQ3i7Zxmi82KUqwOGhSTdqqryhj3nCKRmZdU0d28fqZJ9qbDLFOjzJbLH+2TcQppwRoYxQl9cTpws9cTRKDPh39NwgVTE+BBQHxIDe0hZtTmiDoL6th0gpJ3HG4bjMx42/lHhRj0zNDmQ2bS8aPTl4qQekbOxz9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556208; c=relaxed/simple;
	bh=g27xIIuSKd7qJkXU8YT5s2At8tqdKHfFI5auRXZI9/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYEfRuBbesiSLKWkjsEyjPU0/Oe4QIk32FZDdCv4eYKc9PLKaslA+MHvx8KMUeqWGQWk/vOPXaQhlnOM8ZBxZjzi1O4gqiIPEgpdbW5K55jEandKysz42Iuyv7QJp2tXuaa1DArZgnJyHEviVylGb07o7foB7Jn1QsT5zzsm4KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7wWUquk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7wWUquk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695E11F00893;
	Fri,  9 Oct 2026 14:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556206;
	bh=52WQfMZMFNaXT2hWNbz9KEnv01uG/sANC3tpi4T7/6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i7wWUqukfvapT6O5ehmgA5iu9vb+kZgy/Kajlj4MfJbtKcKcGGK8tsPwesieL1TBM
	 XUACyYBoCXrjURWFVc43Ih4sAdO56rsXxyjEaJ92Gc2WavLgJCCN+KpHE98OaxXX2f
	 xZ+y8Nbs0B+D+CLaKiVkNITBqZ5QdeBC2Wjoq9co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Johan Hovold <johan@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 191/403] tty: amiserial: fix broken TIOCMIWAIT
Date: Fri,  9 Oct 2026 16:09:12 +0200
Message-ID: <20261009140956.592949807@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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


