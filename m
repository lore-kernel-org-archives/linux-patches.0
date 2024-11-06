Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABA31FBC98;
	Wed,  6 Nov 2024 12:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896727; cv=none; b=jWyl+e/Jg/uZDjkw58uu7kxPpHGMm+XixFENjzOzMOMDxv77uMlQky8QNzwTn58HHS8Sr9y1o2rsBSYR1OOtQ5WivGuGw1NgpD/WQSsX+iLCin6YcMQhgNnAK9ltyg+g02zhOfQKhiqZ/m4RrZ45qks4EVehwwhbUdcod+vmYMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896727; c=relaxed/simple;
	bh=bpbushGaSTt0Gtn986VK6bsQom6eUKaheto3zOomrXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZye37mpz3/kcH1FG/YnqFXeqErAx0LCMWLfpxY7dzXDJpYtlpDHxqKu2TujWj+yOdHlPoFeCE9sG6p2iqZrHgZoWGNfcwlbKK+RUQGMh203+lqj9O24bk2SuPWvDIhPSFtUZY99mE5IAT0uJWUd1wLyNpv/tFiKjHq4W0Korug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vEsqkzgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vEsqkzgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E820FC4CECD;
	Wed,  6 Nov 2024 12:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896727;
	bh=bpbushGaSTt0Gtn986VK6bsQom6eUKaheto3zOomrXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vEsqkzgIl9BABHlaBaOPtdF0v2o04WYC9Ix6P4bzeTmkrZhpDoUs0Mb9wPKgRFHKF
	 nXHOlE6OhEyv6Ogfqf2e1EEHRyyIr0t3FMrVBOJyyNGRRZU5m6LCNfq1lUqzsL97Eu
	 HUQp7+BRd4RNM7fImcERWhUdqCFVGXPczYyfPqq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Peter Hurley <peter@hurleysoftware.com>,
	Tomas Krcka <krckatom@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/110] serial: protect uart_port_dtr_rts() in uart_shutdown() too
Date: Wed,  6 Nov 2024 13:04:18 +0100
Message-ID: <20241106120304.638333092@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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
index c7adcf97e2a33..6d7d448d0fbf5 100644
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



