Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CF54418DB;
	Tue, 21 Jul 2026 22:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672321; cv=none; b=DR0am431GjZG6A4R/Q/7FbrM/DVvMkscXIkz7hvBeGY8v3GcxEVVkf5w2GsxzkJK59g1Jmk6jbQ463/Y9mqjn6UcL2v2IkQbkH1BL9RxomHs47fhlrrog5IMFIu4W+70duzdeqvKNJxEPYbvuQ5dQqnaK3ZE3ZG9fwEZ7/XXHlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672321; c=relaxed/simple;
	bh=BesDGHQdhEEMyV2wHgCXgERvSd1jXpXBexO3p+Qppvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I2gtcCQf3SeRiXs/rE0sZ1IUVc5bnTZnkUxAJ7ycuEkwTu4GUFVioSFk/mPLsuWRenhepBxUuC7WMDmZcvzZDv2QQlUywi8cPrUQTJyO6krg0JrxHm2Tn+iY2NneKrcgjtPnTZyzfnCpA633FTp7KIdgt5s9fctYetdBhIB9f+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0vyt1PLJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0vyt1PLJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA041F000E9;
	Tue, 21 Jul 2026 22:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672319;
	bh=GEf+kdtEKc77AjkQDwllXRKTZawxYeBIN88NiUuTJV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vyt1PLJU7MeIyBqZWQSJ3i8aYJ2Llj/mXPs3AEE+Zu3yxPlw8tLCHcDj0Lc25fFr
	 zp9NkP+YvSLAYZ4MM0y0i4qKONDGWbyjvZZaUseXr49XxOG4Pm96PB2pO28gzqGhC6
	 1yBFWzoy9LzKbQZKfXu85r/Wsj6oj5XGvVrk+xq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Zhengchuan Liang <zcliangcn@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Wyatt Feng <bronzed_45_vested@icloud.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 5.15 578/843] netfilter: xt_nat: reject unsupported target families
Date: Tue, 21 Jul 2026 17:23:33 +0200
Message-ID: <20260721152419.050107616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Wyatt Feng <bronzed_45_vested@icloud.com>

commit 5d1a2240935ea47e2673d0ea17fdb058e4dc91dd upstream.

xt_nat SNAT and DNAT target handlers assume IP-family conntrack state
is present and can dereference a NULL pointer when instantiated from an
unsupported family through nft_compat. A bridge-family compat rule can
therefore trigger a NULL-dereference in nf_nat_setup_info().

Reject non-IP families in xt_nat_checkentry() so unsupported targets
cannot be installed. Keep NFPROTO_INET allowed for valid inet NAT
compat users and leave the runtime fast path unchanged.

[ The crash was fixed via
  9dbba7e694ec ("netfilter: nft_compat: ebtables emulation must reject non-bridge targets"),
  so this patch is no longer critical.
  Nevertheless, NAT is only relevant for ipv4/ipv6, so this extra
  family check is a good idea in any case. ]

Fixes: c7232c9979cb ("netfilter: add protocol independent NAT core")
Cc: stable@vger.kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Zhengchuan Liang <zcliangcn@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Assisted-by: Codex:GPT-5.4
Signed-off-by: Wyatt Feng <bronzed_45_vested@icloud.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/xt_nat.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/net/netfilter/xt_nat.c
+++ b/net/netfilter/xt_nat.c
@@ -26,6 +26,15 @@ static int xt_nat_checkentry_v0(const st
 
 static int xt_nat_checkentry(const struct xt_tgchk_param *par)
 {
+	switch (par->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	return nf_ct_netns_get(par->net, par->family);
 }
 


