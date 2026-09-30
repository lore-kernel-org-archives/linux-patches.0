Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAA7511225;
	Wed, 30 Sep 2026 18:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792385; cv=none; b=nOnFrZcjEPQLo+yJ7nX/GJLjcoOVx7x1Xd++Y2BePXRwTqzg/vU7aTps1sAFG0GnyoZNqx5XY1vRY+cXNAE1KUYXzptpn5EbGJ7tm1drTu01370Cqrw1SFdzZPcIA4vaz1wKDaupimuUf05SdxQqbrbNnzgUUgZlvcdIE2iKmnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792385; c=relaxed/simple;
	bh=QYqDS3xfwbIk4Krz9bPJ3ynt7ulnBTzTF1O1US1LioM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlnuiqtDhmywr1XlgPgMrrQqa7l19ngrdsebutEq0M+r2k1Lb1Wzso6u33dGIVJNKVp7u2/jmkoXVbwoXHrvKD2PlQ/CXlFyO/Gw2aDud9fQqBHV8HGf/S82Ha8bQkdGstCeXR/FivA9ZLbMuCtEZybqziyiUNf6fE5QF95jVn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YI18WWle; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YI18WWle"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3B21F0089B;
	Wed, 30 Sep 2026 18:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792384;
	bh=ElW/CLy9mPynwUyB9NlfrF7AxMxrXLjKH1O59PJ4qX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YI18WWlejUaXE7epK8Qz3CtSm5EG9/dKJiuKiSlDcK2vK8PuA+85RHdza3hLaxVNi
	 TRryvEoZAiE66oFGdsukOba6hCO3IuHzdtaj8HYOvRds+0WKf1peFvVeu5FLcMhNIQ
	 qD58ab7odrTFeK09W8oXCwLgz3qUaGrQQjdsKVOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Pengpeng Hou <hppiscas@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 635/752] net: usb: sr9700: include receive overhead in the length check
Date: Wed, 30 Sep 2026 17:28:25 +0200
Message-ID: <20260930152412.009033274@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit c06bde80ae7a7b595732f7cabcb92cf08db9d56a ]

The receive fixup subtracts the Ethernet CRC from the reported packet
length, but compares that payload length against the whole remaining
receive buffer. The following copy starts after the three-byte header,
and the cursor advance consumes both that header and the four-byte CRC.

Require the payload to fit after SR_RX_OVERHEAD before copying it or
advancing to the next packet. The loop already ensures that the
remaining buffer is larger than the overhead, so the subtraction is
safe.

The issue was found by our static-analysis tool.

Fixes: c9b37458e956 ("USB2NET : SR9700 : One chip USB 1.1 USB2NET SR9700Device Driver Support")
Reviewed-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Tested-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Link: https://patch.msgid.link/20260920034745.18468-1-hppiscas@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/sr9700.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/sr9700.c b/drivers/net/usb/sr9700.c
index 07a018585b30f..d0c3f3b01922c 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -403,7 +403,8 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN || len > skb->len || len < 0)
+		if (len > ETH_FRAME_LEN || len < 0 ||
+		    len > skb->len - SR_RX_OVERHEAD)
 			return 0;
 
 		/* the last packet of current skb */
-- 
2.53.0



