Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575F22D3A69;
	Sun,  7 Jun 2026 10:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828745; cv=none; b=O72GDBujfApoekBREw7uz7InjjAh9ghdt/VZdsh1EyTvq2LRkdpKdQ72RM763oOeZAjeaU+lGyeryFOn3BfKu2KnyY9i63OEo3OPzYt5jAvjf0A2soY3XcvPLuEvhbPP/Vnr20G1M4tOwTpFuS5LK9TIdvgI1I4zeY8t+++mQmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828745; c=relaxed/simple;
	bh=UuVD0KPtTt9FaBu3BEbfFGUGxPWF77fQzM421rRqhZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URTCFlOEAGL+GVscamO8wo5lVafaDIRnGwtDKP3GqSFm1EQYRyHcTG4A5x1chnzB246OxMEkbdiGgKFJ4+XDUeBcPlscFpNhmaXSKAW1g5t16ZNMoAlk70wGfJQcfcg7wlAcFQ7RzuR/DnDvwciOo/05nOV0x89+k1zhpB2J20c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZwiul12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZwiul12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E971F00893;
	Sun,  7 Jun 2026 10:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828744;
	bh=WnLbhKwmveuBsCA0LqjtmrB24aIdAlFZWhq7tLzaLDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZwiul12ezjtNIbSQDvY+zl5k5H8kh3iReJXFt/lq9QR3Wabfx778HOlbsEePjW/s
	 O7QnDgBtVgGoZ4KKMp8ycbo1/KEzK74X28r52GMkfeznxg/j1JioAmZWNusJX97Dsb
	 ehnX/dbjg30+pfrP5l/dY4qbq7/v8UxIFKiFuOdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 187/315] ipv6: exthdrs: refresh nh pointer after ipv6_hop_jumbo()
Date: Sun,  7 Jun 2026 11:59:34 +0200
Message-ID: <20260607095734.448782006@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Justin Iurman <justin.iurman@gmail.com>

commit d47548a36639095939f4747d4c43f2271366f565 upstream.

ipv6_hop_jumbo() calls pskb_trim_rcsum(), which can change skb pointers.
Let's recompute nh pointer to make sure any change won't mess things up.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Iurman <justin.iurman@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260522112013.12342-1-justin.iurman@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -184,6 +184,8 @@ static bool ip6_parse_tlv(bool hopbyhop,
 				case IPV6_TLV_JUMBO:
 					if (!ipv6_hop_jumbo(skb, off))
 						return false;
+
+					nh = skb_network_header(skb);
 					break;
 				case IPV6_TLV_CALIPSO:
 					if (!ipv6_hop_calipso(skb, off))


