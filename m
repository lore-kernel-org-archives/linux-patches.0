Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976993D9DCE;
	Fri,  9 Oct 2026 14:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556788; cv=none; b=g5WjYv9S1UI/80qASc/WhvzbpCSYd41aTHps1GZKTEEo1Hw94+pr13dAwo5FO1ZW94A9DJnpSr7i4bfbQeBMvoNpFph0MadYium82sZa26YADmiDIJrfd4K43iwjcNrs0klKEhuRbIij8cScfz1hd0tEm8tZWEg61DIjR9U0BzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556788; c=relaxed/simple;
	bh=7+pJogOjsJ3KnqqMLktgpsM4Gvmm5KTpENmL9W1lvAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CmbsopNCOtU5fXYbg/8tgdy9oR/W3wqjnereRFfFtmNRGJ2eXZoLmh5I++1uqi5dqNEDcN+u8ZlAMqM++HHMwe5RuIJCbvWTPgEtAIJu+8yHXNl5LdvWX/s2lck1eXKOq80HNGMjc31/w6PbgKNIuHTjebl7gifAwM5TiEkE/HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rovhgtfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rovhgtfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41DC1F000FF;
	Fri,  9 Oct 2026 14:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556787;
	bh=6CWvBA9azvIJRgzaseEhGXs8wthnHWw8dL/JYpIOwH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rovhgtfbmAh+VdaDwY5SIjRLfFFEbSThgPHiuJzzpy2565YcuX+br9Msy8f3nT6vm
	 HwN6GrSg2Ain+9dc1azCcdkYYs11UqPJu7QGd8s7eT5iMnKX1hMChpEqaDQbkc6i9G
	 gtI222D/8y89MHIPFiauLSKdhaoYdaPSRm8jFkY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 7.2 242/428] tty: tty_port: restore TTY_IO_ERROR on activation failure
Date: Fri,  9 Oct 2026 16:09:39 +0200
Message-ID: <20261009140951.426996694@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

commit 56964f6a31238fb41d5830bb42520c5b10ff7d8f upstream.

Make sure to restore the TTY_IO_ERROR flag if activation fails to
prevent I/O attempts on a port that is gone or powered down.

This specifically avoids issues like kernel panic due to unclocked
accesses or NULL-pointer dereferences when accessing powered down or
deregistered ports when a TTY ioctl races with hangup and open.

Note that the flag is set again in tty_port_close() but not restoring it
on activation failure leaves a window where drivers fail to handle the
ioctl-hangup race.

Fixes: a9a37ec33a1b ("tty: tty_port: Move the IO_ERROR clear")
Cc: stable <stable@kernel.org>  # 2.6.33
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260908084000.218528-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_port.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -767,8 +767,10 @@ int tty_port_open(struct tty_port *port,
 		clear_bit(TTY_IO_ERROR, &tty->flags);
 		if (port->ops->activate) {
 			int retval = port->ops->activate(port, tty);
-			if (retval)
+			if (retval) {
+				set_bit(TTY_IO_ERROR, &tty->flags);
 				return retval;
+			}
 		}
 		tty_port_set_initialized(port, true);
 	}


