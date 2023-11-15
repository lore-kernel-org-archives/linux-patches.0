Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ED63DB91
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuREdTbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C5BC433C7;
	Wed, 15 Nov 2023 19:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076721;
	bh=FXX9J49ZgIuNEinikvoIBseF8qM7464G5en0HGG0QTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuREdTbjAQ+T+vCA0On/Me7KmGHlljBfp99SdBurZWPOSJQsjBcmDgoza3X6iRdki
	 AovnR6kNs//3ij+O8OjTfmasm3q6B9MLWsejYxtSaAHEvX+v2cUGrIZ0ck6YiwkziO
	 wnP6nn927YnpuyTD9X0Tg0RCS2tOcn6kZCz+M6kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 401/550] misc: st_core: Do not call kfree_skb() under spin_lock_irqsave()
Date: Wed, 15 Nov 2023 14:16:25 -0500
Message-ID: <20231115191628.634511284@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 4d08c3d12b61022501989f9f071514d2d6f77c47 ]

It is not allowed to call kfree_skb() from hardware interrupt
context or with hardware interrupts being disabled.
So replace kfree_skb() with dev_kfree_skb_irq() under
spin_lock_irqsave(). Compile tested only.

Fixes: 53618cc1e51e ("Staging: sources for ST core")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20230823035020.1281892-1-ruanjinjie@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ti-st/st_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 01d2257deea46..1f2542dcba4de 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -15,6 +15,7 @@
 #include <linux/skbuff.h>
 
 #include <linux/ti_wilink_st.h>
+#include <linux/netdevice.h>
 
 extern void st_kim_recv(void *, const unsigned char *, long);
 void st_int_recv(void *, const unsigned char *, long);
@@ -435,7 +436,7 @@ static void st_int_enqueue(struct st_data_s *st_gdata, struct sk_buff *skb)
 	case ST_LL_AWAKE_TO_ASLEEP:
 		pr_err("ST LL is illegal state(%ld),"
 			   "purging received skb.", st_ll_getstate(st_gdata));
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 		break;
 	case ST_LL_ASLEEP:
 		skb_queue_tail(&st_gdata->tx_waitq, skb);
@@ -444,7 +445,7 @@ static void st_int_enqueue(struct st_data_s *st_gdata, struct sk_buff *skb)
 	default:
 		pr_err("ST LL is illegal state(%ld),"
 			   "purging received skb.", st_ll_getstate(st_gdata));
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 		break;
 	}
 
@@ -498,7 +499,7 @@ void st_tx_wakeup(struct st_data_s *st_data)
 				spin_unlock_irqrestore(&st_data->lock, flags);
 				break;
 			}
-			kfree_skb(skb);
+			dev_kfree_skb_irq(skb);
 			spin_unlock_irqrestore(&st_data->lock, flags);
 		}
 		/* if wake-up is set in another context- restart sending */
-- 
2.42.0



