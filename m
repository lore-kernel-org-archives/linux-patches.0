Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F032D949C;
	Tue, 31 Mar 2026 17:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976474; cv=none; b=JUAdQ1FExHpOztqzoGkW1UWAFxz4sr2QdIMR138WsUe6WYBDZSdY+I9/7wXGGINNtgw5cC3CQ5KdjQq7WVcv+5QI1zs5pYsXHMSjEkD1JYzjZ+39mvKBUMKBOZXcbACk8O4WVsqB87ff+iZDBMBiRmtsKKqBGuQ9q96atwENZUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976474; c=relaxed/simple;
	bh=l7syAgKfmWLriSb4nRfSejvU1qOlGiFa3OZ10cXc9nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPKkZqnLcnl0Xbh/4cY/7/6ww05so+J7XEeVsaE0bbYYlao5gQhHZ147RRpJido+ZCfDRdmQ0cH4nFMjQpJGn3rV/9udcWVgxwtoov4vj/Bn8wjIjyN2jO+vayS9g9wYoFG5Kb35l6idvYJoz8EC/VlE5HbB5Bos6S2gFpNepBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qv4IaOH3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qv4IaOH3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17053C19423;
	Tue, 31 Mar 2026 17:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976474;
	bh=l7syAgKfmWLriSb4nRfSejvU1qOlGiFa3OZ10cXc9nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qv4IaOH3Ez5VyNcHfIKbKCnDrUeDdICKdzz1ociCIcus3VqJTsEwuNKpkFjs8CwPk
	 ghar7YPbJW69DBlyhiaz7Eh6B8RS5docYzW2N76xY6k6sP7r38JYJRUbhUPTRUNFCG
	 VO8+eOMpzWtpGrO/2iN5z1vf8le8KBmvWkurm4XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/309] ipv6: Remove permanent routes from tb6_gc_hlist when all exceptions expire.
Date: Tue, 31 Mar 2026 18:20:10 +0200
Message-ID: <20260331161757.425076900@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

[ Upstream commit 6af51e9f31336632263c4680b2a3712295103e1f ]

Commit 5eb902b8e719 ("net/ipv6: Remove expired routes with a
separated list of routes.") introduced a per-table GC list and
changed GC to iterate over that list instead of traversing
the entire route table.

However, it forgot to add permanent routes to tb6_gc_hlist
when exception routes are added.

Commit cfe82469a00f ("ipv6: add exception routes to GC list
in rt6_insert_exception") fixed that issue but introduced
another one.

Even after all exception routes expire, the permanent routes
remain in tb6_gc_hlist, potentially negating the performance
benefits intended by the initial change.

Let's count gc_args->more before and after rt6_age_exceptions()
and remove the permanent route when the delta is 0.

Note that the next patch will reuse fib6_age_exceptions().

Fixes: cfe82469a00f ("ipv6: add exception routes to GC list in rt6_insert_exception")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260320072317.2561779-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index cc149227b49f4..a22af1c8f93ac 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -2348,6 +2348,17 @@ static void fib6_flush_trees(struct net *net)
 /*
  *	Garbage collection
  */
+static void fib6_age_exceptions(struct fib6_info *rt, struct fib6_gc_args *gc_args,
+				unsigned long now)
+{
+	bool may_expire = rt->fib6_flags & RTF_EXPIRES && rt->expires;
+	int old_more = gc_args->more;
+
+	rt6_age_exceptions(rt, gc_args, now);
+
+	if (!may_expire && old_more == gc_args->more)
+		fib6_remove_gc_list(rt);
+}
 
 static int fib6_age(struct fib6_info *rt, struct fib6_gc_args *gc_args)
 {
@@ -2370,7 +2381,7 @@ static int fib6_age(struct fib6_info *rt, struct fib6_gc_args *gc_args)
 	 *	Note, that clones are aged out
 	 *	only if they are not in use now.
 	 */
-	rt6_age_exceptions(rt, gc_args, now);
+	fib6_age_exceptions(rt, gc_args, now);
 
 	return 0;
 }
-- 
2.51.0



