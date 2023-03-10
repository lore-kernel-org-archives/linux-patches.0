Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74508481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E03CC4339E;
	Fri, 10 Mar 2023 14:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457596;
	bh=gVphm+xsFMlbcyDN5+JWhRQKpSaNF1rAO1SHDlmEuLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/UmTicAnh2bdlOo5qyt/fFJOpi4S9oBYcHFEb3QfPN+SQzqW3ohFYscdY7h6I6Oc
	 1mZWTHRmnCB1ZNLwaTyxnlXS0vSgNP6NJxn96pw7pGNjNHZkw7k/s13nJ2PW64qbCs
	 xY55gaWImIPExvFo62GNxs1sY20Xw9K0B0QKXl+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.1 191/200] drm/display/dp_mst: Fix payload addition on a disconnected sink
Date: Fri, 10 Mar 2023 14:39:58 +0100
Message-Id: <20230310133722.955042342@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

commit 33f960e23c29d113fe3193e0bdc19ac4f3776f20 upstream.

If an MST stream is enabled on a disconnected sink, the payload for the
stream is not created and the MST manager's payload count/next start VC
slot is not updated. Since the payload's start VC slot may still contain
a valid value (!= -1) the subsequent disabling of such a stream could
cause an incorrect decrease of the payload count/next start VC slot in
drm_dp_remove_payload() and hence later payload additions will fail.

Fix the above by marking the payload as invalid in the above case, so
that it's skipped during payload removal. While at it add a debug print
for this case.

Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org> # v6.1+
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221214184258.2869417-3-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 01350510244f..5861b0a6247b 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3309,8 +3309,13 @@ int drm_dp_add_payload_part1(struct drm_dp_mst_topology_mgr *mgr,
 	int ret;
 
 	port = drm_dp_mst_topology_get_port_validated(mgr, payload->port);
-	if (!port)
+	if (!port) {
+		drm_dbg_kms(mgr->dev,
+			    "VCPI %d for port %p not in topology, not creating a payload\n",
+			    payload->vcpi, payload->port);
+		payload->vc_start_slot = -1;
 		return 0;
+	}
 
 	if (mgr->payload_count == 0)
 		mgr->next_start_slot = mst_state->start_slot;
-- 
2.39.2



