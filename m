Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC02C42AF95;
	Thu, 20 Aug 2026 16:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244155; cv=none; b=tlzra4bXhsT1mF/VomodEBk7OokZrnf83A2SSy74+7+6697Q1jMXgASiIEpy/yGx0oyWyAZvcOjDb94qi8OjETcOmCjex4A/RVa0Cy0jp8M6Uas0MnAuVox90ffaPPB80u7AUzJoLI7wjSCOQmI61kBq4B2ONzCgmTMvsFqrVf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244155; c=relaxed/simple;
	bh=5f7P3778Cl4gsdDpUYSaD+Yz4Az/VmBgysZNetHntus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6KquiiBFMemqVi/8zNO856S0Lhgbg9lLGz2ShnSmAmBnO4VgQCM8uasYtF3xolmfyJJDIUdshbbmNifEk1yRCQ1irDY+GDEkhWcczaZf64VWgA2D7kVleo6IlRaCtOk8oUyju5u5XDaF2GefKXPKQPwxQXfaTpPP70cupxHThM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUOgRWsS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUOgRWsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4339B1F000E9;
	Thu, 20 Aug 2026 16:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244153;
	bh=KO53i3YFmkLwmBv1NmdojdPNkwHaDYGh+9SXaJ4PinE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUOgRWsSCxJSa4BDjv65STIUA9Qeo8n6b4w8ITcKE5MAZ6DQJ+ktmMkQlciUGVDXj
	 rWT9Mwtm89eCQv1MGJDxsu0LH8qc2pUwJBVJiIEYjXdgYglqviEMUo1bFSF9By6TJ0
	 H2EdaLQbXm1OFE7z8Nr2ycE9bYsdiDpQhkpQq8ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/235] netfilter: nf_conntrack_sip: remove net variable shadowing
Date: Thu, 20 Aug 2026 16:55:07 +0200
Message-ID: <20260820145218.596355891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 7970d6aaf710db166de98c5356a260089896fae5 ]

net is already set, derived from nf_conn.
I don't see how the device could be living in a different netns
than the conntrack entry.

Remove the extra variable and re-use existing one.

Signed-off-by: Florian Westphal <fw@strlen.de>
Stable-dep-of: e5e24a365a5e ("netfilter: nf_conntrack_sip: validate skb_dst() before accessing it")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_sip.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -948,9 +948,8 @@ static int set_expected_rtp_rtcp(struct
 		saddr = &ct->tuplehash[!dir].tuple.src.u3;
 	} else if (sip_external_media) {
 		struct net_device *dev = skb_dst(skb)->dev;
-		struct net *net = dev_net(dev);
-		struct flowi fl;
 		struct dst_entry *dst = NULL;
+		struct flowi fl;
 
 		memset(&fl, 0, sizeof(fl));
 


