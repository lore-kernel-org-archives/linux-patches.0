Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD571217704;
	Sat, 30 May 2026 18:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165341; cv=none; b=tMn1cnKvIaUnJ0BtrNVdt24jMhM3hlEY7Q2u2PoH9Zuq/CiRb+eKDOktoqXvQHFCuY9GK+bWKAGI1sWLrC/nVzxw3U13t85E9Fl2Nd8G8RqxxUESWY68EpVsyd3LV0/B/FK16IiS2aG1/yRTpkH7PJUA2GeQMnUXNnF6blB0ucs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165341; c=relaxed/simple;
	bh=VsMlua7Zhg8Khdp8unEXCobO29SUabs2cNiVkMYqROo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8DRinPhliLjX2/SD6Z3d/Zt8yEyFtWAeSVN6U++9dpxyP5kiSoHuvRoGrYCTlkNpOlebPd1fK0BERO7JQVcA2GFU6lYAsW4YWSEbcLqtXvkuXpMSfuzDSCPyXYsK+W5H68wBvtg6FT/rxBE0jUTxIFR1OSGTsdfoQY1xkjXd+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tqsYzED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tqsYzED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6A51F00893;
	Sat, 30 May 2026 18:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165340;
	bh=OMZbssX6DK42YdhZnv1Apj5l8p+nsiL/kxtwCPgOIeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2tqsYzEDohNuiyepgKUjqLW+/tQZ0cryTlh5AkqAh1vRTtUrYuMvioXkLd9zyM5N3
	 PeWjVjTHgiKFe394vDgYAVqvLmY0lVNfJE52wQVbrVHDKPqr0LZA+GiCEzQUS1JDfq
	 LVKvnCab4fnVDKFSgcrIxnFv9E7L55N4YRB7bmws=
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
Subject: [PATCH 5.10 049/589] net: usb: cdc-phonet: fix skb frags[] overflow in rx_complete()
Date: Sat, 30 May 2026 17:58:50 +0200
Message-ID: <20260530160225.880891083@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


