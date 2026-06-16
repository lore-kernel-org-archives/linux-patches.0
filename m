Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB96447AF49;
	Tue, 16 Jun 2026 17:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630932; cv=none; b=ntbXNH7Y+tF/k4f9dCw/DXDH4fI1JQhXCZJzEqBhQ9J9XOs24f3+F/4gAv/RbMSC77u90QuFWXrjdnc4MlQJWbobGtXbyCBiFC3SkvnPB1geVVeOAyFe0yFXJDHbO1DaXHCbHobK5g3L3xMreV+6JioGBhT700m1ZfzwUHvp8ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630932; c=relaxed/simple;
	bh=nq9TLO5wRXKB+LUBk/6y6O0qLkJwSUF5jLfvv4HGj/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pg5spopkwTA0C4oULr7MIpdKT1Hma0+9Y77kyuOuBJMM859SQPOnaCWll+hT4/YFwYEG5BNxaghX9yXZWHnQyORDJrTgqAJYI54n5krTFBSiElFNMF9hI4Sh4VE7DNISE+PSO+rTNJoBM8bOSPFBBxIP0mZL4ZOJLPPc0wYam98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nGF45zw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nGF45zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF0C1F000E9;
	Tue, 16 Jun 2026 17:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630928;
	bh=z5OYg9b+aHEW9al0Sakus8at2M0tpu90h3+40RACqNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0nGF45zwqu5dLZ9NjGbyojS/F3Qm/id2tIkuaI/d6gudsatAZbwW+cICcANr1cj2b
	 wBpBVEDgrIMX+ZEUlHESirrWFY6pZVCnM91Ckzz4aIzBC87gK3o5HmCbbTcQxEXNxu
	 HJKLo07S+hwNzX5Fr80E4IyPpunyO9fSpys63Ojg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Luxing Yin <tr0jan@lzu.edu.cn>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 123/522] ipv6: exthdrs: refresh nh after handling HAO option
Date: Tue, 16 Jun 2026 20:24:30 +0530
Message-ID: <20260616145131.745615837@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchuan Liang <zcliangcn@gmail.com>

commit f7b52afe3592eae66e160586b45a3f2242972c63 upstream.

ip6_parse_tlv() caches skb_network_header(skb) in nh while walking
IPv6 TLVs.

ipv6_dest_hao() may call pskb_expand_head() for a cloned skb, which can
move the skb head and invalidate the cached network header pointer.
Refresh nh after ipv6_dest_hao() returns so any trailing padding or TLVs
are parsed from the current skb head.

This matches the existing pattern used in ip6_parse_tlv() after helpers
that can modify skb header storage.

Fixes: a831f5bbc89a ("[IPV6] MIP6: Add inbound interface of home address option.")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Co-developed-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Luxing Yin <tr0jan@lzu.edu.cn>
Signed-off-by: Zhengchuan Liang <zcliangcn@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/7aba1debc2196189172499e5769802b026f8caf8.1779247873.git.zcliangcn@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -205,6 +205,8 @@ static bool ip6_parse_tlv(bool hopbyhop,
 				case IPV6_TLV_HAO:
 					if (!ipv6_dest_hao(skb, off))
 						return false;
+
+					nh = skb_network_header(skb);
 					break;
 #endif
 				default:


