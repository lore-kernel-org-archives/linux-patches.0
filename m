Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6DA2571AC;
	Tue, 25 Mar 2025 12:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906117; cv=none; b=IaRCZQpo4TSjjIoPcQreUixuvyBrHdh+Eo/nJlb3M5njwEQB2BgYCseMhP9ETnw31eVwC1HJ9tLzM4AxOrycMFzo2BRHvjHFWHNa8Flv7q8XXSdQCIJdujyVVYZglzzCKprJReSV6Fw5nDjyqIHBD7SkW1H6yeN/aNXWeNGiZzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906117; c=relaxed/simple;
	bh=Azv1tyy1/NzwPk4RVtJuyJ2zj9zOF4dXCBkPi0yyihs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0Sm8zX3RnaCp0MOfymw4PsY+Cd/u1NVgP10aJlVB59tHpsoyckleSayt5M3g7A7sMsz6iQRVss1Ed8aV+zkcQr8G02UlXA3PFWxfk9iIKEp12wBqLuDunggKBo2jJlQL5w1o6g3hA35s2n5ZD+ofcDrcXxbrTo4S/PR1Q1iWoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6jwtBrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6jwtBrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D16A5C4CEE4;
	Tue, 25 Mar 2025 12:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906117;
	bh=Azv1tyy1/NzwPk4RVtJuyJ2zj9zOF4dXCBkPi0yyihs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6jwtBrSfoYhbtEoZVHNp8Sz0NyJQixOnWb0FfNrxoiGtyGTCg2j1g/Goe3DIaJ9E
	 kt1lflsw0sAk0vvxHg9ZggM8F3tPFjlG2zQdwMHRspp9M8v98ojhRSvskKMwJd+T+M
	 BsOmvpUD1IKWfZ86tvFEyz1OD4m2t6B5mwW1TClY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 23/77] ipv6: Fix memleak of nhc_pcpu_rth_output in fib_check_nh_v6_gw().
Date: Tue, 25 Mar 2025 08:22:18 -0400
Message-ID: <20250325122144.960288088@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5715d54f3d0be..f13b2eb904633 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3636,7 +3636,8 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
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



