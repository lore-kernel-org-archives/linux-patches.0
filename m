Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E529374174;
	Tue, 17 Mar 2026 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767724; cv=none; b=OcjVAmYgp0+rsrei7/8HpAwi5gqdlQf2HC1ILcnQYL9Glc4f9+OFqcs13w7ot1p7LmMS1HJZ6O2waRz1vW/dKKZZdH+lG9P+3zql6nPUuqex0uSGITN+mlz4FShdqNS8C5xELvpss7tgBslF+0eQDackleVPwznxBFAlITwXCjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767724; c=relaxed/simple;
	bh=KtXj5foikDc+a5Z8LeiFuxKHEtmUqDonFaOw2gSSqX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKNrw6ANxicLC09E3JZnZzH0f1UDkwHHqd4aClhxkhMQGMvSRVolZhQmUVq0lHTMkDFS4RzRGS4etpDO5JNVLbh0qmG0hI2RtNn3TR53DoAw2ojIsTC0aFSd/etOhnqzhdGebSp6F+BxlBpY0SWqX4LfvBxvTTHzgAtcO9kbOlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f40IOhpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f40IOhpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58C3C2BCB7;
	Tue, 17 Mar 2026 17:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767723;
	bh=KtXj5foikDc+a5Z8LeiFuxKHEtmUqDonFaOw2gSSqX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f40IOhpfxH4TzeVUWngGi9eUexokxz5SSPVWKSbvqpENsQi2t4BmppQC46iVM6VWN
	 yl4jRaWcaxR5uCypiZhQpry4wW2RTMIvKTYJBJUiWLxaScjxX/NWU3nvyxv/e3fpgy
	 KJYMe0LsABdrfKpsar+OTM8ABN3d9EYTIz0D4rSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 111/333] net: usb: lan78xx: fix TX byte statistics for small packets
Date: Tue, 17 Mar 2026 17:32:20 +0100
Message-ID: <20260317163003.484185573@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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


