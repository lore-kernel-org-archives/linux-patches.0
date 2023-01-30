Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55D928EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4ADC433EF;
	Mon, 30 Jan 2023 14:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087569;
	bh=H0Sy5modqtHNlqSQqS/P3ouBfyqA3VdUvVxORAxQ5nY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fX6UostAWp3y1sxE3IXkPYh+Nfid3CNhxYHmvlffamQMeQ6d/km10V0HllS+ocgBs
	 0cv1XA5wbY3rSQlefR0L3n6uMc8TmAzxob1MKJ1+5L3ZEDyjXiJW2wGJbRbbiP2WIM
	 0iHLG2nmR9t2EKEj9NqoWh0raGLyFjwj5dIC22DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Lyude Paul <lyude@redhat.com>,
	Didier Raboud <odyx@debian.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 234/313] drm/display/dp_mst: Correct the kref of port.
Date: Mon, 30 Jan 2023 14:51:09 +0100
Message-Id: <20230130134347.601453014@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wayne Lin <Wayne.Lin@amd.com>

commit d8bf2df715bb8ac964f91fe8bf67c37c5d916463 upstream.

[why & how]
We still need to refer to port while removing payload at commit_tail.
we should keep the kref till then to release.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Fixes: 4d07b0bc4034 ("drm/display/dp_mst: Move all payload info into the atomic state")
Cc: stable@vger.kernel.org # 6.1
Acked-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Tested-by: Didier Raboud <odyx@debian.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/display/drm_dp_mst_topology.c b/drivers/gpu/drm/display/drm_dp_mst_topology.c
index 51a46689cda7..4ca37261584a 100644
--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3372,6 +3372,9 @@ void drm_dp_remove_payload(struct drm_dp_mst_topology_mgr *mgr,
 
 	mgr->payload_count--;
 	mgr->next_start_slot -= payload->time_slots;
+
+	if (payload->delete)
+		drm_dp_mst_put_port_malloc(payload->port);
 }
 EXPORT_SYMBOL(drm_dp_remove_payload);
 
@@ -4327,7 +4330,6 @@ int drm_dp_atomic_release_time_slots(struct drm_atomic_state *state,
 
 	drm_dbg_atomic(mgr->dev, "[MST PORT:%p] TU %d -> 0\n", port, payload->time_slots);
 	if (!payload->delete) {
-		drm_dp_mst_put_port_malloc(port);
 		payload->pbn = 0;
 		payload->delete = true;
 		topology_state->payload_mask &= ~BIT(payload->vcpi - 1);
-- 
2.39.1



