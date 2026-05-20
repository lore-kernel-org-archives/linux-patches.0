Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB083546F0;
	Wed, 20 May 2026 18:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302779; cv=none; b=Wa3td5OD8zODjCSRdD3CFeXlH2VhY2UisLd4zMH5QjvQm/jDPnL9WPrN/H1nOIf5nGE9u6WkAnjoF6Ipb9F7vbXsAMPPD0T6n5ImS22efQc9NGsyS7IweDdrFtFhSjBQC5y4TwUGuNy8Bv0cpmuP+lHe5cVM4xVvHqp+Ec72gII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302779; c=relaxed/simple;
	bh=2hLG/eAEL6IHLzUawOCiwu0lt0ojq4ReW8QG+42mx/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMAoNyOBEtNvCAahWgCJyeI0cWlGCxnuEINSDqFLoA4h9we78mBVBYc84ZTmkqqQBM40uZmlt2thtO8idV5P6rFRiejBkNCriD9jonkIh67Z/0GfB9zMO+WJ9+iEUX1EclhFjcItTR2/5Coo5Uap8L42EFJ3/mm3ovoPc7ApPXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eg8kq5uY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eg8kq5uY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F68B1F000E9;
	Wed, 20 May 2026 18:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302777;
	bh=TsQKdt+LVgZDlZuSI/FJ4UsEc/luK4q8TQ3YT32ay3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eg8kq5uYmdPVdsWzgH+fo+VnaXO/VZF2cZmQs79AuvdLLUNQMjkmQyzU0GkAspPAO
	 qI+forsxMB4Ag33xxXiFH8+xf0Ytq8wGlqCB4LwbuFm14gxqnKADLjZpn4W9jSUxdy
	 UzajTIueez49gxaFykO8zquLyTR3PVx06vW8MFyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"William A. Kennington III" <william@wkennington.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 397/508] net: mctp i2c: check length before marking flow active
Date: Wed, 20 May 2026 18:23:40 +0200
Message-ID: <20260520162107.216760919@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1a7e7397ba75c..8f0b4eb5b6f89 100644
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
index b00e491e8130d..07259b403e108 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -549,6 +549,7 @@ static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
 		       struct netlink_ext_ack *extack)
 {
 	struct cls_fl_head *head = fl_head_dereference(tp);
+	struct fl_flow_mask *mask;
 
 	*last = false;
 
@@ -565,11 +566,12 @@ static int __fl_delete(struct tcf_proto *tp, struct cls_fl_filter *f,
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



