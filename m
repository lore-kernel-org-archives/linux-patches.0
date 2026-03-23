Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669D221E097;
	Mon, 23 Mar 2026 14:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275425; cv=none; b=Au0OFjwCHxmVb4pSkX+vN38Vot9YoCm2NWKicN1p6TkspckGNyFBSljEyem9IU+9SIhkQkbVL/6F3S1pERShb7GJndjeroO1bUSMl0B6H6y2FfYaGhK+mCEwrwAaH/6WrlajkJHeLUF7mYDjermP5ilI4kcM0stQrG6C0Cqw3n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275425; c=relaxed/simple;
	bh=z0rByCz4D1LmVMBW9L56b8tiVZSdTBJz87Zmw37pNcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnS4w11ISsC7xP466hofyHlKsjjgs8SwPktRJJk0mn1aw4Y4nmB1fo1JJxdwhwMr3+exWsFsJqwQT5io8nr+T8mAt2xN/uNIsIOsx9R1GTrBb1dizK+J85UBTaf1PXR/rbTOFPQDTt1nF93LRTyzaOJV56m53MzYVCSnlcrXtY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHqcu0Rb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHqcu0Rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E463DC4CEF7;
	Mon, 23 Mar 2026 14:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275425;
	bh=z0rByCz4D1LmVMBW9L56b8tiVZSdTBJz87Zmw37pNcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHqcu0RbQXEwbmNVKjekYvW5K2mCK0Woo0yL7OskhDnldpD1UmSqyKb0IABcsyylp
	 0f+lMeWhDyvLme1Xh0wnfb0lusS178BoCco8S66HxProQS0Sy9ciXBffrjdB8/du77
	 VqzJhW1lBD1VQSehVXf9aGtmg/f/oJRjLKvcgaLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 093/460] net: usb: lan78xx: fix TX byte statistics for small packets
Date: Mon, 23 Mar 2026 14:41:29 +0100
Message-ID: <20260323134528.949697221@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3886,7 +3886,7 @@ static struct skb_data *lan78xx_tx_buf_f
 		}
 
 		tx_data += len;
-		entry->length += len;
+		entry->length += max_t(unsigned int, len, ETH_ZLEN);
 		entry->num_of_packet += skb_shinfo(skb)->gso_segs ?: 1;
 
 		dev_kfree_skb_any(skb);


