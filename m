Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B09175A89;
	Wed, 30 Sep 2026 18:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793530; cv=none; b=LgR538YU0XsOWgeODVsCvhkHavbE+qXG9JrpyrCZQCenP69xAZcyf6L53j0nTspyU5NoeLV3DpuPeEVY3WAwaCNOZz0goJc5ehtiFrEriZFuF3WP4ODSU2ji7yKNqrLT8mvk5Ic+CRpO5ukCAN1kA4zOqu44FSM8Mef63OUGdVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793530; c=relaxed/simple;
	bh=EP1HkLBWxntcFZkCk8XsqAtwlbWdDaIvJb9lLZUzix0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbSl7T1VBcxvWpPOhDr0agOufwZzZ05/m0AGZSg7aceIkQ553wbMhXFe06jSv5HWUu8JxfUFrEUzCsB5e3r/vJ67h4z9AITlwJLeiDhdNqlSuZOaNzyeGTImsO6gAvPSn3zYUHwycm43UqNgbt/fsmRj4WkzggQevSIklIx2pCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCwQP2sR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCwQP2sR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55C4A1F000FF;
	Wed, 30 Sep 2026 18:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793528;
	bh=CE1eKZGW7JvC5rnreF2XvoJrND9lS1daYQ87DYCn3Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCwQP2sR12SNiidWE5+Iusy3HnSwj20iHdnTPeCsnqqL6EdllXMJWHYPh82xh7Wcw
	 SSdbAdjlSpSXVlYMNex4pkjiFfverbsT64/sutbI8QjHCaioqRaW6hfi6eLe2p23cx
	 ygTO49nKtbKN5+HKF89X2NTgTu/jGlxFacnvFoGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yunfei <zhangyunfei1@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 287/395] net: txgbe: fix FDIR filter restore for VF rules
Date: Wed, 30 Sep 2026 17:29:09 +0200
Message-ID: <20260930152346.885469727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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


