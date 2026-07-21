Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA70A471268;
	Tue, 21 Jul 2026 20:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664657; cv=none; b=flRtbp7rfHv8AvSX1s7gZY9Ic+QPrSj2Q5AA3oZImkxwjyAuTgdbiF5MXjZTVRJVoorNPLTVTo4cYHuzqhZew0UTGKMkXdt8Y+YSvybmK7Ouoyx4uLz/OpwENqYdntI44WJS0YhVc57rC5pDqm3fi6lXmQA+m6620fYw1cFK7s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664657; c=relaxed/simple;
	bh=+pDQmWPFRx/m/I1BqM+FZJCPKPXdl39DIhp5azuyGf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hD9g5Kx42u4B7CasJgacGMH+cso3BcZdjhSjIWqTX6EIPqlo3BbP+5VZUg9CdvJiNuJiy+z7GTJw2ogPpCDBjSEaAe/lHLWwMSoKeCA0YqP6g3VyGrf6P8sadqbQwNRtlwUPUOQnpnqjOV8Afqmk/uzD/glqG+IBGCUE27T9KmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iD0hN2Tr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iD0hN2Tr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5D11F000E9;
	Tue, 21 Jul 2026 20:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664656;
	bh=4JavyS4smMRKH/dKnbcdCj7Gp7he0cLJWUCL1JvLy/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iD0hN2Tr/iYFqHpS1trabgrXIM4q8UH1T/onx8i7cg4wSHgSfDptBwfN3VYjWjKsh
	 itr9U5gUhXlxwANuukhcIuGa53nPcP6nEROn2Adypb+kvabmtB2IfXWD8VN1d4m8ZZ
	 nRpJnQKUxuGpA6Oy3EqA+uEpFe/4k7T5X5N7Or0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 1253/1276] rtnetlink: Make per-netns RTNL dereference helpers to macro.
Date: Tue, 21 Jul 2026 17:28:16 +0200
Message-ID: <20260721152514.134501681@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit 9cb7e40d388d6c0e4677809c6b2950bc67fd8830 upstream.

When CONFIG_DEBUG_NET_SMALL_RTNL is off, rtnl_net_dereference() is the
static inline wrapper of rtnl_dereference() returning a plain (void *)
pointer to make sure net is always evaluated as requested in [0].

But, it makes sparse complain [1] when the pointer has __rcu annotation:

  net/ipv4/devinet.c:674:47: sparse: warning: incorrect type in argument 2 (different address spaces)
  net/ipv4/devinet.c:674:47: sparse:    expected void *p
  net/ipv4/devinet.c:674:47: sparse:    got struct in_ifaddr [noderef] __rcu *

Also, if we evaluate net as (void *) in a macro, then the compiler
in turn fails to build due to -Werror=unused-value.

  #define rtnl_net_dereference(net, p)                  \
        ({                                              \
                (void *)net;                            \
                rtnl_dereference(p);                    \
        })

  net/ipv4/devinet.c: In function ‘inet_rtm_deladdr’:
  ./include/linux/rtnetlink.h:154:17: error: statement with no effect [-Werror=unused-value]
    154 |                 (void *)net;                            \
  net/ipv4/devinet.c:674:21: note: in expansion of macro ‘rtnl_net_dereference’
    674 |              (ifa = rtnl_net_dereference(net, *ifap)) != NULL;
        |                     ^~~~~~~~~~~~~~~~~~~~

Let's go back to the original simplest macro.

Note that checkpatch complains about this approach, but it's one-shot and
less noisy than the other two.

  WARNING: Argument 'net' is not used in function-like macro
  #76: FILE: include/linux/rtnetlink.h:142:
  +#define rtnl_net_dereference(net, p)			\
  +	rtnl_dereference(p)

Fixes: 844e5e7e656d ("rtnetlink: Add assertion helpers for per-netns RTNL.")
Link: https://lore.kernel.org/netdev/20241004132145.7fd208e9@kernel.org/ [0]
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410200325.SaEJmyZS-lkp@intel.com/ [1]
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rtnetlink.h |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -146,21 +146,12 @@ static inline void ASSERT_RTNL_NET(struc
 	ASSERT_RTNL();
 }
 
-static inline void *rcu_dereference_rtnl_net(struct net *net, void *p)
-{
-	return rcu_dereference_rtnl(p);
-}
-
-static inline void *rtnl_net_dereference(struct net *net, void *p)
-{
-	return rtnl_dereference(p);
-}
-
-static inline void *rcu_replace_pointer_rtnl_net(struct net *net,
-						 void *rp, void *p)
-{
-	return rcu_replace_pointer_rtnl(rp, p);
-}
+#define rcu_dereference_rtnl_net(net, p)		\
+	rcu_dereference_rtnl(p)
+#define rtnl_net_dereference(net, p)			\
+	rtnl_dereference(p)
+#define rcu_replace_pointer_rtnl_net(net, rp, p)	\
+	rcu_replace_pointer_rtnl(rp, p)
 #endif
 
 static inline struct netdev_queue *dev_ingress_queue(struct net_device *dev)


