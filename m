Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F333C3F4C;
	Thu, 30 Jul 2026 14:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423223; cv=none; b=aK+FGEsy23ALOITUS2LVNUmDGt/9Yn9Uk9eDI/enxN6RD0oaKQgZQcrqISnQeoNU8VlRWHrYOm44NW/0qfb1YyziDdXBCWAEytsSjkLQ+cU/cDTpeUSjP+E2fHWTWP0q5VuEi8p+/p9k9jRVALl5NbCFJmRLT6ucH3VlhrmcvHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423223; c=relaxed/simple;
	bh=KGWlvSzi4gygoksALEjWXJ1ZXQDcc3TpAdsLT4mkpEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XS091TsQrB0HGuQ28dwbfUifE7ck3ADksPQnIH/t2zBvOpwdxUrrtPdCnTYahnbVyZ1k997s5aiqbGi003hmtWA6w9Lw8XAd323pIW40CfT0j72G+rVKD1yWwovYq1hUlsdG0PMkNJ1WJMNksw0YTeSz3olGCL0mM0XkW+nJjmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T9bvCTJb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9bvCTJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 965CB1F000E9;
	Thu, 30 Jul 2026 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423222;
	bh=2mM3eqLxKuc25YYALIM4LgVx2G3SlG8xlQEfvTfCj04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9bvCTJbN2vuPVEZC3UOWEavjfX4x66jWh9p145Rd2TtPQu8Vw9+t+mdvyOwsv8Hz
	 KMO8y5gcAwkZnQgr64cdUCJQd73W16ZWXxqvyqN6LiOYUq0+ZSedMOYSCd61y4yYFK
	 +aJMxwSlrANOe1gst+QThFQmtgqqstq2dW0Otuqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Deak <imre.deak@intel.com>,
	Lyude Paul <lyude@redhat.com>,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	Jonas Emilsson <jonas.emilsson@gmail.com>,
	Luca Coelho <luciano.coelho@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>
Subject: [PATCH 7.1 710/744] drm/dp_mst: Handle torn-down topology gracefully in drm_dp_mst_topology_queue_probe()
Date: Thu, 30 Jul 2026 16:16:23 +0200
Message-ID: <20260730141459.368002107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Coelho <luciano.coelho@intel.com>

commit 613059875958e7b217b250ed14c3b189f9488421 upstream.

A hotplug or link-loss event can tear down the MST topology
(setting mgr->mst_state = false and mgr->mst_primary = NULL) concurrently
with a caller invoking drm_dp_mst_topology_queue_probe(). Since the check
is already performed under mgr->lock, the condition is not a programming
error but a valid race -- the topology was valid when the caller decided
to call this function, but was torn down before the lock was acquired.

Replace the drm_WARN_ON() with a graceful early return. This eliminates
spurious kernel warnings and the resulting compositor crashes observed
when connecting/disconnecting DP MST monitors, while keeping the correct
behavior of doing nothing when MST is not active. A drm_dbg_mst() trace
is added so the skipped probe remains observable under MST debug logging.

The existing WARN_ON(mgr->mst_primary) in drm_dp_mst_topology_mgr_set_mst()
already catches the case where the topology is initialized twice, so no
diagnostic coverage is lost.

Fixes: dbaeef363ea5 ("drm/dp_mst: Add a helper to queue a topology probe")
Cc: Imre Deak <imre.deak@intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Jonas Emilsson <jonas.emilsson@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/all/20260503034533.1023686-1-jonas.emilsson@gmail.com
Acked-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260622140532.526722-1-luciano.coelho@intel.com
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/display/drm_dp_mst_topology.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/display/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/display/drm_dp_mst_topology.c
@@ -3740,8 +3740,10 @@ void drm_dp_mst_topology_queue_probe(str
 {
 	mutex_lock(&mgr->lock);
 
-	if (drm_WARN_ON(mgr->dev, !mgr->mst_state || !mgr->mst_primary))
+	if (!mgr->mst_state || !mgr->mst_primary) {
+		drm_dbg_kms(mgr->dev, "queue_probe skipped: topology torn down\n");
 		goto out_unlock;
+	}
 
 	drm_dp_mst_topology_mgr_invalidate_mstb(mgr->mst_primary);
 	drm_dp_mst_queue_probe_work(mgr);


