Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CD83876CF;
	Tue, 16 Jun 2026 16:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628595; cv=none; b=WRnoRMCMBL9Z5ukYPA/NDsPtdafznAdK132Zt9YSZ8rP1dtKrXwC2biKY+hEPWDKWDQyrKCTR2YDh1uCzHm5dZnU6fE+pkimPsVTJvVIN8j9Bu97a3UTwC4c5Ba8/FLs/xDd9spfJiCV/RML9BCIJ0g61K9PWBV8KuReWdGZpuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628595; c=relaxed/simple;
	bh=qSHyr3b6sh36EDp8GFzX3U/b4UunvpLZBMewpuwFjGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6Rl6+zrmDIoEWUXgi2nPXY2oSn/m/EoSTHM7G4/uJ5e0TZiAYNBDJFtvHlMjEUEm/yDybT1B0g4oCKmDQEel1cRYe8D9E96qdkocNp3XJJrR8EkdYBbdGbFfr+3sytEZJq+7uzLkgpxgNvlb7RWpgkR4JpKVAfnCUAEJnJRh4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+yX8EtB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+yX8EtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 934CA1F000E9;
	Tue, 16 Jun 2026 16:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628594;
	bh=g3m53FX2ek1iYTTzSMNCZsg9Qyd26ai0Iaz698Fa4CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+yX8EtB/VppKCJLcgv0HphN+oZ/ta2uKlgwiDFvhePaLg/gyI9VwwNSTYqpx9Ap4
	 2nt2uDIUmJqpnBVskb7C/0t48X1qqmGApmszkXuLKXFT1SQOdMo17o3Ovr2bUefcXG
	 TH4K6+etHhaW7wX8SFzUG4C0dO36nSrk3gdnGP0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 126/452] ipv6: exthdrs: refresh nh pointer after ipv6_hop_jumbo()
Date: Tue, 16 Jun 2026 20:25:53 +0530
Message-ID: <20260616145124.365565510@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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


