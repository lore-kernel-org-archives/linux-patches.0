Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DBC10A35;
	Mon,  4 Mar 2024 21:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588497; cv=none; b=DKQsoQY+/7rW1pqJrBC0l0KA+Fudp6V/CzsCqZHxpk/V/YNoMHaYgAll0orKyFS7xvj66pGgkpIs0TcjICy2liHeZAt2aC8jL4PYxt44oXxhGcoi1aRhK6suMvzuisCIeKDdVMEZJCsLnvqmy9OOKNqjXC301U1X1JSZzhjzTBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588497; c=relaxed/simple;
	bh=iaP9KWH8Nu1cJCyP/GHLSky4KfVjoZHDKcuVjz+F8hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovyWIiDf5BdDRztJPzJ2gJ0yPhWSbyVNIfuit3053+W+FTE0XAhowlkkLCnV83tk/j4cff4SZ34mve1KxoX3rdA40UIk9Oh5UUul6j+y5ZboH4BMo0a+e+AqngIAJcL3m2BQl1Jhkhzl9LF0ovyXkxLD59jDTh971Ix3ADbvPxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUCP7c0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUCP7c0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1BEC433C7;
	Mon,  4 Mar 2024 21:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588497;
	bh=iaP9KWH8Nu1cJCyP/GHLSky4KfVjoZHDKcuVjz+F8hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUCP7c0+exfaMHs1uQRkfv2bYf04jU8owFcj+Y/4t71yXyn3nWHi8G2kuiuGDZ+Wk
	 GZwioMpXZFdVH/Fvp3A7VTK/XwvYoOiWeJb94kBPeXBfeMlSQhLPrSZPoXuhae/btB
	 zd8T0CJ7rVW4lVkokh6sebNKuXbTTemtIchHNqek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 106/143] mptcp: map v4 address to v6 when destroying subflow
Date: Mon,  4 Mar 2024 21:23:46 +0000
Message-ID: <20240304211553.304313665@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 535d620ea5ff1a033dc64ee3d912acadc7470619 upstream.

Address family of server side mismatches with that of client side, like
in "userspace pm add & remove address" test:

    userspace_pm_add_addr $ns1 10.0.2.1 10
    userspace_pm_rm_sf $ns1 "::ffff:10.0.2.1" $SUB_ESTABLISHED

That's because on the server side, the family is set to AF_INET6 and the
v4 address is mapped in a v6 one.

This patch fixes this issue. In mptcp_pm_nl_subflow_destroy_doit(), before
checking local address family with remote address family, map an IPv4
address to an IPv6 address if the pair is a v4-mapped address.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/387
Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240223-upstream-net-20240223-misc-fixes-v1-1-162e87e48497@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -487,6 +487,16 @@ int mptcp_nl_cmd_sf_destroy(struct sk_bu
 		goto destroy_err;
 	}
 
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	if (addr_l.family == AF_INET && ipv6_addr_v4mapped(&addr_r.addr6)) {
+		ipv6_addr_set_v4mapped(addr_l.addr.s_addr, &addr_l.addr6);
+		addr_l.family = AF_INET6;
+	}
+	if (addr_r.family == AF_INET && ipv6_addr_v4mapped(&addr_l.addr6)) {
+		ipv6_addr_set_v4mapped(addr_r.addr.s_addr, &addr_r.addr6);
+		addr_r.family = AF_INET6;
+	}
+#endif
 	if (addr_l.family != addr_r.family) {
 		GENL_SET_ERR_MSG(info, "address families do not match");
 		err = -EINVAL;


