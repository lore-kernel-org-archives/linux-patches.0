Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C135D34D38B;
	Sat, 30 May 2026 17:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162662; cv=none; b=botb/iij6Z2af6AQClhQ7++TuiPGRfJpmk8+0gU72sDfzarHgk2Xorn0LInNVsAQq9VQdmsF99803LikYR7CjvO6MNSsqn0zPNlWoEAB8pMWHFIMyrHng3FdFUFYd9FIdu+hAwgF5yrfeUJb4e+8u4VE8wsrWCuB1nUjlb1XaiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162662; c=relaxed/simple;
	bh=AdbhM/AqASSHNjP0l81RTi6Zw92OzJFwPTm86mr59BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azCWYdKJST5d1YAeZNvlXq5iRAh6PaRrDMV+g/9E1mk8AE73Wd/mTWfmTEaTGLpZiCZlarMf1CBy2htO+hrpYDV3S2r/etZKLWoeS0xfcYiPcJgZDOVrALIEpQV2KwB515o4cusWH3mkPuxlZMBlrPrhNQapXNAo1WESFax9USA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJdonCaW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJdonCaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE6F21F00898;
	Sat, 30 May 2026 17:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162660;
	bh=U4EbAIxRZT4e8FuXJwIJCCXaOH+WlxhvsdjAUnvh270=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yJdonCaWUEYHwvvw2QTBc3Z61HBzfiPpo0a3Q9Oxe5fATf5t6ZxsyNM7n89rvHPsD
	 RHj6iruka8n12wIml+6JiAngEux/+khrI/vNw06gnSl4qdkeGev9EUaBEQsY1wZk8I
	 Zzja6eyD73nNzvdtag/6rQbJLShteeAkL3fFc9C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/776] ipv4: icmp: fix null-ptr-deref in icmp_build_probe()
Date: Sat, 30 May 2026 17:55:41 +0200
Message-ID: <20260530160240.970723560@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiqi Sun <sunyiqixm@gmail.com>

[ Upstream commit fde29fd9349327acc50d19a0b5f3d5a6c964dfd8 ]

ipv6_stub->ipv6_dev_find() may return ERR_PTR(-EAFNOSUPPORT) when the
IPv6 stack is not active (CONFIG_IPV6=m and not loaded), and passing
this error pointer to dev_hold() will cause a kernel crash with
null-ptr-deref.

Instead, silently discard the request. RFC 8335 does not appear to
define a specific response for the case where an IPv6 interface
identifier is syntactically valid but the implementation cannot perform
the lookup at runtime, and silently dropping the request may safer than
misreporting "No Such Interface".

Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
Link: https://patch.msgid.link/20260402070419.2291578-1-sunyiqixm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 0215e2510670a..4dae803fc7c71 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1108,6 +1108,13 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 			if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in6_addr))
 				goto send_mal_query;
 			dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
+			/*
+			 * If IPv6 identifier lookup is unavailable, silently
+			 * discard the request instead of misreporting NO_IF.
+			 */
+			if (IS_ERR(dev))
+				return false;
+
 			dev_hold(dev);
 			break;
 #endif
-- 
2.53.0



