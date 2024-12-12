Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A202144C0;
	Thu, 12 Dec 2024 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021030; cv=none; b=pvDLK66rYSzjsA32d54zfioIiTF3l933VoNEs9OJZpDGte6S4Zt19FvJaeeWghor0PkR5fuNqlf5/QkR7//dcRFFgYtTNM3ldCIW2wSyKdziHOo5V2FQtyhtiNbQ2HsltElwuZ5BbCmo7I1WXKu0Fp2qrg53IpiekugqTpiej6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021030; c=relaxed/simple;
	bh=yvszQuYjAVp6foieEJBRYWDSdxTBHX//R8sh810gAzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSniLNFvDx5eFbGSCG5Lq79+zc+hT3aS+aRxXQOzm2X2keFcONNFYq7lo5/8vVwCgPBL+/JRUFTnRUGu6TjLKzM6YVd8LCDuv66POD+9xG6ca8oDeRv+B0jeokiOrgp9Gd2NhJH5ghnDS9YEY3tegWKQ2t8AUcwIejGn0AB9mIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdrZkLeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdrZkLeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F223C4CECE;
	Thu, 12 Dec 2024 16:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021030;
	bh=yvszQuYjAVp6foieEJBRYWDSdxTBHX//R8sh810gAzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdrZkLeV2IJ2O8ouWpaRX0B4aS0YtFVG7k0pzhs8FN7+vncU8bTbTunuQzU0GmOjU
	 VaP7NqiPbCTza6uEzx8DEbQsKzFrVViHlec6wsMN//xPTp2+tT3QME6txot9rbtnQ5
	 dMd9TGjJpkenlJ5uFJA2U4KHavJ2S3mwdq0mT9gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.1 627/772] drm/dp_mst: Fix resetting msg rx state after topology removal
Date: Thu, 12 Dec 2024 15:59:32 +0100
Message-ID: <20241212144415.843443125@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit a6fa67d26de385c3c7a23c1e109a0e23bfda4ec7 upstream.

If the MST topology is removed during the reception of an MST down reply
or MST up request sideband message, the
drm_dp_mst_topology_mgr::up_req_recv/down_rep_recv states could be reset
from one thread via drm_dp_mst_topology_mgr_set_mst(false), racing with
the reading/parsing of the message from another thread via
drm_dp_mst_handle_down_rep() or drm_dp_mst_handle_up_req(). The race is
possible since the reader/parser doesn't hold any lock while accessing
the reception state. This in turn can lead to a memory corruption in the
reader/parser as described by commit bd2fccac61b4 ("drm/dp_mst: Fix MST
sideband message body length check").

Fix the above by resetting the message reception state if needed before
reading/parsing a message. Another solution would be to hold the
drm_dp_mst_topology_mgr::lock for the whole duration of the message
reception/parsing in drm_dp_mst_handle_down_rep() and
drm_dp_mst_handle_up_req(), however this would require a bigger change.
Since the fix is also needed for stable, opting for the simpler solution
in this patch.

Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org>
Fixes: 1d082618bbf3 ("drm/display/dp_mst: Fix down/up message handling after sink disconnect")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/13056
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241203160223.2926014-2-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |   21 +++++++++++++++++++--
 include/drm/display/drm_dp_mst_helper.h       |    7 +++++++
 2 files changed, 26 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3655,8 +3655,7 @@ int drm_dp_mst_topology_mgr_set_mst(stru
 		ret = 0;
 		mgr->payload_id_table_cleared = false;
 
-		memset(&mgr->down_rep_recv, 0, sizeof(mgr->down_rep_recv));
-		memset(&mgr->up_req_recv, 0, sizeof(mgr->up_req_recv));
+		mgr->reset_rx_state = true;
 	}
 
 out_unlock:
@@ -3784,6 +3783,11 @@ out_fail:
 }
 EXPORT_SYMBOL(drm_dp_mst_topology_mgr_resume);
 
+static void reset_msg_rx_state(struct drm_dp_sideband_msg_rx *msg)
+{
+	memset(msg, 0, sizeof(*msg));
+}
+
 static bool
 drm_dp_get_one_sb_msg(struct drm_dp_mst_topology_mgr *mgr, bool up,
 		      struct drm_dp_mst_branch **mstb)
@@ -4097,6 +4101,17 @@ out:
 	return 0;
 }
 
+static void update_msg_rx_state(struct drm_dp_mst_topology_mgr *mgr)
+{
+	mutex_lock(&mgr->lock);
+	if (mgr->reset_rx_state) {
+		mgr->reset_rx_state = false;
+		reset_msg_rx_state(&mgr->down_rep_recv);
+		reset_msg_rx_state(&mgr->up_req_recv);
+	}
+	mutex_unlock(&mgr->lock);
+}
+
 /**
  * drm_dp_mst_hpd_irq_handle_event() - MST hotplug IRQ handle MST event
  * @mgr: manager to notify irq for.
@@ -4131,6 +4146,8 @@ int drm_dp_mst_hpd_irq_handle_event(stru
 		*handled = true;
 	}
 
+	update_msg_rx_state(mgr);
+
 	if (esi[1] & DP_DOWN_REP_MSG_RDY) {
 		ret = drm_dp_mst_handle_down_rep(mgr);
 		*handled = true;
--- a/include/drm/display/drm_dp_mst_helper.h
+++ b/include/drm/display/drm_dp_mst_helper.h
@@ -695,6 +695,13 @@ struct drm_dp_mst_topology_mgr {
 	bool payload_id_table_cleared : 1;
 
 	/**
+	 * @reset_rx_state: The down request's reply and up request message
+	 * receiver state must be reset, after the topology manager got
+	 * removed. Protected by @lock.
+	 */
+	bool reset_rx_state : 1;
+
+	/**
 	 * @payload_count: The number of currently active payloads in hardware. This value is only
 	 * intended to be used internally by MST helpers for payload tracking, and is only safe to
 	 * read/write from the atomic commit (not check) context.


