Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC89D2D9ECD;
	Mon, 13 Apr 2026 16:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098045; cv=none; b=bBNHFMvLNmw30CbpyiYys0HEU6cWZ3q86PPuv+cCAlNGGieFwUVKvtouGQi6fc74DQw+LDESQ2WYrXw98tMtU6fytMAkyfyQZsu9eLEEa2+Nbt7qO0LyqSv4ltnVg3Mj72GaO6+mqeNaVN2DRzG7iqDl/mctZlEbfm5R7r3e4LE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098045; c=relaxed/simple;
	bh=QvOjFSHnYksDSay1ygaCQwwzALX21YsmszJg+xRTvg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxT6XclMwQtC6l4aJWvAtuHgw3cjEvPpGDNRKjvnO1YbKouLWjbeZBo4vejztx14Citaxsek5PCuVR0yUimy2xYTQGtn58xVmOGomIkK3P35LW5eeLYQU2hlLVss6mpc24XEySIu2TINIT9/a948bQE6erJHwZfBugRWDxA1IFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a/SqDKUi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a/SqDKUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62831C2BCAF;
	Mon, 13 Apr 2026 16:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098045;
	bh=QvOjFSHnYksDSay1ygaCQwwzALX21YsmszJg+xRTvg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a/SqDKUiczqflROkxisahzROsqpuXRDkDaFZRgSVEWvi/+FhvzFkGdN8AU/t82kWr
	 4bsz4/fCmEC6NllbXIaIvyZdwm1x+BKBnh5WtcNUiO91XT/f9CF4oNsBQBgpQAo5CK
	 2P2W7JtjrHdulY9iapLUZP14gYDi1HGOKjFglgVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 339/570] netfilter: nft_payload: reject out-of-range attributes via policy
Date: Mon, 13 Apr 2026 17:57:50 +0200
Message-ID: <20260413155843.192135696@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
index 49a1cf53064fe..cb6ee00bbc09b 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -176,10 +176,10 @@ static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
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



