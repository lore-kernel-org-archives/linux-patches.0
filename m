Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B738C30C618;
	Thu, 30 Jul 2026 15:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424698; cv=none; b=nBaBCWoLct2cpKJJy9BknqdiQVs0k93LTPP6Pi1A/XNCkjm+U9RABAiG0kaftwYxg26+OOO4PLoTvZXH7UgoE1EWdaoGv7rJU7nnQLCNOgiFJMWAU/Hjzc8O6ZOemk6RMkYN3e5MF2eFDl83lBM5ZwG/Zx3H/3dpuioRgFQOr1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424698; c=relaxed/simple;
	bh=zGG4ZeesuFtnjGut16Varegp1QH3Y2CuOhUSaGZCsGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GwBYWAtX+E5bVvL/doR2PpUIREoqxPJ4vVkx4ygqfa6YL+Ya1y0xk+1INc7FxiCMXSxE0e3t7db0RCr33CYRduqQ2uFvep7xsSLt9UpPyIFBlC1yK7g76Q1GBZ1hk7HYWRSLwJ6hBfEc8lyWsNPhJmPi99I+SmeqZekrWcRHliU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WeDo8AJV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WeDo8AJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181F51F000E9;
	Thu, 30 Jul 2026 15:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424697;
	bh=t5qz3MYO0hdJlwoXisS734C6yPvQk58ytDgIGQqLj5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WeDo8AJVXRc0Cm5lHiQy0IUN5TcCde91GMqnKvvlA6AACZ+/0cHjBnMbO0A/EUrpN
	 nsuv/Sg3564t+AUg6PFYyB5tsBlxwt3MkdqNI+RAuumeWVNWIymrjKkroLVAFziOgO
	 jLvNdmEK+p8bkKOn51yNc3h327HgtsYnlkXN6s2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: [PATCH 6.18 484/675] serial: 8250_mid: Fix NULL function pointer dereference on DNV/ICX-D/SNR platforms
Date: Thu, 30 Jul 2026 16:13:34 +0200
Message-ID: <20260730141455.411542628@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit 7fb13fd7e9a59a37cd911efff83abe19e3ee029d upstream.

Commit b1b4efea05a5 ("serial: 8250_mid: Disable DMA for selected
platforms") replaced the dnv_board setup and exit callbacks with
PTR_IF(false, ...), which evaluates to NULL. However, the three call
sites in mid8250_probe() and mid8250_remove() unconditionally
dereference these function pointers without NULL checks, causing a NULL
pointer dereference (kernel oops) on any Denverton (DNV), Ice Lake Xeon
D (ICX-D/CDF), or Snowridge (SNR) platform.

Fix this by adding the missing NULL checks before calling the setup and
exit callbacks.

Fixes: b1b4efea05a5 ("serial: 8250_mid: Disable DMA for selected platforms")
Cc: stable <stable@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Link: https://patch.msgid.link/20260715073546.1875083-1-yijiangshan@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_mid.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/8250/8250_mid.c
+++ b/drivers/tty/serial/8250/8250_mid.c
@@ -318,9 +318,11 @@ static int mid8250_probe(struct pci_dev
 	if (!uart.port.membase)
 		return -ENOMEM;
 
-	ret = mid->board->setup(mid, &uart.port);
-	if (ret)
-		return ret;
+	if (mid->board->setup) {
+		ret = mid->board->setup(mid, &uart.port);
+		if (ret)
+			return ret;
+	}
 
 	ret = mid8250_dma_setup(mid, &uart);
 	if (ret)
@@ -336,7 +338,8 @@ static int mid8250_probe(struct pci_dev
 	return 0;
 
 err:
-	mid->board->exit(mid);
+	if (mid->board->exit)
+		mid->board->exit(mid);
 	return ret;
 }
 
@@ -346,7 +349,8 @@ static void mid8250_remove(struct pci_de
 
 	serial8250_unregister_port(mid->line);
 
-	mid->board->exit(mid);
+	if (mid->board->exit)
+		mid->board->exit(mid);
 }
 
 static const struct mid8250_board pnw_board = {


