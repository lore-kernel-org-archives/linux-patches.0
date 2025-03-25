Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47EC268C4F;
	Tue, 25 Mar 2025 12:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905923; cv=none; b=oiyeKQc2aXmBZ5cpjY4FzokKAS3UlsY/x7HGuWK7fWqiEfZxHQp8hxXaj+vgMB8DREzYxHLH8WRLGaYl6rwA34Pocqrjo4kNhxt7nKWB3yikBZ/2Sw8obkJhPx8AOXvf6Wb/xMLkC61LWCyUFPHPkCRh+jjcJUV2lmvDrKveI5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905923; c=relaxed/simple;
	bh=7fdvlT6qfxTwjMC1U/aOuQWEhHhBmaCf+9OrvDtrr18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JS0zBkB0G1iNyrIDq1mLpnR2cj8xijPYYzg6inQKRULQD7b5ZW6NvU2wrr30mt2uFixCa5GIgjrLZUdt9LoGZnmfYV6o/eMUUD4xdz0FYbEWtDI0471GCuDbAr9VzedTUWX9xGIreZRjli76fQm1ljShla/tW2wpmE3Ym/pCicw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AayQgr6+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AayQgr6+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EE8C4CEE4;
	Tue, 25 Mar 2025 12:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905923;
	bh=7fdvlT6qfxTwjMC1U/aOuQWEhHhBmaCf+9OrvDtrr18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AayQgr6+7/ZGbpEhbxr6TUIVpKTie4qCgLARxHr+kkAaPKOJ/8PlFn9uzTkRcXKD5
	 ctluiEhkMNNnwvCj33/8vL4DVgrPQNd2EiKuSecHXl+sgz8swKBE3O1U4F6xL3aRau
	 Zz9ciW4kK03UYEL1O8Gf27TvVL73jAsEMPssuMag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 039/119] ipv6: Fix memleak of nhc_pcpu_rth_output in fib_check_nh_v6_gw().
Date: Tue, 25 Mar 2025 08:21:37 -0400
Message-ID: <20250325122150.058591141@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 9740890ee20e01f99ff1dde84c63dcf089fabb98 ]

fib_check_nh_v6_gw() expects that fib6_nh_init() cleans up everything
when it fails.

Commit 7dd73168e273 ("ipv6: Always allocate pcpu memory in a fib6_nh")
moved fib_nh_common_init() before alloc_percpu_gfp() within fib6_nh_init()
but forgot to add cleanup for fib6_nh->nh_common.nhc_pcpu_rth_output in
case it fails to allocate fib6_nh->rt6i_pcpu, resulting in memleak.

Let's call fib_nh_common_release() and clear nhc_pcpu_rth_output in the
error path.

Note that we can remove the fib6_nh_release() call in nh_create_ipv6()
later in net-next.git.

Fixes: 7dd73168e273 ("ipv6: Always allocate pcpu memory in a fib6_nh")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250312010333.56001-1-kuniyu@amazon.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 997e2e4f441d2..1864048e7fd5d 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3644,7 +3644,8 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 		in6_dev_put(idev);
 
 	if (err) {
-		lwtstate_put(fib6_nh->fib_nh_lws);
+		fib_nh_common_release(&fib6_nh->nh_common);
+		fib6_nh->nh_common.nhc_pcpu_rth_output = NULL;
 		fib6_nh->fib_nh_lws = NULL;
 		netdev_put(dev, dev_tracker);
 	}
-- 
2.39.5



