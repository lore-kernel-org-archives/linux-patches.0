Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E228615C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:18:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FF5C433C1;
	Mon,  5 Dec 2022 19:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267932;
	bh=DoZwt6SssrCaHomhGhjUI7wR79zmxnYR6J9fq8RpZoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihOWGN2DN1sJq164o6Ncp8wS2+9p3R6xaIvNUE9IPFm9dzL51TY79KZ9e/g5k1ATH
	 O8Ge/zjpFf8Y32TRLBeOnZK1AryJ4w7Y7sP3B6nzIH76uLwm5l2YYNZRqXK0AofDNM
	 krSdtMpgWIL11d3fy4I9hdltdeKiCVJrND8VcNtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/105] xfrm: Fix ignored return value in xfrm6_init()
Date: Mon,  5 Dec 2022 20:08:58 +0100
Message-Id: <20221205190804.030126724@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 40781bfb836eda57d19c0baa37c7e72590e05fdc ]

When IPv6 module initializing in xfrm6_init(), register_pernet_subsys()
is possible to fail but its return value is ignored.

If IPv6 initialization fails later and xfrm6_fini() is called,
removing uninitialized list in xfrm6_net_ops will cause null-ptr-deref:

KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 PID: 330 Comm: insmod
RIP: 0010:unregister_pernet_operations+0xc9/0x450
Call Trace:
 <TASK>
 unregister_pernet_subsys+0x31/0x3e
 xfrm6_fini+0x16/0x30 [ipv6]
 ip6_route_init+0xcd/0x128 [ipv6]
 inet6_init+0x29c/0x602 [ipv6]
 ...

Fix it by catching the error return value of register_pernet_subsys().

Fixes: 8d068875caca ("xfrm: make gc_thresh configurable in all namespaces")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/xfrm6_policy.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 30232591cf2b..1925fb91e514 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -416,9 +416,13 @@ int __init xfrm6_init(void)
 	if (ret)
 		goto out_state;
 
-	register_pernet_subsys(&xfrm6_net_ops);
+	ret = register_pernet_subsys(&xfrm6_net_ops);
+	if (ret)
+		goto out_protocol;
 out:
 	return ret;
+out_protocol:
+	xfrm6_protocol_fini();
 out_state:
 	xfrm6_state_fini();
 out_policy:
-- 
2.35.1



