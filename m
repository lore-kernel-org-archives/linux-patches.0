Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548563DC857;
	Mon, 17 Aug 2026 14:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976372; cv=none; b=g1nJm+aPSKJefeT8ToWwdmbTd/oUa4FcU93rHcxC0c31puxrTgU9KKVNBxUbXiYaxRpxnn8v1TpP7HZdUFCz4ziheLd2iup5mWW4F3X1asmmZvoQk0U6556JCuXfDzscxaw+hohKOboOH1oaxcVnk1WgFKtjRpnxb2U1E1OlNMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976372; c=relaxed/simple;
	bh=Wp1iQ3zj1ZMk3unH1berjUvwPKkWzaPhOWxfnIJH+wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIK/VdEYoWHtQGY0Cjjdi27sT0z9A93KtCeJLAqWw5mCQIrgRYNv6RFT+X3/DV7B29f4Lav2wq7VXPPKfZVRz4QEZC1nV4q9/Oe+1GDOe54EVduNEWwCEs2bmYnONtWj0KdqwFkvut5WDDZNDnbE+wLixbxr3kmi4HaMAP6vVl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1CIaf3s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1CIaf3s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF691F000E9;
	Mon, 17 Aug 2026 14:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976371;
	bh=oPJVQ9X0+xiOPLrpWFK57/+oR7FkPs3smGIgbZrTJiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1CIaf3sq2Aaj6YdDWZa4AIc987QD2751t8a2VgY5SV+qk21u+VrQCfm3FD+6jf5N
	 qvsapENLjpRTUXYDJDyq14R+bONmBXJbB+cJAbZxJUK8hXx4CjjqLekzoxJk8YS8QR
	 j+7oU8A4iGj5U6EDjp4R+hRQeDxUqXXbqoN29C2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 349/389] ipvs: clear IPv4 options after rebasing tunnel ICMP errors
Date: Mon, 17 Aug 2026 15:33:08 +0200
Message-ID: <20260817132552.403009423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit e0ba936287dfe9783426aac27e5fd76fe35b38c9 upstream.

ip_vs_in_icmp() rebases an skb from the outer ICMP packet to the
quoted original request before passing it to icmp_send(). However,
IPCB(skb)->opt still describes the outer IPv4 header.

A timestamp option in the outer header can therefore leave an offset
that points into the quoted transport header after the rebase.
__ip_options_echo() treats a byte at that stale location as the option
length and copies it into the fixed-size option storage on the
__icmp_send() stack, causing a stack out-of-bounds write.

Clear the stale option metadata after resetting the network header.
Keep the remaining control block fields, including the ingress
interface used by the ICMP response path.

Fixes: f2edb9f7706d ("ipvs: implement passive PMTUD for IPIP packets")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6-sol Codex:gpt-5.5-cyber
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipvs/ip_vs_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1837,6 +1837,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, s
 		if (pskb_pull(skb, offset2) == NULL)
 			goto ignore_tunnel;
 		skb_reset_network_header(skb);
+		memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 		/* Ensure the IP header is present in headroom */
 		if (!pskb_may_pull(skb, hlen_orig))
 			goto ignore_tunnel;


