Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58F22F25F7;
	Mon,  1 Dec 2025 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588589; cv=none; b=Hr1+YICZ/cindz+8rAn/PScsTV+zcWvHanxGlkaXfuDJikoFLt5ab+5slPIvKiGhmU4cHEk++MbVbUTJx0qOIQkxY/srPQsuRTsSoCqTh8i34akr6uP7F5tS55aRfwMbvw+cqjcFYuqGvECZVQRDy2pb/JOnjPvIclgGjAfXHeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588589; c=relaxed/simple;
	bh=fupo/qwLBjuKzsNKcy+bFgGkZs4LBzzUUwmpYiycbvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EHJ5SnFE9hRPb/K1O11p44Knahutv+SQBVdAD1X0OsNHNPw45pYrmu/5rhsJciWt3y/pWEjG4IRQ40Hw6e1vxFHzNnyeKBCZejwZXKbnOzLis/uAva5SYhXr4l1RdYiQ9xzKAOZ5f9xz+UII05dm0HXGmDOpG5v4VAiJCijxPnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bYOD7xr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bYOD7xr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023B7C113D0;
	Mon,  1 Dec 2025 11:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588589;
	bh=fupo/qwLBjuKzsNKcy+bFgGkZs4LBzzUUwmpYiycbvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYOD7xr2wU7KTovA7SqwOUfnucQn1waawePB6QOeUPPyhrHrcnNkalOoTTlQiLrza
	 At//A2myCo3iHCMldOGFQhFzbxe5mauZQo6XDBeh+fpUq7940xCHyVCsOTnsuSytgx
	 HjLZguQipthOEy22dxdtRcVO16sl2yP0rKSHhrqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/187] net: macb: avoid dealing with endianness in macb_set_hwaddr()
Date: Mon,  1 Dec 2025 12:23:29 +0100
Message-ID: <20251201112244.887447154@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a635c9af26c3e..873b0acecd1bf 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -277,9 +277,9 @@ static void macb_set_hwaddr(struct macb *bp)
 	u32 bottom;
 	u16 top;
 
-	bottom = cpu_to_le32(*((u32 *)bp->dev->dev_addr));
+	bottom = get_unaligned_le32(bp->dev->dev_addr);
 	macb_or_gem_writel(bp, SA1B, bottom);
-	top = cpu_to_le16(*((u16 *)(bp->dev->dev_addr + 4)));
+	top = get_unaligned_le16(bp->dev->dev_addr + 4);
 	macb_or_gem_writel(bp, SA1T, top);
 
 	/* Clear unused address register sets */
-- 
2.51.0



