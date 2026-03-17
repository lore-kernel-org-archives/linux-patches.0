Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E703A382E;
	Tue, 17 Mar 2026 16:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765910; cv=none; b=phwiVeWQl37GD/PAMXyTZ+Yakrv7Rxr4w++TCW74a1w2bivlv2H8diadYkm6VIKFa9B8RXaCzawN/99V5mp46WOvFvGOiIyAUAQWdTUyHLwsW9/2yZNYZxYWGk95MBY2yI0MI1zXaUfkbLfYapgIZmeGC94F5yT9F5/GsKD8T1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765910; c=relaxed/simple;
	bh=41Sg/kd00Y63cadcorkQ12WwDBJypQDSenwVd9/pEas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKeAo6Ih9idWJb6/+k03mvm0tupslUSDX33vuMS2f6Ceb0GGK+xoQNHH5UHNioDtJJakQbawdXvuchyhtle2OhKjOjg/eUAwjUTaA1jxCoK0Dx2DoivmzrGWPZ3bWWtWHSZ0nAaK49nYQyl9FibodZvAZ9Cpip59WdcSKJ5OfOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJcPBonF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJcPBonF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10307C4CEF7;
	Tue, 17 Mar 2026 16:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765910;
	bh=41Sg/kd00Y63cadcorkQ12WwDBJypQDSenwVd9/pEas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJcPBonFpAe4nEk6QpRlgzBhfNBLP000JuUjIzfldZxY8IUf6FXm1lKM7wEZoD0YN
	 HwVOnCm8LJc8tubxEK5MYZfVPJizrP4VmfbObKtuI4HeyFxZ73smkZG6k2fasNQajG
	 ttLEOCHwsZnfb0I/JG8enxw4N2ffqIJy54h7ophA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.19 122/378] net: usb: lan78xx: fix TX byte statistics for small packets
Date: Tue, 17 Mar 2026 17:31:19 +0100
Message-ID: <20260317163011.505452408@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

commit 50988747c30df47b73b787f234f746027cb7ec6c upstream.

Account for hardware auto-padding in TX byte counters to reflect actual
wire traffic.

The LAN7850 hardware automatically pads undersized frames to the minimum
Ethernet frame length (ETH_ZLEN, 60 bytes). However, the driver tracks
the network statistics based on the unpadded socket buffer length. This
results in the tx_bytes counter under-reporting the actual physical
bytes placed on the Ethernet wire for small packets (like short ARP or
ICMP requests).

Use max_t() to ensure the transmission statistics accurately account for
the hardware-generated padding.

Fixes: d383216a7efe ("lan78xx: Introduce Tx URB processing improvements")
Cc: stable@vger.kernel.org
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20260305143429.530909-3-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4178,7 +4178,7 @@ static struct skb_data *lan78xx_tx_buf_f
 		}
 
 		tx_data += len;
-		entry->length += len;
+		entry->length += max_t(unsigned int, len, ETH_ZLEN);
 		entry->num_of_packet += skb_shinfo(skb)->gso_segs ?: 1;
 
 		dev_kfree_skb_any(skb);


