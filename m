Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C9033F5B0;
	Mon, 20 Apr 2026 16:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700918; cv=none; b=BHFQ2vycQCRtMt8/pEV7PRlKe3PhSWaNxbYhH2+8bzjkEMIAnKSUnLV3QWwV5bKzjjIRGwUROUyiAM9xLvcrVouu2avTsJHzmPx136PCPA85EPbQonJ4ncP0f28EKMHiOuNw7gILRrZ9jqNbr5TBki+UfrjChO3LcdJO7BxuIK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700918; c=relaxed/simple;
	bh=kzSP35S04XBn/D34o3N+Xoj4ZaSGk8+PaNQ2AXS+vkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4qrLcafCPlOZaxQ1UKPFc86qfdSjuZLdpqexiL7RaFZlocbyA6/mmVPGKK+U8G9ywyFoWMGK4ii0kKeD0CbteaMtbWAsm2JkBIKiSy4e4wKkJ8MK85h/xE0T52i+t8y4HprYCT4oXAw2wCvmd3RYFJ6j4JG8hDnLLuxb6Ystog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xt9aZxF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xt9aZxF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30A63C19425;
	Mon, 20 Apr 2026 16:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700918;
	bh=kzSP35S04XBn/D34o3N+Xoj4ZaSGk8+PaNQ2AXS+vkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xt9aZxF0urHTeRP1LW/bRpd2itqdwOrWTfRuS0FB436yf9wF5xyKFOaAIM9Cg5KEM
	 Mg9u+86ETPGgv+idPW46lg1RUGCSaySszW8+0Bku+sArtng5FDGPyKpbeSVWDvuQ+V
	 MtyeFHF5OSOyNw31bZF/QYItMJ1Cgnymq7u5ylWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiqi Sun <sunyiqixm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 078/198] ipv4: icmp: fix null-ptr-deref in icmp_build_probe()
Date: Mon, 20 Apr 2026 17:40:57 +0200
Message-ID: <20260420153938.418034319@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b39176b620785..980aa17f3534d 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1145,6 +1145,13 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
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



