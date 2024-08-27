Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039591CFBC;
	Tue, 27 Aug 2024 15:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772044; cv=none; b=tCsG4Tkm/zInnrgpdUJjtalF7I5d7OZF6+Ut4auVJatIH70ttS+cu/LC/0av6Y4aF+b7+JejsMkLR5rOUNgCNDmCM2glYepltsCTCAy/UEZdKya6ooBLv2f1QBUs9ZqWOI5YJWuXyryAsTq5JSBTGIdpq8ba9GzFW/nZxO6CGgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772044; c=relaxed/simple;
	bh=gjZNHRdyFZ79Vy56HjO2/Bu9MjmkR7JQCkMzmVuyx/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyzT+dWR6/gQjz9F6jcSv4nk5OQiQfu/murT1m0xeyQ9Xq+TCqD+5xMnuSPGnrEyXUWIPMILgapo1kAD2U5qDO2MLilzvUAmlGjrmj8B3y0dbZm29Cg62Q5wn0hFBkQ0YqC7exSevcuibnLW841RznyPFgT4RR/z3f1svnSUYo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCAG1b0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCAG1b0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B9CCC4E693;
	Tue, 27 Aug 2024 15:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772043;
	bh=gjZNHRdyFZ79Vy56HjO2/Bu9MjmkR7JQCkMzmVuyx/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCAG1b0W8ZHBD1fA1zrop+nDccZd+3yXBTXGgcFQkCMp9rZocjnuOOzUYl7gXDNcW
	 GiWcUTEkexCxDLA4hFI9HbjUZ8vSGeMUCEKoUxrVcmFgywOflxLBj85tUmKA134AdS
	 SIfhdxnefEJXNbdvM/exVRtGhRuWpIvku9QP69r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Hughes <tom@compton.nu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 095/321] netfilter: allow ipv6 fragments to arrive on different devices
Date: Tue, 27 Aug 2024 16:36:43 +0200
Message-ID: <20240827143841.854871935@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 87a394179092c..e4b45db8a3992 100644
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



