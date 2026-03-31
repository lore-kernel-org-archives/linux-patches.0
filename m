Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A703E3C5C;
	Tue, 31 Mar 2026 16:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974982; cv=none; b=HFb1U8piFyaWBYKzrqDXlzUpU5LLiPd2HmVuU/I1ojJd/jC0Li48wH3TGT6XVeNFrJmBMrfrdTz0GxrI658WyH/+LNyj2WC7FDClQl58CHDnHmtFRSYiJwsgFhSRBm7dUfMZL7/JKrCNHgK5SKkl8sTJu5Xt2LuyNneMuBxuMpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974982; c=relaxed/simple;
	bh=YSgoWowNgIHB6tra2a/sfkiw+uWpIUcvIiWKqnohBzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T8m2aSispQREKJzFoWbbgiImsuGUocDNk5U3A+ihbp1OFpJnx2AY+JfcrpVv+E5v97Plep158INQh5XfBTJ4SYC7ZD04BdZMArWM4C3RgUXVsx1WVSaZu2qflvacJSpLdYEFQXxyogfxQV/vuiGtv/ZAuBXwHva2Hv4COJFm0UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dg2jvSCt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dg2jvSCt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C192BC19423;
	Tue, 31 Mar 2026 16:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974982;
	bh=YSgoWowNgIHB6tra2a/sfkiw+uWpIUcvIiWKqnohBzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dg2jvSCtIf7CHgO5JJ3OdGrT6D9FbHKKahRAbrW/1P7i2EhmkiD+QiklG1EYFGFD4
	 GmRPgSpaeVZ1WVaw7UjCRgTnew0mTFlVg7Tjtsq9EYPuHyoQbTzGLXbBtuJf0zeilN
	 BMRho8O9QKvcFmDaTyNycao2lYxl6AOKIPBz1gHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 091/342] can: statistics: add missing atomic access in hot path
Date: Tue, 31 Mar 2026 18:18:44 +0200
Message-ID: <20260331161802.369568810@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 770173d8db428..a624c04ed5c63 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -469,7 +469,7 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
 
 	rcv->can_id = can_id;
 	rcv->mask = mask;
-	rcv->matches = 0;
+	atomic_long_set(&rcv->matches, 0);
 	rcv->func = func;
 	rcv->data = data;
 	rcv->ident = ident;
@@ -573,7 +573,7 @@ EXPORT_SYMBOL(can_rx_unregister);
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
index 0938bf7dd646a..de4d05ae34597 100644
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



