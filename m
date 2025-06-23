Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B70B13A265;
	Mon, 23 Jun 2025 13:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684594; cv=none; b=OSX2JFFE34dO0gKrr3SueQZgxFsIqY8UeftzFeF9KUW8DCkg+wM8BfbBS6bkMRe76jQAHPNhQ84WzjowKUappNcspl3bxzJ2SNdl9N5YpUhDIyyf1dKcJk3fUgVYK7fuslfUvPrE4kHzg6uVxqcIyDhNqKZBsarp9ecitAQBvQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684594; c=relaxed/simple;
	bh=heszwoDvolpQlNdvcdmp2j/3Kv6AiXvrFcMcIExW86o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMrBLjm4oJBfcKwQioxZ4+VJv17Yb2UcGRDVkyyEsppXUR4228dZCeQ+Btv8aOBIKphADtSzq7BKTpAhECms7DkJknaNS+irl/qVFuoKN4CF3mrwEdWvT+DcaYmq3zTki53SVQTD9Acb3ecdIYHcKQenmp8VKJpqS/gZOKHG1o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWuJ5s4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWuJ5s4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5CDC4CEEA;
	Mon, 23 Jun 2025 13:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684593;
	bh=heszwoDvolpQlNdvcdmp2j/3Kv6AiXvrFcMcIExW86o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWuJ5s4zP6yyEA3+O+OXpYGPvzIjg7blyaUzdliAD7IbmgiBPufk9CCEJr8GsIGyC
	 eqp5ekZxPqAWYf6/a6A65ZegQ9uENdBtcdMXEA/Lb8tbe9M7HWAvLdA728nvwffDgv
	 oG68tf7eaSg2prKrpLBdZfFXR8Nb/uM1CAOPS540=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 127/592] NFC: nci: uart: Set tty->disc_data only in success path
Date: Mon, 23 Jun 2025 15:01:25 +0200
Message-ID: <20250623130703.291468596@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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
@@ -119,22 +119,22 @@ static int nci_uart_set_driver(struct tt
 
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


