Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4579517E90E;
	Mon, 27 May 2024 19:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836969; cv=none; b=U3MEnPxKRbHsYnavReBtE9fPdeGRfj8gHfu5QLEPVnVxpvx3FXnqkiqnR+Dt3jOMEyeCS3EDH8ZHTKYqVx/PO7Kkkkg4LZUqhsYnzkZ212Om9RvEtx2LPzWOtTCQpKsQjwSWszjSdGcGY1YBPGW6iv7z2i83rwmLhEzGKmI9BLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836969; c=relaxed/simple;
	bh=HFBnGmgT2X+uNRMdO5KYYcOCMj7b/c/5+dXAWUEYgdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2Z7U/LIudYkr0f8dqjz7UH7jkyxTaY8u/1dJBq6RdjOVYKmwa9G7ZZS1EEhQjeY3+S4tyualxoDaEZ6ZfZHDFNCqMyYRYqqXI0qb8Scr8eKVF4o1faiTp9ft8O4odNq/0Pmplbt+G6ApzNjznuhhVsPLseMDXbP6fdvzZppNr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hq2bCe3E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hq2bCe3E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEFFC2BBFC;
	Mon, 27 May 2024 19:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836969;
	bh=HFBnGmgT2X+uNRMdO5KYYcOCMj7b/c/5+dXAWUEYgdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hq2bCe3EDm3eOQ51CW0x7xE1ipjRh/+0bnI4Ts3H1t9cVy6lt64RYiZ+7bYrXuuUi
	 O0rCnX+A3IQiHH0t1tERLaYWvdMY0TRRs0XjUyAj2S0uaJ3ZXkkhp+Id9naV0vdbmj
	 8YAKK3+UTqeAd0x4plqXSgmmCMSeArUHJwGum9aY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Watanabe <watanabe.yu@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 258/427] inet: fix inet_fill_ifaddr() flags truncation
Date: Mon, 27 May 2024 20:55:05 +0200
Message-ID: <20240527185626.544529700@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1af7f88af269c4e06a4dc3bc920ff6cdf7471124 ]

I missed that (struct ifaddrmsg)->ifa_flags was only 8bits,
while (struct in_ifaddr)->ifa_flags is 32bits.

Use a temporary 32bit variable as I did in set_ifa_lifetime()
and check_lifetime().

Fixes: 3ddc2231c810 ("inet: annotate data-races around ifa->ifa_flags")
Reported-by: Yu Watanabe <watanabe.yu@gmail.com>
Dianosed-by: Yu Watanabe <watanabe.yu@gmail.com>
Closes: https://github.com/systemd/systemd/pull/32666#issuecomment-2103977928
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240510072932.2678952-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/devinet.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 7a437f0d41905..7e45c34c8340a 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -1683,6 +1683,7 @@ static int inet_fill_ifaddr(struct sk_buff *skb, const struct in_ifaddr *ifa,
 	struct nlmsghdr  *nlh;
 	unsigned long tstamp;
 	u32 preferred, valid;
+	u32 flags;
 
 	nlh = nlmsg_put(skb, args->portid, args->seq, args->event, sizeof(*ifm),
 			args->flags);
@@ -1692,7 +1693,13 @@ static int inet_fill_ifaddr(struct sk_buff *skb, const struct in_ifaddr *ifa,
 	ifm = nlmsg_data(nlh);
 	ifm->ifa_family = AF_INET;
 	ifm->ifa_prefixlen = ifa->ifa_prefixlen;
-	ifm->ifa_flags = READ_ONCE(ifa->ifa_flags);
+
+	flags = READ_ONCE(ifa->ifa_flags);
+	/* Warning : ifm->ifa_flags is an __u8, it holds only 8 bits.
+	 * The 32bit value is given in IFA_FLAGS attribute.
+	 */
+	ifm->ifa_flags = (__u8)flags;
+
 	ifm->ifa_scope = ifa->ifa_scope;
 	ifm->ifa_index = ifa->ifa_dev->dev->ifindex;
 
@@ -1701,7 +1708,7 @@ static int inet_fill_ifaddr(struct sk_buff *skb, const struct in_ifaddr *ifa,
 		goto nla_put_failure;
 
 	tstamp = READ_ONCE(ifa->ifa_tstamp);
-	if (!(ifm->ifa_flags & IFA_F_PERMANENT)) {
+	if (!(flags & IFA_F_PERMANENT)) {
 		preferred = READ_ONCE(ifa->ifa_preferred_lft);
 		valid = READ_ONCE(ifa->ifa_valid_lft);
 		if (preferred != INFINITY_LIFE_TIME) {
@@ -1732,7 +1739,7 @@ static int inet_fill_ifaddr(struct sk_buff *skb, const struct in_ifaddr *ifa,
 	     nla_put_string(skb, IFA_LABEL, ifa->ifa_label)) ||
 	    (ifa->ifa_proto &&
 	     nla_put_u8(skb, IFA_PROTO, ifa->ifa_proto)) ||
-	    nla_put_u32(skb, IFA_FLAGS, ifm->ifa_flags) ||
+	    nla_put_u32(skb, IFA_FLAGS, flags) ||
 	    (ifa->ifa_rt_priority &&
 	     nla_put_u32(skb, IFA_RT_PRIORITY, ifa->ifa_rt_priority)) ||
 	    put_cacheinfo(skb, READ_ONCE(ifa->ifa_cstamp), tstamp,
-- 
2.43.0



