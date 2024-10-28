Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69DC15B10D;
	Mon, 28 Oct 2024 06:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097151; cv=none; b=NKesNn63r/q1mSqp+5E+Ab4IPbZtSTgfg8r8bxMQPXJwoNTqJrNZ9iHUVGz6E/X0Mo1zSPu3wLpe1oJWikilyL5wkOpdRVUyNaNpf5CoJ7YaviKFk1vdFxUJo0PK7Z7Pmr58IFzFev/PzkrLeBPip/wGbQnSKT6xNDO9imcAb2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097151; c=relaxed/simple;
	bh=3LbHKOzjn+E+Iikhs/9g4QPRBLzxv/wJjGdQFic9D9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xwu1f8KjQ81Mh/RT+s0WWIKPZD+jBzo2IGBuKBHiCbxuPAxYNqGiI1ehto4sxorqcP2XZ/C1edI91K1iqrVZ82VSnV9A+Hax3jsR0GULjJO1u8GxLMEruV5kT5vCJY3NpajiA0tRZOm5myC16Ra61wbYthj/cA8zs6kDyHt+WEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2u+rZHqE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2u+rZHqE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB3DC4CEC7;
	Mon, 28 Oct 2024 06:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097151;
	bh=3LbHKOzjn+E+Iikhs/9g4QPRBLzxv/wJjGdQFic9D9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2u+rZHqETKGRysIaOfrr87PE64fUWv4c9+le7U2/Qjfhp/W5pojRS+LO1fcHHo0zc
	 3R2KwOjTMIL0qRtKn8jXsYy0LgoDUUsxcm3/x3+z4V+5aJ6RfN6gyyx62Rov+xjVcx
	 hOZIpZ0xb2s6l6R6kA515RkETH9xgAhGtEyBVuC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Peter Hurley <peter@hurleysoftware.com>,
	Tomas Krcka <krckatom@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 78/80] serial: protect uart_port_dtr_rts() in uart_shutdown() too
Date: Mon, 28 Oct 2024 07:25:58 +0100
Message-ID: <20241028062254.777163787@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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
index 7cd12ea88c0b0..404354727d194 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -286,14 +286,16 @@ static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
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



