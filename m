Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F83431A44;
	Wed, 30 Sep 2026 19:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795229; cv=none; b=jaF+oB52g5Hnt7mCneIk701Acslgs95ECUE5bg+xuFvQ+BdFNwnEmtQdVBalgBdsUbyBE5oEbzNMen0saaHkpTAQBIfvcyGPWhd+DO5Exr93Vm/TLSyJdbDs+I809gnc6JUiOY/vViYheYTsclhQ3OwElh9ErIw75QJyY77Cj4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795229; c=relaxed/simple;
	bh=VFP1xdfzoHHmk09t2YAtGWY6BTJvZezVqZmkvZKhZzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZuaO263HqnPnmBzkPegz8t5eR7Yt1bWLWDIt2UaKoR1+bhKQiJEWc+z5TSuShFbmk2+v0R0Is3bqkrxDv95bDkD2WM5qmeGnQk1i3jvoEVIhNXuWUkNdtdZN6KptYWkJa1EJsZMCJLb+Hl8rYKHbAyXOUGkLeayhj8naO894j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMPkAbP6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMPkAbP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A2E1F000FF;
	Wed, 30 Sep 2026 19:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795228;
	bh=hUcdPkKbiLzIbm2OFAGgjNECT4d2hKN1B+y/s9K9cNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UMPkAbP6+WMQJ94bTOtGp5EZ+a/lwTc5bcpqei6hcAKcOwLXlaldUga2Y4xMWrO6s
	 ty9uo3porQUvEhUpsGYJZTPPGFARdFVJEz7i6vyydRn2+xWbaf6c+ZmCM/NT8qYE59
	 gqwiv898eK79WCOXGOFATqa8xvDINcTxhba0pGcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0488/1193] nexthop: Initialize extack in remove_nh_grp_entry()
Date: Wed, 30 Sep 2026 17:19:32 +0200
Message-ID: <20260930152444.995197016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e751464f4fad9..7a00acde974a9 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1759,7 +1759,7 @@ static void remove_nh_grp_entry(struct net *net, struct nh_grp_entry *nhge,
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



