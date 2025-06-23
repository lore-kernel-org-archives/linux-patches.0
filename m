Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DC64315A;
	Mon, 23 Jun 2025 21:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714860; cv=none; b=M5QGznJeoXYQNLRcj8rdP8L2qmn58U0D0CXIs86mZZ2uIfEKLUvNO+xabGl1E+0bqOJf0j9u6eMcYRO4ZfQowGmqdYLTcMZBbbLBrh6ah1jp5vQk2U8pUXl1i67LvBskkU+CRevzmvKHNWu9gvTAptz59sU0+1TQI/qGH1aZQ7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714860; c=relaxed/simple;
	bh=FRxTu3fHfYEum/TFb2S78o6VxtHCtIm9X4jkiAxPZQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KwALObCcUI48H37ttwHLnLM1uaqmeXGUeAvYSDrhJiQ06NUmcKzZtKU1fZ+jD3XzASI7D6TLQ8dPpZ62LsIvLI3NntJtdMIZEiNV7vFJfGakIpPmwCzf0ztThiVysSS6iTo4E3RsxEUcaL6kYRaw+RogxBsbIDbvQibP8bncjLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgp5trTV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgp5trTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E730C4CEEA;
	Mon, 23 Jun 2025 21:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714860;
	bh=FRxTu3fHfYEum/TFb2S78o6VxtHCtIm9X4jkiAxPZQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgp5trTVYukxYtM0pJA5Ts+ULd1i0cUhK+OAKT8ZG5Zhs6HmfeBq/fTf6gSpBFpLP
	 5wtulOQmXHpU+ZHCaaydNq/o84KOcxS0eHZB3IZLd0QAnWKVG3NHJo+BkO1r7R1st9
	 fWSldPTzjSlvaviG+2viFu5oyKNus+7wzE8kLcog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 234/411] NFC: nci: uart: Set tty->disc_data only in success path
Date: Mon, 23 Jun 2025 15:06:18 +0200
Message-ID: <20250623130639.547496418@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit fc27ab48904ceb7e4792f0c400f1ef175edf16fe upstream.

Setting tty->disc_data before opening the NCI device means we need to
clean it up on error paths.  This also opens some short window if device
starts sending data, even before NCIUARTSETDRIVER IOCTL succeeded
(broken hardware?).  Close the window by exposing tty->disc_data only on
the success path, when opening of the NCI device and try_module_get()
succeeds.

The code differs in error path in one aspect: tty->disc_data won't be
ever assigned thus NULL-ified.  This however should not be relevant
difference, because of "tty->disc_data=NULL" in nci_uart_tty_open().

Cc: Linus Torvalds <torvalds@linuxfoundation.org>
Fixes: 9961127d4bce ("NFC: nci: add generic uart support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20250618073649.25049-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/nci/uart.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -131,22 +131,22 @@ static int nci_uart_set_driver(struct tt
 
 	memcpy(nu, nci_uart_drivers[driver], sizeof(struct nci_uart));
 	nu->tty = tty;
-	tty->disc_data = nu;
 	skb_queue_head_init(&nu->tx_q);
 	INIT_WORK(&nu->write_work, nci_uart_write_work);
 	spin_lock_init(&nu->rx_lock);
 
 	ret = nu->ops.open(nu);
 	if (ret) {
-		tty->disc_data = NULL;
 		kfree(nu);
+		return ret;
 	} else if (!try_module_get(nu->owner)) {
 		nu->ops.close(nu);
-		tty->disc_data = NULL;
 		kfree(nu);
 		return -ENOENT;
 	}
-	return ret;
+	tty->disc_data = nu;
+
+	return 0;
 }
 
 /* ------ LDISC part ------ */


