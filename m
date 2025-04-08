Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BB0269B0D;
	Tue,  8 Apr 2025 10:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109856; cv=none; b=a8LqG9g3i8w1lFvC+ixWcAT6wF2haMiauOySqm/w4I2d0Q1Uzyr9leixik35gd0IHDWlbd1rPoRbmFBgWPOw/XMDY29Y633/amlINK/CNr7kAxhAB0wylGZM6y5Ff3N1dis+pj23var7RJ8+4n6Z83S+clEOv/gbzrz1sz2yxOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109856; c=relaxed/simple;
	bh=zhUs9bC0KC80cQU8AoLeormnTP1qx2dhFu8syNRnM9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Baw+EQpczyqHi46RnCo7P3A7w89RiPX3OKLYL+o/QCLqZJNxhCCJ0QsVB9sZOY8PlQxoNqiNKojS6Zgd13UyBwsJ5y2fPW5oZ5qFexjmfa7Bam6yxFI8J5rwBv2zTQSMvdT673A2qGyV0Ivlkp40VCBCqhzZNl0rBJJxOUm9p+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJF2c+sr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJF2c+sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E76BC4CEE5;
	Tue,  8 Apr 2025 10:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109855;
	bh=zhUs9bC0KC80cQU8AoLeormnTP1qx2dhFu8syNRnM9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJF2c+srwER/tXl0fw3fQwTsFP6tKLD0sapD21xXuvX7pgODt45qmMcfUGepdzOPA
	 TVGKX5CU35u8wSSVDvCfnu6poYerhp764Y0QhXp3lCd7KmTIAimqKcR9rjtbIWUnob
	 0SAJ6Pf/rKzNJzcP5JwPA8Rzqn7S1W+CFMx1v8Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/227] ipv6: Fix memleak of nhc_pcpu_rth_output in fib_check_nh_v6_gw().
Date: Tue,  8 Apr 2025 12:47:35 +0200
Message-ID: <20250408104822.700430887@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 178c56f6f6185..802386b3937f7 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3519,7 +3519,8 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 		in6_dev_put(idev);
 
 	if (err) {
-		lwtstate_put(fib6_nh->fib_nh_lws);
+		fib_nh_common_release(&fib6_nh->nh_common);
+		fib6_nh->nh_common.nhc_pcpu_rth_output = NULL;
 		fib6_nh->fib_nh_lws = NULL;
 		if (dev)
 			dev_put(dev);
-- 
2.39.5



