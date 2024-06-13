Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32409384;
	Thu, 13 Jun 2024 12:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281933; cv=none; b=C0P6QjJL73BjenfP6+bolVAt6MFKZvY8gCBOI0THFfR2jN/xcVjqvNWAdvj7FkZQpSBfrPR33AG6UBEeU7WitbfKWZLqrP4QI12r8Wy5YnjOeHFsw4V/Ermsw++i1eO+sASJy+h6q9Jh7Qox8ohtekHUV9itNyANKuWGASbaf8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281933; c=relaxed/simple;
	bh=7E+36LT0uwLlALQsyahV4KskEaNpcvN3dUdYDct6DTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cH1AmTADn9BCK4sIAKZhID7dTZFkrUk4E4WLHd4mUThulAq5S3Vj71M0cQRtlA9LvfdM5hb6BOJCRut60brOpsx02qjGfdV57+9T2HnUHQjDp3/CIihLu+xy+BzZI4wWlSKg1sLVTvsjXGEkBbU3rs7+RtzKYVAHv45TYmcWHf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSx9/kdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSx9/kdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BE9C2BBFC;
	Thu, 13 Jun 2024 12:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281933;
	bh=7E+36LT0uwLlALQsyahV4KskEaNpcvN3dUdYDct6DTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSx9/kdbmrgLLyDqfPOqgXmD1hO3Vkbc59Qx0WFU9bStR1dJD+hUfn2DNqC1mHkLc
	 wsgqbDpRF2mrIDG7HpGvjbpFCOfwoeJ2PWbWRxbRC/kXwTMRElgOEPOjdf2GkVUkF1
	 +Y4CZ9QnmEHAkNXBAxwtMJKrInSnf6QndOO1Q/W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/402] usb: aqc111: stop lying about skb->truesize
Date: Thu, 13 Jun 2024 13:31:02 +0200
Message-ID: <20240613113306.227988107@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9aad6e45c4e7d16b2bb7c3794154b828fb4384b4 ]

Some usb drivers try to set small skb->truesize and break
core networking stacks.

I replace one skb_clone() by an allocation of a fresh
and small skb, to get minimally sized skbs, like we did
in commit 1e2c61172342 ("net: cdc_ncm: reduce skb truesize
in rx path") and 4ce62d5b2f7a ("net: usb: ax88179_178a:
stop lying about skb->truesize")

Fixes: 361459cd9642 ("net: usb: aqc111: Implement RX data path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240506135546.3641185-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/aqc111.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 6db37eb6c5cc8..4b48a5c09bd49 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -1141,17 +1141,15 @@ static int aqc111_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 			continue;
 		}
 
-		/* Clone SKB */
-		new_skb = skb_clone(skb, GFP_ATOMIC);
+		new_skb = netdev_alloc_skb_ip_align(dev->net, pkt_len);
 
 		if (!new_skb)
 			goto err;
 
-		new_skb->len = pkt_len;
+		skb_put(new_skb, pkt_len);
+		memcpy(new_skb->data, skb->data, pkt_len);
 		skb_pull(new_skb, AQ_RX_HW_PAD);
-		skb_set_tail_pointer(new_skb, new_skb->len);
 
-		new_skb->truesize = SKB_TRUESIZE(new_skb->len);
 		if (aqc111_data->rx_checksum)
 			aqc111_rx_checksum(new_skb, pkt_desc);
 
-- 
2.43.0



