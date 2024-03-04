Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF57161675;
	Mon,  4 Mar 2024 21:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589269; cv=none; b=DCzCK9/nmPhPAAIyDWdEvDkyRbOXih0rsLyM4Kr+Fq9LzqxHoseh87cEAcQBl/pcRpZE+sH6kcL6k8L1KOL3/uWjDShDvqfxsZ7mPOtkgHyDrmJLGNeaBYaP012/peNf/P3oAZJSER/P4zvvfdkx/5IV7G9qNGgzcVT03ciSAH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589269; c=relaxed/simple;
	bh=at5qafrZcEAeLjzP6Fhl6CCHKCnwZO+vFc7wkqByZac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfxhTcsFJem0giqR2uzPny2uaIZXAJxLDjnBV7+s6Hvw9MpYMbqkvDfBCB4u6VZOtqwkqS5RyQgLAkRlk/2YDsHSGoRc/05VcN5N89GkNSGPQKl/8WBwO1drujDC3MqWkviX8ZHsV/PJYVRDHDt1PHxCyCZfAwqlVxipZ+bZnuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8yUAqRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8yUAqRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C62C433F1;
	Mon,  4 Mar 2024 21:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589269;
	bh=at5qafrZcEAeLjzP6Fhl6CCHKCnwZO+vFc7wkqByZac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8yUAqRbxudO3dah3lAWDEuCEZuMbRuq5kUtAtaxEjg24y74rdKxHYXQo+JkoBHR2
	 6HbwdyTzPo5gQ5EU2A71azjGpqf4MZZvYcXy2TfhxVAIXQcE3QoqIVsLvh9EuGR1Ka
	 VmD5sRPbDdi5IXzP/cCT4E/mlceb7MiuwmG0Ry4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 20/84] netfilter: nfnetlink_queue: silence bogus compiler warning
Date: Mon,  4 Mar 2024 21:23:53 +0000
Message-ID: <20240304211543.001030198@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b43c2793f5e9910862e8fe07846b74e45b104501 ]

net/netfilter/nfnetlink_queue.c:601:36: warning: variable 'ctinfo' is
uninitialized when used here [-Wuninitialized]
   if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)

ctinfo is only uninitialized if ct == NULL.  Init it to 0 to silence this.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 62e7151ae3eb ("netfilter: bridge: confirm multicast packets before passing them up the stack")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_queue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 5329ebf19a18b..f4468ef3d0a94 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -387,7 +387,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	struct net_device *indev;
 	struct net_device *outdev;
 	struct nf_conn *ct = NULL;
-	enum ip_conntrack_info ctinfo;
+	enum ip_conntrack_info ctinfo = 0;
 	struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
 	char *secdata = NULL;
-- 
2.43.0



