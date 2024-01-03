Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5171BDF1;
	Wed,  3 Jan 2024 17:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lca/8V25"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8729C433C7;
	Wed,  3 Jan 2024 17:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301741;
	bh=m7Rt070RwdndxNoJnGlxfernv2QtdcQk3Yw+fCR7oQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lca/8V25a7+4ULScbi6Ulf0Miz0JNIC0QYLDFWMugFQ9sI9lLABytMfpkjlXoftj9
	 kGD2jP57ggb5/ktTazebrbLrMGj0yiME3y9dgpZc5/A0TrsfXOUC9sKVQ0CpnNF94l
	 nmtj/KcPw2OqFJotuuaTuUrGe7xgpoI2t7onfnDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/75] net: warn if gso_type isnt set for a GSO SKB
Date: Wed,  3 Jan 2024 17:54:58 +0100
Message-ID: <20240103164845.836656166@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3fc27b52bf429..34f80946d2c72 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3523,6 +3523,11 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
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



