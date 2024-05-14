Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EF284DEA;
	Tue, 14 May 2024 11:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687322; cv=none; b=o4VbH4OgREuq7esvLxUFuu8HcmlSyU3Ksinoczvkf0fqHwspUBJhjcgV2gkVTlNgYU4CgEUEksJVc6KdGdwYULBpWVAfdJpYiZ04v9a6Yqwif8IMbcmNXbTO01+dJRBKYgLc2melaXHY3wD0De+mASOXFQRuz0CKNqs4MDRwIQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687322; c=relaxed/simple;
	bh=B0VYggLqGWOdvBYIIXH0iASgNPfaGNjvQD80X74bVEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0is0RLyVjIxGFH0FbUPCUY4dbnIEgI2dt9eucIxz8Rtupd/WJ8FzkmjqLA2LyQqzAAMUpCXzXxw7fCOSYoiaN2YIIe+8MXBCx4uROL/NnA6p3RtYIjF87fjgwzhqpB4+/UQKX4AaRl52/2L6nzwMEXf+QgmmetXvrzfO7899jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmBohZPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmBohZPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D2AC2BD10;
	Tue, 14 May 2024 11:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687322;
	bh=B0VYggLqGWOdvBYIIXH0iASgNPfaGNjvQD80X74bVEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmBohZPlxitXThMGMHGzgTIL6g6Q5MgyDpc1fLEZD3smsS5zQNpMQWXi5uUu5x531
	 rXGtGKnj5G2JWNUR3TfttOgNQBu3CUkneK+r/CQSJ1teZtUHF2nXVufI6jrvNUlV5s
	 JKDBvrzgJg3fg6iRrexzvlhtzJN7AB3tzoM5Ea2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Chapman <jchapman@katalix.com>,
	David Bauer <mail@david-bauer.net>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/111] net l2tp: drop flow hash on forward
Date: Tue, 14 May 2024 12:19:23 +0200
Message-ID: <20240514100958.083095530@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Bauer <mail@david-bauer.net>

[ Upstream commit 42f853b42899d9b445763b55c3c8adc72be0f0e1 ]

Drop the flow-hash of the skb when forwarding to the L2TP netdev.

This avoids the L2TP qdisc from using the flow-hash from the outer
packet, which is identical for every flow within the tunnel.

This does not affect every platform but is specific for the ethernet
driver. It depends on the platform including L4 information in the
flow-hash.

One such example is the Mediatek Filogic MT798x family of networking
processors.

Fixes: d9e31d17ceba ("l2tp: Add L2TP ethernet pseudowire support")
Acked-by: James Chapman <jchapman@katalix.com>
Signed-off-by: David Bauer <mail@david-bauer.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240424171110.13701-1-mail@david-bauer.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_eth.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 6cd97c75445c8..9a36e174984cf 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -136,6 +136,9 @@ static void l2tp_eth_dev_recv(struct l2tp_session *session, struct sk_buff *skb,
 	/* checksums verified by L2TP */
 	skb->ip_summed = CHECKSUM_NONE;
 
+	/* drop outer flow-hash */
+	skb_clear_hash(skb);
+
 	skb_dst_drop(skb);
 	nf_reset_ct(skb);
 
-- 
2.43.0



