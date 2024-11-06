Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC601E1C33;
	Wed,  6 Nov 2024 13:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898352; cv=none; b=AidoBbWm3l7rcoN0jE5LBIm7m6c9ALwByjSWWhXzzZVxSBft1rle7YSdTYa9aZFZrG+YOMqE+4+uLwwSZXxfVmVbu4+d4w3RmCNg+aEP7G++YKdJLUP+7Kq3or2k+9IYr4y0rYNTGFx+avWKViOKNugpMUQJw5ekXTMkp+ulTZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898352; c=relaxed/simple;
	bh=9zGBi1Fjx8XCSKqqidnFXtuUZCRsHWxWrRz9c4rAviA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McWVHAk4RPXtp6pcn2r6d17uaGifNifd5DMdUl3gjo/VJ2A333Gc6e+q04A7f67bcwPaTAJEdXx71Y/UxGJKBqgpjVLko/xzMzCfdFGkDKr6aO8GVJ9lvPgjG9qn5BAGGKrt1Xl6uA79CNO0juXMlDrTWDmTPvjC3GVYQOA7j/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4DcmIeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4DcmIeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EB4C4CECD;
	Wed,  6 Nov 2024 13:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898352;
	bh=9zGBi1Fjx8XCSKqqidnFXtuUZCRsHWxWrRz9c4rAviA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z4DcmIeoPqllfIExfFlY2xKUc5V053epLMBcmCU0sF/Rc3F8nThxDOJQKPr3YBl1c
	 oRsPV6oUJCuS54sGeMJI+E8aLoty9LoGyQ5fFVeuSNEaEvIJ9aU3s/ODuAiDFAp/FH
	 ZbsJ/NFuaZI/ZhPoLoJP0cvymQ6l4NyqZWOMn0fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Guillaume Nault <gnault@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 209/462] ipv4: Mask upper DSCP bits and ECN bits in NETLINK_FIB_LOOKUP family
Date: Wed,  6 Nov 2024 13:01:42 +0100
Message-ID: <20241106120336.679952127@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c31003d8c22f8..2d6b125024314 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1344,7 +1344,7 @@ static void nl_fib_lookup(struct net *net, struct fib_result_nl *frn)
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



