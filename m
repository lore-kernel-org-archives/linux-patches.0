Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267473DEFE7;
	Wed, 30 Sep 2026 19:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796742; cv=none; b=gt/ZfQ2MhOzBZj4DGzfY7PGmMBel03hc1FiSSpW6TeJvKRVP4PaRvjMxQnwiJy4dFzviTnveVAX/YvC3rlB4nespRoNwMnd8isvP4pSI78XP6agwtp68rZWcGWuQEAsj91NhQUb5ccOaMzrgYfcE8HmQqlqYX1MVSMZ00YK7OnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796742; c=relaxed/simple;
	bh=jx2DZFjlxXbPa48jnmhLWqqhXLpAXH1IMwE/crbdJig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/11RWAPKH8Frr3izCtlB28xYVwKikETkt8czwh6/uBke/QN8BSfyokZGSzszj3OLMXmZipHRCx9jxu8+ZcPp200s/aYuMccEoYak/ZzvxteMrAeNPETYybwiheSZ0EUC079I2HRC9qDYg7qogQviWcyGVmuN2zVNwLu5yDXbI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w+M+ef+s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w+M+ef+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E87D1F000FF;
	Wed, 30 Sep 2026 19:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796740;
	bh=vY/kzPZdL3cApdo27Qabk4cWDZzuJJyy4+Y4sVXAjTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+M+ef+sEF/9syE79IsxZ8atOESLnxhsWJaC0HSMkodNewwS/yk/KjcbL0ak+Y6yb
	 EL5PF8WPqEP6nb1iPEBDXkWrr3GAp4DK3NhSIisbMbbMfa3SaekLVBb4+/RyW+EWjf
	 cjQlQ9m40fFFVT5uRyqmBshhzsEVYQoz25tuOHK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Pengpeng Hou <hppiscas@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1020/1193] net: usb: sr9700: include receive overhead in the length check
Date: Wed, 30 Sep 2026 17:28:24 +0200
Message-ID: <20260930152456.899466147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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



