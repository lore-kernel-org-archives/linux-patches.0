Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8587D35337E;
	Tue, 26 Aug 2025 14:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218572; cv=none; b=cqje426sv+GBtKrF5IeYSvmMy5TPI+bOo5Bp9bHyzgXGLWYLrnN/3YoGBu6Px+yIlpfDiMTsXN+UGij6YT8vpyFSg1IPk6RetFJlopFZrmSDAlbTeTxkAVD5gn1m876UEZfNJoX4od8jlhYIH/F52bofJiQsIbNm4a2dbFfkUVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218572; c=relaxed/simple;
	bh=gD3nqlPKiAgAThqfTU/tU/tfBZ/tzC0p+dFmdB71tZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOctExXOg1jNXFqQbKPkml2mKBiA3bJZktuusJyTYwNsJfjQN1gcomHY9JxiWIyYP0eRE+X77j3q2Cy19Uhz/Lmcf52Wdm5wKjlEgH7N0DjgiX35rHNJwGBAlrE33cCQZBznIvocjpS5VIEOVR9WcKNQ0EFKF/ygdblY3eeQN30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaeSaV4W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaeSaV4W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164BAC4CEF1;
	Tue, 26 Aug 2025 14:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218572;
	bh=gD3nqlPKiAgAThqfTU/tU/tfBZ/tzC0p+dFmdB71tZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vaeSaV4Wj4gJRz2rDhL1VEWwCrwJ0arlhs7sj5oc0KR4UxAvWsNgHPMbC5dBc6OVo
	 3CxaBVoeBLxXvJ3hY1w9kwjRd81Wtz38KoktzvYvFa0+sNFt/m4O66UiL/LAHN3Q8L
	 dpxUhr+CsDeyt3fZcLy2koxZOPedXlGaBoalPxuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Andrew Jeffery <andrew@codeconstruct.com.au>
Subject: [PATCH 5.4 020/403] soc: aspeed: lpc-snoop: Cleanup resources in stack-order
Date: Tue, 26 Aug 2025 13:05:46 +0200
Message-ID: <20250826110906.326123108@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -265,8 +265,8 @@ static void aspeed_lpc_disable_snoop(str
 		return;
 	}
 
-	kfifo_free(&lpc_snoop->chan[channel].fifo);
 	misc_deregister(&lpc_snoop->chan[channel].miscdev);
+	kfifo_free(&lpc_snoop->chan[channel].fifo);
 }
 
 static int aspeed_lpc_snoop_probe(struct platform_device *pdev)


