Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739B818C03F;
	Tue, 10 Sep 2024 09:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961499; cv=none; b=AY7LmTOpLfTRI2Zp2FSlL3emfgWDCXkqTfVshq437b8Jm+cAmVpNcmRqsb/gFkc/pk/e9ruFTBs56z0U5mKyMENrtZ+0UZ//0NCySI1lWQJs/P2ylUhkHZvTTaBFzKXA9xbY+RUnTgFeavmvjSf4QLQcmVPk/SYjmv9ynRlJGs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961499; c=relaxed/simple;
	bh=ad0QAjPkANkMefGKmprfFX7k8hmc7XQ183q5lDgWtUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhmb6wmWLYpHxx/N5ljTWGDP4dJ580p1sIT2ZkGVqH6Y6hfQhEPVfMqLcYDde3cC5VH1nzur8GEKx1P8o9UuniWDQNW5jbcuoo5LTbGpgTHBbbgTR0srsYu0yuQVg26lZ9qweU8obE9S+cuspOrAWcmekuX7tPhBHfAElZOzRCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhqEIZyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhqEIZyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C12C4CECE;
	Tue, 10 Sep 2024 09:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961499;
	bh=ad0QAjPkANkMefGKmprfFX7k8hmc7XQ183q5lDgWtUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhqEIZyhR/TsPOMxmHv32vnZEGb4XEn3oH6qfSzFOgNc76ZJWKeP2fzLoABQQGVov
	 XxgW2PQvzfpqDN8WRfKa4Yb520ajIYExJSPRZ8DO6EcVmhL2XZel+ew5M1AEmBxwRQ
	 nMKh4uikrtahCq2/Yy5HHuENECf5KFNX0ALAWuAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Roman Li <roman.li@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 091/375] drm/amd/display: Lock DC and exit IPS when changing backlight
Date: Tue, 10 Sep 2024 11:28:08 +0200
Message-ID: <20240910092625.301209885@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Li <sunpeng.li@amd.com>

commit 53c3685f5307967a62517ace10e69d66520d0fc5 upstream.

Backlight updates require aux and/or register access. Therefore, driver
needs to disallow IPS beforehand.

So, acquire the dc lock before calling into dc to update backlight - we
should be doing this regardless of IPS. Then, while the lock is held,
disallow IPS before calling into dc, then allow IPS afterwards (if it
was previously allowed).

Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 988fe2862635c1b1b40e41c85c24db44ab337c13)
Cc: stable@vger.kernel.org # 6.10+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4237,7 +4237,7 @@ static void amdgpu_dm_backlight_set_leve
 	struct amdgpu_dm_backlight_caps caps;
 	struct dc_link *link;
 	u32 brightness;
-	bool rc;
+	bool rc, reallow_idle = false;
 
 	amdgpu_dm_update_backlight_caps(dm, bl_idx);
 	caps = dm->backlight_caps[bl_idx];
@@ -4250,6 +4250,12 @@ static void amdgpu_dm_backlight_set_leve
 	link = (struct dc_link *)dm->backlight_link[bl_idx];
 
 	/* Change brightness based on AUX property */
+	mutex_lock(&dm->dc_lock);
+	if (dm->dc->caps.ips_support && dm->dc->ctx->dmub_srv->idle_allowed) {
+		dc_allow_idle_optimizations(dm->dc, false);
+		reallow_idle = true;
+	}
+
 	if (caps.aux_support) {
 		rc = dc_link_set_backlight_level_nits(link, true, brightness,
 						      AUX_BL_DEFAULT_TRANSITION_TIME_MS);
@@ -4261,6 +4267,11 @@ static void amdgpu_dm_backlight_set_leve
 			DRM_DEBUG("DM: Failed to update backlight on eDP[%d]\n", bl_idx);
 	}
 
+	if (dm->dc->caps.ips_support && reallow_idle)
+		dc_allow_idle_optimizations(dm->dc, true);
+
+	mutex_unlock(&dm->dc_lock);
+
 	if (rc)
 		dm->actual_brightness[bl_idx] = user_brightness;
 }


