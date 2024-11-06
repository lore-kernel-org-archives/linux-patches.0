Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112331E103C;
	Wed,  6 Nov 2024 12:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896907; cv=none; b=Yn/8vKgeyUyM+1QKYRCgyiJS9KZEBpsbz3tQsc4dAD4YVViBMTRK2OIxSfEeDmEQhZjgG0bZM+aQuyv6QKrBZ5SRqVS1OgZfqWBTsM3KuFF0jYFkzw8aAaSxxOV/aRQcMzi0HxONoXIW+Zka/cqf8eEdcW9mcwtVa7hmJ+QZKgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896907; c=relaxed/simple;
	bh=n74kcTbRRW60wEIO7aDFwFAioc1XBba6rxVe+/Kf28Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cK4GSL6oGr6I1ui2UV8F0A2ae/Yhrt15V+ewAu78JDMcmyKCtiOCXmfpYR+31wYH7QlxcF59p8LJl5BrfmXIMkyW3ggJMnQfIm9Wx7QMOy4EaMYess+uDnJs1iEhAtTMe9BDIYLiWVN2RsnOGOThi9SGKV1lcHpB9q3K8n+7764=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZ0cnA+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZ0cnA+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C826C4CECD;
	Wed,  6 Nov 2024 12:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896906;
	bh=n74kcTbRRW60wEIO7aDFwFAioc1XBba6rxVe+/Kf28Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZ0cnA+BuYd/JlFau6o6I9rU22BKERvb9tGsaQdSZsQKdtPwhE0weybe/QWx9DTEY
	 yjqK9QwPBYdDOzeQhXWBpZ/028iXj07oEfdZTWTi6MBJYCqzqJZ/CZKQwS/aNyBRxJ
	 v6ZVUYziGk/tdp1I7IfUiPVUQGqYJ5erA+nnBNuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexander.duyck@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/110] net: support ip generic csum processing in skb_csum_hwoffload_help
Date: Wed,  6 Nov 2024 13:04:41 +0100
Message-ID: <20241106120305.259960414@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 62fafcd63139920eb25b3fbf154177ce3e6f3232 ]

NETIF_F_IP|IPV6_CSUM feature flag indicates UDP and TCP csum offload
while NETIF_F_HW_CSUM feature flag indicates ip generic csum offload
for HW, which includes not only for TCP/UDP csum, but also for other
protocols' csum like GRE's.

However, in skb_csum_hwoffload_help() it only checks features against
NETIF_F_CSUM_MASK(NETIF_F_HW|IP|IPV6_CSUM). So if it's a non TCP/UDP
packet and the features doesn't support NETIF_F_HW_CSUM, but supports
NETIF_F_IP|IPV6_CSUM only, it would still return 0 and leave the HW
to do csum.

This patch is to support ip generic csum processing by checking
NETIF_F_HW_CSUM for all protocols, and check (NETIF_F_IP_CSUM |
NETIF_F_IPV6_CSUM) only for TCP and UDP.

Note that we're using skb->csum_offset to check if it's a TCP/UDP
proctol, this might be fragile. However, as Alex said, for now we
only have a few L4 protocols that are requesting Tx csum offload,
we'd better fix this until a new protocol comes with a same csum
offset.

v1->v2:
  - not extend skb->csum_not_inet, but use skb->csum_offset to tell
    if it's an UDP/TCP csum packet.
v2->v3:
  - add a note in the changelog, as Willem suggested.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 04c20a9356f2 ("net: skip offload for NETIF_F_IPV6_CSUM if ipv6 header contains extension")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 5edab9328d5e0..6f04bb2ac4932 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3647,7 +3647,18 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 		return !!(features & NETIF_F_SCTP_CRC) ? 0 :
 			skb_crc32c_csum_help(skb);
 
-	return !!(features & NETIF_F_CSUM_MASK) ? 0 : skb_checksum_help(skb);
+	if (features & NETIF_F_HW_CSUM)
+		return 0;
+
+	if (features & (NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM)) {
+		switch (skb->csum_offset) {
+		case offsetof(struct tcphdr, check):
+		case offsetof(struct udphdr, check):
+			return 0;
+		}
+	}
+
+	return skb_checksum_help(skb);
 }
 EXPORT_SYMBOL(skb_csum_hwoffload_help);
 
-- 
2.43.0



