Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E4324E4D4;
	Mon, 23 Mar 2026 14:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277324; cv=none; b=Jv6kDFnoou/BhTdtpLcEk1eF7eXHPNcGwe/j8vF//vFYpxhl7t6PAQFYPkARfydIpa5Z1K3IqUCYeWg4998HU3es9AiCTwrhnvvSB8ByziIxWUVcsi1h+MbS35rZ62NKylHqLF56MLUVV9ZL/T/ywHGmLTSFm9vjPmFP68gV5PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277324; c=relaxed/simple;
	bh=XhI2NC7a4JiFIA33LWJtC4ZeS4b5ovL7i7xlSqZkS3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brAsvh489l5qBVXbB6tbL1OrOXhW/p9j3GI3ruExtWMNrqgbVodEL52Bf0wjd/5ed38MFCEe0z+YoQqeMws2wnAN+GyR+EbSEXYZjA9FeuxbKQUXOeGIYS5m64rTGCKO2tNLaoN3UXMg+Du5mgw7qWUl8jEreGY0Ta28sPzVC8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrxUdFoU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrxUdFoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A784C2BC9E;
	Mon, 23 Mar 2026 14:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277323;
	bh=XhI2NC7a4JiFIA33LWJtC4ZeS4b5ovL7i7xlSqZkS3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CrxUdFoUlo54sSjOsx5ayyEWwX6GdFdGeEwo+aQkx7lOzVZC+zpb0snoUsvp3Fsb4
	 kCGDZOXlp0dFAVwooV20xvxGRfy+aQqf1nHIPceP/QcTEyQ6kUrFxhQdd2yKI0krSk
	 NMDZGuCrSqnXobxlgfZEaRhXv1VZzQcWBbOzamJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 398/460] netfilter: xt_CT: drop pending enqueued packets on template removal
Date: Mon, 23 Mar 2026 14:46:34 +0100
Message-ID: <20260323134536.345309064@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit f62a218a946b19bb59abdd5361da85fa4606b96b ]

Templates refer to objects that can go away while packets are sitting in
nfqueue refer to:

- helper, this can be an issue on module removal.
- timeout policy, nfnetlink_cttimeout might remove it.

The use of templates with zone and event cache filter are safe, since
this just copies values.

Flush these enqueued packets in case the template rule gets removed.

Fixes: 24de58f46516 ("netfilter: xt_CT: allow to attach timeout policy + glue code")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_CT.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 3ba94c34297cf..498f5871c84a0 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -16,6 +16,7 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_zones.h>
+#include "nf_internals.h"
 
 static inline int xt_ct_target(struct sk_buff *skb, struct nf_conn *ct)
 {
@@ -283,6 +284,9 @@ static void xt_ct_tg_destroy(const struct xt_tgdtor_param *par,
 	struct nf_conn_help *help;
 
 	if (ct) {
+		if (info->helper[0] || info->timeout[0])
+			nf_queue_nf_hook_drop(par->net);
+
 		help = nfct_help(ct);
 		xt_ct_put_helper(help);
 
-- 
2.51.0



