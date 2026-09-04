Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F44F3EC6AE;
	Fri,  4 Sep 2026 05:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500042; cv=none; b=qQPo/lxXv5hL9+TR9FrPv3qt/pLCKyFFAcohh3MiGcEVH2Di15XPjsEpYOYejOrfso4OqYzulTfLaorXMwVRKATsRN80w/z+um94ZGYm9XIvMST9ecjdeNSibUaJO6W5/wlHkkxEbtVrtVGoBgUNgRZdQpvPz26FD1/zTKNJ8OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500042; c=relaxed/simple;
	bh=HLoHHxjtyes4dHWHs79h6WxrcChiHLtx6+m0DQcL0To=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/GCa9H+Gm245O9qU9kj7r7U6X+MOkXW3GxQlcQxqlaWTTy33l+bNrl2oFoubHl/eLGZ2GbtfGu81ek7huJ0Af9cdogJv62176WYoH15oxVSVyuuJ3JPqi5HLKCYM06fFKCM/vdMgOOUvqv3IB2evEEPrJjfVFizl8xWqQ3IywI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mDCt5ZBj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mDCt5ZBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79561F00A3D;
	Fri,  4 Sep 2026 05:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500041;
	bh=2+9NIbecK3LpxA2/VsrwqbJxHDlBywLFcSetVeTXMy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mDCt5ZBjq/wsvjsyO0tYwbU0iqjwA2tKX+mSGDN/TGUxpqKUGOz/O5CURG5OwqKZC
	 89qqQGIoe2iJZhLiA68JhiL4GYMb4RMxcCPAXwCuxCzknIArmBZi8UeU+cunwWRU3q
	 iqCIckFI8AeFv376ABiMeE0FzJG/0imeF/IQSRhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.2 628/713] net: fix spurious TX timeout after dev_activate()
Date: Fri,  4 Sep 2026 06:59:56 +0200
Message-ID: <20260904045817.905618397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 82aeed2400786bd3f79d88cb8b8f42e6127e5923 upstream.

While debugging another issue today, I found out that my TX queue is
reported as stopped for 4294907392 ms (49.7 days), on a machine that
had been up for four minutes.

    bnxt_en 0002:01:00.0 eth0: NETDEV WATCHDOG: CPU: 28: transmit queue 23 timed out 4294907392 ms

4294907392 is not an elapsed time. It is the value of jiffies at that
moment: INITIAL_JIFFIES is 4294667296, which leaves jiffies 59 seconds
short of wrapping.

dev_activate() runs transition_one_qdisc() over every TX queue, which
resets trans_start to 0, and then stamps only queue 0 through
netif_trans_update().

Stamp jiffies instead. A queue stopped across dev_activate() now gets a
full watchdog_timeo of grace, and is still reported if it is stopped
that long.

Fixes: 9b36627acecd ("net: remove dev->trans_start")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Link: https://patch.msgid.link/20260825-trans_start-v2-1-286b4d6d70cb@debian.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1278,7 +1278,7 @@ static void transition_one_qdisc(struct
 
 	rcu_assign_pointer(dev_queue->qdisc, new_qdisc);
 	if (need_watchdog_p) {
-		WRITE_ONCE(dev_queue->trans_start, 0);
+		WRITE_ONCE(dev_queue->trans_start, jiffies);
 		*need_watchdog_p = 1;
 	}
 }


