Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4228528001E;
	Tue, 27 May 2025 17:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368555; cv=none; b=XonF0r+W5J/8i6NUIVqI6+T8QosGDTugc7pyL/OTOLz4rtFNO0MZnvLPzc81bsqGzh4tsW8pHexS/vcKAogCfuYhga8ochNzbjc+YeWG8hWys39ksNr1lGeTMvCp7XgQwwIaQTIiQRwK6LvADWgXpEqk5asrKqAVKRfN2sNhnjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368555; c=relaxed/simple;
	bh=v/tL9e5zyq8O3vBK5iSoSxck+4BRdNI662khMF0ox7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TIFIaBouah2Zr6OYrOUf5rZ5/5LPC4+oCg8fka6SQV7+5AJ911PcFH/FICC8Iocy/SApxTyPXp4jFNOXJtlxLZ/qJJw7uGlxkkuDWKFifvLrwuAdC1k7ayV6SdnMVMqHSSczGOjNRSjUVTcBgRKaIBZ0sCtFYsExPIOu90MyKJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtDFNiKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtDFNiKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6664C4CEE9;
	Tue, 27 May 2025 17:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368555;
	bh=v/tL9e5zyq8O3vBK5iSoSxck+4BRdNI662khMF0ox7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtDFNiKfYkC+tr6EBrZ8+bp8lZlFA088TlN3VlWLfvdJKQ0JJYIWVE15cDoDaVpry
	 NGA66M2/NoUaYBfhyz7LtjY5yghwbbG4wdh/eHug4+mKVZmBHtayXaQlEEliBx7Pkq
	 kP5XgcZyhtwadOnOQgGRma4QpCbHMJrJOEBiJ8gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingi Cho <mincho@theori.io>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 713/783] sch_hfsc: Fix qlen accounting bug when using peek in hfsc_enqueue()
Date: Tue, 27 May 2025 18:28:30 +0200
Message-ID: <20250527162542.153830523@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 3f981138109f63232a5fb7165938d4c945cc1b9d ]

When enqueuing the first packet to an HFSC class, hfsc_enqueue() calls the
child qdisc's peek() operation before incrementing sch->q.qlen and
sch->qstats.backlog. If the child qdisc uses qdisc_peek_dequeued(), this may
trigger an immediate dequeue and potential packet drop. In such cases,
qdisc_tree_reduce_backlog() is called, but the HFSC qdisc's qlen and backlog
have not yet been updated, leading to inconsistent queue accounting. This
can leave an empty HFSC class in the active list, causing further
consequences like use-after-free.

This patch fixes the bug by moving the increment of sch->q.qlen and
sch->qstats.backlog before the call to the child qdisc's peek() operation.
This ensures that queue length and backlog are always accurate when packet
drops or dequeues are triggered during the peek.

Fixes: 12d0ad3be9c3 ("net/sched/sch_hfsc.c: handle corner cases where head may change invalidating calculated deadline")
Reported-by: Mingi Cho <mincho@theori.io>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250518222038.58538-2-xiyou.wangcong@gmail.com
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_hfsc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index cb8c525ea20ea..7986145a527cb 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1569,6 +1569,9 @@ hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 		return err;
 	}
 
+	sch->qstats.backlog += len;
+	sch->q.qlen++;
+
 	if (first && !cl->cl_nactive) {
 		if (cl->cl_flags & HFSC_RSC)
 			init_ed(cl, len);
@@ -1584,9 +1587,6 @@ hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch, struct sk_buff **to_free)
 
 	}
 
-	sch->qstats.backlog += len;
-	sch->q.qlen++;
-
 	return NET_XMIT_SUCCESS;
 }
 
-- 
2.39.5



