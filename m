Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A63E548EE;
	Tue, 22 Jul 2025 14:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192839; cv=none; b=pB4iij4mHv2bxIyxmwwRn7+3RnLicZtOmUZqtkKR0FMHf6GdATev+ynr2jZjgLrUHEcnEcpTl+DtXKLfPWDHDdfCzUyIwxu9YwBXg5TkBCENaN46IruQwx6aQg7vbi+PhH4+h0n6C+KXN6oTG0tUlk55Ih/JpGzqa6JUloRArWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192839; c=relaxed/simple;
	bh=PjgXgsXOtW4wd2jjoic3f+zb+EwLGR++7l9S0MPB3AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFZ1EqxSA2XJFMGQEGgvxq7YHD7FWT7zKtCn0JVruTYwyvMvduszQ9L7qJMi2UL3GPZx0c8EWhghVsDumEjItgF9jXRto9QG2el8yXRkOhh85H5hYqZ3IsZcogLTrsBpUQ0XeLnLCvIQvvwV0Q5O0t93JGYU9HMkeUkCssOuKwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJdYpegp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJdYpegp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904C9C4CEEB;
	Tue, 22 Jul 2025 14:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192839;
	bh=PjgXgsXOtW4wd2jjoic3f+zb+EwLGR++7l9S0MPB3AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJdYpegpeQcfuyRtfd7/0veNxDiqSGwS0YgdWdcPZ5WmwbIha47DlXA1X/2CuMSe6
	 z8XJf8ub6t7p910MUjPfqO3CJMsPXpd2eaRIQWed9D2xIrbFnCvOCdkrUC5hG/DnV1
	 639OlDXrrwjCw7IFnQf27LsMap/c37A6t2FT2l98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Andrew Jeffery <andrew@codeconstruct.com.au>
Subject: [PATCH 6.12 065/158] soc: aspeed: lpc-snoop: Cleanup resources in stack-order
Date: Tue, 22 Jul 2025 15:44:09 +0200
Message-ID: <20250722134343.181508708@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


