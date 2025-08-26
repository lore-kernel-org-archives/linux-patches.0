Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEF9350842;
	Tue, 26 Aug 2025 14:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217117; cv=none; b=EV4oE9j3Xji55AGi+WQYTJE+ufzhz+qck2W8H9njTrAg2j55AuVWMae/ETdU4al6kF66TWRoVzI8uO9G01fr+LWvzS9Uy5yXuE5f9qgPDDGQKaaUrfjQSyD0TiMV40iZFqdEVNe2HlO83wLx8jJiqQzYPOk5mNZ+GjWo7rPsjcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217117; c=relaxed/simple;
	bh=+0j7CsGvwFF67g0HR5/F/XnqP05+y35gwLouo7fTqLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b+auGDjPb7a7PvKFfLGaSLRh1iCH8h+eK+0VjSG6TV736q3qN17GGsGJILpJ4/SV/JervzWl2zuxy6v3rsYggzWuaJXQg5JWldwDDQT6WX1f85tWS5rVbTXDOaX/bs3RrLeb41Svv9UhaFrN5FEUzeNzTcMqaTUaGC5mB0v5woQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWBl7C07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWBl7C07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B04EC113CF;
	Tue, 26 Aug 2025 14:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217117;
	bh=+0j7CsGvwFF67g0HR5/F/XnqP05+y35gwLouo7fTqLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWBl7C07V5x/gv7HrzQ1Mwdcq8SMYKSHeGcHbGao/kzfvJjJEQ257skl5gL8wy6bv
	 slzY1YetB2ZVZ7WpDu/Q5iUQanp7u2LTvhbkHb53gNns+VT1HXcxqIF97xGNoB7qdT
	 8LZq9U0UkXSOoG3n1suNYXNslayfq7n9EDVZX9/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Andrew Jeffery <andrew@codeconstruct.com.au>
Subject: [PATCH 5.10 022/523] soc: aspeed: lpc-snoop: Cleanup resources in stack-order
Date: Tue, 26 Aug 2025 13:03:52 +0200
Message-ID: <20250826110925.138861398@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


