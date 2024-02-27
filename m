Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798A913B29C;
	Tue, 27 Feb 2024 14:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043066; cv=none; b=W8EjOa2SEfghxRLLnJL2mZjMUmkgMnWYMsAQG531xnvAAxQd2ZAQtottbw8SKck6RmliQI8eE51i3Kn/vQnBkVvW74/1nyFLH8505ZLngCIqA+TOC/rpmw5pnDPqcHhC+MwU8rhCEaSVuyUUPHTlhoUg0UHLPjYF6K04lQGavks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043066; c=relaxed/simple;
	bh=jkehg+eXcDioMsPphQP2MpdCeS3Ex0BiC9A/5AkwxAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiC3Yto3xbSJUO5cMD3CP+5qOAiYg82Cta4xu24GQVi3+C/mY3PlnaEOD02du4hUAcf7aZsfnAFSwwYPXREm/uLOGYKbLEHAhcd2lbe2rx7CI5385QbviEwMMzKWOiIdmBzJX8DQe7poXDH1dUsVZCddarnnWsVZW5boR6LGIRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=srwGCqsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="srwGCqsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083B9C43394;
	Tue, 27 Feb 2024 14:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043066;
	bh=jkehg+eXcDioMsPphQP2MpdCeS3Ex0BiC9A/5AkwxAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srwGCqsr021tspbE4yCE18dn4+jd6qtQqoL5EzmFSp8RWPaGfwXdxra1/jQg5VB5w
	 nCxHneKPqfFGTgccrIwxeidT5FPN+zRzgx/DbRcZte3ni2/NlFLvMzy7jhF3MGJ/60
	 0cJiIKr22ZeT30wIRFw9vdEGyY3RqK9jg5oQFjiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 222/245] ipv6: sr: fix possible use-after-free and null-ptr-deref
Date: Tue, 27 Feb 2024 14:26:50 +0100
Message-ID: <20240227131622.408368232@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Vasiliy Kovalev <kovalev@altlinux.org>

[ Upstream commit 5559cea2d5aa3018a5f00dd2aca3427ba09b386b ]

The pernet operations structure for the subsystem must be registered
before registering the generic netlink family.

Fixes: 915d7e5e5930 ("ipv6: sr: add code base for control plane support of SR-IPv6")
Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Link: https://lore.kernel.org/r/20240215202717.29815-1-kovalev@altlinux.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 0c7c6fc16c3c3..dc434e4ee6d66 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -507,22 +507,24 @@ int __init seg6_init(void)
 {
 	int err;
 
-	err = genl_register_family(&seg6_genl_family);
+	err = register_pernet_subsys(&ip6_segments_ops);
 	if (err)
 		goto out;
 
-	err = register_pernet_subsys(&ip6_segments_ops);
+	err = genl_register_family(&seg6_genl_family);
 	if (err)
-		goto out_unregister_genl;
+		goto out_unregister_pernet;
 
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
 	err = seg6_iptunnel_init();
 	if (err)
-		goto out_unregister_pernet;
+		goto out_unregister_genl;
 
 	err = seg6_local_init();
-	if (err)
-		goto out_unregister_pernet;
+	if (err) {
+		seg6_iptunnel_exit();
+		goto out_unregister_genl;
+	}
 #endif
 
 #ifdef CONFIG_IPV6_SEG6_HMAC
@@ -543,11 +545,11 @@ int __init seg6_init(void)
 #endif
 #endif
 #ifdef CONFIG_IPV6_SEG6_LWTUNNEL
-out_unregister_pernet:
-	unregister_pernet_subsys(&ip6_segments_ops);
-#endif
 out_unregister_genl:
 	genl_unregister_family(&seg6_genl_family);
+#endif
+out_unregister_pernet:
+	unregister_pernet_subsys(&ip6_segments_ops);
 	goto out;
 }
 
-- 
2.43.0



