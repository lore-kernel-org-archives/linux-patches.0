Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828622836BE;
	Wed, 23 Apr 2025 14:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419642; cv=none; b=AN3N9+d7v+THFr8NbNvJ/3I2tLQDOTyo+ad1sG9wvAf5hUe051YFPQ17vNkTu0i0+Hv6EIRI4QrHpvMcq3GNcyBPI2m7k1cjQot913NQw9ntf0ygBL03Vgjlywp2lWG2l8vULEajKMcUrPto9BzkiPyiffqe4uLVvIT+xaKD8oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419642; c=relaxed/simple;
	bh=XGPlDipsWdU9/U8KNNZJXsPYK7CwPiFKv8Z//sBqlCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGz3bt79RlHGzX2zaepTMxDOaGB4+5F+C0W7fOhHKOY9FsKcw4mAeVAA4yW5y6TvewHRBaU6UOqTMoxY6N6Q2pBeRoUKPekGlPdSkneXaj3++Avf0GKtogR9fzOivd8XJIiGJleIMmJh7F9jscGnoWA/BtX2M2MUpT2/arYiGjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHTwIjp5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHTwIjp5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3BD7C4CEE3;
	Wed, 23 Apr 2025 14:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419642;
	bh=XGPlDipsWdU9/U8KNNZJXsPYK7CwPiFKv8Z//sBqlCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHTwIjp576bDvi7UQmrYqSUNe7sc7qbvKhLLTiQymE428tWt7uYm4FsvgokYwUQXj
	 +XfkAhBLX3ECTk/Cf2ECilVFla5u6sxpVWfrxDjE+aaQ6zapH/8fF+auQxcxDrf7Md
	 EV9SU+xX9Vy1fABpbf0asR3KIRHXPHfL0RV/Lj/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianlin Shi <jishi@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/223] ipv6: add exception routes to GC list in rt6_insert_exception
Date: Wed, 23 Apr 2025 16:41:42 +0200
Message-ID: <20250423142618.340450252@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit cfe82469a00f0c0983bf4652de3a2972637dfc56 ]

Commit 5eb902b8e719 ("net/ipv6: Remove expired routes with a separated list
of routes.") introduced a separated list for managing route expiration via
the GC timer.

However, it missed adding exception routes (created by ip6_rt_update_pmtu()
and rt6_do_redirect()) to this GC list. As a result, these exceptions were
never considered for expiration and removal, leading to stale entries
persisting in the routing table.

This patch fixes the issue by calling fib6_add_gc_list() in
rt6_insert_exception(), ensuring that exception routes are properly tracked
and garbage collected when expired.

Fixes: 5eb902b8e719 ("net/ipv6: Remove expired routes with a separated list of routes.")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/837e7506ffb63f47faa2b05d9b85481aad28e1a4.1744134377.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index bae8ece3e881e..d9ab070e78e05 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1771,6 +1771,7 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 	if (!err) {
 		spin_lock_bh(&f6i->fib6_table->tb6_lock);
 		fib6_update_sernum(net, f6i);
+		fib6_add_gc_list(f6i);
 		spin_unlock_bh(&f6i->fib6_table->tb6_lock);
 		fib6_force_start_gc(net);
 	}
-- 
2.39.5



