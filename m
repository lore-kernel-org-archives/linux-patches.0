Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDF03D47CE;
	Tue, 16 Jun 2026 18:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633516; cv=none; b=a9gaMiLdTWCUJMhm13fHNA+sQ/u5wIqUWDADNzzHqCR6fE1+Qc7ARx2nliHSYi9bZhuYt+ZzRfAP+37rj4/onOuiQ4VIN8ndN02byWO8RdyDOVtoqBEOocGNRkakFQM8Yu2j6UviHkTrMFJkqFnzoj56EXtHsHkO+a6wFimEeL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633516; c=relaxed/simple;
	bh=cx/NPcODYvZ1nyuIfmICcQZihUWtlsydLITL6/Afl4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKDaJMj3GTb8NufBtPAcPPHJwJW8bQv0PPTDEy5zhMxurnVZnkreCDeKaXpMdTyEu0gwVRPKbm1m2A4us0wa2inX05OamhXCY4eQD5l8ina9jZrq5uHZfBDX+BDETBu7gBfRMbndQL9a1CQgwHAL+p1a61wCsOWLuOclkrBWz7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJYtTKJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJYtTKJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146CA1F000E9;
	Tue, 16 Jun 2026 18:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633515;
	bh=BI1d5jk2wz6N0eO3LN1LrUHrKiae0kE0k7ykLP+xz4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJYtTKJHKXJgUqtYlssBCkVyDm2++54uvtJnKICnyKwY7cFU5istiX9vsRqYHmtad
	 Z65v+SLD0dHxRcTcygyiGRrCus3WCazcVTt4WWv3jK4wVX9Crwan66RhiP9ClpeY7N
	 Pzv0ePe3HU8U7qYGSNymMsmqT/N8rbOeS2KPmpaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 086/411] ipv6: exthdrs: refresh nh pointer after ipv6_hop_jumbo()
Date: Tue, 16 Jun 2026 20:25:24 +0530
Message-ID: <20260616145104.824758790@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
@@ -183,6 +183,8 @@ static bool ip6_parse_tlv(bool hopbyhop,
 				case IPV6_TLV_JUMBO:
 					if (!ipv6_hop_jumbo(skb, off))
 						return false;
+
+					nh = skb_network_header(skb);
 					break;
 				case IPV6_TLV_CALIPSO:
 					if (!ipv6_hop_calipso(skb, off))


