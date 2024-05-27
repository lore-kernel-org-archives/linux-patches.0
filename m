Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665C317E90E;
	Mon, 27 May 2024 19:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836946; cv=none; b=V+2BZbaVplZxDzfluiw5VPMaoYvCHF5rX8c6xtng0cAnUTn4g3Y/AsTRKSUpemj0ioddXR2b8mDkDIRxC4rki0qCzq5L2ur1pDseBCDS/hvdvizrrhV3A7R4jdz+Jjpy4FtGhq4sETLh36n1b/lyHJc6aqyRrsB16C9rHHyfnbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836946; c=relaxed/simple;
	bh=ClAPcjR1EF+OKhfpoRpv4O4s+e2kWdDb7NV0NcqdFBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXQfg1ZP+rZhZ3G7bvG0tV1S1cciPi8SzwQ/jAYKDZuOiaQ250Ic10d0rr/puYkG/36GJcUnkhsQLbwZXdLeYSZUbQLUx/8xHIzE+GiLSZaH7x2Pccom79Tdob8pATF1XA7nbQiKHCPDhOfUjpWf+JSiZrwWyFlSn8D+QXpG9qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lszBC19I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lszBC19I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2CBC2BBFC;
	Mon, 27 May 2024 19:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836946;
	bh=ClAPcjR1EF+OKhfpoRpv4O4s+e2kWdDb7NV0NcqdFBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lszBC19IYRDixTcFjDwCRN2Egh3SMORZI6RPZkdkhUeZQUv8INS6RYgZWbKbGZQ4H
	 ypTIdAeI48/mdam3tRYpf5vMihfHz7viTS5eX+2ryYkElqM4yYwhnl5FyLyeKOj1Yp
	 LmVQnZAU/8zaZq6qTb90Q3tcH0lvt3dVdyvHrkQw=
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
Subject: [PATCH 6.9 250/427] ipv6: sr: fix invalid unregister error path
Date: Mon, 27 May 2024 20:54:57 +0200
Message-ID: <20240527185625.894694605@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index c4ef96c8fdaca..a31521e270f78 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -551,6 +551,8 @@ int __init seg6_init(void)
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



