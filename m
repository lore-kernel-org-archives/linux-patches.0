Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038C22DF126;
	Sat, 17 Oct 2026 18:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260654; cv=none; b=RF58hpN30YKYOg1ONolc2v67kVWiATpvkcJfF7AnRbbrj13SWZyb0FLv6ihHhYB8FWtHkM8v5Wpr2IOZkvR53R0XNPy07jSnnCMnQ2v4cllazxJQiEQH4tK24y5sl5Gfnv+dBF6zRD6CDbh24OeGH7nRWvlmEFbvaR9GfRKz3w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260654; c=relaxed/simple;
	bh=GGWFwIX3e/FZW0RdUe/014GyPEMtHyPWMcM4RNImk1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+ZS1Fkn/mTadBCh2lpp8FYCH9v+bZtbD8tMbytEfwLw0aXMMuJfM9jzOnA7RnWUcHl8Bfjf46yidagkaBlyVO3A+nVPazfoVqi3vUJV/AIYcFKOsSyhSaasRvtq3dRBqZqfZ1OM3DLq+aDjbmbF1dv2kSK+bwDTBMf4NHnPLrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pt/+hh2f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pt/+hh2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597E71F000C4;
	Sat, 17 Oct 2026 18:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260652;
	bh=D1u5/hMcl7OZoG+kIylluJasBXa0Ks6RvjfBcqTQVqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pt/+hh2fMg1xxZZ3gdxHPcIvVDODf5hUHUnAdUzsCIx9q+HAlWpMX0zJ6Ntl1eD5+
	 cRyx0ee46NSZIgUDOMdsRkDtasreeFksOxU0KZdP5Bd7a6l+4v3WedS3s6HAGmU7Gj
	 xusg8ZJa2fKKPviyixOScPyuJ4+U5fT3MXIbt6Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1615/1674] eth: ice: dont dereference pointers from TP_printk()
Date: Sat, 17 Oct 2026 18:04:47 +0200
Message-ID: <20261017160512.538607872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit b8bf9bfda5f62e11444e483c2b4aaff90c5cfc6b ]

After forwarding net-next during the v7.3 merge window we started
seeing:

  TRACE EVENT ERROR: Event ice_tx_dim_work has double dereference in TP_printk: REC->q_vector->tx.tx_ring->q_index
  WARNING: kernel/trace/trace_events.c:420 at test_double_dereference.cold+0x39/0x4b

this is due to extra checks added in tracing subsystem in
commit b5cc230af5e5 ("tracing: Warn when an event dereferences a pointer in TP_printk()").

Printing happens long after the event was recorded, by which point
the pointers may be invalid (the ring or the dim instance).
Copy the eight scalars into the event instead.

Fixes: 3089cf6d3caa ("ice: add tracepoints")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_trace.h | 64 ++++++++++++++--------
 1 file changed, 42 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_trace.h b/drivers/net/ethernet/intel/ice/ice_trace.h
index a41e210a310d1..aac117b8d4438 100644
--- a/drivers/net/ethernet/intel/ice/ice_trace.h
+++ b/drivers/net/ethernet/intel/ice/ice_trace.h
@@ -63,23 +63,33 @@
 DECLARE_EVENT_CLASS(ice_rx_dim_template,
 		    TP_PROTO(struct ice_q_vector *q_vector, struct dim *dim),
 		    TP_ARGS(q_vector, dim),
-		    TP_STRUCT__entry(__field(struct ice_q_vector *, q_vector)
-				     __field(struct dim *, dim)
+		    TP_STRUCT__entry(__field(u16, q_index)
+				     __field(u8, state)
+				     __field(u8, profile_ix)
+				     __field(u8, tune_state)
+				     __field(u8, steps_right)
+				     __field(u8, steps_left)
+				     __field(u8, tired)
 				     __string(devname, q_vector->rx.rx_ring->netdev->name)),
 
-		    TP_fast_assign(__entry->q_vector = q_vector;
-				   __entry->dim = dim;
+		    TP_fast_assign(__entry->q_index = q_vector->rx.rx_ring->q_index;
+				   __entry->state = dim->state;
+				   __entry->profile_ix = dim->profile_ix;
+				   __entry->tune_state = dim->tune_state;
+				   __entry->steps_right = dim->steps_right;
+				   __entry->steps_left = dim->steps_left;
+				   __entry->tired = dim->tired;
 				   __assign_str(devname, q_vector->rx.rx_ring->netdev->name);),
 
 		    TP_printk("netdev: %s Rx-Q: %d dim-state: %d dim-profile: %d dim-tune: %d dim-st-right: %d dim-st-left: %d dim-tired: %d",
 			      __get_str(devname),
-			      __entry->q_vector->rx.rx_ring->q_index,
-			      __entry->dim->state,
-			      __entry->dim->profile_ix,
-			      __entry->dim->tune_state,
-			      __entry->dim->steps_right,
-			      __entry->dim->steps_left,
-			      __entry->dim->tired)
+			      __entry->q_index,
+			      __entry->state,
+			      __entry->profile_ix,
+			      __entry->tune_state,
+			      __entry->steps_right,
+			      __entry->steps_left,
+			      __entry->tired)
 );
 
 DEFINE_EVENT(ice_rx_dim_template, ice_rx_dim_work,
@@ -90,23 +100,33 @@ DEFINE_EVENT(ice_rx_dim_template, ice_rx_dim_work,
 DECLARE_EVENT_CLASS(ice_tx_dim_template,
 		    TP_PROTO(struct ice_q_vector *q_vector, struct dim *dim),
 		    TP_ARGS(q_vector, dim),
-		    TP_STRUCT__entry(__field(struct ice_q_vector *, q_vector)
-				     __field(struct dim *, dim)
+		    TP_STRUCT__entry(__field(u16, q_index)
+				     __field(u8, state)
+				     __field(u8, profile_ix)
+				     __field(u8, tune_state)
+				     __field(u8, steps_right)
+				     __field(u8, steps_left)
+				     __field(u8, tired)
 				     __string(devname, q_vector->tx.tx_ring->netdev->name)),
 
-		    TP_fast_assign(__entry->q_vector = q_vector;
-				   __entry->dim = dim;
+		    TP_fast_assign(__entry->q_index = q_vector->tx.tx_ring->q_index;
+				   __entry->state = dim->state;
+				   __entry->profile_ix = dim->profile_ix;
+				   __entry->tune_state = dim->tune_state;
+				   __entry->steps_right = dim->steps_right;
+				   __entry->steps_left = dim->steps_left;
+				   __entry->tired = dim->tired;
 				   __assign_str(devname, q_vector->tx.tx_ring->netdev->name);),
 
 		    TP_printk("netdev: %s Tx-Q: %d dim-state: %d dim-profile: %d dim-tune: %d dim-st-right: %d dim-st-left: %d dim-tired: %d",
 			      __get_str(devname),
-			      __entry->q_vector->tx.tx_ring->q_index,
-			      __entry->dim->state,
-			      __entry->dim->profile_ix,
-			      __entry->dim->tune_state,
-			      __entry->dim->steps_right,
-			      __entry->dim->steps_left,
-			      __entry->dim->tired)
+			      __entry->q_index,
+			      __entry->state,
+			      __entry->profile_ix,
+			      __entry->tune_state,
+			      __entry->steps_right,
+			      __entry->steps_left,
+			      __entry->tired)
 );
 
 DEFINE_EVENT(ice_tx_dim_template, ice_tx_dim_work,
-- 
2.53.0



