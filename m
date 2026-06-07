Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC34D1E98EF;
	Sun,  7 Jun 2026 10:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829031; cv=none; b=UkVOhOAPDrIUcbgcey/hDR2BzjcGbN6gDFcNHx8vbMV7eCFW+KxM72H3cU8ASqx59KX/O9Hj0O5SKG8CAIG+LyXHJc/6bzSqg0DgOnhv1Y9J6OvDnTYIulWgddViFTHA922lWhz0TvboKjRIXBL5W27xr4VW4AZ/LVrHIOCKVwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829031; c=relaxed/simple;
	bh=whFJa1RQ7ersFtUbyHInAOE21L1T6PCQRgeIh7Dnmrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikY2l0aMmNl0mbZ+fv5LtzJfCchPS1LtSgz3hDdTMJT/Zvbu5RpAuwC0dB8z/S1E7JOkSKd91nJFXUF2iAdDnPHLtRWAjR7RcoRltn5MErBVqW6zhnIiVbLEzxlbIZcUseK9Rr9eD18M/PuXiBp/Wt2YPZ86Ap3H/6f0rCWq39I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ao/oKCCN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ao/oKCCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DE31F00893;
	Sun,  7 Jun 2026 10:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829030;
	bh=EPfP7hniqJdSu3oaLi36efEsm0SRHBw3A6E7+0Y/HB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ao/oKCCNPziNHWg+1hZ6l6NwWuPE8EilOmJal1hm1fnq6AdA2wIR9BosUwu5A+FGN
	 nVuHiLo//OO+LVDDAkJgysjAqJ1XrOeV53TfP7OH+UzaNR8glcHv/OR0335AA4AQK1
	 REetB7dHuTVVvI1zZ4yd8kJLTANheJYTx9KfHpdg=
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
Subject: [PATCH 6.12 188/307] ipv6: exthdrs: refresh nh after handling HAO option
Date: Sun,  7 Jun 2026 11:59:45 +0200
Message-ID: <20260607095734.623548073@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -203,6 +203,8 @@ static bool ip6_parse_tlv(bool hopbyhop,
 				case IPV6_TLV_HAO:
 					if (!ipv6_dest_hao(skb, off))
 						return false;
+
+					nh = skb_network_header(skb);
 					break;
 #endif
 				default:


