Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65562E3B13;
	Tue, 15 Jul 2025 13:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586655; cv=none; b=GoMZiuFEXdJU/1Erkcyi+k+ASZDBON/1CtbXKmfTFUGHxTOJ8S4zhzZTrHaFfdEYsyOD93JN9WczuH7cDA9ShOdUb2s+gR6PsFI4fl9Xs2aY3baBI9KraltgN+HEwkV4AOVRkx9HKOqS5Ywn3Oq0zi/SWfAXOhj38QqNEFkKgyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586655; c=relaxed/simple;
	bh=T35nPW0MydciyY67m6fyt3acuKE48fX+yZbF6qlYFT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+Q0Mp/gr+rq8sqC0VkQOBDuP3owfFopRQ+D2EieE0F5zPYloPwkK7wIAImd1T9+BMjtPPF6WX5hDFfCb+beUhqRR6osod6pycVbgcO4eN77gAJvfgw36qtPDAIZ14s8vLJhZ01gDvngnDauHDtYNdit4uN8+D7IAMEBpnbZAkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqnI77ak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqnI77ak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465B3C4CEE3;
	Tue, 15 Jul 2025 13:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586655;
	bh=T35nPW0MydciyY67m6fyt3acuKE48fX+yZbF6qlYFT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqnI77akZkQloOrSO5HvFx6GEJyt5R5T4peTwc2xAplV/gBNXkgsn2KNeuKkkRRFn
	 who+idk4ioURZLf6qaZiBaL08gkk64fnNrnU5rlvG4MQuBb3it+5Cs3zrOKo44zu6+
	 YqIKiSdUX80yFclXAvERUfQi6zImolClNJ6KOyIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georg Kohmann <geokohma@cisco.com>,
	Jakub Kicinski <kuba@kernel.org>,
	WangYuli <wangyuli@uniontech.com>
Subject: [PATCH 5.4 148/148] net: ipv6: Discard next-hop MTU less than minimum link MTU
Date: Tue, 15 Jul 2025 15:14:30 +0200
Message-ID: <20250715130806.198532958@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georg Kohmann <geokohma@cisco.com>

commit 4a65dff81a04f874fa6915c7f069b4dc2c4010e4 upstream.

When a ICMPV6_PKT_TOOBIG report a next-hop MTU that is less than the IPv6
minimum link MTU, the estimated path MTU is reduced to the minimum link
MTU. This behaviour breaks TAHI IPv6 Core Conformance Test v6LC4.1.6:
Packet Too Big Less than IPv6 MTU.

Referring to RFC 8201 section 4: "If a node receives a Packet Too Big
message reporting a next-hop MTU that is less than the IPv6 minimum link
MTU, it must discard it. A node must not reduce its estimate of the Path
MTU below the IPv6 minimum link MTU on receipt of a Packet Too Big
message."

Drop the path MTU update if reported MTU is less than the minimum link MTU.

Signed-off-by: Georg Kohmann <geokohma@cisco.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/route.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -2765,7 +2765,8 @@ static void __ip6_rt_update_pmtu(struct
 	if (confirm_neigh)
 		dst_confirm_neigh(dst, daddr);
 
-	mtu = max_t(u32, mtu, IPV6_MIN_MTU);
+	if (mtu < IPV6_MIN_MTU)
+		return;
 	if (mtu >= dst_mtu(dst))
 		return;
 


