Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556F62F84F;
	Tue, 26 Aug 2025 13:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215522; cv=none; b=SZqX04CN3H0e/7y+uELJIOKPcf0xRoc+krczl75AqjOViauEw3/zmcrCF+jKN/A7/CBLJjIMnN9DNAxu4TM2ApaxpydJfNlQGdM5exkbnBS9TjVmQNAHA6ZNIANZ2QhRTFdeldJ5EG1ypPA1o7YJwwjxy1BwJll31BinLlW9dyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215522; c=relaxed/simple;
	bh=+cEP4LDXnAsmBDjx2ctuTYUoYLRT1EAutRI75TxtDvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVC5Pguo0HGDBDcPIiv6xEDA2Gn6NwG9gYIV7GLPLOpcGSNdM599cwydAP5DUzB+kxK3QS4WyrZ7FaZEb243A/9tJ/xv6G9MWi2Z/FC7Pmarp58O0RUokJR48t/HP/aUoJVC6xeB7brSOKfFjGc8/znsuGEKszmZHHFYzoRCDlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yey8Xm3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yey8Xm3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA016C4CEF1;
	Tue, 26 Aug 2025 13:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215522;
	bh=+cEP4LDXnAsmBDjx2ctuTYUoYLRT1EAutRI75TxtDvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yey8Xm3poI9aaOxa0Y2y1SKtY0fynYoYHLhMB4ECvvKs/UtxkuS9ozf6dV38/mrSr
	 KltGgr5QZ5yQV+gOP5sukh7/fVbOFuwTqkX24n6QkB6iqjCBjWgRJjhinkAC7VapLR
	 mW8SXGn7RSc1eorV2GbulEdWX2XYJShYH2iBeCVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Andrew Jeffery <andrew@codeconstruct.com.au>
Subject: [PATCH 5.15 024/644] soc: aspeed: lpc-snoop: Cleanup resources in stack-order
Date: Tue, 26 Aug 2025 13:01:55 +0200
Message-ID: <20250826110947.107524301@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -264,8 +264,8 @@ static void aspeed_lpc_disable_snoop(str
 		return;
 	}
 
-	kfifo_free(&lpc_snoop->chan[channel].fifo);
 	misc_deregister(&lpc_snoop->chan[channel].miscdev);
+	kfifo_free(&lpc_snoop->chan[channel].fifo);
 }
 
 static int aspeed_lpc_snoop_probe(struct platform_device *pdev)


