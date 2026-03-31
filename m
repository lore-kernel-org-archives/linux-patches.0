Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67785413225;
	Tue, 31 Mar 2026 16:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975712; cv=none; b=DNWY1XKqqkgC15ZHNSCqkyleX8+t0gAeW0blNzDPTp5mldUc5cf0pWR2dsRs23vmL+2SqqlJQG2hg/Ry+b75xXxelf4Tzm2v4IjhG0J+8GFe5vmuQ6trc2Fd0Pl6foVksFyZg+LubDjYWUqMDNjiKZuOBcaxz+cHyRgb9Vwx5kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975712; c=relaxed/simple;
	bh=eozfyc5pJoM3nPC8ESkHy1tR6ngWH0a6Lb9FvxTMan4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrnMCdbzFFkjBLbDdSPGv3IVxLBL0OniBFY3cGzOpjixUMTzJBPYlaSy26GbWNdnHVSijVn8Pz4hPVSv5CjxpBmKtXiUMAoK7dADC9RZDiUPgaDohwTrEAqp0ed1eLst4i5xc3mhrbNWl1on3PT9gdKxyic2b3KRwaQWVGWEHaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FcswOKnw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FcswOKnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C9AC19423;
	Tue, 31 Mar 2026 16:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975712;
	bh=eozfyc5pJoM3nPC8ESkHy1tR6ngWH0a6Lb9FvxTMan4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcswOKnwrFZJubdtrslbh9VhrqbRpx6Sswft+9AjIePL9aC/eI4LSGIhkHwgoMcQI
	 i5FPo5kA9h3vs7Egq9pzV/1QQq1V7+xGwR2BxDJu2Dwe9jwqC3M3E8GfpA/jzOP7zE
	 o6cKVG6m+43yb8UjYDLo6tKQAz5OuAAQYAL0Nnc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/244] can: statistics: add missing atomic access in hot path
Date: Tue, 31 Mar 2026 18:20:07 +0200
Message-ID: <20260331161743.797589558@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

[ Upstream commit 46eee1661aa9b49966e6c43d07126fe408edda57 ]

Commit 80b5f90158d1 ("can: statistics: use atomic access in hot path")
fixed a KCSAN issue in can_receive() but missed to convert the 'matches'
variable used in can_rcv_filter().

Fixes: 80b5f90158d1 ("can: statistics: use atomic access in hot path")
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260318173413.28235-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/af_can.c | 4 ++--
 net/can/af_can.h | 2 +-
 net/can/proc.c   | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 65230e81fa08c..c86cbb3ed9c54 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -467,7 +467,7 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
 
 	rcv->can_id = can_id;
 	rcv->mask = mask;
-	rcv->matches = 0;
+	atomic_long_set(&rcv->matches, 0);
 	rcv->func = func;
 	rcv->data = data;
 	rcv->ident = ident;
@@ -571,7 +571,7 @@ EXPORT_SYMBOL(can_rx_unregister);
 static inline void deliver(struct sk_buff *skb, struct receiver *rcv)
 {
 	rcv->func(skb, rcv->data);
-	rcv->matches++;
+	atomic_long_inc(&rcv->matches);
 }
 
 static int can_rcv_filter(struct can_dev_rcv_lists *dev_rcv_lists, struct sk_buff *skb)
diff --git a/net/can/af_can.h b/net/can/af_can.h
index 22f3352c77fec..87887014f5628 100644
--- a/net/can/af_can.h
+++ b/net/can/af_can.h
@@ -52,7 +52,7 @@ struct receiver {
 	struct hlist_node list;
 	canid_t can_id;
 	canid_t mask;
-	unsigned long matches;
+	atomic_long_t matches;
 	void (*func)(struct sk_buff *skb, void *data);
 	void *data;
 	char *ident;
diff --git a/net/can/proc.c b/net/can/proc.c
index 25fdf060e30d0..2f78ea8ac30b0 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -196,7 +196,8 @@ static void can_print_rcvlist(struct seq_file *m, struct hlist_head *rx_list,
 			"   %-5s     %03x    %08x  %pK  %pK  %8ld  %s\n";
 
 		seq_printf(m, fmt, DNAME(dev), r->can_id, r->mask,
-				r->func, r->data, r->matches, r->ident);
+			   r->func, r->data, atomic_long_read(&r->matches),
+			   r->ident);
 	}
 }
 
-- 
2.51.0



