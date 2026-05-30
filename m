Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59590263F44;
	Sat, 30 May 2026 17:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161900; cv=none; b=DEJlN6lYkvcTnokAAgzhdNJR12c5/mGH+IiHaQ8iEnNCgj/P533LDFo0N0OWsL3oeLJQglFmO/HNmO6ZuikpHsjrfm0B0ZsGcyKDj3Pn1VKFt1cpoXM9X/95hMJa0QA6x50gGzomleRR1HOxUrQfBlPRHyR3pgSjAS3tAIBkJk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161900; c=relaxed/simple;
	bh=HcrIldPu+YPVG702srQA4iqQ128R5LXoe7KJSaK0UPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4bcCfzGatq3v1aG4IeU3c6CWTcypHPqGjrlgtf2N2zPBL0bg1WkS09U/FfZul17a/G1oYpgrmiXcxyUaKvgiYgdZzJNdFn2YMG3TyEA3MTt131xtsjQlDHAAB2sNr8PUpBH0AwG75xo/RKMz5gKmQcyW4ROSfRsarO5qE47wrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0UouiV3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0UouiV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AEA1F00893;
	Sat, 30 May 2026 17:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161899;
	bh=6YzQ/hMf7KEDDQqlfZVSV/6JbJwADLC8TS8pEyYSHZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0UouiV3XIispF4t9Irtkv/LzAX+imWHxObRJmmeB5gd1jd5217J0mitWZZmw6EoF
	 Hr0CyxKRRNeoVmEJqumIKdSvhcamsWESLzxNUQjHvTK/yMer00pAiZwQvsGzXgoGJV
	 O1SxooXqIDk9Lu05FT/3e4WY5XinsgsP8wiSvu7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"William A. Kennington III" <william@wkennington.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 759/969] net: mctp i2c: check length before marking flow active
Date: Sat, 30 May 2026 18:04:43 +0200
Message-ID: <20260530160321.524804176@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William A. Kennington III <william@wkennington.com>

[ Upstream commit 4ca07b9239bd0478ae586632a2ed72be37ed8407 ]

Currently, mctp_i2c_get_tx_flow_state() is called before the packet length
sanity check. This function marks a new flow as active in the MCTP core.

If the sanity check fails, mctp_i2c_xmit() returns early without calling
mctp_i2c_lock_nest(). This results in a mismatched locking state: the
flow is active, but the I2C bus lock was never acquired for it.

When the flow is later released, mctp_i2c_release_flow() will see the
active state and queue an unlock marker. The TX thread will then
decrement midev->i2c_lock_count from 0, causing it to underflow to -1.

This underflow permanently breaks the driver's locking logic, allowing
future transmissions to occur without holding the I2C bus lock, leading
to bus collisions and potential hardware hangs.

Move the mctp_i2c_get_tx_flow_state() call to after the length sanity
check to ensure we only transition the flow state if we are actually
going to proceed with the transmission and locking.

Fixes: f5b8abf9fc3d ("mctp i2c: MCTP I2C binding driver")
Signed-off-by: William A. Kennington III <william@wkennington.com>
Acked-by: Jeremy Kerr <jk@codeconstruct.com.au>
Link: https://patch.msgid.link/20260423074741.201460-1-william@wkennington.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mctp/mctp-i2c.c | 4 ++--
 net/sched/cls_flower.c      | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/mctp/mctp-i2c.c b/drivers/net/mctp/mctp-i2c.c
index 2eeccc3b70eff..cf0947b64a123 100644
--- a/drivers/net/mctp/mctp-i2c.c
+++ b/drivers/net/mctp/mctp-i2c.c
@@ -461,8 +461,6 @@ static void mctp_i2c_xmit(struct mctp_i2c_dev *midev, struct sk_buff *skb)
 	u8 *pecp;
 	int rc;
 
-	fs = mctp_i2c_get_tx_flow_state(midev, skb);
-
 	hdr = (void *)skb_mac_header(skb);
 	/* Sanity check that packet contents matches skb length,
 	 * and can't exceed MCTP_I2C_BUFSZ
@@ -474,6 +472,8 @@ static void mctp_i2c_xmit(struct mctp_i2c_dev *midev, struct sk_buff *skb)
 		return;
 	}
 
+	fs = mctp_i2c_get_tx_flow_state(midev, skb);
+
 	if (skb_tailroom(skb) >= 1) {
 		/* Linear case with space, we can just append the PEC */
 		skb_put(skb, 1);
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index a40a9e84c75f4..fd8c2f0f3256e 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -537,6 +537,7 @@ static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 		       struct netlink_ext_ack *extack)
 {
 	struct cls_fl_head *head = fl_head_dereference(tp);
+	struct fl_flow_mask *mask;
 
 	*last = false;
 
@@ -553,11 +554,12 @@ static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 	list_del_rcu(&f->list);
 	spin_unlock(&tp->lock);
 
-	*last = fl_mask_put(head, f->mask);
+	mask = f->mask;
 	if (!tc_skip_hw(f->flags))
 		fl_hw_destroy_filter(tp, f, rtnl_held, extack);
 	tcf_unbind_filter(tp, &f->res);
 	__fl_put(f);
+	*last = fl_mask_put(head, mask);
 
 	return 0;
 }
-- 
2.53.0



