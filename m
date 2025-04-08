Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7908F26A0FF;
	Tue,  8 Apr 2025 12:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113887; cv=none; b=qinjEEOQ3yki7JhA5cvtIIx64GzPKpFfsox9A3yrklioJEGNrZdtihxkud6V2HDN0HGfdqkXSVg9CF9t+gT7IdGULRdbftOxfS4jNW/qWR8YYmtRgKz+VaW5+C4n4MrvcXmrvfqGB+J+2wFv8WXw41FSn7ELks5qM+UzS2UNqVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113887; c=relaxed/simple;
	bh=3CSXOQYEGeFf5oXWi0MO5NzJRN24G6NO4Fg+iIcoU0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kyty7AkbmWkNbdU1kVWI0R2OYOY4vQaCpOfJjfZiem75kFQKXI8j39gIKLonfV0wPETQVwVZEcLpomvPcZhHapkQDAENVAvM2s7hSAJ0JdwfMV/kzbf6Fan0QwGyW5rI5FpT7NQp+jTDU5GxuOfhpqJ1Sl7DSYGViGPWhYbJGPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfFENzss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfFENzss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F68C4CEE5;
	Tue,  8 Apr 2025 12:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113887;
	bh=3CSXOQYEGeFf5oXWi0MO5NzJRN24G6NO4Fg+iIcoU0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfFENzssyNb8voPGfhvk53WMpS/aaY5wPyFFd44uQ2fBW0lI3zK/Nn+khSQHYaqXn
	 FpJw+6VxpiKrsaxD2NoPO4HrCD0HQqUMLmjxIqsbw+fC0+Ipl4Ugzri9WSaaMMUoEE
	 AXQ8UsISr1AqVd8sQ8Jn2hXnGWb2wAV6N39CrOqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 056/154] ipv6: Fix memleak of nhc_pcpu_rth_output in fib_check_nh_v6_gw().
Date: Tue,  8 Apr 2025 12:49:57 +0200
Message-ID: <20250408104817.079476649@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 99908861246d3..d037979f6579f 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3549,7 +3549,8 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
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



