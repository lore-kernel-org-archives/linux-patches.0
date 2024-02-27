Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C7E13B2B8;
	Tue, 27 Feb 2024 14:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043583; cv=none; b=AYecdkv2h668bL/Cv8mTIvkJTZDR1tYMtpEfr+TeGUuEFXlqZAwEFRTLfmBZyaKpHX/AXMyrMer2sP2mOhD30rXVh+I1M4tXeZLdMZ4UUy3aTA0yz3IqO6almSLOLN6nl+FbzMn2oXtP7W0OHwZsf/Ohjjb1cRT45M4ZR3UmQRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043583; c=relaxed/simple;
	bh=geZiu7Ho4ymIpC639d5Sq038iPbBe45FxyNoNgvCUlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BAGL+Xe5vfIK3oft3xgVFBZr2ANN3I0Oma6doxKHqgSR9e4BIZ7ANSzFHDMkU+9hMjlw8zfp0xmMgmcEEO8RaVXKBrNo1OjEZOJNSzUXOEp7PjYSWbiCNGS2qLGkd9iq3oFMhHY8NF/xX/muRtdVeAiX/zhXjZ1BO8eKzft+v6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GO+hn9dP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GO+hn9dP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FA7C433F1;
	Tue, 27 Feb 2024 14:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043582;
	bh=geZiu7Ho4ymIpC639d5Sq038iPbBe45FxyNoNgvCUlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GO+hn9dPGXkVFpB7lYW2bYzfiB+9divow3EMSf7lxy9Girx3MGerTbSPHamM+pYZg
	 8E/Sccts06h5zDdiQjIwIXMu1om9DdW7/go9Qhj8i7aPilwnwXBu9/oXIRSnNGBMpW
	 9DRpUO1sjEjWux2fHa7SkwMYwzg7SpAP3n4snULo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/195] ipv6: sr: fix possible use-after-free and null-ptr-deref
Date: Tue, 27 Feb 2024 14:27:00 +0100
Message-ID: <20240227131615.663052854@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 29346a6eec9ff..35508abd76f43 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -512,22 +512,24 @@ int __init seg6_init(void)
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
@@ -548,11 +550,11 @@ int __init seg6_init(void)
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



