Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD1B15B10D;
	Mon, 28 Oct 2024 06:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097442; cv=none; b=BkCOjnopNhRCtMZFe2O+C4LS1Vrey1jFGZThhiKUQq8FLx9ScjaCiuk10Xm6qRutwLIkinIPRJd9wxG0TRjFir13MF440ExoeantAATi8a907YcJ9Pzfi75pCF2VTIJ+AiOTl5mSKrI3k4IPrlB//ZsUyywxH55A9Os7wb1eya4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097442; c=relaxed/simple;
	bh=Bh+Csoz2sM1MgOkkd/nEGTYP7EJ5KPtc6uCWneGoYS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kz9KBWrsLqyGfy+jbEFh0LGTlV1agSl7zKClfyDDmlMYyoZSA6LFzxRE9c8NAb3aLJ1LtkRPZ2EUjSYXAdr1NuksKNRjHqCW4lXoShPWRK+ZndWdMkrjt3VLtet4q+XAipAmbqUYkuqSMrCzNmGoZl6/XQ2i30XcImzB0UsspBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pF5t4Lbr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pF5t4Lbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70403C4CEC3;
	Mon, 28 Oct 2024 06:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097442;
	bh=Bh+Csoz2sM1MgOkkd/nEGTYP7EJ5KPtc6uCWneGoYS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pF5t4LbrfRB1JOtJdn0JZ2GyacFHdra/pPfhsTYfXpvuwz9Gqg6qfjMsTrVKprXdv
	 qJosPJtVnNKqnnQfSYPK2awCOjziSg/iauUfHo6GSu+5rbLlcOhMXwbdZqwrgjO07g
	 2weQosfHCwXFUHXSNchV1PDHDftfUgbC8qEwcNl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Peter Hurley <peter@hurleysoftware.com>,
	Tomas Krcka <krckatom@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/137] serial: protect uart_port_dtr_rts() in uart_shutdown() too
Date: Mon, 28 Oct 2024 07:26:08 +0100
Message-ID: <20241028062302.364261299@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 602babaa84d627923713acaf5f7e9a4369e77473 ]

Commit af224ca2df29 (serial: core: Prevent unsafe uart port access, part
3) added few uport == NULL checks. It added one to uart_shutdown(), so
the commit assumes, uport can be NULL in there. But right after that
protection, there is an unprotected "uart_port_dtr_rts(uport, false);"
call. That is invoked only if HUPCL is set, so I assume that is the
reason why we do not see lots of these reports.

Or it cannot be NULL at this point at all for some reason :P.

Until the above is investigated, stay on the safe side and move this
dereference to the if too.

I got this inconsistency from Coverity under CID 1585130. Thanks.

Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20240805102046.307511-3-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[Adapted over commit 5701cb8bf50e ("tty: Call ->dtr_rts() parameter
active consistently") not in the tree]
Signed-off-by: Tomas Krcka <krckatom@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index c91e3195dc207..19a53801ff9ee 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -339,14 +339,16 @@ static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
 		/*
 		 * Turn off DTR and RTS early.
 		 */
-		if (uport && uart_console(uport) && tty) {
-			uport->cons->cflag = tty->termios.c_cflag;
-			uport->cons->ispeed = tty->termios.c_ispeed;
-			uport->cons->ospeed = tty->termios.c_ospeed;
-		}
+		if (uport) {
+			if (uart_console(uport) && tty) {
+				uport->cons->cflag = tty->termios.c_cflag;
+				uport->cons->ispeed = tty->termios.c_ispeed;
+				uport->cons->ospeed = tty->termios.c_ospeed;
+			}
 
-		if (!tty || C_HUPCL(tty))
-			uart_port_dtr_rts(uport, 0);
+			if (!tty || C_HUPCL(tty))
+				uart_port_dtr_rts(uport, 0);
+		}
 
 		uart_port_shutdown(port);
 	}
-- 
2.43.0



