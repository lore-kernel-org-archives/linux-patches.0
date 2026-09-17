Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69E13A5E6F;
	Thu, 17 Sep 2026 16:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664006; cv=none; b=AEUZIBzO39tNBsUxrZHgdhGSamAxMYaH1hRJGhAokdhP/8UxtiWUBVC6Ah5MtxQz1XgNDD/BAlvTPp7AUOvVuHxWTGhGhuM8xBC/2saq4L1CX/zjKLOlJWrCwlIN/QZcZi8TNo9XGX/rFULdlUanTqAguXI5nSb4gl2NN0vNhpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664006; c=relaxed/simple;
	bh=hoVnLax9QdNcZ7wWj/aCGLLZh1zrlqwqT6w3DFrDMJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O3+uwdjWPzZAZr+UDMI68JKwVWdXgzpMI5GFW3vzBP/hzW3YV0AYfR4G7pE/VQp+vviEqivkKRwkNgoDXHP0fzpoWrWgu+A/BnhZX99uyZYLrTp0+uDhQZVA8Ctipj0aHDbAREUR8dsts0A/qIxKyfuWobH82DwIIYVuGZRZBYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0457Q9G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0457Q9G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAD21F000FF;
	Thu, 17 Sep 2026 16:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664004;
	bh=6y1/n7WQusQ518ZWxjDpoSNp4o3Z7rKZay7jacCEidg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t0457Q9GnC7b0o4EGm/RYyiB7Q3psUW6FaFAvGcvrA+jaTmfPOsIoMpmtdXVSMvqK
	 NwbaKKyy3Yyz2o7ozxv8+0FLdvvkzC5gg70EQxA8hITlfoCVDxqoyFySJxqEtQ0IFI
	 dveG4p0YYAu+qF2YKmFnmZwf0tkK/gHw/3MkYE6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C5=81ukasz=20Stelmach?= <steelman@post.pl>,
	Ido Schimmel <idosch@nvidia.com>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0228/1250] ipv6: addrconf: fix temp address generation after prefix deprecation
Date: Thu, 17 Sep 2026 16:00:23 +0100
Message-ID: <20260917151558.319964721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c98b1b919f18c..80706368a303c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1180,6 +1180,7 @@ ipv6_add_addr(struct inet6_dev *idev, struct ifa6_config *cfg,
 	ipv6_link_dev_addr(idev, ifa);
 
 	if (ifa->flags&IFA_F_TEMPORARY) {
+		/* manage_tempaddrs() relies on addresses being added to the head */
 		list_add(&ifa->tmp_list, &idev->tempaddr_list);
 		in6_ifa_hold(ifa);
 	}
@@ -2610,8 +2611,10 @@ static void manage_tempaddrs(struct inet6_dev *idev,
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
@@ -2646,6 +2649,11 @@ static void manage_tempaddrs(struct inet6_dev *idev,
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



