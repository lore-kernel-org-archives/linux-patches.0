Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7294A4ABBDB;
	Thu, 17 Sep 2026 17:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667632; cv=none; b=u99i+6exNc7eHc0N+nfSnRss1HaXxB+mdZPx/BzKzQBQtkO0Ujo51UoJsFsTbbzczuQ6EGbGmLer16X5qijCqlsZ4bpUxKVuY6bUtW3H9Bxd4aRLcrfKAxr5dX0d90shu83MZkCwY0y4Q7GtD/0kiIyewwjG5KGDTtmSvYZkTmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667632; c=relaxed/simple;
	bh=sZWWWMbgtluVEToHfTNRn6r3VLlFcxtM57YfWLzzWUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S7EFqXBs9abGHn79Kq7gGolc42G7uiKxieydyUNeMd6bmoHpqqrYA/43SNbRA/S4JEAxz5jgZYMGCC/mkyj7jE61n67WI2Q3VgW4dYEgHQQHHmXmnq2ZiqRZ3ZwyPb53eixWCaqPWGvv9uBkkWYhJGzr2TlYd5Uy6NU2vzx5WnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLMdRYgb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLMdRYgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CDF1F00893;
	Thu, 17 Sep 2026 17:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667631;
	bh=LiTt1Fa5F110bRKN0y+3sgrQ9RNT2UFACM4KgfkYs40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aLMdRYgbfp3NQJkoaWYbYWPAV6hY/o4ockh/HT/zkYjcZwYJ59/GvOUm8JKiGwtkY
	 r0yGwylJPfZV8rX+kn4udLplesPsUhahD74b2ctdwNlAq04DAZkORlGTHZjeCic3fR
	 0ZWNUIMkPAfxGM1LPVhspbXgmjjFTuygBWCxe5tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Stelmach?= <steelman@post.pl>,
	Ido Schimmel <idosch@nvidia.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0156/1102] ipv6: addrconf: fix temp address generation after prefix deprecation
Date: Thu, 17 Sep 2026 16:01:39 +0100
Message-ID: <20260917151543.449202496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit e20d8922aa8fe441d291364c96c2179a005b79ea ]

When a router temporarily deprecates an IPv6 prefix (either by sending a
Router Advertisement with Preferred Lifetime = 0 or by letting the
lifetime expire) and later restores it, the kernel permanently loses its
ability to generate temporary privacy addresses (RFC 8981) for that
prefix.

This happens because the address worker attempts to generate a
replacement temporary address when the current one nears expiration. As
the base prefix is deprecated already, the generation fails after
marking the temporary address as already having spawned a replacement
(ifp->regen_count++).

When the router eventually restores the prefix, the temporary address
becomes active again. However, once it naturally expires, the address
worker sees this temporary address already tried to generate one and
skips the regeneration.

Fix the issue by resetting the regen_count check of the latest temp
address generated for the prefix updated by the incoming RA.

Reported-by: Łukasz Stelmach <steelman@post.pl>
Closes: https://lore.kernel.org/netdev/87340td30q.fsf%25steelman@post.pl/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260523103811.3790-1-fmancera@suse.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 9fe7851029e25..ef938fb1d7549 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1173,6 +1173,7 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	ipv6_link_dev_addr(idev, ifa);
 
 	if (ifa->flags&IFA_F_TEMPORARY) {
+		/* manage_tempaddrs() relies on addresses being added to the head */
 		list_add(&ifa->tmp_list, &idev->tempaddr_list);
 		in6_ifa_hold(ifa);
 	}
@@ -2606,8 +2607,10 @@ static void manage_tempaddrs(struct inet6_dev *idev,
 			     __u32 valid_lft, __u32 prefered_lft,
 			     bool create, unsigned long now)
 {
-	u32 flags;
+	u32 orig_prefered_lft = prefered_lft;
 	struct inet6_ifaddr *ift;
+	bool reset_done = false;
+	u32 flags;
 
 	read_lock_bh(&idev->lock);
 	/* update all temporary addresses in the list */
@@ -2642,6 +2645,11 @@ static void manage_tempaddrs(struct inet6_dev *idev,
 			prefered_lft = max_prefered;
 
 		spin_lock(&ift->lock);
+		/* the first match is the most recent temp address */
+		if (!reset_done && orig_prefered_lft > 0) {
+			ift->regen_count = 0;
+			reset_done = true;
+		}
 		flags = ift->flags;
 		ift->valid_lft = valid_lft;
 		ift->prefered_lft = prefered_lft;
-- 
2.53.0



