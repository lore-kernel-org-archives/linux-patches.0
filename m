Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31813F7882;
	Mon, 17 Aug 2026 13:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974276; cv=none; b=ah3zLYWqzFmc8cyqT5bM/FN1jqNFAZlXjhwAnMlEt06+mVplAp8JndA3IrMIFkAkdHnuBEDoFCusIsB3WQTYmt3Cvp6jTy9tky1gJxOEa3bZ0iYN0iNLpHPXgv29b0P+dgEzfb0kwDQWGAXi/miJ1yleX7x9fiL1+GupuoMXlkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974276; c=relaxed/simple;
	bh=YQ75OoX9oPBTUrHJZDJRke4qnFAgYnxVSVmkWm1366Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMhzg3Ouz5Pux1dng6DrP8ftwDJZzkGSPCtR2y2MK+evFAki6mVMZKeb95oR4VSzVhGMwYHP9Zs8XbaWfp4lbTn6AcKN9l+JMMOVrW6TUeZrugI+3CjDa6dX2acJKIjchVWrXzYgmm5aoTUZ0B9DYfAhi3Zl08fUrKVpP8UxjG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Let3sxD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Let3sxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CF51F00A3A;
	Mon, 17 Aug 2026 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974270;
	bh=r4v9U5KmXb08ani9myVj7mzkqGPjqlM8ldBBR4DWkOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Let3sxDIjD8sH5FZi6XiJ5g5txVfKVB9I/c62yr0UZLMRbKZXPiDDSjmlgpmETxI
	 uANa+EH98QFESOUJIlWIZs5yHG4dX8TGO27orQ1X+UV9dAdLABnB0j3JFXwevIIjHv
	 JDipijPQRNfbhzsZkEqTobb2xpWHCKYPDwiVcbKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.1 148/271] ipvs: clear IPv4 options after rebasing tunnel ICMP errors
Date: Mon, 17 Aug 2026 15:31:13 +0200
Message-ID: <20260817132542.958930640@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1950,6 +1950,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, s
 		if (pskb_pull(skb, offset2) == NULL)
 			goto ignore_tunnel;
 		skb_reset_network_header(skb);
+		memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 		/* Ensure the IP header is present in headroom */
 		if (!pskb_may_pull(skb, hlen_orig))
 			goto ignore_tunnel;


