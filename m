Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D033386441;
	Wed, 23 Sep 2026 14:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174454; cv=none; b=KcdLUrqhmvSALcOq5+z2t5dX1bmoWs7tmKGXA8GYYCaveg4m0WEbJmPGtOzT9ImcM4BVfZNFm6Rn/Pn0eWjnWlqPTCG9jgXCkl+fUzFu2e07mzcc72zHiypsoagb5a1zSahImK8dMALKDmuhIXxTs4XUaeCoXl8YHb3nOWNPxRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174454; c=relaxed/simple;
	bh=PTuIrYvhkxToiQ6pgv5AMNc0UzZGZVDjAH67xC3+48A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ilyMP0TlrtKE2SUeVqmSaTA0x7GVBgVdtcCfh0HTXGAfXj38KFD6yEXrW/FOPJ7E+A/QC9M4lZOpew8EkgUJK27f7CEXySn0tmmdhSm4P/+B127bSJw31x1NrbcVtqZd1VxSvIcGOfnCjY9nSevOo3ckQWJNYwbGzTWP3U6mm0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07uhlpOy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07uhlpOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769191F00899;
	Wed, 23 Sep 2026 14:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174453;
	bh=1KggqFKhpwxSX+eYZ3ZlrKOZEK1dDhCkerxB8Nnx5Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=07uhlpOyJKc35wUud47GVsEi7evJWbdJ+H8b4CGSRfPwqHG3e7TQaWAOpMtASIO/9
	 qZ74O4Me3rp5W544ptmHtMxEgklHHY/FV4kQ50bn7CXpNelT8naO1sL0HKmwVReIqt
	 mIwkRd2IuI3Wvbv2Lf2GmayFWbXnAAxIHMeZXn/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/398] neighbour: Add missing RCU annotation for neightbl_dump_info().
Date: Wed, 23 Sep 2026 16:02:56 +0200
Message-ID: <20260923140646.083450196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 764dcebb033764633700a036c7351a7c6350eec6 ]

neightbl_dump_info() fetches the first non-default neigh_parms
with list_next_entry(&tbl->parms, ...) and iterates through the
list with list_for_each_entry_from_rcu().

However, list_next_entry() does not use RCU helper.

Let's use list_for_each_entry_rcu() and skip the default parms.

Fixes: 4ae34be50064 ("neighbour: Convert RTM_GETNEIGHTBL to RCU.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260909233143.2401847-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 979aabdad8dd ("neighbour: Skip default parms when resumed in neightbl_dump_info().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 9873fc08b7494..d51899b011ddd 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2596,11 +2596,14 @@ static int neightbl_dump_info(struct sk_buff *skb, struct netlink_callback *cb)
 			break;
 
 		nidx = 0;
-		p = list_next_entry(&tbl->parms, list);
-		list_for_each_entry_from_rcu(p, &tbl->parms_list, list) {
+
+		list_for_each_entry_rcu(p, &tbl->parms_list, list) {
 			if (!net_eq(neigh_parms_net(p), net))
 				continue;
 
+			if (!p->dev)
+				continue;
+
 			if (nidx < neigh_skip)
 				goto next;
 
-- 
2.53.0



