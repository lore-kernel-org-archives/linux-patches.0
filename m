Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26363F7887;
	Tue, 31 Mar 2026 16:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974984; cv=none; b=PnZ81/4JAHFsDyNR/GJ4C3USr4IXCGldQCTX18XozhRz0HzaO1yHwIHaL8vfoDn2TagX27Z6YS7km0JBqGXlcB0IMgEfwZKmAXk198YDLjnEK/E7Ojq4QOH43RPehCWk+vLgjzM/xInvNZKLkYrGJhCCFwzogp+k1Xi3BtGVK7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974984; c=relaxed/simple;
	bh=JHkSdINmPzONNtAlHwQoMeUy9ObOj9BgKerntu9LqDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bwMcWmyEZkdT2dn6s82hoVgFAI7NAlH8mur73yP7RDugfeqY1sicao/ftClzGJchns9IIQ8NFSSLVM2TV01yXreNh1/Vbc6xKPx/5hQXdn+vgxVaajFTARS+33IJnir9V+UKrBsoRlk+AyR7YXMbhMCS6jmOQ3F2Ccqr4Mg7OB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H7PRJOg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H7PRJOg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C3FC19423;
	Tue, 31 Mar 2026 16:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974984;
	bh=JHkSdINmPzONNtAlHwQoMeUy9ObOj9BgKerntu9LqDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H7PRJOg1bc16ReQbI6jqiO+ZeMnuW+Ei6Y2HgeQo2fydH7+ps0NZ/ApIql1pZAsEl
	 jYxRfvoyp63WiRPakseMhGsfHJABtVw0fDDo2PWJqTBnRY47d+23LzfyLSP26GJYHM
	 u3I5I4JPFpJXEIrKfFA/xQRcKs0A00vuUIlO8Lso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 118/342] ipv6: Remove permanent routes from tb6_gc_hlist when all exceptions expire.
Date: Tue, 31 Mar 2026 18:19:11 +0200
Message-ID: <20260331161803.352610245@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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



