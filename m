Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAE533F5BC;
	Mon, 20 Apr 2026 16:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700965; cv=none; b=pPpl5ZQROIg4rQ43Cx0+GnszY4o4h6lNRQvyXMaRc3AUosbzVWPPvht6M//RTC+c0LIWptkH6lK+0WFDyT/IBdLC78bKRxrQxv06wU4/j+irgVLNH0DYEsybavGkFG8J/1ADCj3uqJGkUQKV8NFyKlrNO9E3qF9eHhbumRJ81WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700965; c=relaxed/simple;
	bh=x93jEvUpY2QOWaFE45roo1WIGEoOzOLDD/rqj6n94Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rs9NzMchL1C00qVlInsl44MSNU2wI9vExtluao5ABQdZFSA0k6v7x87azKkUuDhtHuuG0qebs31CtVEXDvL1jrm33Au/VVx+ih5bSIi6RMCM6sCadib+gDkr/Llm5AWprFtW0PCu7SCse+gY0y9brsuUX5av/nnBjI3jEZ+aMTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bB+x17OQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bB+x17OQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FFDC2BCB4;
	Mon, 20 Apr 2026 16:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700964;
	bh=x93jEvUpY2QOWaFE45roo1WIGEoOzOLDD/rqj6n94Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bB+x17OQ71vGYGwtxzJIfAgT1mwuL3zg1eX3JAjH6JdY/zyaQE9eE8aZfRJIZ2bnS
	 F8MgMLRp20b6VBVBkNCNH0NJhPXk7UChzgxUkccrapwMHwi6Zpqp7eJxq/W0oWvBb/
	 4VpwTQU+4CpQ60a+5sKlqydglfvu9RYfxpdmpjaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 128/198] net: usb: cdc-phonet: fix skb frags[] overflow in rx_complete()
Date: Mon, 20 Apr 2026 17:41:47 +0200
Message-ID: <20260420153940.216190569@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 600dc40554dc5ad1e6f3af51f700228033f43ea7 upstream.

A malicious USB device claiming to be a CDC Phonet modem can overflow
the skb_shared_info->frags[] array by sending an unbounded sequence of
full-page bulk transfers.

Drop the skb and increment the length error when the frag limit is
reached.  This matches the same fix that commit f0813bcd2d9d ("net:
wwan: t7xx: fix potential skb->frags overflow in RX path") did for the
t7xx driver.

Cc: Andrew Lunn <andrew+netdev@lunn.ch>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026041134-dreamboat-buddhism-d1ec@gregkh
Fixes: 87cf65601e17 ("USB host CDC Phonet network interface driver")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/cdc-phonet.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -157,11 +157,16 @@ static void rx_complete(struct urb *req)
 						PAGE_SIZE);
 				page = NULL;
 			}
-		} else {
+		} else if (skb_shinfo(skb)->nr_frags < MAX_SKB_FRAGS) {
 			skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 					page, 0, req->actual_length,
 					PAGE_SIZE);
 			page = NULL;
+		} else {
+			dev_kfree_skb_any(skb);
+			pnd->rx_skb = NULL;
+			skb = NULL;
+			dev->stats.rx_length_errors++;
 		}
 		if (req->actual_length < PAGE_SIZE)
 			pnd->rx_skb = NULL; /* Last fragment */


