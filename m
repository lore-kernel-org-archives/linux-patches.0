Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9EB51B170;
	Wed, 30 Sep 2026 17:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789160; cv=none; b=ra8ehuyRGC2wNGHVECMQQLxVz0dD5UqZ8v6muzDCDjvbPwC0tYj9By8VkWdAvRClF0wStyOc03APJTukd3PIQ9RyHYqzBkM8a0dTHyofEW6zHcnQgHgM7cUENDNTgI7t/H6yFU9DfTnMux+fOmGpzOMfisFjbi7++zGWXFxgEeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789160; c=relaxed/simple;
	bh=aOAbIWnOdEtiTI7K7m1KITDUVrckgzFvScizJG74JWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXUhqXiBN/7N5Pk60uE2AUYVW/bVP0+8fY71aTyK0ajAU1Cf3pkSuJgAnSmXQizT2bgQ53gLD2YPYCsl/7iHrvzVrcHkEwIMXZKdMmxoJ7bYXNROcmKNnDccjqgir698f8ow2sF4bkEU2Ybn8lAmO3BRhjdTC3Tghz4guhb2X9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epmPS+yF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epmPS+yF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F1D1F00899;
	Wed, 30 Sep 2026 17:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789158;
	bh=XjTpCwJkeH+SRSZUmhgQ3ban+YsEbyF/zwvbsRzQW2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=epmPS+yFI8/n+TYCY08xaUqsqGvTBjdAGb8olHIM7M0fxi+5hXHAPXh9Al9UaC3Px
	 taPol+eYYg8937eKeNRu6vpyK/1dMNLokjJAINSZc1OESF3HWzfhzT1q7igif92/8e
	 kzFVDfsy6isRL8rqVCY4Hu5kdsC2/CSfqa246g5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Pengpeng Hou <hppiscas@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 379/877] net: usb: sr9700: include receive overhead in the length check
Date: Wed, 30 Sep 2026 17:21:30 +0200
Message-ID: <20260930152422.854636119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index e4d7bcd0d99c2..202bb55e811f4 100644
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



