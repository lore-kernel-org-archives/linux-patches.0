Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F7825A323;
	Tue, 27 May 2025 17:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365765; cv=none; b=CdL7/jfNieLcl4jilJ9aO/agha4hsPu8dtMf3bYtJ8cMLBUqNl9gqrvgITrEfU5mGzBajaJy/KruFS/b3GrwIRh+cRHKZtRDf454mu7X80BD5AOHXtHn0fEdbvzBR8CUNV9dWcxRkKpL1+kCFU0NqyWOwbPqUsnuVEArW4jN6V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365765; c=relaxed/simple;
	bh=YRtsSkgwmnlOwdPxoeM/pyuI1W7n7foKFp54412V7aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJUn+xPh5EVAUWN96/VpakFTA/XEYO1PZ6yWQJ+mE3nPudI/+OW6bCPyJJgJkVNf9HuntEaGofYJ9lyV2PPBw3ryYy9cDE7Y8TpUCUWRy2bFSjswnfK2CUw8gjFQ3l8fdG4qA78nzVbsHe8oOY9oo+JbwFDyQXMJXhV998iLLvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ez/UbQnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ez/UbQnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88931C4CEE9;
	Tue, 27 May 2025 17:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365765;
	bh=YRtsSkgwmnlOwdPxoeM/pyuI1W7n7foKFp54412V7aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ez/UbQnbXgiMCgeRTJlgYwRLz+OyDlErr2S58qJVHfXMZcfiw5Sdi/61Y1ekqn4I0
	 oUf30MxDxtZzlLhLoemsVbds8c31ElNO00GzWkcy6OwupPPF9reSVwK1EM3iirH1Eh
	 th6fRedidnVL6zUx8rrACbrGB18XkAroDFloagAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 451/626] net: flush_backlog() small changes
Date: Tue, 27 May 2025 18:25:44 +0200
Message-ID: <20250527162503.326888136@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cbe08724c18078564abefbf6591078a7c98e5e0f ]

Add READ_ONCE() around reads of skb->dev->reg_state, because
this field can be changed from other threads/cpus.

Instead of calling dev_kfree_skb_irq() and kfree_skb()
while interrupts are masked and locks held,
use a temporary list and use __skb_queue_purge_reason()

Use SKB_DROP_REASON_DEV_READY drop reason to better
describe why these skbs are dropped.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20250204144825.316785-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7b7b36c43c82c..2ba2160dd093a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6034,16 +6034,18 @@ static DEFINE_PER_CPU(struct work_struct, flush_works);
 static void flush_backlog(struct work_struct *work)
 {
 	struct sk_buff *skb, *tmp;
+	struct sk_buff_head list;
 	struct softnet_data *sd;
 
+	__skb_queue_head_init(&list);
 	local_bh_disable();
 	sd = this_cpu_ptr(&softnet_data);
 
 	backlog_lock_irq_disable(sd);
 	skb_queue_walk_safe(&sd->input_pkt_queue, skb, tmp) {
-		if (skb->dev->reg_state == NETREG_UNREGISTERING) {
+		if (READ_ONCE(skb->dev->reg_state) == NETREG_UNREGISTERING) {
 			__skb_unlink(skb, &sd->input_pkt_queue);
-			dev_kfree_skb_irq(skb);
+			__skb_queue_tail(&list, skb);
 			rps_input_queue_head_incr(sd);
 		}
 	}
@@ -6051,14 +6053,16 @@ static void flush_backlog(struct work_struct *work)
 
 	local_lock_nested_bh(&softnet_data.process_queue_bh_lock);
 	skb_queue_walk_safe(&sd->process_queue, skb, tmp) {
-		if (skb->dev->reg_state == NETREG_UNREGISTERING) {
+		if (READ_ONCE(skb->dev->reg_state) == NETREG_UNREGISTERING) {
 			__skb_unlink(skb, &sd->process_queue);
-			kfree_skb(skb);
+			__skb_queue_tail(&list, skb);
 			rps_input_queue_head_incr(sd);
 		}
 	}
 	local_unlock_nested_bh(&softnet_data.process_queue_bh_lock);
 	local_bh_enable();
+
+	__skb_queue_purge_reason(&list, SKB_DROP_REASON_DEV_READY);
 }
 
 static bool flush_required(int cpu)
-- 
2.39.5



