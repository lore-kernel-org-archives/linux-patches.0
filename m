Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5033D4134;
	Wed,  8 Apr 2026 18:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671845; cv=none; b=msC5BQWWwn0DQaAdVGbxXBAJeVtLnYRWbrK8SVHijsTEvzpt81eUdP3dZq4s62o+UAgfen9y23JJlXmXhHORtrQZ0+4rz6d3Xh3FRu9Ze0k7AtFTXu0jH0iNr2L9TRjYc7/+cAhgcF7FLxScdbsaeAZlBT8oMsr4TB4lJYrerko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671845; c=relaxed/simple;
	bh=h69+FZvBJJO37du/NFx17cFgflVtKD6yGBnft7rBYtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCKKc7jyZ+BJGozD8ipO2xSx6zaNV+J6aJxNrQ+rWQiK5iQcoxPjV6/OikPEza9a0ZEILQI+E2B0DPb8sRgsTE7ZnYlg/x5sDijbYacYr7ryscyA8pb10nVkLzopFDdEmou/CbkJFPtFK/iYSl22StBEXcg/i1S6uYTD3o5rjWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=og3/LXoX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="og3/LXoX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50366C19421;
	Wed,  8 Apr 2026 18:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671845;
	bh=h69+FZvBJJO37du/NFx17cFgflVtKD6yGBnft7rBYtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=og3/LXoXBJOZfu5sa3A4FT37mPOKsfU9nEXLaMFrgtv+d7EawrMVTDGkvagkaCcBA
	 W1VAbzKbww6sLp91/jXmOgu8HKLRoCTcUdVoyRyDv2b16wOfdaK0GTfDcPF5Z9eEl7
	 AsBQ7K3YqS9O6llWBlko55IyEm5KMn2Z532NMV8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/312] netfilter: nfnetlink_log: fix uninitialized padding leak in NFULA_PAYLOAD
Date: Wed,  8 Apr 2026 19:59:34 +0200
Message-ID: <20260408175935.867264244@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 52025ebaa29f4eb4ed8bf92ce83a68f24ab7fdf7 ]

__build_packet_message() manually constructs the NFULA_PAYLOAD netlink
attribute using skb_put() and skb_copy_bits(), bypassing the standard
nla_reserve()/nla_put() helpers. While nla_total_size(data_len) bytes
are allocated (including NLA alignment padding), only data_len bytes
of actual packet data are copied. The trailing nla_padlen(data_len)
bytes (1-3 when data_len is not 4-byte aligned) are never initialized,
leaking stale heap contents to userspace via the NFLOG netlink socket.

Replace the manual attribute construction with nla_reserve(), which
handles the tailroom check, header setup, and padding zeroing via
__nla_reserve(). The subsequent skb_copy_bits() fills in the payload
data on top of the properly initialized attribute.

Fixes: df6fb868d611 ("[NETFILTER]: nfnetlink: convert to generic netlink attribute functions")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_log.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 200a82a8f943d..4fcdd9ec8de9b 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -639,15 +639,11 @@ __build_packet_message(struct nfnl_log_net *log,
 
 	if (data_len) {
 		struct nlattr *nla;
-		int size = nla_attr_size(data_len);
 
-		if (skb_tailroom(inst->skb) < nla_total_size(data_len))
+		nla = nla_reserve(inst->skb, NFULA_PAYLOAD, data_len);
+		if (!nla)
 			goto nla_put_failure;
 
-		nla = skb_put(inst->skb, nla_total_size(data_len));
-		nla->nla_type = NFULA_PAYLOAD;
-		nla->nla_len = size;
-
 		if (skb_copy_bits(skb, 0, nla_data(nla), data_len))
 			BUG();
 	}
-- 
2.51.0



