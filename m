Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A021A1EEF8;
	Thu, 13 Jun 2024 12:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282047; cv=none; b=KDstuGyVx5Ho1xYNKHPx4Ix0trAyd8nvAchf83h2bIete530sdNkQls0t/DHnI7t1LBU/QpiCO5e3OPZ5u3ruZlkQXSBxdoW8zfY24/Kt0XjhyR4WSeeffO7L6gU4DAYodcVZqgMREMSt2UUQIgwXk3a7YKhFssd7BxTOX1mTp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282047; c=relaxed/simple;
	bh=OuJVc0d9pVKTLqeshr33tFSTAkEYf850wRWl38XCmn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s59/bWPMXg+6K8n+t4k4V5azCsFz867hN749JpZwQq8cUGjcQfa3xICBAX2Po6h66ndqqIr3wp9+GvHMV//puNtXkf/CHTrWklY8yxqBDFBfv+DK0oYsN+2atencBaF9qnT/kUygemy5mDWpV21HHulfZc+hyLZcizM+T6JJL3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ytpdqvD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ytpdqvD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275C7C2BBFC;
	Thu, 13 Jun 2024 12:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282047;
	bh=OuJVc0d9pVKTLqeshr33tFSTAkEYf850wRWl38XCmn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ytpdqvD7GgzCJFPoM8ygNY4qUckCGcGKZvZHfy1dNbC+b2TJLOe8LKkD3tCn3ks2
	 KmYHVBsJ8w03SGwFEp7wvR5XV1W+8/RKE8RCkijHRfY0yLJ8GU14kiKHBhiVcr3ZhN
	 QyC7k3ilXJOb3TCLuO0OjhCrdn+2o+ysUmDCpAM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/402] ipv6: sr: fix invalid unregister error path
Date: Thu, 13 Jun 2024 13:31:14 +0200
Message-ID: <20240613113306.695648478@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 160e9d2752181fcf18c662e74022d77d3164cd45 ]

The error path of seg6_init() is wrong in case CONFIG_IPV6_SEG6_LWTUNNEL
is not defined. In that case if seg6_hmac_init() fails, the
genl_unregister_family() isn't called.

This issue exist since commit 46738b1317e1 ("ipv6: sr: add option to control
lwtunnel support"), and commit 5559cea2d5aa ("ipv6: sr: fix possible
use-after-free and null-ptr-deref") replaced unregister_pernet_subsys()
with genl_unregister_family() in this error path.

Fixes: 46738b1317e1 ("ipv6: sr: add option to control lwtunnel support")
Reported-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240509131812.1662197-4-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 846c3abbcfb41..03090d1419d09 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -546,6 +546,8 @@ int __init seg6_init(void)
 #endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
 out_unregister_genl:
+#endif
+#if IS_ENABLED(CONFIG_IPV6_SEG6_LWTUNNEL) || IS_ENABLED(CONFIG_IPV6_SEG6_HMAC)
 	genl_unregister_family(&seg6_genl_family);
 #endif
 out_unregister_pernet:
-- 
2.43.0



