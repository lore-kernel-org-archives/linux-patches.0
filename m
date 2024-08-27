Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA561C57AF;
	Tue, 27 Aug 2024 14:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769878; cv=none; b=t9mbV9X0jc1JdUdwGm+6Lvvgbuet7wKKKxhyP9xmv6wo89un4wU96fIIEUt+FQFGbSZtGA/Dc0LVEPeVNakQCOkKthV4ut5jnkws2Twdw6EftdfjeYYO59Bsl14JXwU93+JzYzSxuvLkLF7PZxsmAQTNI99DKEtWJPVo1WmD2F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769878; c=relaxed/simple;
	bh=c/L8J0QrhpuIzhlMPbTPQfBWQN121mUVLglh0ZCSejk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSII/2WaSN/wCtxpjFj0y2wOG0aWV9t0Lz3WP8d5u7TVRh4MxCjCX68nzqt0zW9slO+SnkXFdBAZcpoeicqQM9NYPaUhM8r1HZdZTSPPncvbj7MwUWL6K7JMYUYzMCUXrcbM7o055tUsivegZqy21HiW9dNkWoh4xD5yyqKZB+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8di4XRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8di4XRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2B9C6105D;
	Tue, 27 Aug 2024 14:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769877;
	bh=c/L8J0QrhpuIzhlMPbTPQfBWQN121mUVLglh0ZCSejk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8di4XRsdfjgTJ5Z3UjYeldRIphGpz9yg3OkH/o75VK8JsPEow87bJCMOauSerPDB
	 GBeV3Rp/PSCQ6JviBkI73x2YIuJ7ayaU8HL9DCBLmH2VNN9EEEt1QbVEYt7dH1i04M
	 0vgcG8nueaQASUuHk6+NQTp2RWZBysVkHZSoPW6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Hughes <tom@compton.nu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 063/341] netfilter: allow ipv6 fragments to arrive on different devices
Date: Tue, 27 Aug 2024 16:34:54 +0200
Message-ID: <20240827143845.811973705@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Tom Hughes <tom@compton.nu>

[ Upstream commit 3cd740b985963f874a1a094f1969e998b9d05554 ]

Commit 264640fc2c5f4 ("ipv6: distinguish frag queues by device
for multicast and link-local packets") modified the ipv6 fragment
reassembly logic to distinguish frag queues by device for multicast
and link-local packets but in fact only the main reassembly code
limits the use of the device to those address types and the netfilter
reassembly code uses the device for all packets.

This means that if fragments of a packet arrive on different interfaces
then netfilter will fail to reassemble them and the fragments will be
expired without going any further through the filters.

Fixes: 648700f76b03 ("inet: frags: use rhashtables for reassembly units")
Signed-off-by: Tom Hughes <tom@compton.nu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index efbec7ee27d0a..c78b13ea5b196 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -155,6 +155,10 @@ static struct frag_queue *fq_find(struct net *net, __be32 id, u32 user,
 	};
 	struct inet_frag_queue *q;
 
+	if (!(ipv6_addr_type(&hdr->daddr) & (IPV6_ADDR_MULTICAST |
+					    IPV6_ADDR_LINKLOCAL)))
+		key.iif = 0;
+
 	q = inet_frag_find(nf_frag->fqdir, &key);
 	if (!q)
 		return NULL;
-- 
2.43.0



