Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1533417D7E;
	Thu, 30 Jul 2026 15:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425088; cv=none; b=des6wMkhXEIJJZqEdSJk0GRe0xpQxB9HzPUStp8uNDL4nUDAJY3zPlNdzJ7DlJx0W2ZA62AMn0TbgXFvJ1A6LxX9fLDyBX7SJJc+YdS3gtIBtopuC7GNMprbbmmj9d8nfl790Nt1LWlGoTxlwYslQq3fyUKCeeL3U0KZo1XaHUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425088; c=relaxed/simple;
	bh=M8nwfrX8XSF3gq07kz1bz/J2DQYnoxxBNaTi4jLFrC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmI/O6/74qRprJuz4mWkPDyGCwu3vo5L0Q/30lS5+bQ6Tgrs90x4HKej4ZPIqPD6tRw5iBRUjyQIvCdtxACAgNDlUvgnnEj1SFm1NDLS5lmIK+1EKFLx4ZV8YvsBGGb0rgbMPYDBt5GAm0XLRYHWT3oPVkj0FQt/LS8+zW1UzXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAbyWfmu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAbyWfmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AB81F000E9;
	Thu, 30 Jul 2026 15:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425087;
	bh=bL/wGX8a/4D2Cmwn7b6NbFgdUWORbCoRLgvBFa3JgE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pAbyWfmuYbPu2XIKQ61GsWl6/kNOhEvPg0OXtRgNtgl9ffJ/Pze1poXu17zD9j74S
	 7koXqFKithF+Vfc18fFSNDJLvtGso9/fgoyV4X5KvDKq1P0noT9Bq8l3MGjFdgbi6k
	 9L1MNV4NZVzEU66r1X/VstVu+vyt0WEjPC9MZWd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ren Wei <n05ec@lzu.edu.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 621/675] netfilter: nf_conntrack_sip: validate skb_dst() before accessing it
Date: Thu, 30 Jul 2026 16:15:51 +0200
Message-ID: <20260730141458.318934252@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e5e24a365a5e024efef63cc49abb345fbd4852c5 ]

tc ingress and openvswitch do not guarantee routing information to be
available. These subsystems use the conntrack helper infrastructure, and
the SIP helper relies on the skb_dst() to be present if
sip_external_media is set to 1 (which is disabled by default as a module
parameter).

This effectively disables the sip_external_media toggle for these
subsystems without resulting in a crash.

Fixes: cae3a2627520 ("openvswitch: Allow attaching helpers to ct action")
Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Cc: stable@vger.kernel.org
Reported-by: Ren Wei <n05ec@lzu.edu.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_sip.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -947,7 +947,6 @@ static int set_expected_rtp_rtcp(struct
 			return NF_ACCEPT;
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 	} else if (sip_external_media) {
-		struct net_device *dev = skb_dst(skb)->dev;
 		struct dst_entry *dst = NULL;
 		struct flowi fl;
 
@@ -969,7 +968,11 @@ static int set_expected_rtp_rtcp(struct
 		 * through the same interface as the signalling peer.
 		 */
 		if (dst) {
-			bool external_media = (dst->dev == dev);
+			const struct dst_entry *this_dst = skb_dst(skb);
+			bool external_media = false;
+
+			if (this_dst && dst->dev == this_dst->dev)
+				external_media = true;
 
 			dst_release(dst);
 			if (external_media)


