Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EAC34DCD7;
	Fri, 21 Nov 2025 13:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732906; cv=none; b=N3fgzTMejlZ4GygJDCfl9eFcci4Rx3q40J8icvUarMyiCno2F4OJiJKIAQBi+wvNeYzD02rDiEjdOEMOVF84fHO0KmeamGAC1HGfO8g4xSS2mIWIqge85r6HDMsznyRxP0iI922TfseJ0xOOAhYUYAbNlDQD1MaaaCB3lFd1aVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732906; c=relaxed/simple;
	bh=9/G6k6PS8xyKafmz6XjsSXeO/IR+86CObfBx+CAgZGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N8++e9HIsngVs/zZjoOJr5LKkfNLISH8h90yYyu2lX6r0GxBSoH8DWib5KBLz7R35LRQXK9EkS5fyf13w4XoNIE5YA7VS1tkGs+RtkdAN78SWUIK6J7xDs2PzP4i9udltzlIag035lU8n6cR65t4YCBgFGwKIxPnzjAjvUP8amo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFC7+bFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFC7+bFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9A4C4CEF1;
	Fri, 21 Nov 2025 13:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732906;
	bh=9/G6k6PS8xyKafmz6XjsSXeO/IR+86CObfBx+CAgZGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFC7+bFVQl1dsdmQtiT05fGIoXo6tZSSzO0O5gs79g4HFAGf7SLwYHlXO1khrld1e
	 RhWNA+INYYo0yrLqUUUmpVIgPmK1fChpHhyELrdiqUEcGHHFoXfpjQacO+OrdQlRi0
	 ySVV4Ni9DZp9/vYr65nUWk9u1RGydgEtkpl/AX5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 285/529] net: macb: avoid dealing with endianness in macb_set_hwaddr()
Date: Fri, 21 Nov 2025 14:09:44 +0100
Message-ID: <20251121130241.169733638@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 70a5ce8bc94545ba0fb47b2498bfb12de2132f4d ]

bp->dev->dev_addr is of type `unsigned char *`. Casting it to a u32
pointer and dereferencing implies dealing manually with endianness,
which is error-prone.

Replace by calls to get_unaligned_le32|le16() helpers.

This was found using sparse:
   ⟩ make C=2 drivers/net/ethernet/cadence/macb_main.o
   warning: incorrect type in assignment (different base types)
      expected unsigned int [usertype] bottom
      got restricted __le32 [usertype]
   warning: incorrect type in assignment (different base types)
      expected unsigned short [usertype] top
      got restricted __le16 [usertype]
   ...

Reviewed-by: Sean Anderson <sean.anderson@linux.dev>
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250923-macb-fixes-v6-5-772d655cdeb6@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index b836ab2a649a2..7593255e6e53d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -281,9 +281,9 @@ static void macb_set_hwaddr(struct macb *bp)
 	u32 bottom;
 	u16 top;
 
-	bottom = cpu_to_le32(*((u32 *)bp->dev->dev_addr));
+	bottom = get_unaligned_le32(bp->dev->dev_addr);
 	macb_or_gem_writel(bp, SA1B, bottom);
-	top = cpu_to_le16(*((u16 *)(bp->dev->dev_addr + 4)));
+	top = get_unaligned_le16(bp->dev->dev_addr + 4);
 	macb_or_gem_writel(bp, SA1T, top);
 
 	if (gem_has_ptp(bp)) {
-- 
2.51.0



