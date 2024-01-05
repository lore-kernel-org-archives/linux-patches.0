Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E59E2D7AD;
	Fri,  5 Jan 2024 14:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWGqxxy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72A5C433C7;
	Fri,  5 Jan 2024 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465646;
	bh=ErgLsLa88B22Ld79oA+OZIhqGg4KrB0gmxW0WM3Y9i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWGqxxy8kit7yUHJIJFdxHEFRUWcCYtbp8Wf/5d78Wo0k3fJYU4wLGbmNGLH69nXy
	 iXG9vpd5zLQ0OOeGAmSa6qgAPV4FmHd0GhMO74pdZsAyc1eIDW2PKNtsgjWVNxqw4T
	 UIvjc0p5HLnjsnTox5vHToWj0WbYxlkPxXiT66XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/41] net: warn if gso_type isnt set for a GSO SKB
Date: Fri,  5 Jan 2024 15:38:57 +0100
Message-ID: <20240105143814.712196018@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143813.957669139@linuxfoundation.org>
References: <20240105143813.957669139@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 1d155dfdf50efc2b0793bce93c06d1a5b23d0877 ]

In bug report [0] a warning in r8169 driver was reported that was
caused by an invalid GSO SKB (gso_type was 0). See [1] for a discussion
about this issue. Still the origin of the invalid GSO SKB isn't clear.

It shouldn't be a network drivers task to check for invalid GSO SKB's.
Also, even if issue [0] can be fixed, we can't be sure that a
similar issue doesn't pop up again at another place.
Therefore let gso_features_check() check for such invalid GSO SKB's.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=209423
[1] https://www.spinics.net/lists/netdev/msg690794.html

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/97c78d21-7f0b-d843-df17-3589f224d2cf@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 24ab059d2ebd ("net: check dev->gso_max_size in gso_features_check()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 0f9214fb36e01..ea05db68aa95a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3200,6 +3200,11 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	if (gso_segs > dev->gso_max_segs)
 		return features & ~NETIF_F_GSO_MASK;
 
+	if (!skb_shinfo(skb)->gso_type) {
+		skb_warn_bad_offload(skb);
+		return features & ~NETIF_F_GSO_MASK;
+	}
+
 	/* Support for GSO partial features requires software
 	 * intervention before we can actually process the packets
 	 * so we need to strip support for any partial features now
-- 
2.43.0



