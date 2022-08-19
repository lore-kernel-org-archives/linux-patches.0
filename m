Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1FF4A05
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2988C4347C
	for <patches@lists.linux.dev>; Fri, 19 Aug 2022 18:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1660933040;
	bh=LEEEEOX6G1IaaqTRlCasYpvCUXv44vPCVu13fnwnnpU=;
	h=From:Date:Subject:References:In-Reply-To:To:Reply-To:From;
	b=HezPveJjz02t1dXYgQ5IcKH6UORY9Nby8tj8AG2AWTmfBqgL9gmjnGxVrRxWdPkSZ
	 APJSxYPHkBOMrgrfTGyoDbJGmTdxAvKicCwH293TqtzMN1jiXP0PN7S3avTyA84X1D
	 MnwJ1B18qu0827PDS9DaMIcnluMtZaoBXBhLa28Oja3agnKR++7kj4IOXxJUxmCEyZ
	 6cSNOAxaqQK5b4Qy78ei1oe64TbcfvCzAzfz8B7hBO5iKuv0FN9tpQ1lJjbHpPaIei
	 CGjKu5ydmE9kRKHFU1HRIIr6tZt1OJqrdscrpHJWKJFhP6w2RXmCdWI03980Ad/7DL
	 WCES66OfqrF4g==
From: Konstantin Ryabitsev via B4 Web Endpoint <devnull@kernel.org>
Date: Fri, 19 Aug 2022 14:17:18 -0400
Subject: [PATCH v1 4/9] mm/vmstat: Use preempt_[dis|en]able_nested()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220819-test-endpoint-send-v1-4-2d7c68bdbbdc@linuxfoundation.org>
References: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
In-Reply-To: <20220819-test-endpoint-send-v1-0-2d7c68bdbbdc@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-c53d8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4331;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=ZLr+k5q/XdqQ8D5ytuGxgW/t38sBPuLtfCpnkzkEpto=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJL+X163ePqK1hdbXUu6W/3kbdXaxB7zlnV7Fm7lcNNdccuX
 WbWpo5SFQYyLQVZMkaVsX+ymoMKHHnLpPaYwc1iZQIYwcHEKwEQq2Rj++02Vdfjgs3kj43nz7e9Lcq
 In79vyU/Nn2tXOXzyak0IV/jP8Ys5YayZdf9UzsiNCpOdgYPn7y9mLP05+JtGcKCb3d78PPwA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Original-From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Reply-To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

From: Thomas Gleixner <tglx@linutronix.de>

Replace the open coded CONFIG_PREEMPT_RT conditional
preempt_enable/disable() pairs with the new helper functions which hide
the underlying implementation details.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 373d2730fcf2..d514fe7f90af 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -355,8 +355,7 @@ void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 	 * CPU migrations and preemption potentially corrupts a counter so
 	 * disable preemption.
 	 */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
+	preempt_disable_nested();
 
 	x = delta + __this_cpu_read(*p);
 
@@ -368,8 +367,7 @@ void __mod_zone_page_state(struct zone *zone, enum zone_stat_item item,
 	}
 	__this_cpu_write(*p, x);
 
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
+	preempt_enable_nested();
 }
 EXPORT_SYMBOL(__mod_zone_page_state);
 
@@ -393,8 +391,7 @@ void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 	}
 
 	/* See __mod_node_page_state */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
+	preempt_disable_nested();
 
 	x = delta + __this_cpu_read(*p);
 
@@ -406,8 +403,7 @@ void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 	}
 	__this_cpu_write(*p, x);
 
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
+	preempt_enable_nested();
 }
 EXPORT_SYMBOL(__mod_node_page_state);
 
@@ -441,8 +437,7 @@ void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 	s8 v, t;
 
 	/* See __mod_node_page_state */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
+	preempt_disable_nested();
 
 	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
@@ -453,8 +448,7 @@ void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 		__this_cpu_write(*p, -overstep);
 	}
 
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
+	preempt_enable_nested();
 }
 
 void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
@@ -466,8 +460,7 @@ void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
 	/* See __mod_node_page_state */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
+	preempt_disable_nested();
 
 	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
@@ -478,8 +471,7 @@ void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 		__this_cpu_write(*p, -overstep);
 	}
 
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
+	preempt_enable_nested();
 }
 
 void __inc_zone_page_state(struct page *page, enum zone_stat_item item)
@@ -501,8 +493,7 @@ void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 	s8 v, t;
 
 	/* See __mod_node_page_state */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
+	preempt_disable_nested();
 
 	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
@@ -513,8 +504,7 @@ void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 		__this_cpu_write(*p, overstep);
 	}
 
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
+	preempt_enable_nested();
 }
 
 void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
@@ -526,8 +516,7 @@ void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
 	/* See __mod_node_page_state */
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_disable();
+	preempt_disable_nested();
 
 	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
@@ -538,8 +527,7 @@ void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 		__this_cpu_write(*p, overstep);
 	}
 
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		preempt_enable();
+	preempt_enable_nested();
 }
 
 void __dec_zone_page_state(struct page *page, enum zone_stat_item item)

-- 
b4 0.10.0-dev-c53d8

