Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFA225D525;
	Tue, 25 Mar 2025 12:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906345; cv=none; b=c71LJI1h5p+l5fw3bsiI2q+zgO5jeZDuipDSZuWuy4TD+P/yc0utZjgI71SXMmxaUI7m7AKX9vhAh4/3BU+0u0YSBIwgN4E3BXS/t+f4ntwwmvPbmfUbRl7WDpz0UKKqKu/F9guvnJeRiv1OGbd7kCK7KZzJvqEP8Q7jIVuAkoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906345; c=relaxed/simple;
	bh=Qy1r2Qoc+Nmf/pgF3VWv1Y8nn1McAmNGloDk8BsToa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNBdfMulxjxAPHiaSN0ebSORdyZYbjRD4YIr5L33QNjhh2gapEMJ/z3Nnxbto3K+EoVJQSuBJW/HK69CYUysA95Dqgzs04AYUKSZs9ORpHyO0ZG5CFYuMnm+KDKptM37z5uYo5ALSpnsjaO11gELXasx3DzasKLYdeD89nSlzSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lLD7Wxy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLD7Wxy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3185DC4CEF2;
	Tue, 25 Mar 2025 12:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906345;
	bh=Qy1r2Qoc+Nmf/pgF3VWv1Y8nn1McAmNGloDk8BsToa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLD7Wxy4cV2wZRaZiCu/G4Sz8DdoBCSmKt0vSvw5o2R45W8hEQmnKiaOpoXoLBLet
	 YyczmlGeirW2scIEJQyL4/So1KBKqVyttzV16pkx2LTAYYbMVR4nqa0LgXlRr08ZoZ
	 ocDVkSq6prvOIH3U5fGVh9SyL54iUU18zWC7dKDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/116] ipv6: Fix memleak of nhc_pcpu_rth_output in fib_check_nh_v6_gw().
Date: Tue, 25 Mar 2025 08:22:05 -0400
Message-ID: <20250325122150.181872282@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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
index 2736dea77575b..e9a30978abac1 100644
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



