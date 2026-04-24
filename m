Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE6919A288;
	Fri, 24 Apr 2026 13:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037703; cv=none; b=log8qkDwwf9YYunXZ5qRtOOygGwXpMBU2vWelNzfLhCgcgCK5JmCrc1Z+gsZW6vC/8AvSOl+rdw6LzeUzewBrpMXHsblCpBC8yE3qpMUPlgrUpiv9M+qvu9ZQ7tXDqbR+lGtcCR+rnvzicUj1JP0kbktRx1m3jH7rPs0l+/Abgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037703; c=relaxed/simple;
	bh=uHkrnxVVhEn0n2fbikv1Sk8t7fXdW5tsUZ1q1Hcwm2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rs7Zwuukw5SoJuvm11rZ0cxQf+PH1jc5mSclI15rQU1fxg9+x3O862lKmxmVui/X88henLWZE5SxNEZgs3JJvuDJlkzicWH5aOoWW0/orzWmL2KXWdJciiD1EbZ4BHK1owTF0j0OnZaFKe13S5biksX3YVkVJxnG/jfyVk7aWnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKk/+O2G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKk/+O2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D51EC19425;
	Fri, 24 Apr 2026 13:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037703;
	bh=uHkrnxVVhEn0n2fbikv1Sk8t7fXdW5tsUZ1q1Hcwm2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKk/+O2G/617MzUoEsmfOxtZfXoOPHNk1+vObscnb8lEsEkEn0qnWOX35Na0yuz58
	 4i7WqSnHSDKMGiqQnu7p/6C0kgxTNJQtqV1QXytnZ9pf3TBbLmDYNGROFnAl/FEESe
	 DggClxkj8eVbXjqa2USOhHit1gowAFs2CzvcBw2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 037/166] ipv4: icmp: fix null-ptr-deref in icmp_build_probe()
Date: Fri, 24 Apr 2026 15:29:11 +0200
Message-ID: <20260424132540.622880595@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 64a0bc633a3eb..3171392c8c066 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1136,6 +1136,13 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
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



