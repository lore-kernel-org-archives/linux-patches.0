Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36A5503BF7;
	Wed, 30 Sep 2026 16:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784278; cv=none; b=mf7DopVl+cb+tIyIIAbfcAD+KtpibFJTPsb+eAQC+hEps4WHtnGW4rWHFp4YEg08CLJ0hlacONdHXYs7+88K+3N/ywKvAbWHNCTd539UzjiwzlDwqqxCQO+amCtICfhp6Kf7c3gVH8haU3JWNS0q13tx6YBr6O5ovsB0GyCM+aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784278; c=relaxed/simple;
	bh=BOptDMojWr/M12iIGEp1P9GlwLFBeFgl4XQ6OnLxKrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SZ9af+CCOM9HFbsVfJSF0ux9bUKEevakSEVZgmOwTsBM3XrMZN7lGgiwvLNNgv7fmrbLcKFyWqGLqRqVKR0mx5lP26JX8W+/2sg4maBb9faicB9YofElkU9+UHm4BE0eNu/1yDAq++EMvFlKKp3m7bAVabm+fZb86IOCK2m8oxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxcPsLrX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxcPsLrX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64E81F00898;
	Wed, 30 Sep 2026 16:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784272;
	bh=S8slSa4ZmZCSP4cUuHwzOM1kKlDywUvEpxjFnE07Ruw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxcPsLrXYX0iO9iEf4ZNCxs6u5Ea74D3h+KYTy4f3aV/dVRPYsyRGGw407XAbe51y
	 oFMq3/CDVZDHbAqXOSCR8i6VVKUBXEXbSHXy/t9gB3FHVN68eilikofsSs++U+PzX9
	 sH9f0/Uml/9RTIjOVPWx/yz8dnjzKQU0n/zYdFXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Stelmach?= <steelman@post.pl>,
	Ido Schimmel <idosch@nvidia.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/982] ipv6: addrconf: fix temp address generation after prefix deprecation
Date: Wed, 30 Sep 2026 17:13:53 +0200
Message-ID: <20260930152418.894780858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9fe1f67ceacd4..849ed409f74fc 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1169,6 +1169,7 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	ipv6_link_dev_addr(idev, ifa);
 
 	if (ifa->flags&IFA_F_TEMPORARY) {
+		/* manage_tempaddrs() relies on addresses being added to the head */
 		list_add(&ifa->tmp_list, &idev->tempaddr_list);
 		in6_ifa_hold(ifa);
 	}
@@ -2556,8 +2557,10 @@ static void manage_tempaddrs(struct inet6_dev *idev,
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
@@ -2592,6 +2595,11 @@ static void manage_tempaddrs(struct inet6_dev *idev,
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



