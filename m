Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F04219301;
	Tue,  8 Apr 2025 11:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112497; cv=none; b=pSdft0L31VtdqAP2ySAj5nYdE0z0l8io7IMGLdSbS7oPLv15aNIZZJZnmgz9F3y2k0RLwqYOf3YwwnHl495236q15QqTX3auEuwSDbiitUU+hYAPz5LKq49fI4xQFMJ7v2zopsNmjSN0mW1iFqQeYCoq5IVYARaECGaz4fRyZ2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112497; c=relaxed/simple;
	bh=zq8zLonBs5xmFpoO/Zxo9LBUvNcmQcmB6dQ7oXACbZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6fxAZVZCYjbdx2Zi30zJadkZto8sBpqKxHhc4gddklirJINH0VMBQUdpuHMXmxSDA5IdjohO2G6wNcJZ2+aTk1FI4Rzq7Qw02o9grS0q+HActgMtm34VfHLMxHDEQGU2ywiQf3IX6FK/kNgiVCQeyGyhAozJ1hDfp17zNzvY+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SNcbEnIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SNcbEnIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B13C4CEE5;
	Tue,  8 Apr 2025 11:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112497;
	bh=zq8zLonBs5xmFpoO/Zxo9LBUvNcmQcmB6dQ7oXACbZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SNcbEnIGGoH0XHq5JtfApQwXiCcK1BsBg02xSsDB4zzLB8urgAdo8qs0v8b2n/1zB
	 osl1+U5JQiPItAlV3P/q6tFj+q6FYYkN6lOoH3TU8ral83XLjyLdDMuCsVljpXtXxs
	 P2d4JqGCj1zO5ndawK1+yAdroFVGzunobswBsF3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/279] ipv6: Fix memleak of nhc_pcpu_rth_output in fib_check_nh_v6_gw().
Date: Tue,  8 Apr 2025 12:47:54 +0200
Message-ID: <20250408104828.807637585@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 94526436b91e8..875cab88f3891 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3630,7 +3630,8 @@ int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 		in6_dev_put(idev);
 
 	if (err) {
-		lwtstate_put(fib6_nh->fib_nh_lws);
+		fib_nh_common_release(&fib6_nh->nh_common);
+		fib6_nh->nh_common.nhc_pcpu_rth_output = NULL;
 		fib6_nh->fib_nh_lws = NULL;
 		dev_put(dev);
 	}
-- 
2.39.5



