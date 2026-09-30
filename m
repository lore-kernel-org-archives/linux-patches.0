Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2105A4D2EFE;
	Wed, 30 Sep 2026 17:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787818; cv=none; b=UwfLieVBbA57KYDtXLjuFgrFk8BrsdyoSqgZXFR3O0JGeSFdm5AMZV/rppctmxqaq8e228HoAEwvYdLbWW8fn63GIa+Ceox8ritmjtRVrVdsG/ONEn2fMCXwSTRbt4BjJVo7wSUHzPNyz+kFWGH4D/isEhoMLPxvm+E639Q3Eoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787818; c=relaxed/simple;
	bh=z93dW4tnmpKZJi0MkLdj/0ECZqcGKbw4dGnNTyj4nNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6jQA3adfu4xTIkfwoZn18dWXojFngF/b0HcwgsLHdHskvZ9vtbrZdH0Li6iqabZV6nB9Zt9Y3fx5PsZaiboFFHouuEzAwUZ8Bm90ZOXKsDGNHOnkwK1pemD0JJbVBb22jP4RbDDgsAcl98AEBfx3YZ3W768x0GTA8lzlQ0wqxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZ0g+Q0c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZ0g+Q0c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2691F000FF;
	Wed, 30 Sep 2026 17:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787817;
	bh=6S86u9y82T1RlP0LWV72XZ1z/t4nt80rtvDOCO66f3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZ0g+Q0c1KV0rlPtNA3wVue9LR57qOWhR2SpVhvrqUP0qwgG7kIEQb4LzevCpZhlD
	 /vmYBT8Fpo5llVzv8pv7uYrg7PzNf2Vx0D8uWwhhrSZITcv/dGdtrr1dhDLJCsZUFj
	 1VasCe4R33AA4P6vGQwnm428QXIBCguybKzr1g3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yunfei <zhangyunfei1@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 347/457] net: txgbe: fix FDIR filter restore for VF rules
Date: Wed, 30 Sep 2026 17:27:32 +0200
Message-ID: <20260930152353.503115603@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Zhang Yunfei <zhangyunfei1@kylinos.cn>

commit 651010592bdce7005c1179498327e51bfc4fe1a5 upstream.

txgbe_fdir_filter_restore() reprograms every filter from
txgbe->fdir_filter_list after a reset. It extracts the ring part of
filter->action with ethtool_get_flow_spec_ring() and maps it onto a
PF rx ring, silently dropping the VF part of the cookie that
txgbe_add_ethtool_fdir_entry() stores there (input->action =
fsp->ring_cookie).

For a rule directed at a VF, restore therefore reprograms the filter
to the PF queue with the same ring index: after any down/up or
txgbe_reinit_locked(), traffic matching the rule is steered to the
PF instead of the VF.

Handle VF rules the same way txgbe_add_ethtool_fdir_entry() does:
validate vf against wx->num_vfs and ring against
wx->num_rx_queues_per_pool, and map the ring onto the absolute
queue index ((vf - 1) * wx->num_rx_queues_per_pool) + ring.

Fixes: 7a91722e0dd4 ("net: txgbe: Support the FDIR rules assigned to VFs")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yunfei <zhangyunfei1@kylinos.cn>
Link: https://patch.msgid.link/20260911091123.798931-1-zhangyunfei1@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_fdir.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_fdir.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_fdir.c
@@ -591,15 +591,24 @@ static void txgbe_fdir_filter_restore(st
 			queue = TXGBE_RDB_FDIR_DROP_QUEUE;
 		} else {
 			u32 ring = ethtool_get_flow_spec_ring(filter->action);
+			u8 vf = ethtool_get_flow_spec_ring_vf(filter->action);
 
-			if (ring >= wx->num_rx_queues) {
+			if (!vf && ring >= wx->num_rx_queues) {
 				wx_err(wx, "FDIR restore failed, ring:%u\n",
 				       ring);
 				continue;
+			} else if (vf && (vf > wx->num_vfs ||
+				  ring >= wx->num_rx_queues_per_pool)) {
+				wx_err(wx, "FDIR restore failed, vf:%u, ring:%u\n",
+				       vf, ring);
+				continue;
 			}
 
 			/* Map the ring onto the absolute queue index */
-			queue = wx->rx_ring[ring]->reg_idx;
+			if (!vf)
+				queue = wx->rx_ring[ring]->reg_idx;
+			else
+				queue = ((vf - 1) * wx->num_rx_queues_per_pool) + ring;
 		}
 
 		ret = txgbe_fdir_write_perfect_filter(wx,


