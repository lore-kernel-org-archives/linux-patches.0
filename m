Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4204226B2D3;
	Mon, 17 Aug 2026 15:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979575; cv=none; b=hw/JidiTTuCjIW8AlJTAQx5XWnhrVa8qRwPoFdEcLX5/COaqfkJRvSEO9SIHX6dPyVI0iVQB0eAmPqBmhTkRq4nLIL2jhpM78+bQy29HUed40G4UZ0cMB0T4A1cpge0/c/45QVWXgeRHQPJneclKp4Z3MHe8ohUsPF/bxy74yOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979575; c=relaxed/simple;
	bh=MEtnTFq07PMtCh6yNtXGbUdZ+jVPib87bDxKonOS38c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrkpwUwZ6/xefZITvVPudiNfvMPgWKi7T9kfo7wL0XYrA7cgQhvaExi0OaPqM5H61ShtxPrkKthOwEobTsY36pK+jutOC8qe9Omu/l1HKo6HpwS1NMpeIsjNXEAL9JShH4rA5/4bgKp6lNFRghMnmihK4ycijGrSeGn4rPDoUdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TepCzFnU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TepCzFnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B30C1F000E9;
	Mon, 17 Aug 2026 15:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979574;
	bh=bIBM1Q/leD37tpKFWlHATDzCSb+p4iIjy0sCSYJy7Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TepCzFnUy089WrAWsfMVR2jzf65Qmj58XgN05yaR4mq0IbiCVou8HZfFlGcUS+b3E
	 iluuj+JxnSv3/ommFQ4YHybEaH1RwLBxQwltOfHLyaH1Clu967ldOOaFiq3PfeVLCK
	 +qi1wLOgn1jwaZGsf8SHHtwRosbNIHOOM71HQN+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>
Subject: [PATCH 6.1 236/609] serial: 8250_mid: Fix NULL function pointer dereference on DNV/ICX-D/SNR platforms
Date: Mon, 17 Aug 2026 15:28:52 +0200
Message-ID: <20260817132551.981515902@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


