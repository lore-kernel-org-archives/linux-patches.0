Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF4C15B10D;
	Mon, 28 Oct 2024 06:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097763; cv=none; b=deZFR1vJjAydk4LenhitRx2ReS0zNNtD0LotbY4ae/F1xeCKfWKF0XAVBL+zJQjaH7LXmWGnnkXJTaTI3GSBZXwfV8j7HhaUuxmQwK6IJR6jz8UiCQtxyj3oQS6uFM3UWg7IxR299PFBP7nT3sZUtEYBvK0BNp6Ui4Zj1nbzCgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097763; c=relaxed/simple;
	bh=xZRzH5tpZ1K6lOamqwJNRkm4bjsvgxIs6SVB7668QW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6NqM5islDsGTeIzRRS3K2BIfMhZTFfKrJ6gNKDNqQyhW5wnbjjC+xXV1LuBI/+shqWTpfnY1AAPILhGkJzrVbW7uEks1pAC4cHUW6ioJJYFcD/ey8bttyYjdtaacoLTYi1nQ7Wi1jq8+OGifdHjZ2q/SgJefjuULwe57tGWk3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tenEOuhK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tenEOuhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1E4C4CEC3;
	Mon, 28 Oct 2024 06:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097763;
	bh=xZRzH5tpZ1K6lOamqwJNRkm4bjsvgxIs6SVB7668QW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tenEOuhKnyQPGWd2gMdgiegNS+zTe9EeG3hXGMFKTOSEfBhakE0wxEnkSr9VhwsVH
	 Ig7g1cgniOa/ADFvkWCuNke2//gs5QDMRWRoyjeT4h4d2EZxVTPIuBMCDbTWFFh0xQ
	 WLVgtBFbPSVtEbkyivtBckC/esPw7vMdu+Ei2tp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lai, Yi" <yi1.lai@linux.intel.com>,
	Florian Westphal <fw@strlen.de>,
	Eric Dumazet <edumazet@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/208] netfilter: bpf: must hold reference on net namespace
Date: Mon, 28 Oct 2024 07:25:15 +0100
Message-ID: <20241028062309.962437525@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1230fe7ad3974f7bf6c78901473e039b34d4fb1f ]

BUG: KASAN: slab-use-after-free in __nf_unregister_net_hook+0x640/0x6b0
Read of size 8 at addr ffff8880106fe400 by task repro/72=
bpf_nf_link_release+0xda/0x1e0
bpf_link_free+0x139/0x2d0
bpf_link_release+0x68/0x80
__fput+0x414/0xb60

Eric says:
 It seems that bpf was able to defer the __nf_unregister_net_hook()
 after exit()/close() time.
 Perhaps a netns reference is missing, because the netns has been
 dismantled/freed already.
 bpf_nf_link_attach() does :
 link->net = net;
 But I do not see a reference being taken on net.

Add such a reference and release it after hook unreg.
Note that I was unable to get syzbot reproducer to work, so I
do not know if this resolves this splat.

Fixes: 84601d6ee68a ("bpf: add bpf_link support for BPF_NETFILTER programs")
Diagnosed-by: Eric Dumazet <edumazet@google.com>
Reported-by: Lai, Yi <yi1.lai@linux.intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_bpf_link.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index 96015a59db09e..2aad0562a4135 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -23,6 +23,7 @@ static unsigned int nf_hook_run_bpf(void *bpf_prog, struct sk_buff *skb,
 struct bpf_nf_link {
 	struct bpf_link link;
 	struct nf_hook_ops hook_ops;
+	netns_tracker ns_tracker;
 	struct net *net;
 	u32 dead;
 	const struct nf_defrag_hook *defrag_hook;
@@ -120,6 +121,7 @@ static void bpf_nf_link_release(struct bpf_link *link)
 	if (!cmpxchg(&nf_link->dead, 0, 1)) {
 		nf_unregister_net_hook(nf_link->net, &nf_link->hook_ops);
 		bpf_nf_disable_defrag(nf_link);
+		put_net_track(nf_link->net, &nf_link->ns_tracker);
 	}
 }
 
@@ -258,6 +260,8 @@ int bpf_nf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 		return err;
 	}
 
+	get_net_track(net, &link->ns_tracker, GFP_KERNEL);
+
 	return bpf_link_settle(&link_primer);
 }
 
-- 
2.43.0



