Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2530C364024;
	Tue, 16 Jun 2026 15:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624951; cv=none; b=JlH1W1+qHgZbyoj07XwaBHx84Ae5HIJudQNA8+qzYmDmdcAK3JiGj+OEIVLORxPl3vDS/OQA2ywDyA+exfaF6gqn/JOeTjewBkbxQVZvbOKkUiGzwTFxtpOCgsB9IpUi8HDwCXIGs2/ZSFd4k2VOZ/x6ZEwylIs8xZbD+sluQu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624951; c=relaxed/simple;
	bh=HBM57hLqGOs2CBDnoD6yHUsbVMerqQ7KtLYoeGJpS6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDcoKlpDclTWmMfohSaH3NmofBZJxpCMo3zxgSPfOxzhilUECCk26Na4bHTsOyXvaXtJE6H3YcUFi/Ebj2hbpTXNPAzbb3iR6phiwQgb7NTxRHznBhlEVVxzIPlSp+X5R29praEU0jor+bwQDaDEO/YBR2APtZtrWR87UDzY/pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYLuE/SN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYLuE/SN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E2C1F00A3A;
	Tue, 16 Jun 2026 15:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624950;
	bh=vP1Y/z4Thf3qVd4L8CeUvzjXS0hKsTCH2n09v+ixPRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYLuE/SN3RxZk/PLsNmjU3y5wn6MjSvZGueaz/m5M+vMfYaEp/TM0xtzn3LuJMvkx
	 ZcUzRtr6eEkcLM5GJc6G38x8fgTZfKR69ozJHDfmvSYzroVUlhKkrLUA1smmVwQWoG
	 2SWWzw0j1YIlNRq6LZd4NzIVuXeV2UE96XoT4CKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Shahar <tamirthesis@gmail.com>,
	Amit Klein <aksecurity@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/325] ipv4: restrict IPOPT_SSRR and IPOPT_LSRR options
Date: Tue, 16 Jun 2026 20:27:32 +0530
Message-ID: <20260616145100.481176855@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d3915a1f5a4bc0ac911032903c3c6ab8df9fcc7c ]

This patch restricts setting Loose Source and Record Route (LSRR)
and Strict Source and Record Route (SSRR) IP options to users
with CAP_NET_RAW capability.

This prevents unprivileged applications from forcing packets to route
through attacker-controlled nodes to leak TCP ISN and possibly other
protocol information.

While LSRR and SSRR are commonly filtered in many network environments,
they may still be supported and forwarded along some network paths.

RFC 7126 (Recommendations on Filtering of IPv4 Packets Containing
IPv4 Options) recommend to drop these options in 4.3 and 4.4.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Tamir Shahar <tamirthesis@gmail.com>
Reported-by: Amit Klein <aksecurity@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260602161547.2642155-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_options.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/ip_options.c b/net/ipv4/ip_options.c
index be8815ce3ac242..09d745112c1526 100644
--- a/net/ipv4/ip_options.c
+++ b/net/ipv4/ip_options.c
@@ -530,6 +530,10 @@ int ip_options_get(struct net *net, struct ip_options_rcu **optp,
 		kfree(opt);
 		return -EINVAL;
 	}
+	if (opt->opt.srr && !ns_capable(net->user_ns, CAP_NET_RAW)) {
+		kfree(opt);
+		return -EPERM;
+	}
 	kfree(*optp);
 	*optp = opt;
 	return 0;
-- 
2.53.0



