Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208671;
	b=YonvnGoySAxVfIl6CKRuMx95b80flQpjC4DrKCuxoGR+6pgcefAsJgwLzjcppUIlVF4V
	 F+59ipG+VZuFUESnVnTQ3JmL/eKTw2U5JVNpNl1gEMvrIQwKimGE6H2OJh12PqJcgBh5M
	 ObXbh5UtU4NR4/9Ui0+A9oFNOvSZYMYffKb/cO7Y8OBeqFpLNgBeZcJc8A8CLO36cgw26
	 C7d+5/qHqjkTxWWx2VMBs506jgZ27oFAJq6xzrlPpIxulus9JQ+qGeUs/1MoIgZGYoi/v
	 2akV9PzrqtcQ3CSK3mfDvVlpkoqT98GANfyFGDjT1K5NS7fPAp8L8zTvXKm5iw+MBlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8GEc/pfWlQ4xQ5HTXqeDdNzsyFXX2J2RsvnAp+6QcSs=;
	b=DdDNJw/+kvll8Zw1/xq5I2ox4FBnSqiW3qYlkePmUy+0PO8aGBs68H+CbHJIZ6c/OxUF
	 l5oe5wHj1SWZR8z4ED5v9OEIlo+rxz0g7H8sfiM/PXOrKXM9RI6E8X3I78wse6omNxnYl
	 ZW2jSgscxxcsdyQpb6BLoSU3WEV5unN4WJNSEMBvxjKIUUsQvPCz5PbdYAD5wyxYVsWAG
	 7oyMprWMmNqsSQGWzpQaRQtRkZlB+jVfQSJoXDAqJ7iIOo7wX66IB3waRjuXS2GQbmPRw
	 mLhtc03nRMXV8gcAf0rpBtPiftxd2PVQ/+1SOG5HTqYlI6kmzdTcmbadCgiY1X8FBTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IET8KPsf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59F3606A31A;
	Wed, 28 Oct 2026 17:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IET8KPsf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DF11F01825;
	Wed, 28 Oct 2026 17:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208670;
	bh=8GEc/pfWlQ4xQ5HTXqeDdNzsyFXX2J2RsvnAp+6QcSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IET8KPsf908bCIgGSuy2VvEyFM4LSwKYKUyNJ5KJ/czfJcNLmzSOAWqEyslpZOeK9
	 D7DCVxx8yiYRgSVhfzELE0QfkJ6OjuzmdtHYw8nV43jSDrtlgne0z1Wie5Lz2iI7xt
	 nhp6bZNCCwqduJTZMoELJIPnzDkFlVdXlUsRM2Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Johan Hovold <johan@kernel.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	stable@kernel.org
Subject: [PATCH 5.10 202/516] tty: amiserial: fix broken TIOCMIWAIT
Date: Wed, 28 Oct 2026 17:55:54 +0100
Message-ID: <20261028170008.287859853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1173,11 +1173,6 @@ static int rs_ioctl(struct tty_struct *t
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
@@ -1185,6 +1180,10 @@ static int rs_ioctl(struct tty_struct *t
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


