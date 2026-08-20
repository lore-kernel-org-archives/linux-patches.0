Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA3747D935;
	Thu, 20 Aug 2026 16:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244626; cv=none; b=O+ImIYNEmtVaRyFUFOhBDi/Qy0zSgLP/YnS1Uw3tyLA/nPze14cl26IvxG9lGM25V3QziCFzS/mZA6M3TYVaNzkRXbpRf9cPGQvQklGs9ioko2PTUg0LgVmaY50t7mAazRyhff93T1J9ELp/bCfdw45upGuAOSYA/bITEgwnzlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244626; c=relaxed/simple;
	bh=OHzd7KiDv519naX3fZJPobalsA7ZPnQ5mYf2CSK3mnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AWN602qj2UlsgfqqAsFbGYelJAYZPt3cOKlAbiSI1MLMhoHk2IP95iWNo3O8HjHaILVZVzOi9I/lwU7rJdlFPJGmnAYNIystZf5UuzZzSMDDPWhIURpBkEi3y8877AfF/1E26WsR71Yoq6Vj8+ILsgJc0XqADj0xk53oIJDFpWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnZcOnXP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnZcOnXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 350AD1F000E9;
	Thu, 20 Aug 2026 16:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244625;
	bh=KC71auolRXsUa1QwvBcU3FfppIchXJIfDQE5vNBAPUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QnZcOnXPazq1T5k9vNfiMm/w8Rxn89kAF0T3AIVTE07b7PmqNdBPWGZhY2czzqgGO
	 u0tq96zphjhdUdzRdijpzd+P0FT+ExvhBF1pBh5wdQPexNSlMrh7D9g6SFUZGd5qCg
	 WmQ0/Y60gyKkJwOcEqx5lLFtZ51gkvnUhohFte7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 235/235] USB: serial: keyspan_pda: fix information leak
Date: Thu, 20 Aug 2026 16:57:51 +0200
Message-ID: <20260820145223.738333075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 6bfc8d01ac4068eced509f8fc74d0cd205e4dcec upstream.

The write() callback is supposed to return the number of characters
accepted or a negative errno. Since the addition of write fifo support
the keyspan_pda implementation will however return the number characters
submitted to the device if the write urb is not already in use. If this
number is larger than the number of characters passed to write(), the
line discipline continues writing data from beyond the tty write buffer.

Fix the information leak by making sure that keyspan_pda_write_start()
returns zero on success as intended.

Fixes: 034e38e8f687 ("USB: serial: keyspan_pda: add write-fifo support")
Cc: stable@vger.kernel.org	# 5.11
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/keyspan_pda.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -606,7 +606,7 @@ static int keyspan_pda_write(struct tty_
 	if (rc)
 		return rc;
 
-	return count;
+	return 0;
 }
 
 static void keyspan_pda_dtr_rts(struct usb_serial_port *port, int on)


