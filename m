Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74CD1D88D7;
	Mon, 18 Aug 2025 13:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524918; cv=none; b=Rn7DnAh1YMY+9xLw4emw5xLgdg/hhwMXTRB8O+JITUDPwSy5ewE7BEFWbR3lC2EOJ51BVb8sKQDA/d4cSDXtEBGO/PMAWapg7JUPR7dgrHf57TZOjVhPVRXfemlvYf1W/jVLomhWMIv21gux+7db4IFHtBrke8dZJ+jn55ifmaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524918; c=relaxed/simple;
	bh=Z3MLSg+CN3odnzFLH4H4WIOd15K8/OH3JE9Kt/lAnAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/Br0Tzu8leG9Dthe+AC13z7vCcseugZpEr9S9MhpnivQMQiBNMqzSItEvtVcGpEQT3dkRAblLh1fucMHbVMKspXRvPeIYL1vuoM6sc0FFk8J/YFmmvzVxINQ6c7UJCy2DRyP0tQ3cPT2ew0HgfsMf9gNt8/gzDNXRbH9edeBjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgcKVsla; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgcKVsla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D6FC4CEEB;
	Mon, 18 Aug 2025 13:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524918;
	bh=Z3MLSg+CN3odnzFLH4H4WIOd15K8/OH3JE9Kt/lAnAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgcKVslaogjsx0sO6RB+CUAVNl9ewFdCB3mEtYny3HDCHNMn7DcvxBHwQCXTRyxct
	 cAsn3Dt6DcVkI/wjylxxZYBAWYqU7TqNLkjiQUjLNJ4VhmjPbDJqKViDXZ10QCC43n
	 KLLBoW6Cz5xkxI4ANSBS2agtn6OLblyEqV0eGeIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6641a61fe0e2e89ae8c5@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 061/570] xfrm: flush all states in xfrm_state_fini
Date: Mon, 18 Aug 2025 14:40:48 +0200
Message-ID: <20250818124508.171797110@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 42e42562c9cfcdacf000f1b42284a4fad24f8546 ]

While reverting commit f75a2804da39 ("xfrm: destroy xfrm_state
synchronously on net exit path"), I incorrectly changed
xfrm_state_flush's "proto" argument back to IPSEC_PROTO_ANY. This
reverts some of the changes in commit dbb2483b2a46 ("xfrm: clean up
xfrm protocol checks"), and leads to some states not being removed
when we exit the netns.

Pass 0 instead of IPSEC_PROTO_ANY from both xfrm_state_fini
xfrm6_tunnel_net_exit, so that xfrm_state_flush deletes all states.

Fixes: 2a198bbec691 ("Revert "xfrm: destroy xfrm_state synchronously on net exit path"")
Reported-by: syzbot+6641a61fe0e2e89ae8c5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6641a61fe0e2e89ae8c5
Tested-by: syzbot+6641a61fe0e2e89ae8c5@syzkaller.appspotmail.com
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/xfrm6_tunnel.c | 2 +-
 net/xfrm/xfrm_state.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 5120a763da0d..0a0eeaed0591 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -334,7 +334,7 @@ static void __net_exit xfrm6_tunnel_net_exit(struct net *net)
 	struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
 	unsigned int i;
 
-	xfrm_state_flush(net, IPSEC_PROTO_ANY, false);
+	xfrm_state_flush(net, 0, false);
 	xfrm_flush_gc();
 
 	for (i = 0; i < XFRM6_TUNNEL_SPI_BYADDR_HSIZE; i++)
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 97ff756191ba..5f1da305eea8 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -3278,7 +3278,7 @@ void xfrm_state_fini(struct net *net)
 	unsigned int sz;
 
 	flush_work(&net->xfrm.state_hash_work);
-	xfrm_state_flush(net, IPSEC_PROTO_ANY, false);
+	xfrm_state_flush(net, 0, false);
 	flush_work(&xfrm_state_gc_work);
 
 	WARN_ON(!list_empty(&net->xfrm.state_all));
-- 
2.50.1



