Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEFE81448DA;
	Thu, 13 Jun 2024 12:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280948; cv=none; b=K/LSk7KpifRQYUayr81+2DSprGiBedM//RLFAjoeiI4bVYZEedqb12WNuweMVM2B80C/lOk2LOeX5BqKRvY+i1jWbYshTj2hesAyFUIz0srtAYP4PzGr4jayv99mgqr8SE2s0FwcHyBBn9Q+NAXM7+99tRUb0Esd8OV+pKlMwmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280948; c=relaxed/simple;
	bh=viBtBybZDv7RhztIVqcHzRQ/vCXeW+AYDdqMXxCjAqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4k4UzFQ/iQDgTT3ILXSmfdPHf70cyA0cFivBZVkvkYVBD8K60VtPsSw0j+v1PBEwlLWJrUN+TnCLPausnPUdnPlocUciloTemZOzO9EethmxYmuRuHXoovQID3OK5m2vxLvGXXr/XUKDv1ABiuUUBSwmWeM+xbAzMOvH3qh5M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UWiM3E3Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UWiM3E3Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687C7C2BBFC;
	Thu, 13 Jun 2024 12:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280947;
	bh=viBtBybZDv7RhztIVqcHzRQ/vCXeW+AYDdqMXxCjAqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UWiM3E3ZuUrY+7iv7gtFfKQnd2F7SlZtVrTCsql2klOObWFzWD/Z9b8oDzjzPV4Z2
	 6Ruv5j3erYUlknmDlRxCdm0bjEXQjT8cF9AVMy7Wpg8lhbdpHoY/YTu+4idPYwTLKY
	 pf/AAUVDqti5toU42isNb++gaDMTYAKjeCuaYmBU=
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
Subject: [PATCH 5.10 088/317] ipv6: sr: fix invalid unregister error path
Date: Thu, 13 Jun 2024 13:31:46 +0200
Message-ID: <20240613113250.955282860@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 722bbf4055b02..77221f27262aa 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -490,6 +490,8 @@ int __init seg6_init(void)
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



