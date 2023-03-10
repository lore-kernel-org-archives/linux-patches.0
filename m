Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F3BA8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC2F6C433EF;
	Fri, 10 Mar 2023 14:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457022;
	bh=XxkmY2yiIMJC/qSCr8YHujO/njukcWxugAbZZqrorZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQMajtwW2XjIglXidH7vQF90hp1iWRRABKdLW2+0kh1u9KHlYhi/MyqRQ4Ag+VSW7
	 GlQO++3gdorrzTPe4fO8YjUD/A2q8M1RPQmIUz5UqsHrKPxMM4t+++U6WnsyI5/huE
	 k5pRc7GOxhIz+ZTFVS+GBT8RfZDlhXOJvet60HUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.2 204/211] drm/display/dp_mst: Fix payload addition on a disconnected sink
Date: Fri, 10 Mar 2023 14:39:44 +0100
Message-Id: <20230310133725.125075034@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
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
 drivers/gpu/drm/display/drm_dp_mst_topology.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3309,8 +3309,13 @@ int drm_dp_add_payload_part1(struct drm_
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


