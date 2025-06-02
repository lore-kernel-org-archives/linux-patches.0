Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27252248B5;
	Mon,  2 Jun 2025 14:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875057; cv=none; b=Jx4PCcGK4cIleHhYfprRnODXA912NxqtEv+wKRZRTwo1SbnZs2/8vViRsHADUbjyiiYpHmV9hsB90teGfGOnj3Bp1ZGpF3p25vF+erG3gT0u3fCPuuB3Ug3ZJn29KkmPbaYkEYba9AXjxXG6/6pK3WVvsnZu15U4Pj5AFQdOSAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875057; c=relaxed/simple;
	bh=JUhiKdmcN+kPguFhhCCX9OFbyYUKGdhk8tEeSkiL4Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GuSWxXHQu/swIyrp9X2BTlimuA/o0LokYeeFBPXSnlWppgGsRp2/UFgL/QaK0U07C6/tSHCoPAhxAulVUkYzoKWDQhfUwaDWswlld6dJGztgW9xOwdY20ZbBIADX4fH97w2lgt0OwVB4Qz1cN64Z2Srxanf4fpGt1h7SVwjsa2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05oW9UOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05oW9UOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13B6C4CEEB;
	Mon,  2 Jun 2025 14:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875057;
	bh=JUhiKdmcN+kPguFhhCCX9OFbyYUKGdhk8tEeSkiL4Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=05oW9UOCFDPjczlHIjvCScZyH2MbHCiJd6+kRWXiwMYdDzQbtxV0FwAnD0tGYO/Eh
	 l/XC3Yg+kXp7ySg7phI0CXE85JDv+ToEEJ35//iskkNbfdus/kyCPe8qpCZxBMltVd
	 qy81NIl25rVKQYmmrZ4pcOkSm8mErD9+WWELKyu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 015/270] net/sched: act_mirred: dont override retval if we already lost the skb
Date: Mon,  2 Jun 2025 15:45:00 +0200
Message-ID: <20250602134307.818246525@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit 166c2c8a6a4dc2e4ceba9e10cfe81c3e469e3210 upstream.

If we're redirecting the skb, and haven't called tcf_mirred_forward(),
yet, we need to tell the core to drop the skb by setting the retcode
to SHOT. If we have called tcf_mirred_forward(), however, the skb
is out of our hands and returning SHOT will lead to UaF.

Move the retval override to the error path which actually need it.

Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Fixes: e5cf1baf92cb ("act_mirred: use TC_ACT_REINSERT when possible")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Minor conflict resolved due to code context change.]
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_mirred.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -256,31 +256,31 @@ static int tcf_mirred_act(struct sk_buff
 
 	m_mac_header_xmit = READ_ONCE(m->tcfm_mac_header_xmit);
 	m_eaction = READ_ONCE(m->tcfm_eaction);
+	is_redirect = tcf_mirred_is_act_redirect(m_eaction);
 	retval = READ_ONCE(m->tcf_action);
 	dev = rcu_dereference_bh(m->tcfm_dev);
 	if (unlikely(!dev)) {
 		pr_notice_once("tc mirred: target device is gone\n");
-		goto out;
+		goto err_cant_do;
 	}
 
 	if (unlikely(!(dev->flags & IFF_UP)) || !netif_carrier_ok(dev)) {
 		net_notice_ratelimited("tc mirred to Houston: device %s is down\n",
 				       dev->name);
-		goto out;
+		goto err_cant_do;
 	}
 
 	/* we could easily avoid the clone only if called by ingress and clsact;
 	 * since we can't easily detect the clsact caller, skip clone only for
 	 * ingress - that covers the TC S/W datapath.
 	 */
-	is_redirect = tcf_mirred_is_act_redirect(m_eaction);
 	at_ingress = skb_at_tc_ingress(skb);
 	use_reinsert = at_ingress && is_redirect &&
 		       tcf_mirred_can_reinsert(retval);
 	if (!use_reinsert) {
 		skb2 = skb_clone(skb, GFP_ATOMIC);
 		if (!skb2)
-			goto out;
+			goto err_cant_do;
 	}
 
 	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
@@ -323,12 +323,16 @@ static int tcf_mirred_act(struct sk_buff
 	}
 
 	err = tcf_mirred_forward(want_ingress, skb2);
-	if (err) {
-out:
+	if (err)
 		tcf_action_inc_overlimit_qstats(&m->common);
-		if (tcf_mirred_is_act_redirect(m_eaction))
-			retval = TC_ACT_SHOT;
-	}
+	__this_cpu_dec(mirred_nest_level);
+
+	return retval;
+
+err_cant_do:
+	if (is_redirect)
+		retval = TC_ACT_SHOT;
+	tcf_action_inc_overlimit_qstats(&m->common);
 	__this_cpu_dec(mirred_nest_level);
 
 	return retval;


