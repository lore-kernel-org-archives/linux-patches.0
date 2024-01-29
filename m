Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 956FD15705F;
	Mon, 29 Jan 2024 17:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548113; cv=none; b=cjnlU7Zhsf0wsRiFteNSJvgYFd62aSRMF4BSjsmfIyBwmSN9XG6lj3msica/w2/WMWX+IWbW55/+XcZ6x3XK9Wl3QtIUmWIf5pfQ8hUoLV0ovqo3J+H1SzVYYYWz88qYs7r0lod9Q9H7oA70w5DU7K53J4Ch8fDMHS9x93ifs+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548113; c=relaxed/simple;
	bh=rkcqpn/ssF1lr+3a5Lnq0zGOUKIm0EXUbmAOjHAVxrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7zrcFrzq/MTcmcQ3ePxgacvyFQ9ZvU/vqc/cBzeJ+XeEwbZxHWwEjXoI1akj2rOnWl9dEt6Ax0TS8OauRaxYjrCLqAjwBQiMc9YwbXxDBy94R5iuEH0WVwIxDOySyUURTwYlSUBEed5QD2vKZO0MSenrDLS5NrICS9l+t5O2aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BHW3FeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BHW3FeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6EBC433C7;
	Mon, 29 Jan 2024 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548113;
	bh=rkcqpn/ssF1lr+3a5Lnq0zGOUKIm0EXUbmAOjHAVxrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2BHW3FeVSy+JNT5R/OObaJrWc37i6esbxchkWhNOAg+VpVPJRy99oqtZ0eAV5Skaj
	 UBzPtWtfC7TIJ9DGOwswY3KnJror+JXnkKsaoUCUVTU+6hpSkrS00j1eGtr0yWvq+k
	 dTLdTFCFZ8UbQzOAHbYfae3KNVLyfsRz87mG9Y6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.7 136/346] serial: sc16is7xx: improve do/while loop in sc16is7xx_irq()
Date: Mon, 29 Jan 2024 09:02:47 -0800
Message-ID: <20240129170020.386471292@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit d5078509c8b06c5c472a60232815e41af81c6446 upstream.

Simplify and improve readability by replacing while(1) loop with
do {} while, and by using the keep_polling variable as the exit
condition, making it more explicit.

Fixes: 834449872105 ("sc16is7xx: Fix for multi-channel stall")
Cc:  <stable@vger.kernel.org>
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231221231823.2327894-6-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -783,17 +783,18 @@ out_port_irq:
 
 static irqreturn_t sc16is7xx_irq(int irq, void *dev_id)
 {
+	bool keep_polling;
+
 	struct sc16is7xx_port *s = (struct sc16is7xx_port *)dev_id;
 
-	while (1) {
-		bool keep_polling = false;
+	do {
 		int i;
 
+		keep_polling = false;
+
 		for (i = 0; i < s->devtype->nr_uart; ++i)
 			keep_polling |= sc16is7xx_port_irq(s, i);
-		if (!keep_polling)
-			break;
-	}
+	} while (keep_polling);
 
 	return IRQ_HANDLED;
 }


