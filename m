Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383E44E2F03;
	Fri,  9 Oct 2026 14:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556845; cv=none; b=K44XXK4tP2dOCh2n2YXjaKhrg3p0jJbnU9P/EmEwadk+7gho1t2R7hFyyq7wprTKzXAasSvM5quJc4941oSq6sA26HoBz8Fc5ooZvxYL1gED1BVvHiNizaaEDErnVJ04gnR9bfOFutfbZy/FQtK6//BF4TTqKU++HAxD1ruUivs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556845; c=relaxed/simple;
	bh=MgXbMZUaBNeBKbJv1G5TK6eoswuhlXeXhRMZ6qUvcr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NapS1p9C5+M4/397EvUXspFtRo0A5OkeN5Lb5iS6P4kD3PTpGwPdUfXALIiWnQ9PJSY+Gd5JDOdBR6YN8alwBa5gv7WK2zEfI65esNBc9q1W7xGVCcWqrUWijhUtrm1IwBMceIUxCP1sjGMtIqL669PuSLIuxFGVogx7dBLLv+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li4JKhDg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li4JKhDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CED81F000FF;
	Fri,  9 Oct 2026 14:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556843;
	bh=2o0WFIuu87O71bFMmgp+3k/qG9OUOj8NYD+S3o/j2/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=li4JKhDg/CGmc7FU1I5EFM6FXlr1GKrj//31LCQRomrHm9+dWbwH0e7/NcK8lLyEX
	 35RN2fNeYthWLM6VUVT98JeofcXOuvnUbj/aLW7khTSyWqMJsUd7YZmwUC1dtqxO6o
	 l81bvi0E7NqLV6Ysus29xUX71RFlLUSimH1Pp+ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	stable@kernel.org,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.2 251/428] serial: abort TIOCMIWAIT on hangup
Date: Fri,  9 Oct 2026 16:09:48 +0200
Message-ID: <20261009140951.617929572@linuxfoundation.org>
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

commit eb35b73e133686e5b999eb7130c4e3d22fe03089 upstream.

Add the missing hangup check to the TIOCMIWAIT wait loop to avoid going
back to sleep (indefinitely) after being woken on hangup.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: sashiko-bot@kernel.org
Link: https://lore.kernel.org/r/20260904115542.E20D11F00A3D@smtp.kernel.org
Cc: stable@kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260910130816.642699-5-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1232,6 +1232,11 @@ static int uart_wait_modem_status(struct
 			break;
 		}
 
+		if (tty_io_error(tty)) {
+			ret = -EIO;
+			break;
+		}
+
 		schedule();
 
 		/* see if a signal did it */


