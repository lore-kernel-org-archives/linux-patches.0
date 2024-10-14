Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B500E571;
	Mon, 14 Oct 2024 14:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915992; cv=none; b=CCd7xfS4hY4HESbCcsu2ABh5vvh62R6XmxepsIbDg5WGW9hl6HA7UnQnhm6sEa8lcfa0y1VobWIo7bLiMu4SpwjEYScWVlFyhmmdHRPKZhhVjq8aWIPNDYV6TC2TruPdso+HwlUUsm91KPjJgoeFbb3+YpkiNuJy2n1xwsktaVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915992; c=relaxed/simple;
	bh=XqV1lVSNUbUxvOn3kWixek4Rh2HaRpq5RRrDhpXPia4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idDTHd5kgv0VdfquKt+eDbnhB8hZMu135ihXIDCtR4/lDMOfZ+i97wcGFqQa/SoAUs2+RrY/Q+sW9Ka1GMxkLr5GdZ8H9BGkRk7ZY/XCcjig18zrtQiQA7O1soC5kfFbXtw9YvcAHLcdyGLSO5EQyi8L2H3PziKgeF7rTQ+aWEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMnrPPIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMnrPPIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECBFC4CEC7;
	Mon, 14 Oct 2024 14:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915992;
	bh=XqV1lVSNUbUxvOn3kWixek4Rh2HaRpq5RRrDhpXPia4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMnrPPIiSHM0rRVYug661KjLZpn4MOtJxrXW54bTDDC/eIO18rLNQDtWnSOSYnE96
	 KZzJBxhNcbnyflChJ6FiuaIkDNhC/I6qhgNO0XZv6uUos0IrnTTVMTXSY/ktl07Bum
	 FpKfAb/ityEiYiz3PQuynpbSh84lNdDlZtysskDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Peter Hurley <peter@hurleysoftware.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 054/214] serial: protect uart_port_dtr_rts() in uart_shutdown() too
Date: Mon, 14 Oct 2024 16:18:37 +0200
Message-ID: <20241014141047.099635148@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/serial_core.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 20e797c9e13ab..4187ddeeac366 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -407,14 +407,16 @@ static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
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
-			uart_port_dtr_rts(uport, false);
+			if (!tty || C_HUPCL(tty))
+				uart_port_dtr_rts(uport, false);
+		}
 
 		uart_port_shutdown(port);
 	}
-- 
2.43.0



