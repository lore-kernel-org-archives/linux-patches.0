Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACB6225A3D;
	Mon, 23 Jun 2025 22:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716886; cv=none; b=NcOOjqv++swMvRfXB0edL5eK+Vw0pb058btA0P1lUJdBWSYHp44Qi2AvMn0f5wtfI0UN2l+jBp1wadAfQKD7Pg+U+3XDwFdu+ygvZGhHPp+IfCwfff6oWlSZBz47TpWvp0OCDkupTV+s1IvebOCi5+Jv0oHvm9qgv8UqkhKziCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716886; c=relaxed/simple;
	bh=/CQGu3D5ErzgQGVjM7rBWtVEba1d9jmxlJlLZ6WtAtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYF1Bp9svWd5gslt2k5jky+GpWzhnanxW2oBYyz6+TjCNKCETwUah5M/T5orBWY2IgjtLd0EHQt/1R+KHEt/hL86oNAId53n6WyX29NsGk+u064nJSo+cESP8jHc0wGYxU7t7YuC5WH2XbGiemjNcu7B4I5N1HIBhtHwr5cykww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsDoxEzS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsDoxEzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBE6C4CEEA;
	Mon, 23 Jun 2025 22:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716886;
	bh=/CQGu3D5ErzgQGVjM7rBWtVEba1d9jmxlJlLZ6WtAtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsDoxEzSv30spj7w3rKv9bnXAS3mTtN/YJ4a+VWeJCEC3Dub1GLptf5KpeFlYxSAC
	 UVvpmEV6O0ecP7UV3q49+ci+Y4FRepLfQIF2HdNbsUSCTrKP4J03TDcHCKzCDAhU1K
	 tFgKTuB9+1f1VtRFimC+abhdqav7YofgO9cFA/e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 342/508] NFC: nci: uart: Set tty->disc_data only in success path
Date: Mon, 23 Jun 2025 15:06:27 +0200
Message-ID: <20250623130653.757719185@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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


