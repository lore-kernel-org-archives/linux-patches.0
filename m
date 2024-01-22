Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131267E562;
	Tue, 23 Jan 2024 02:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975744; cv=none; b=ssKUo7RZY7UQWsTjGG00VkPJEWspvLWUtkBLIRUPfvQNcGxyH68tYpq+FzcmlczQ9e9nGUMvs7s/ZgacM3I0Lp1RWd6UlRIxenHeUqqy1zB+39/oJw56BIoBghagrgF25VsC9D0ZSMocmn4heR2mdMIF3+ej8WYmEKpEgiURYe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975744; c=relaxed/simple;
	bh=eUEREUW863k9qwK2ucoBLFHpLu1mRE8gBLJO0xU/npU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9pMZXJEesrJDF7HKThQNVgCrfvpqqI6q7D6HZK+BDVOP69XV9PbF+PFYrHmokLtCZ4Ukuvj1Rj6/jOSK+4g9tJI1ncK8X0fMMCK6w1vIqJKw7ohfP09+2Odn6Np/4BYgT+rc7ChxzdIfl27A32gvy8mQQkwnzDsuMVY/kmWDYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2eWQuH32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2eWQuH32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE072C433F1;
	Tue, 23 Jan 2024 02:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975743;
	bh=eUEREUW863k9qwK2ucoBLFHpLu1mRE8gBLJO0xU/npU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2eWQuH3221lL8G1oME/qs5uda7HOouk56pdLF4kkiQu4lj3BpejdOSe/aC97DmiAD
	 yi6oaMkc2IuFQ19kBWKDfZ943OSQU119p29qjlJUpd1xjCveQ+tuCklVZC+oYFJkP1
	 8/ZGCNjsqSwWPlqnLYvbN+lFriym6nx78TS/ijLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 528/583] amt: do not use overwrapped cb area
Date: Mon, 22 Jan 2024 15:59:39 -0800
Message-ID: <20240122235828.261606422@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit bec161add35b478a7746bf58bcdea6faa19129ef ]

amt driver uses skb->cb for storing tunnel information.
This job is worked before TC layer and then amt driver load tunnel info
from skb->cb after TC layer.
So, its cb area should not be overwrapped with CB area used by TC.
In order to not use cb area used by TC, it skips the biggest cb
structure used by TC, which was qdisc_skb_cb.
But it's not anymore.
Currently, biggest structure of TC's CB is tc_skb_cb.
So, it should skip size of tc_skb_cb instead of qdisc_skb_cb.

Fixes: ec624fe740b4 ("net/sched: Extend qdisc control block with tc control block")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20240107144241.4169520-1-ap420073@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 2d20be6ffb7e..ddd087c2c3ed 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -11,7 +11,7 @@
 #include <linux/net.h>
 #include <linux/igmp.h>
 #include <linux/workqueue.h>
-#include <net/sch_generic.h>
+#include <net/pkt_sched.h>
 #include <net/net_namespace.h>
 #include <net/ip.h>
 #include <net/udp.h>
@@ -80,11 +80,11 @@ static struct mld2_grec mldv2_zero_grec;
 
 static struct amt_skb_cb *amt_skb_cb(struct sk_buff *skb)
 {
-	BUILD_BUG_ON(sizeof(struct amt_skb_cb) + sizeof(struct qdisc_skb_cb) >
+	BUILD_BUG_ON(sizeof(struct amt_skb_cb) + sizeof(struct tc_skb_cb) >
 		     sizeof_field(struct sk_buff, cb));
 
 	return (struct amt_skb_cb *)((void *)skb->cb +
-		sizeof(struct qdisc_skb_cb));
+		sizeof(struct tc_skb_cb));
 }
 
 static void __amt_source_gc_work(void)
-- 
2.43.0



