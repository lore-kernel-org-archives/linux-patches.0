Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D654E1C7E;
	Wed, 30 Sep 2026 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783760; cv=none; b=vCNfZg9ClSj4DluLA4R1sSJdqy6TPEcs4MnJPHW0DVJdIMQFv/lcugzlAojg+RUOsWT5c7c+EM4kjsIhcCwbbHEdudFtwasguxufXnPSVgC+VBuR3/pTlaEfpgtLrA0Mx7mfbK3q9o9yUEnzv4z5NrOgY5nTTJYLmc/s9ZydmAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783760; c=relaxed/simple;
	bh=2kINU6b/CG6qTYEponWwUKzz0WPs/Tsu7lRwoo+g5jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCZYIhF3idt0LM30v9a2gYIIVPrPcA2QJvbbfffAY4i4jXAYimu5mdeNkJgXi13O/ECROEyhDRtFe8+0KAoqKDoFaCf/YhCsAW+D6o2xB521scvClra09+HJlbvbvol7EecZ3TzqAy01uO/Izfd5iut4WYVHEfj+pddyMr4a8Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JFaDVbcv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JFaDVbcv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692981F00893;
	Wed, 30 Sep 2026 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783755;
	bh=EtpXBQmzPwXtUsBnUI05Hh4zDf1mXPlQaCKR1KZ5YZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JFaDVbcvYzC4CBBKZnyY9RxqdbNLmmMQAYLLMkCTdll6Y46zJgQqbdt7yzfJ/5Huj
	 cjdwe2xuvb3tiEb5duQq9uE7kGk/tO42ZAhEvi8ZKcpJ7REWtJsUQXwXHNIT8ikooy
	 +5KdGDk2cdvvb2231B4h4cle0gD+NT97IhDx49sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Pengpeng Hou <hppiscas@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 512/595] net: usb: sr9700: include receive overhead in the length check
Date: Wed, 30 Sep 2026 17:26:45 +0200
Message-ID: <20260930152358.715248673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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
index 9dbce3232d7c2..abfc7fdbe71d3 100644
--- a/drivers/net/usb/sr9700.c
+++ b/drivers/net/usb/sr9700.c
@@ -402,7 +402,8 @@ static int sr9700_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		/* ignore the CRC length */
 		len = (skb->data[1] | (skb->data[2] << 8)) - 4;
 
-		if (len > ETH_FRAME_LEN || len > skb->len || len < 0)
+		if (len > ETH_FRAME_LEN || len < 0 ||
+		    len > skb->len - SR_RX_OVERHEAD)
 			return 0;
 
 		/* the last packet of current skb */
-- 
2.53.0



