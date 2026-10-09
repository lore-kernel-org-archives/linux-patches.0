Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7F681ACD;
	Fri,  9 Oct 2026 14:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556047; cv=none; b=e7nJSVhpG2vt89q9n9v2nYwzwxT1oizqD2BtvDgqc+CMemV94niYJKIk6cHQozhtoCpTgXt//liC5hO+mFWZMnCsjbVz2/nWU+eIGAS6oyauP8Bl8ICrAERAsY97KUuFCBnQBaJ36XgkD3PTxwSeaWsYHvV0q0FU6FsD4PhBWc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556047; c=relaxed/simple;
	bh=Ibq+4YDuEMVj44VseBikPPDorzM0192N3THOISKaZ50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnPBoIq1iXXDQb/kDtpsMP/gCMMoN51yYOZ51NbNME0kqLnkgNME57Sh2TUQTNd6CyR8bqD2I8OHeix7WPIDQ9I1zHUw7lRRNS+2wZA9kLtDPt/ag4pH5Hi+Pbf38Sr6zi2tH81mXzxiioKmv9qDfVTPdJ4WCCqNr8E6DiejTnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w3qcNbs+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w3qcNbs+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0B31F000FF;
	Fri,  9 Oct 2026 14:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556046;
	bh=Q6yz9sDs30HLPmTwxzII5+WIvovAk0KfIaOFSXCQu78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w3qcNbs++UDzbD9jsmQwW8TZkBuhklvwdlxVrMvT/oKwZqjudSQxI/hZGRvUkCiit
	 nFGLM6Y/8sNehl74OjiH14j9S7t+sw5/ucj8tMaxDcmEIPYEusCSdwm8Zs7U22Vn+6
	 32Uxx4SQKivmdW8djLwU12SjLX9Ld/XMPQhP6xEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qishuai Liu <lqs@lqs.me>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 112/428] ipv6: fix prefix route expiry in modify_prefix_route()
Date: Fri,  9 Oct 2026 16:07:29 +0200
Message-ID: <20261009140948.662463492@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qishuai Liu <lqs@lqs.me>

[ Upstream commit a7bfaba4823e3c165bb2004c74eff7c096672bc7 ]

modify_prefix_route() is given the lifetime in clock_t relative to now,
but fib6_set_expires() wants an absolute jiffies value. So when a
permanent address is changed to a finite valid_lft, the prefix route
ends up already expired and GC removes it.

Steps to reproduce:

  ip link add dummy9 type dummy
  ip link set dummy9 up
  ip -6 addr add 2001:db8:9::1/64 dev dummy9
  ip -6 addr change 2001:db8:9::1/64 dev dummy9 valid_lft 3600 preferred_lft 3600
  ip -6 route show dev dummy9    # expires is negative

Fixes: 8308f3ff1753 ("net/ipv6: Add support for specifying metric of connected routes")
Signed-off-by: Qishuai Liu <lqs@lqs.me>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260923132048.3272878-1-lqs@lqs.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index cbe681de38188..e482389376dce 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -4873,7 +4873,7 @@ static int modify_prefix_route(struct net *net, struct inet6_ifaddr *ifp,
 			fib6_clean_expires(f6i);
 			fib6_may_remove_gc_list(net, f6i);
 		} else {
-			fib6_set_expires(f6i, expires);
+			fib6_set_expires(f6i, jiffies + clock_t_to_jiffies(expires));
 			fib6_add_gc_list(f6i);
 		}
 
-- 
2.53.0



