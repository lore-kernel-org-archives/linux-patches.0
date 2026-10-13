Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2360D3AE18C;
	Tue, 13 Oct 2026 11:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891951; cv=none; b=Wk1hlMB+1Uxq1q+1Y/U5EMhdjCQvZHnwG11Qu6y8FUWP/oWGL6Q8PwHViSwLgGx85/YF4PxP1CU44m8U2lWvE+t/kqD4bDshQTEBFgs1j9Naxr6dYeaKA7wjN6xNuJ898Ri+76JW9+7bM+xXN+5SBdQ5jao9yKEjTqnvKMPefyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891951; c=relaxed/simple;
	bh=p0U5kt0r6cigH0Ln32GuT5E4HXvqe3P2hfFANNZZXYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4Uhafn+VrABlmpEC8a89g8zXK2cTc0pnUTzPx5jJh1Pfidk3xSJLWwMCWVD7aw2bg2dgxiAGXHN5v6JmQBKFxP2ONgJ9gHX7mE1sK0cUxuxQGdKbqwDtdSbVEDncxU3tP6zrf60fJZhuIoNiA8eEnaAdCejAbwRio8M0tW2sfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gp8NgXND; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gp8NgXND"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E94C1F000FF;
	Tue, 13 Oct 2026 11:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891949;
	bh=rBN80ZY+8G2cobma/WAQq3BVhQUNeLPb5JYBI94tMJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gp8NgXNDD5B6//GdTHkde0iU0FoAavP4hpXp8WRQY0MbWVicYSJNdS8OdCmp2kKtv
	 MwHmuIbCRvYdqQNy+qGyAwXYTEKWPipiX8EI5KUZwE0d0nPfcI+DvLBN67oA7h0hlT
	 hZLSPi/2q8GEQ0DrZkpPHok2i0x7niXf6yX+f5Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 011/281] ipv4: stop exception dump when nexthop group shrinks
Date: Tue, 13 Oct 2026 13:35:27 +0200
Message-ID: <20261013112855.323783402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit 4f4afc07dcb2edd4f9afa36595373f8cdb9b58c2 upstream.

Commit 4ce5dc9316de ("inet: switch inet_dump_fib() to RCU
protection") allowed IPv4 FIB dumps to run concurrently with nexthop
replacement.

fib_dump_info_fnhe() uses fib_info_num_path() as the loop bound,
then fib_info_nhc() independently reloads nh->nh_grp. If
RTM_NEWNEXTHOP replaces a group with fewer paths between those loads,
fib_info_nhc() returns NULL and the dump dereferences it through
nhc_flags.

Stop the walk when the indexed path is absent. Nexthop groups are
dense, so the current snapshot has no later path.

Fixes: 4ce5dc9316de ("inet: switch inet_dump_fib() to RCU protection")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261001170513.GA1657889@shredder/
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/5bb7bd97411eb9db454464bf449107395e760f26.1790915964.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -3165,6 +3165,9 @@ int fib_dump_info_fnhe(struct sk_buff *s
 		struct fnhe_hash_bucket *bucket;
 		int err;
 
+		if (!nhc)
+			break;
+
 		if (nhc->nhc_flags & RTNH_F_DEAD)
 			continue;
 


