Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2402EC09B;
	Sat, 12 Sep 2026 11:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212259; cv=none; b=nhuUDSaAmQN45V/JVzq8SQla3EVaCDrjSDZdwIeuLc5Pli1TEPy2RfyR1xpHUigwjl86x8HcT8eu+nxJdnnrRm34Uh89IdzHwyOjcZiQiHlVPvBcb0QjlvcwRS5Sn8+eNbOK/B4JCOYe5Zpxk+ljURBEoR1hRtPX9W+bKAr2r2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212259; c=relaxed/simple;
	bh=MyOMznGIVARY2w3zxQRY+fN7as1knzWP5QdLc39CGK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4zc6F43hyYXN8mFWgIYvwx4nq4xCrDvLk0XqcLjTe84LK2Xi5AtjAYi+MwiUmsA45gN0Zu9oZVsdnvmFwKDZPX3XgMSc9tg6giETO9Y90kjGiT5R4dmOvJyJXpEW+wEJvNTnyKnL6j/JYKPZv3SjGSLSs0ZSZst/M95gQ2hffM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/Lk3Ds5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/Lk3Ds5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18811F000FF;
	Sat, 12 Sep 2026 11:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212258;
	bh=3gNrnbA+34Md2R00PfghKmVO/CyXjrRw+WD2Zsp78/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/Lk3Ds5lx+Y09dbX1Of/dw8a/Ui7Qm2jjxmI27hmuLeR8NEZV6RrJSYBeUrKxQXG
	 DT33p4hNx36fd7rpeZbcNK3urMmXDN7+CbvWIamElCSkXvi+ph63/GniSYtkcLL/Hu
	 Wpa2ZmWGcmt+hAMCSwrxL0eptN3vw/5w0ntxi2ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1400/1518] gtp: add synchronize_net() in gtp_newlink() error path to prevent use-after-free
Date: Sat, 12 Sep 2026 08:59:29 +0200
Message-ID: <20260912065655.218355934@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

[ Upstream commit d989e22ae9802c52c56ad4284d0caf26696cf6ae ]

gtp_newlink()'s error path frees tid_hash and addr_hash without
waiting for an RCU grace period after clearing sk_user_data. A
concurrent gtp_encap_recv() in softirq may still hold the gtp_dev
pointer obtained via rcu_dereference_sk_user_data() and access the
freed memory.

  BUG: KASAN: slab-use-after-free in gtp0_pdp_find+0x1f6/0x200 (gtp.c:152)
  Call Trace:
   <IRQ>
   gtp0_pdp_find+0x1f6/0x200
   gtp_encap_recv+0x527/0x24b0
   udp_queue_rcv_one_skb+0x75f/0xc10

Add synchronize_net() before the kfree calls in out_hashtable, which
covers all error paths from both gtp_encap_enable() and
gtp_create_sockets().

Fixes: 459aa660eb1d8ce6 ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Reported-by: AutonomousCodeSecurity@microsoft.com
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Reported-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Link: https://patch.msgid.link/20260820020735.59474-1-blbllhy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index af45118083ca2..070f37cbddbf6 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1549,6 +1549,8 @@ static int gtp_newlink(struct net_device *dev,
 out_encap:
 	gtp_encap_disable(gtp);
 out_hashtable:
+	/* Wait for RCU readers that may still reference this gtp_dev. */
+	synchronize_net();
 	kfree(gtp->addr_hash);
 	kfree(gtp->tid_hash);
 	return err;
-- 
2.53.0



