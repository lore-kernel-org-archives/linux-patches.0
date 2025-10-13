Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8321D30DD2A;
	Mon, 13 Oct 2025 15:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369984; cv=none; b=Pwczv5oFEywu2aZy0dvYGFg/7a6DnXAa2Ws5vjH5FHmxt37gnPMjqYWdT+xzQ/+VV4Y7WhryRAskGjYiOOqV8LeNtPewyqcQ/LuQMYIQl91/b37pUHGKKYg/zOS8VBpKQmY3cIm02Mr3aRhSQ6BtU8c8SpB/dMjw6molBRI1QwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369984; c=relaxed/simple;
	bh=FkuS9Rl2UYIPhMPYrqzsy8D9EWAuyC9mLZBikuSOUDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TtqevNkOeXtV2SLMakUT9RP0Wim8qsJvx8vMYotkDyIhBpeaSzKYlKy6RENWn76pCxptvhTdND4TdUVmBrQ3v4OBspO9jXFX+5+0Xh2PL+U0uMKt8yHk+k+QFhEyHpBmvF8Lm57xURgybM5ZwIX/+8WtSs2rlZxzv+C3/J2745w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkacYMCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkacYMCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BD2C4CEE7;
	Mon, 13 Oct 2025 15:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369984;
	bh=FkuS9Rl2UYIPhMPYrqzsy8D9EWAuyC9mLZBikuSOUDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JkacYMCYtKq4YBMiU0NlCpZlCl97FiIt9HGwnHBTX0P8mV65oijjwgaXCIUWjSa2D
	 QC+lm3FdhxnMs+7Yb3JzIxYz4BM9nBYZqkPqlVNFtSiifQwGeBA0tCuFjg5soixXBH
	 fUlfayGsdM8f4gc8HxV0KD2X0xI1XrBC5ygIZC1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 437/563] netfilter: nfnetlink: reset nlh pointer during batch replay
Date: Mon, 13 Oct 2025 16:44:58 +0200
Message-ID: <20251013144427.114959175@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 09efbac953f6f076a07735f9ba885148d4796235 ]

During a batch replay, the nlh pointer is not reset until the parsing of
the commands. Since commit bf2ac490d28c ("netfilter: nfnetlink: Handle
ACK flags for batch messages") that is problematic as the condition to
add an ACK for batch begin will evaluate to true even if NLM_F_ACK
wasn't used for batch begin message.

If there is an error during the command processing, netlink is sending
an ACK despite that. This misleads userspace tools which think that the
return code was 0. Reset the nlh pointer to the original one when a
replay is triggered.

Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch messages")
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index e598a2a252b0a..811d02b4c4f7c 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -376,6 +376,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	const struct nfnetlink_subsystem *ss;
 	const struct nfnl_callback *nc;
 	struct netlink_ext_ack extack;
+	struct nlmsghdr *onlh = nlh;
 	LIST_HEAD(err_list);
 	u32 status;
 	int err;
@@ -386,6 +387,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
 	status = 0;
 replay_abort:
 	skb = netlink_skb_clone(oskb, GFP_KERNEL);
+	nlh = onlh;
 	if (!skb)
 		return netlink_ack(oskb, nlh, -ENOMEM, NULL);
 
-- 
2.51.0



