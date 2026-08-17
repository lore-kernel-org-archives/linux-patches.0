Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9183839EF05;
	Mon, 17 Aug 2026 14:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977668; cv=none; b=dM0LPtm+vbyWSk7VZKmkN69ApgrwcnSc0tx71IHT2685hz0sE8150HryU3WVj2lTwj2J80cDSCWw0cIoKE6w7uDFWxTA7GYKTaHuf+MJ+fUc+Fs9x4K54/YlORui6ocusecU2usGY6UJDKXZXJZ18nIYRg2kaUpxdZpwJpcuMNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977668; c=relaxed/simple;
	bh=II8tzgGY6ALd0wyMjwiHbjolo1BlzzGy1j4JaSNsvNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uOK3GHE32uLOnRQJGlwGhwrzVsCgdHI5t+U+M5g4YIDfzBm8aWbgeh6cz14WStMD9BZW6ygdh0oKQcF/HSDYUC6Of0CfuwwIXPL+K1r7hL2WBeHS/aN27u6bMsieOoT1IEOiVT6xJRg246u8O/uinlGECfrzGcNMzdlZO1NNggg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0i8FqdL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0i8FqdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9DD1F000E9;
	Mon, 17 Aug 2026 14:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977667;
	bh=ncM4kiVpT8xeqxovPZfi8HTFVzW57f2XR5HkGxNWl+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l0i8FqdLHdmAaGw7lTFbUHxud8LOGzNbu4fKkVvQfpdsE1egm+WfOB1dKAGKDzkq/
	 X02AYL+rZ4i2o8iqMLHopJIG4fGcnWCeD2CiW5m+P/HBFqE9UtScmJTGF4rQ5aALjZ
	 SXpXvSwVjij5sBCKopfcOfxQHedRog30wEVIfET0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 409/456] ipvs: clear IPv4 options after rebasing tunnel ICMP errors
Date: Mon, 17 Aug 2026 15:33:19 +0200
Message-ID: <20260817132555.268402068@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
@@ -1825,6 +1825,7 @@ ip_vs_in_icmp(struct netns_ipvs *ipvs, s
 		if (pskb_pull(skb, offset2) == NULL)
 			goto ignore_tunnel;
 		skb_reset_network_header(skb);
+		memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 		/* Ensure the IP header is present in headroom */
 		if (!pskb_may_pull(skb, hlen_orig))
 			goto ignore_tunnel;


