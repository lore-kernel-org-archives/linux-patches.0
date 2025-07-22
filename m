Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B73E92D9EE2;
	Tue, 22 Jul 2025 13:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192043; cv=none; b=KuOPfzm6Cl2JpEOEkW2mTN6NiPK8DtUOtrlugk+aL2zHLpnlw5mA8FLQmNYOahd3uHRBBqSteV0YEzGUtFilH1g/M/1AE7+ZNWtWPeyUtVceQhsllzBFQNmBtM8ES++jdIQ1PtM9CXLGsPqZkPLiKLlC3cjioN5r2tn+8kxYS0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192043; c=relaxed/simple;
	bh=y3U7WQBgFr+5xNiJE/kAAwMCnnb32GVjG7Q8nzfn5yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsAXh8xy77eHxY5R4a7mRVXkFS506wiluFgDz5juC3citHvwgOIUcnPy8Gs7CzraHc3/rGWIabfS8qybNpWne6V75Z5NFYdvij09O4R2VwvudsaNX9NCW7ZEmogxEsFjLKYQBj616vfinA0ISl6eIrlmLf55t+csUPKPoyqOgco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BoqKgLIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BoqKgLIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205E7C4CEEB;
	Tue, 22 Jul 2025 13:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192043;
	bh=y3U7WQBgFr+5xNiJE/kAAwMCnnb32GVjG7Q8nzfn5yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoqKgLIWDIz4UPQGgFJ9/Wl2+GF6MpImcd+5XvE5dCEM5rT2HkI/AKXPluV7mYrKZ
	 vnGJuQDRXQCIIDI+eztlMOhgTd4SFyLGBuR5PIaXXFUZ7DIhugYOR72ZpsffmbA7Q2
	 NYFEP4lY/1Wcq/FTSmPTXH2bHlHhCnPLc2Us/5XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean Delvare <jdelvare@suse.de>,
	Andrew Jeffery <andrew@codeconstruct.com.au>
Subject: [PATCH 6.1 28/79] soc: aspeed: lpc-snoop: Cleanup resources in stack-order
Date: Tue, 22 Jul 2025 15:44:24 +0200
Message-ID: <20250722134329.408157067@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134328.384139905@linuxfoundation.org>
References: <20250722134328.384139905@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


