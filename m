Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB8078F2B;
	Mon,  6 Jan 2025 15:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178794; cv=none; b=jbBk0ETmX6657ufQ+TAruYaGquDuFECnPYjnSRBTRX03xjEw2oFO46hraDJTnjF6cuxHTD32qDXgnb+GSDxbtcRqcnTl8yoTQH3yPexxFPFji2lnl+w8yQ+s133MurSgfNqsS+nBRTAPdwcCL7waLaSq/GPuV+YVK8DPHXTFuZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178794; c=relaxed/simple;
	bh=OEtd23vVEDGMGnGe5nj95wHZqwoB0EQALp/Y6clt3io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLJN8N7d4Qr5eUaBuS5BKRtn0VFTneMOVPcMfU83udhufpkDbS3+l6oBjbIuOI8x0vBM48aJPhUsstLqYu5dYCL/2j7rJyH6MH4+STLWF12YKX041+rk9lUv6wCG0qU3uc8g/FSlLBz46okIVT2VjAFAfy/65WZilpevjL476kY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XrdiWpE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrdiWpE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF162C4CED2;
	Mon,  6 Jan 2025 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178794;
	bh=OEtd23vVEDGMGnGe5nj95wHZqwoB0EQALp/Y6clt3io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrdiWpE7w0wlQkiUhTdcdccdMS3o16c0ZFJR1xkpv8Sb7s8eUViQiTri4QXTc7MnQ
	 tL1MSykDhzsFnGmQOvdO6TOaZdZVTD4UYw3IwI/ogTAWR/jWPGwmKrr7Z6rzEvpDrE
	 k1gDUul7gKyw/VFukxgBGKadOE4xD7LYVwl/hP98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/168] drm/dp_mst: Verify request type in the corresponding down message reply
Date: Mon,  6 Jan 2025 16:16:42 +0100
Message-ID: <20250106151142.014171922@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 4d49e77a973d3b5d1881663c3f122906a0702940 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 31 +++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index f72b4ff169a8..86e1a61b6b6d 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3993,6 +3993,34 @@ drm_dp_get_one_sb_msg(struct drm_dp_mst_topology_mgr *mgr, bool up,
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
@@ -4022,6 +4050,9 @@ static int drm_dp_mst_handle_down_rep(struct drm_dp_mst_topology_mgr *mgr)
 		goto out_clear_reply;
 	}
 
+	if (!verify_rx_request_type(mgr, txmsg, msg))
+		goto out_clear_reply;
+
 	drm_dp_sideband_parse_reply(mgr, msg, &txmsg->reply);
 
 	if (txmsg->reply.reply_type == DP_SIDEBAND_REPLY_NAK) {
-- 
2.39.5



