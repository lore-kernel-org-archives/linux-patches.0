Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0290643B6EE;
	Tue, 21 Jul 2026 22:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674217; cv=none; b=u3PVZ9VhgOm5LU4faQTsXQm6X7DY8ZaVUWFDEnL3dQjrNljUy9iFRUfGXZfpBf/PaUSssQkXwiZXfS6ZcX+nGCSojtInkZmI4eEyOWEfyX9sD7IshUwQv4pkiw2RxC04WxasrHTnYF7tKS5eBcz97ixgMmkXIPhxnGOW6/AJ1rY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674217; c=relaxed/simple;
	bh=S62bAvna5MIkdp34OZdBGdYbI5hF/XY5rvEysD2t/gI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ei0zo8+p6DgPm43knPL0lXLLh31cXcejtapcmOLym3HsmkW3UTuFRmu44CKpyQpyyKOmpNJjMhIi2f6iJmgJmWxkWVWWpMzu2Ym3E6AMYnAPQaxDK1OLmQq4J1L8LAMJGjzTMuJGAUPLx1D1ulLHlvbv/sm+6BpKxf8mnadP5jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlHbW3n1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlHbW3n1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25D6C1F000E9;
	Tue, 21 Jul 2026 22:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674215;
	bh=4GP5uKHpAqcN2Wwx2M/3KJyrUW7Tr3IjOnWxz6e+DiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlHbW3n1WK4ObxB0414GTJdBl9PlCMgSnDuSAn5J2zs/9U2FMMB9zmX83hO/SPerY
	 VNltms/xfs9Y4kAfryLe8IRrJYucNAXnzO85I/do9jcTH2Z8q0935aRcZso8sb/LrR
	 NJ/DjxjMOdEnuEBVo5q4KG1Gd68pqDXkEDeriaoY=
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
Subject: [PATCH 5.10 450/699] netfilter: xt_nat: reject unsupported target families
Date: Tue, 21 Jul 2026 17:23:29 +0200
Message-ID: <20260721152405.851437227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
 


