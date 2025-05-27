Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA7A1FB3;
	Tue, 27 May 2025 17:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368000; cv=none; b=E2JMJ3kvRQDhDlf3G+sNBgvADNXa2OCRoTFE5Ak7K5G05N/o7A9fesjc3TfuE5eOZRFVrT4cYJ8gdtgoV4f08VOwBPlAWgE68eILjbS1lOVwrP1aa8XEd7PkrtAyYnDormpGchilwabDFvlGWrAHSgsywS97oULMkl6vdsjvqS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368000; c=relaxed/simple;
	bh=SMxIQmUIqpxaKcTE6E53voQnfAJZTu1tLrDL00X3gys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfU9McuWkLDjV/E6xe1p+j9V50mnhf0L8br3Q46mJIbSygt9ZjoREQEXrT8Pi9sioNRqurKMk4eGOz39goA6PQTjKy4v6jYn7/bC9/wLXMLdWmPT9Kg29U98DXJFhdTD5ro1paBtStz6JwgiW2qI6lG+FqCf7Ar76fxwU+cuor8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgiN13MZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgiN13MZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B79AC4CEE9;
	Tue, 27 May 2025 17:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368000;
	bh=SMxIQmUIqpxaKcTE6E53voQnfAJZTu1tLrDL00X3gys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgiN13MZdgJX4JvAzOggBOopLWzV8l76TveovYFnQkd7P7NNKeTBBnVOO99hFww4r
	 dBYSKY1gUfKeF9Rsg/L0ueGaqqj9adApG2fUxpTx9x3FJcSpyGrytxYRX+CzQE5gk7
	 nFKYqesZKE8p3ULD4vEY/bNjMZT9nWguVHxUzW7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 566/783] net: flush_backlog() small changes
Date: Tue, 27 May 2025 18:26:03 +0200
Message-ID: <20250527162536.193805367@linuxfoundation.org>
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
index 2f7f5fd9ffec7..77306b522966c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6187,16 +6187,18 @@ EXPORT_SYMBOL(netif_receive_skb_list);
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
@@ -6204,14 +6206,16 @@ static void flush_backlog(struct work_struct *work)
 
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



