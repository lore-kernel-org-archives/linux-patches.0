Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 561844DDB40;
	Thu, 17 Sep 2026 15:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659493; cv=none; b=o1lLVMiXJP++8vQQo6g/u8k2UR/6leM4AyQNj9jtQI8uBR7sMdsvRVrwjKoc/i1Pehjlb5okPxAKzcSvZmaHC6xeDXVbZ7NTJal4YPWOB1BYB1uLLjlcAK9CGolFwn5+0PpeYMwDi7sQtOwxw0NrcLwPxZ3FUhN8aFh/HPzZxY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659493; c=relaxed/simple;
	bh=UHb/NpEvzeubx9geMnK6LVpXhRU06vNX9vHLDOX7ShQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f98A2o4n8qGBw2XbeTyCHLVXpGzoAyFwzBcwZuqvel1WiApp0mFWeErnk69fDoGVfGDXu5hKet2xN2f5Ft8rxz8o7rTclGGehzxmD0mPXOHj11nm851sTfdNARQYgDtkWTOiBhlhlYGNAWK3a/B0+n+NLOkm8PMLA+pPpbB2WAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TO3b/dKm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TO3b/dKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26831F0089B;
	Thu, 17 Sep 2026 15:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659484;
	bh=tt1clssWJS7VLVbsVPJpjJ7kYh7/vdoXlfn7TsLAR30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TO3b/dKmO0j1Vrhj5+D+eqwbafsDaAYYOmv8cMsLrAstXIpfQLDtk7UItpstgzIZz
	 zNAEvh6w4FuRHRs1lw898wArW6n6cruX1iNJfztZUw9QE6Bgu5V/nz2m5Pkk1hlcCI
	 +ACPdDJcWjVX9DFW19g/MOwYmiBSPj16MCHcjx/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 272/733] nexthop: Initialize extack in remove_nh_grp_entry()
Date: Thu, 17 Sep 2026 16:09:40 +0100
Message-ID: <20260917151358.125486798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 5bd9e4e7cdaa03879e9b73b12ab52cceb1edd55b ]

remove_nh_grp_entry() prints the extack message when a listener fails
to replace the reduced nexthop group. However, extack is not
initialized and listeners are not required to set a message when
returning an error. Neither netdevsim nor mlxsw do so when an
allocation fails, resulting in the dereference of an uninitialized
stack pointer.

Fix by zero-initializing extack, as was done in commit 6347c5314cee
("nexthop: initialize extack in nh_res_bucket_migrate()").

Fixes: 833a1065eeb1 ("nexthop: Emit a notification when a nexthop group is reduced")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260903080259.10378-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 0f1e21a5c812e..901c353196828 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2029,7 +2029,7 @@ remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
 {
 	struct nh_grp_entry *nhges, *new_nhges;
 	struct nexthop *nhp = nhge->nh_parent;
-	struct netlink_ext_ack extack;
+	struct netlink_ext_ack extack = {};
 	struct nexthop *nh = nhge->nh;
 	struct nh_group *nhg, *newg;
 	int i, j, err;
-- 
2.53.0



