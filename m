Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00A8882C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56782C4339E;
	Fri, 10 Mar 2023 15:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461433;
	bh=DZaCYSRo0NyDNMgDLmTs+CC/NU3Ive8CY5yxMX3Q0Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGtqgid2w0jPSTiyVSGbRFh9bOheOJFaCITD3Vl0jBc8f9WwZSfQJSAdjTCl9Z1vq
	 NRK4TCY0QFeDbRHe54PY1R+RvtMbJcMESYsMJ/Zn/Xi1VcfodjC9rcjABAtRjwBiTf
	 AWW6Cqj4WWgVwG80MXZ5ZIWiT+i8eeVWzc5GugVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 5.15 126/136] drm/display/dp_mst: Fix down/up message handling after sink disconnect
Date: Fri, 10 Mar 2023 14:44:08 +0100
Message-Id: <20230310133711.032419184@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Imre Deak <imre.deak@intel.com>

commit 1d082618bbf3b6755b8cc68c0a8122af2842d593 upstream.

If the sink gets disconnected during receiving a multi-packet DP MST AUX
down-reply/up-request sideband message, the state keeping track of which
packets have been received already is not reset. This results in a failed
sanity check for the subsequent message packet received after a sink is
reconnected (due to the pending message not yet completed with an
end-of-message-transfer packet), indicated by the

"sideband msg set header failed"

error.

Fix the above by resetting the up/down message reception state after a
disconnect event.

Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org> # v3.17+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221214184258.2869417-1-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3781,6 +3781,9 @@ int drm_dp_mst_topology_mgr_set_mst(stru
 		set_bit(0, &mgr->payload_mask);
 		mgr->vcpi_mask = 0;
 		mgr->payload_id_table_cleared = false;
+
+		memset(&mgr->down_rep_recv, 0, sizeof(mgr->down_rep_recv));
+		memset(&mgr->up_req_recv, 0, sizeof(mgr->up_req_recv));
 	}
 
 out_unlock:


