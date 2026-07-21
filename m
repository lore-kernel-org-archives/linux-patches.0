Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33D53644B3;
	Tue, 21 Jul 2026 19:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663556; cv=none; b=OpJH0VTCfRPG6/t6iEslHi775ufoO6tU6//CrASbm+TROHsWZbhFL/SAVHFo+j6Rl7ujyndtL2AaxVlIS+zE1la1NJwTyhIVCsgrba3wxHBCKe4/4V+sMct6Zwgc9Y3WwxNkoXGICnjzojWCYU0JdWdi3eOBZunMjfgw5dlTRF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663556; c=relaxed/simple;
	bh=QGRYksqueHtEzl8U1OxQt97zLhxCWRsaA8jJy8CmyK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Do3qAZ69nA9H/4K9VMjhzFWEssLh46zYRPTORTxZzTzeuckswHyAzB+Xef2CMO8FC0Nr1sFRnAfsnIa+AJ59ov4oFJww6JlEtZLMwiAlvkEKpmszlZnvqjZsnQ3spq2fvDxOa/jE8qOtTtT+rgfOE1Yscn/iExPOFXey/2uGwKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xKMmN+sI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xKMmN+sI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD801F000E9;
	Tue, 21 Jul 2026 19:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663554;
	bh=Fq4mT0uZnpwJkASU/wu3CFzeaODpvJYI8sJGnFJm/lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xKMmN+sIwbRXErBxBxyzcbEe6XSl8SKvHWIx/talAcKm+eCCIj9O+vMJYey+WNV1W
	 et+k2xF6SV3nRICNiIHboHyj+9codkAXuQg69EBtih4d7LxLo7bFtZSBgiuGtwIh0g
	 MoLfz+40iXx7ewsHCYISSK8s+9Ia24H8DaeJx5G4=
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
Subject: [PATCH 6.12 0866/1276] netfilter: xt_nat: reject unsupported target families
Date: Tue, 21 Jul 2026 17:21:49 +0200
Message-ID: <20260721152505.430258669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
 


