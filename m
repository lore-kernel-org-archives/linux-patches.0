Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D920F3431F5;
	Fri,  9 Oct 2026 14:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556227; cv=none; b=srYDTBk1WLx/edX6FMfk9bnyt7f2vr5hCKun0MZJ29/FWV75I37Qr3oUuneD1Uepg5cRZ2/rZjy2DSm/Ycd7MdmwHv8JjyrqNnSugX/bWIVHmV5sSaf2HQd5OfyY0j+yrlpJJ8uwIcYo9f/VssyJMb2f6SEW3A93JZ5xgnFFhr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556227; c=relaxed/simple;
	bh=Nb1524uvUl/Ou9BR4r2AsZWBmhpCoeZsT9H5cZt7z80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVx1NDQf7qtSRL2rPKr1u7EiTiKLZCdM1J42IMv/vmGyQ5hHMYNLsEpMZ+f4qe/HL2/0y856TrvgF9egUYif3i6vOEdnLjOKump2b2oYoaQZcmOJiMR8lau23NrEDnBGikAWI11Kls8wyVdnzvCtsb/jhSRk6zC+fET5SNuLWn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kPvsHA4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kPvsHA4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167C61F000FF;
	Fri,  9 Oct 2026 14:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556226;
	bh=XJfEhd0KkyRHUgly2c841rppLvNwB9ET0ZHj/h87uL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPvsHA4ajRZ1GUxMofR8tvD09e/jZDER52DHEMb3Eb1tB3dPyq6S1OUKL82rxjva/
	 sgxV0Jwa6hO17OBBmGM3uxxBY/fCx2gAIrzizqxPWmWPdxP4dNRv++gSG67F70deZJ
	 WISjBHeRB4pCX7xPILp3GixRxeIl2z9uSUB32ca8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 194/403] tty: tty_port: restore TTY_IO_ERROR on activation failure
Date: Fri,  9 Oct 2026 16:09:15 +0200
Message-ID: <20261009140956.666812506@linuxfoundation.org>
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
@@ -745,8 +745,10 @@ int tty_port_open(struct tty_port *port,
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


