Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DFB6F2FE;
	Thu, 12 Dec 2024 15:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017994; cv=none; b=P+Hye0+xGXn7/UWVEB46NVnUqJZjynZeD12Xb4A4eA8zmyHQKDlyUgH1WZRBmxCvc4GNgzkvcxMFTtuEaz8FWY8jGw406zHLcqpQZNT4pFy7DwZb+vVXKKJONW3kHVgabVhGT8IrEXg93LMi95dzmHycdpdXyzfHR9iUDVVgBgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017994; c=relaxed/simple;
	bh=IQDwcpsYjy5kfgGq2Is642ZbQW+pd9UK6wBYp1I6Q4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ5dbbt0b13WMNHW3S7frBUMTgelJKW5vi4WJXvYsjAubODVeEb1+1LYUo/yk9FOsRRHj46xMkT2nDUiKydGes3hs5EpfEEn1GFAp4fxi8y2JtZ6THWA5Bmsh2HClTnusM4wBAaIaiQbYIcF3bB5aAkmZQKeZ5PiYU3v1MFepOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cxu/MSnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cxu/MSnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06CAC4CECE;
	Thu, 12 Dec 2024 15:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017994;
	bh=IQDwcpsYjy5kfgGq2Is642ZbQW+pd9UK6wBYp1I6Q4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cxu/MSnYG1hSg542lkrqbP1klKntjt1CrQFZx+ir6gPTgGjwXAJh8tDV6EE/THzra
	 hwBRkUlClOYN2wD8R4q1qZVjJBIBUAKPmqtZFFASD5R/xR4jKspikOCIGoNulLlz2l
	 bH6GrZ8VKZxO+WIBDozaa8YV7b7Xr+U36yzfuwws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.6 168/356] drm/dp_mst: Fix resetting msg rx state after topology removal
Date: Thu, 12 Dec 2024 15:58:07 +0100
Message-ID: <20241212144251.273042401@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -690,6 +690,13 @@ struct drm_dp_mst_topology_mgr {
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


