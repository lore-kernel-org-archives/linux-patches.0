Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB931C2DB1;
	Tue, 27 Aug 2024 15:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771255; cv=none; b=oj2ZDXwVXHcbVtGNo4TKX3hOwkTU6wPfL/nlv4lbAPpL9Lt1F5J6KiSuuxVduKObl4kyEGXFaXNQ9GTDjVUUAlOorVbqk0tT2/YotL6/hrnrUVEJ875EspuPPBEhVI4lWLw/ucCP0f/Vsl4bwlv8KK+xdwaiuCZZgSQsXtWyeI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771255; c=relaxed/simple;
	bh=giybfBXFNK5RuJZu5WtnQX8AYSmNIdTOC/3NzZ5TASQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXGQKIN1KUfR7XGWvgMt2J/dE0lDlJp7Hkqcv22iz195CHq4XRt9NprJNveYgK+pZU2axcuigw4Oitucdjlp0iQWugwgW3SN1HHpfzzysGK/8c4RY7AXXoN1IZ9fAMN5nayJT7OuWuQCRUp3jc19yqAEvF4rPy+hCtRBy3pZvPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxW33V6E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxW33V6E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D37AC61040;
	Tue, 27 Aug 2024 15:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771254;
	bh=giybfBXFNK5RuJZu5WtnQX8AYSmNIdTOC/3NzZ5TASQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxW33V6E+CAcA99lSZRITr+B6T6iMJ1IHMV59vntx7SStuwsCo3sb8iP4IhCzm0z2
	 XCjsBaviqWvDbY/m1iZA+s9WoSPJoBnz0Avb5gTzTGTyBsqyFxdzyCjjm8TzKDuCMD
	 G2Ame7CNFz9kRtzBFAb0BgrDLvuOiXIqp6ItY+sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Hughes <tom@compton.nu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 102/273] netfilter: allow ipv6 fragments to arrive on different devices
Date: Tue, 27 Aug 2024 16:37:06 +0200
Message-ID: <20240827143837.291725505@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5e1b50c6a44d2..3e9779ed7daec 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -154,6 +154,10 @@ static struct frag_queue *fq_find(struct net *net, __be32 id, u32 user,
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



