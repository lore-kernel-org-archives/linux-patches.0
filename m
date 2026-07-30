Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F050340DFC6;
	Thu, 30 Jul 2026 15:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424984; cv=none; b=nM5KA2BnotGWuT9irfcdTfdm9swGqwPsb1GtWVXlusj7+8Uqos2PQZ1xSBcLRWujLVPUrH7wMZA6i7xdbQ4QVzQW6dXOd/J4Ur2qJz16csQCk7QVCwwxhOhryaLX9qFczds2PNOGbjalf8f0tgID2LIO6jd19udYnt3opTAoWP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424984; c=relaxed/simple;
	bh=kOfIVhITJXszJ3bpnDd6fr2SkVQW73CmYPN+sv7+5ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5RHSphkSJP2gO+27v4ONt2PaZRrMfO/8xCvQS9IgGs+Wn7mXZ4gnt7A48ew1AeFyx7evDN1ocyazf3pPWGgH4q24roS+9eUbppIWzxDOaPcmqjzc7GzIjRiRrLKjk6ChJ2BwW4AXmJRdIHL/xPIzk/8pwJPkBlzRfTyWZfSGVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRk/7pcb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRk/7pcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2012F1F000E9;
	Thu, 30 Jul 2026 15:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424982;
	bh=pah5NjNoLXfTelcNYb9D1MQKbnd7aIoBIPkHYg6Zk40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jRk/7pcbQc0ws52riVf0zrLkggbDlgIhNy6rDW/7fBlzxdBvl4O3ZeYZ6mLApGuJG
	 01QwW2q6VA/Iv5zssgagEnnq0fmBisyFXpGhXr7/+lT1Ff1xmK/N/uWZ5NgmHvTImU
	 4jtlcQscT/cmvnnzC7+j/4qPGAouR+fB7X7+ms9k=
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
Subject: [PATCH 6.18 584/675] drm/dp_mst: Handle torn-down topology gracefully in drm_dp_mst_topology_queue_probe()
Date: Thu, 30 Jul 2026 16:15:14 +0200
Message-ID: <20260730141457.535177016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


