Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E982733E344;
	Mon, 23 Mar 2026 14:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277306; cv=none; b=KjNe0qu6tAFGjEmdpm7Aa4mHq9NoAEzJolsw+PPtMb46WFEMwq6m7Pqz55wXBBAt3xFeo5VFqQGcjD4iYoBVsNuHkCGZLk0FhKTuo1SeyeX4n6+hzXsVl4E0dAMBTOeYM/el5M7n/TjShRKZwVuMVQk0tfUy/D520hFmxvaUq6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277306; c=relaxed/simple;
	bh=b8BYWJavuSZEkX0aSYg6SxWwOgGPqppq4DbIXHQIjyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VWs4U++w3gxNggxg4hl/TAa9mcmnpFe3PGJ532Qt01JpY2pCP/Io8OzTdgZqWrV0Vo5dpq3n5ycHuRNTAoaqxIXtKunboR7sqYb+he4o+0tfBxVOdxWAfY0Ww2yyWooXabgUrsNJ6yo2dvyBP6DymUsOpEIr8LFC8HBscXLyDHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J5O1Pxi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5O1Pxi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DACC4CEF7;
	Mon, 23 Mar 2026 14:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277305;
	bh=b8BYWJavuSZEkX0aSYg6SxWwOgGPqppq4DbIXHQIjyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5O1Pxi8+7mY/g4CZiKxt1ss27/lHBp8z1I/te5K9EVAQHHsrxgTOcE6XCtG0y/zV
	 Wg8ALtpJlYK/cvXNB+TKZfwf/0+trQHJWrjyxF+IgB6WELP3DbpyZR8j7PB3m9mTxN
	 xNMyzrw/H1eq4aJBwvOkU5kM3bL5ptgvxhNFIwH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 391/460] mpls: add missing unregister_netdevice_notifier to mpls_init
Date: Mon, 23 Mar 2026 14:46:27 +0100
Message-ID: <20260323134536.176513921@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 99600f79b28c83c68bae199a3d8e95049a758308 ]

If mpls_init() fails after registering mpls_dev_notifier, it never
gets removed. Add the missing unregister_netdevice_notifier() call to
the error handling path.

Fixes: 5be2062e3080 ("mpls: Handle error of rtnl_register_module().")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/7c55363c4f743d19e2306204a134407c90a69bbb.1773228081.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 3373b6b34dc7d..719dabb76ea21 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -2774,6 +2774,7 @@ static int __init mpls_init(void)
 out_unregister_rtnl_af:
 	rtnl_af_unregister(&mpls_af_ops);
 	dev_remove_pack(&mpls_packet_type);
+	unregister_netdevice_notifier(&mpls_dev_notifier);
 out_unregister_pernet:
 	unregister_pernet_subsys(&mpls_net_ops);
 	goto out;
-- 
2.51.0



