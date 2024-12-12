Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364A3217707;
	Thu, 12 Dec 2024 15:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016342; cv=none; b=ARVNRRKbEWWzBfvKbR/GFIjSyG96tzPKu/ZelUObsCeCWC+vuL8mpC5yb6Aw0QcsVYgADGc5QJQrGYSAc6f7+aM+GUcbvFTE2+RXtTLQ62QvPyJ+qq4ObIWXC6JI2X81hzLBQvxR24oNtD3HIKKt4TzZkE20goG1wfig29hDz8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016342; c=relaxed/simple;
	bh=ri8dVpTwz66BpQO3CYvrGsLwHuOdyV+t35zrRuqTUTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sF/LHTm3dJwqrbu72OKz8CMZa9cK/25vXVGcP5PIBUFSan2y7IyzdDtgHWKO0YG92PuqYU8RFmsBii9De5Mdhu3ajgZViNPzsJPL1E7gkJ5CY7QtgQmfys1cySqekhN6ACVQamo7YcSVvxqX7/2xbhmVPj8omnQnj7AzIPbG0vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BW1CDstB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BW1CDstB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0ABC4CEDD;
	Thu, 12 Dec 2024 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016342;
	bh=ri8dVpTwz66BpQO3CYvrGsLwHuOdyV+t35zrRuqTUTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BW1CDstBTsaCrKkl9Fr5YO72ehxTp3g1LcLNwXwB0Y6iEwR6rDb97TVemJzzY/5gM
	 GvI58HBGh8OJkIANCsVw//te5uQj06sJrmehQ76ut9XNEPxNCQjtSDT3EKl9E+65lU
	 /rfJ9s9TLxTTQBG7/atnoA6TiF1/py5XeIEzv8eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.12 172/466] drm/dp_mst: Verify request type in the corresponding down message reply
Date: Thu, 12 Dec 2024 15:55:41 +0100
Message-ID: <20241212144313.596710028@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 4d49e77a973d3b5d1881663c3f122906a0702940 upstream.

After receiving the response for an MST down request message, the
response should be accepted/parsed only if the response type matches
that of the request. Ensure this by checking if the request type code
stored both in the request and the reply match, dropping the reply in
case of a mismatch.

This fixes the topology detection for an MST hub, as described in the
Closes link below, where the hub sends an incorrect reply message after
a CLEAR_PAYLOAD_TABLE -> LINK_ADDRESS down request message sequence.

Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org>
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/12804
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241203160223.2926014-3-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |   31 ++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3937,6 +3937,34 @@ drm_dp_get_one_sb_msg(struct drm_dp_mst_
 	return true;
 }
 
+static int get_msg_request_type(u8 data)
+{
+	return data & 0x7f;
+}
+
+static bool verify_rx_request_type(struct drm_dp_mst_topology_mgr *mgr,
+				   const struct drm_dp_sideband_msg_tx *txmsg,
+				   const struct drm_dp_sideband_msg_rx *rxmsg)
+{
+	const struct drm_dp_sideband_msg_hdr *hdr = &rxmsg->initial_hdr;
+	const struct drm_dp_mst_branch *mstb = txmsg->dst;
+	int tx_req_type = get_msg_request_type(txmsg->msg[0]);
+	int rx_req_type = get_msg_request_type(rxmsg->msg[0]);
+	char rad_str[64];
+
+	if (tx_req_type == rx_req_type)
+		return true;
+
+	drm_dp_mst_rad_to_str(mstb->rad, mstb->lct, rad_str, sizeof(rad_str));
+	drm_dbg_kms(mgr->dev,
+		    "Got unexpected MST reply, mstb: %p seqno: %d lct: %d rad: %s rx_req_type: %s (%02x) != tx_req_type: %s (%02x)\n",
+		    mstb, hdr->seqno, mstb->lct, rad_str,
+		    drm_dp_mst_req_type_str(rx_req_type), rx_req_type,
+		    drm_dp_mst_req_type_str(tx_req_type), tx_req_type);
+
+	return false;
+}
+
 static int drm_dp_mst_handle_down_rep(struct drm_dp_mst_topology_mgr *mgr)
 {
 	struct drm_dp_sideband_msg_tx *txmsg;
@@ -3966,6 +3994,9 @@ static int drm_dp_mst_handle_down_rep(st
 		goto out_clear_reply;
 	}
 
+	if (!verify_rx_request_type(mgr, txmsg, msg))
+		goto out_clear_reply;
+
 	drm_dp_sideband_parse_reply(mgr, msg, &txmsg->reply);
 
 	if (txmsg->reply.reply_type == DP_SIDEBAND_REPLY_NAK) {


