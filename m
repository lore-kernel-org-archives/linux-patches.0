Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7857F2EE267;
	Tue, 22 Jul 2025 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193487; cv=none; b=ndeNq73HmF3VOIIfDf/LPXNqOp/OSyfHDRTr7VtJz1qoxuhO7pGa83KQRXXYY1ZBJkD0xgMJZLQ93wvPbJYcBzTxCDcgtYm73XBJ0xI/IKzMjbz3QTz+k/ag8CG1XL7c/Xvc6xDdfcuYMSE+pqEJBNx8qcLglCW3k2SVbpdgkkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193487; c=relaxed/simple;
	bh=L91Yudsb32LpU4yKR+QQl67BFonX3gl+GdM9uE6D/HI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qU7JmEM/loWu0TpdypTNgZ4YMZZUY8kCIKAet5yWs2PoSAvfSSL8btxB9THG1WFdflZ730KA2/bIEsQtoE1xpa+p2rmwvFsivm/ZoYmxfF0U84hYduRKKhaqFVutLRAqGpflJm3N7TwiU2qZ0gKH18t3QrQxabDxLujjZ5awNrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10c0bB4v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10c0bB4v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DE1C4CEEB;
	Tue, 22 Jul 2025 14:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193487;
	bh=L91Yudsb32LpU4yKR+QQl67BFonX3gl+GdM9uE6D/HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10c0bB4vQk8SBkkr2Ogo728kn0WNbagEhT32G9dSB1GdGfpL4vm6sNVh8QwmKp4tI
	 axB7Qk8tw2mNy72r3RmU/TM8IiK008Na4ItV9010fN/P8CCHfEriWbeko/vX8+Uyn4
	 b2HTw9XcDu0qehKIbrXsX/WEAy+7H1ijOrXlr2TQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Andrew Jeffery <andrew@codeconstruct.com.au>
Subject: [PATCH 6.15 075/187] soc: aspeed: lpc-snoop: Cleanup resources in stack-order
Date: Tue, 22 Jul 2025 15:44:05 +0200
Message-ID: <20250722134348.522827346@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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


