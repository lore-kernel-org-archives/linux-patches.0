Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D816E4204E;
	Sun,  7 Jun 2026 10:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829660; cv=none; b=mOQ/a/V1kpxmnIcj+3LaeHY/Y5I5qcTKjLjKWZAjGbrm/0wFDVyVsk2emA1iphpPeT8f+of3IuTij8r7BUYq9+5HPJszv3J8oKuHX7FY1V7xw3Q8NnqWToNbVbHT5CZqCZjsoBYuNIbmoeS2HFYqRzqtrPMDgJEm8Adbgvjiyys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829660; c=relaxed/simple;
	bh=46yXnYqL4mMEsns003+nBOISCT7vccrKHU2Ppk8odjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKCrbgL3SSS4i0S2jVcxcGqRBvhQ1jKQWvFLVJc9CKu/O8gyQyPrVC8SfDgefnoP0nbitcFqRz8lPYsdGMc0wlDzUfPiUsp9gVcsm43kkpkDEvBK97emMAsoXqBmwq8P5nr1ut26GE7WyDuF5sqPEPWHwILY8cQ/1Lnrbe/MxMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFzeurWK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFzeurWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC7581F00893;
	Sun,  7 Jun 2026 10:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829659;
	bh=F1eUrjtyMFtaZe4lIPwoGMS1+Z/gtLOIVNu48O0BUW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFzeurWKE5iLJafr541BTrVQahVKM6Svhdd2AMGjTugCoZE1BSSrW7F3fJSInAfHk
	 P0kaBqfxaPKBrF6Xnlf01Ib/CmUqewbjrOlCoLJFMW0I7ruydD8GmI99Mx6SQ4tZr2
	 PxfvDtFsi6bmhKARpCaJGZBRWss08BGBKqmeCftk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>
Subject: [PATCH 7.0 296/332] serial: altera_jtaguart: handle uart_add_one_port() failures
Date: Sun,  7 Jun 2026 12:01:05 +0200
Message-ID: <20260607095738.934838963@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

commit ea66be25f0e934f49d24cd0c5845d13cdba3520b upstream.

altera_jtaguart_probe() maps the register window before registering the
UART port, but it ignores failures from uart_add_one_port(). If port
registration fails, probe still returns success and the mapping remains
live until a later remove path that is not part of probe failure cleanup.

Return the uart_add_one_port() error and unmap the register window on
that failure path.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 5bcd601049c6 ("serial: Add driver for the Altera JTAG UART")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Link: https://patch.msgid.link/20260512065837.79528-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/altera_jtaguart.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/tty/serial/altera_jtaguart.c
+++ b/drivers/tty/serial/altera_jtaguart.c
@@ -379,6 +379,7 @@ static int altera_jtaguart_probe(struct
 	struct resource *res_mem;
 	int i = pdev->id;
 	int irq;
+	int ret;
 
 	/* -1 emphasizes that the platform must have one port, no .N suffix */
 	if (i == -1)
@@ -418,7 +419,11 @@ static int altera_jtaguart_probe(struct
 	port->flags = UPF_BOOT_AUTOCONF;
 	port->dev = &pdev->dev;
 
-	uart_add_one_port(&altera_jtaguart_driver, port);
+	ret = uart_add_one_port(&altera_jtaguart_driver, port);
+	if (ret) {
+		iounmap(port->membase);
+		return ret;
+	}
 
 	return 0;
 }


