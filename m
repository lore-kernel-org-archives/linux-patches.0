Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8152E4271;
	Tue, 22 Jul 2025 13:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192366; cv=none; b=OtM7tUvmOHrPk4QnBGxm4eXGuZvP6onWcLWjq1d8kJgRZdKDlUOAW6eMCOJlLuRw2z5biwrmF6QCPS0b88A2l1se/NRy0tRPu+HTCtQKP/J3cjkbogqPVbhqlzHJ3gZdRSyy0LmFCx539RnCbGQrNUaggEpi/QXlg+6mYKOOqU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192366; c=relaxed/simple;
	bh=6lZ5GL08HHxuQPZ4gkgZCN0yOm+JFNTzJL6+sR0cxe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ok+doxwUO8ehfb5a7IvA1dWOg4M8PLx+doYdD0sZijKONZE/OIZPgcuu0gwuKmgy1HaZ5cr6fM6hcBojWLEhjO+K1y61HR17uJPB96IRch1Vtfjt6quwiFFxmo+2NEYmmDryVSMBOcJVsv4RERH/Yb/NI8Xw182TcUFYNwZzFuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwS3BUle; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwS3BUle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FCAC4CEEB;
	Tue, 22 Jul 2025 13:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192366;
	bh=6lZ5GL08HHxuQPZ4gkgZCN0yOm+JFNTzJL6+sR0cxe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwS3BUle6cXjm8SQ/wRKuxUGGxAh/QLEXnlxPxfTT0hZKdHeoPqJ9t5xKRRADUgE6
	 xNabTCFaPhz6Lxl6In5dC9LuXEcraVOK2oXIMSHXndHdV0KEP95agBtfdPpKoQtjUB
	 3hVrrp73tw4mw7GbfmS0Yjxy/eBYfJKtgfkAlpI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Andrew Jeffery <andrew@codeconstruct.com.au>
Subject: [PATCH 6.6 045/111] soc: aspeed: lpc-snoop: Cleanup resources in stack-order
Date: Tue, 22 Jul 2025 15:44:20 +0200
Message-ID: <20250722134335.070880060@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jeffery <andrew@codeconstruct.com.au>

commit 8481d59be606d2338dbfe14b04cdbd1a3402c150 upstream.

Free the kfifo after unregistering the miscdev in
aspeed_lpc_disable_snoop() as the kfifo is initialised before the
miscdev in aspeed_lpc_enable_snoop().

Fixes: 3772e5da4454 ("drivers/misc: Aspeed LPC snoop output using misc chardev")
Cc: stable@vger.kernel.org
Cc: Jean Delvare <jdelvare@suse.de>
Acked-by: Jean Delvare <jdelvare@suse.de>
Link: https://patch.msgid.link/20250616-aspeed-lpc-snoop-fixes-v2-1-3cdd59c934d3@codeconstruct.com.au
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/aspeed/aspeed-lpc-snoop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/soc/aspeed/aspeed-lpc-snoop.c
+++ b/drivers/soc/aspeed/aspeed-lpc-snoop.c
@@ -263,8 +263,8 @@ static void aspeed_lpc_disable_snoop(str
 		return;
 	}
 
-	kfifo_free(&lpc_snoop->chan[channel].fifo);
 	misc_deregister(&lpc_snoop->chan[channel].miscdev);
+	kfifo_free(&lpc_snoop->chan[channel].fifo);
 }
 
 static int aspeed_lpc_snoop_probe(struct platform_device *pdev)


