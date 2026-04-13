Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49446317152;
	Mon, 13 Apr 2026 16:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099261; cv=none; b=Qr+u/EMBYaTv1w0TMmMk/1VUiJW5gjhTfffzIFSntyg6jmLyB+HuTiLoA6inEg8YqbTLHMgtJZ96x1E9kZHTTQCr8Y01VImsdY7MTN5ZJF1GJrCp06xiDApM43LIpHR88VPGNDwLXvgYUTPXx3WhIZj87Pf6wQgOGhGHB7cnCv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099261; c=relaxed/simple;
	bh=buMepbAQIySVoHuRlGP3GIiSktuYvjn12Y06G6ftfuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fsrZNZhl42K00f7cY3/cpy1D+TlAhgmnjFm8uXbsds57ast9X95Fo+LP9rnCJrgpiCkak73/eh5LOTsGFTLs1ii6WgP0Ks3ke1pS4YRR+yJSR/FG1Wp2x/50XQHrA3yUfEgiBAonoqTx8EAVobQk/2Dqs85q/jffI2uiCIXzQ9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QD8bPBoA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QD8bPBoA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CD0C2BCAF;
	Mon, 13 Apr 2026 16:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099261;
	bh=buMepbAQIySVoHuRlGP3GIiSktuYvjn12Y06G6ftfuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QD8bPBoAVUISOi4QGIoNJft5ZZlES3l7pbk1QsRZHSlx1ZRNcV5OMDUVCqfcJyjNq
	 +4nY1Gn0wl4xXSrYWbbRGj0BYChqhcSpiuxWngUkJqh/pA69DFk5okMVREC7f5cHFo
	 uMZfzpx7qA3iJwUQNGMfwDZ3Ac6N93KIWjIdGPJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 272/491] netfilter: nft_payload: reject out-of-range attributes via policy
Date: Mon, 13 Apr 2026 17:58:37 +0200
Message-ID: <20260413155829.232476061@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e7af210e6dd0de633d3f4850383310cf57473bc8 ]

Now that nla_policy allows range checks for bigendian data make use of
this to reject such attributes.  At this time, reject happens later
from the init or select_ops callbacks, but its prone to errors.

In the future, new attributes can be handled via NLA_POLICY_MAX_BE
and exiting ones can be converted one by one.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 8f15b5071b45 ("netfilter: ctnetlink: use netlink policy range checks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_payload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index f607cd7f203ad..f59ad5fb42575 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -119,10 +119,10 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
 	[NFTA_PAYLOAD_SREG]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_DREG]		= { .type = NLA_U32 },
 	[NFTA_PAYLOAD_BASE]		= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_OFFSET]		= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_LEN]		= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_OFFSET]		= NLA_POLICY_MAX_BE(NLA_U32, 255),
+	[NFTA_PAYLOAD_LEN]		= NLA_POLICY_MAX_BE(NLA_U32, 255),
 	[NFTA_PAYLOAD_CSUM_TYPE]	= { .type = NLA_U32 },
-	[NFTA_PAYLOAD_CSUM_OFFSET]	= { .type = NLA_U32 },
+	[NFTA_PAYLOAD_CSUM_OFFSET]	= NLA_POLICY_MAX_BE(NLA_U32, 255),
 	[NFTA_PAYLOAD_CSUM_FLAGS]	= { .type = NLA_U32 },
 };
 
-- 
2.51.0



