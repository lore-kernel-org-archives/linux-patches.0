Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E871DE8BE;
	Tue,  8 Oct 2024 13:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393341; cv=none; b=LrpYVsKSKJjEMDRWATGzJRbD86VIXvNjHV5lUI7FytRIzqcBSZk5P93Xe44OAhinLQ4Q4ehMNt+urLLdGzJAHQH7blBwxsnLSwij+vIU9zqq3kWcyMwAhyKBFLqhauLrYpTfzNupXaEkVZglalYFcL/GTQ3OzEazHQ8TFuSY4oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393341; c=relaxed/simple;
	bh=Z6Aq3Bn7j/GrA6RdMA8PrO6VBMINE7X/uf66GMSbCLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXYlfZv9BS/d62p6WMrAUab3DfgaIQPYSgiVOM6l3Wms4VccaZjvIfxAyjWfovvDYstvu708JH3dJLM4aTK0LlhljKebMIXk/jNKHXi0c05k+8fm69QZsgIPirYijybTm2e/MCMpeu/246Tvrge0hJLZMI5y0HPJdYWQGhKOxIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cD1cITxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cD1cITxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72BF8C4CECC;
	Tue,  8 Oct 2024 13:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393340;
	bh=Z6Aq3Bn7j/GrA6RdMA8PrO6VBMINE7X/uf66GMSbCLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cD1cITxIpTdU1vQZhWRcO+wAxda7Ien42neErDyQGzOAf6AzkSy+OmFovIg21QPYC
	 AWgiwCHEL7lXpOBMoqTq8wdIGwFhLCG7yh/lgNahOIcbNzJ2QVeNdqI7WbbE0R2cGd
	 9Zf9t3LBkXXTwXk3+hFBJ0I7ru5A8r0Ira7JhC/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 091/386] ipv4: Mask upper DSCP bits and ECN bits in NETLINK_FIB_LOOKUP family
Date: Tue,  8 Oct 2024 14:05:36 +0200
Message-ID: <20241008115633.033720609@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 8fed54758cd248cd311a2b5c1e180abef1866237 ]

The NETLINK_FIB_LOOKUP netlink family can be used to perform a FIB
lookup according to user provided parameters and communicate the result
back to user space.

However, unlike other users of the FIB lookup API, the upper DSCP bits
and the ECN bits of the DS field are not masked, which can result in the
wrong result being returned.

Solve this by masking the upper DSCP bits and the ECN bits using
IPTOS_RT_MASK.

The structure that communicates the request and the response is not
exported to user space, so it is unlikely that this netlink family is
actually in use [1].

[1] https://lore.kernel.org/netdev/ZpqpB8vJU%2FQ6LSqa@debian/

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 390f4be7f7bec..90ce87ffed461 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1343,7 +1343,7 @@ static void nl_fib_lookup(struct net *net, struct fib_result_nl *frn)
 	struct flowi4           fl4 = {
 		.flowi4_mark = frn->fl_mark,
 		.daddr = frn->fl_addr,
-		.flowi4_tos = frn->fl_tos,
+		.flowi4_tos = frn->fl_tos & IPTOS_RT_MASK,
 		.flowi4_scope = frn->fl_scope,
 	};
 	struct fib_table *tb;
-- 
2.43.0



