Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE981258EE9;
	Mon, 23 Mar 2026 15:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278306; cv=none; b=argLOx7RKPhZEdEm3UC3ZkTbYNFhLxziqkcb+hJPoUUx8UGQfdO19Pl55uJ2mnLSioxUWE6ED3R586tFwKOBcolNgUkUs4Iqq1ozwHKtNjVkhedvXF1gH1m87sSH0vB1le+YAI62UaY1UTjHbaNNkdeeC9tx0YUHpK+RU1Fln8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278306; c=relaxed/simple;
	bh=k3SWX7VXLOU0f31GEVzNoXA8hbmMmc+MAJWQW70Vca4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYXBmgXEIOMZMYPQL9Zxdqhre9YH3iaeoVjHFYlBr+0rz+sQHaixGrqqaACebTxvQuWzet5dUowJMMQFsbwCdaVRXCAc3GB8qvWaWqO+ns5jUO/H8yKj/vmLdwL2ry1+DOoAzBwEruK7+ZNp6JNCn0H5mOG7QlTgoW2XYNWBybk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNmrAk11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNmrAk11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36617C4CEF7;
	Mon, 23 Mar 2026 15:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278306;
	bh=k3SWX7VXLOU0f31GEVzNoXA8hbmMmc+MAJWQW70Vca4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNmrAk11W4Y4ZHC8gTD3Aa2kq9tvNQViNIhJbAkrk16P80vGojDKgOpxKzAp3nlt4
	 v8/tbOdnbEvxWXEkYiAJa97LrCOEREpPSMfgaEJMvFotqX3OocnFYsDlcBx10TkjqZ
	 yM6p0+/Ryn8dV+dBsoWhsRnG65o/BWxcmmGSg8h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 265/567] net: usb: lan78xx: fix TX byte statistics for small packets
Date: Mon, 23 Mar 2026 14:43:05 +0100
Message-ID: <20260323134540.386679181@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


