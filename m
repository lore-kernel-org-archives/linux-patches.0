Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427E82C2340;
	Mon, 18 Aug 2025 14:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526167; cv=none; b=nX2hlmUVSFaRau4nGdoog1Jlp7H31oDdl4FmYHrdRtruCyi+CI2VczszmU0MjfUC6rm1KZzhEFki3k9Ics2eJu1ZgztApzMOlLqq3OXHv/B3kGqkP9trBilBqeSctEkO7Cth+T7N07tgcu6a8np+62RoBQkeZNIntXV8/uVqx5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526167; c=relaxed/simple;
	bh=hUZ36xEjuEBool6wGkZqYxu4In8ypDo1J9i1Nafz2ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E01kr8OeQu4M91FzihQK3W6Jr92cQquGyGZNyojCHGhcjMb2vqbSVhpjDKoXUn6csA3Rpde6jzDXEd8gVj67M+bOldNGhxnobaGb+CylULGPXpwpTXH/8v9KLMD4gam3nJP2eWG3V+jPNCBhTD2y4KDMFWntIVR5onhG4k4Kg9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tcl4KLhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tcl4KLhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DE2C4CEEB;
	Mon, 18 Aug 2025 14:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526166;
	bh=hUZ36xEjuEBool6wGkZqYxu4In8ypDo1J9i1Nafz2ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tcl4KLhACH4BzArst8dUjJHVWpb+tFcCD9igO9RXdRyCAsot/I2sJdflg8Ux0r27A
	 mna3Z8708RUk0meVV/BbIK2FL2OqC7QzkRMh63QiWTqIJHsymgDhAgTDiMzSd6XiUd
	 x2tfTkepzPfADQHNoTkLNqCNN7wRu6ywsHey6YYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janna Martl <janna.martl109@gmail.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 476/570] drm/i915/psr: Do not trigger Frame Change events from frontbuffer flush
Date: Mon, 18 Aug 2025 14:47:43 +0200
Message-ID: <20250818124524.223804187@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 184889dfe0568528fd6d14bba864dd57ed45bbf2 ]

We want to get rid of triggering "Frame Change" events from
frontbuffer flush calls. We are about to move using TRANS_PUSH
register for this on LunarLake and onwards. Touching TRANS_PUSH
register from fronbuffer flush would be problematic as it's written by
DSB as well.

Fix this by using intel_psr_exit when flush or invalidate is done on
LunarLake and onwards. This is not possible on AlderLake and
MeteorLake due to HW bug in PSR2 disable.

This patch is also fixing problems with cursor plane where cursor is
disappearing or duplicate cursor is seen on the screen.

v2: Commit message updated

Bspec: 68927, 68934, 66624
Reported-by: Janna Martl <janna.martl109@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/5522
Fixes: 411ad63877bb ("drm/i915/psr: Use SFF_CTL on invalidate/flush for LunarLake onwards")
Tested-by: Janna Martl <janna.martl109@gmail.com>
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://lore.kernel.org/r/20250801062905.564453-1-jouni.hogander@intel.com
(cherry picked from commit 46fb38cb20c0d185a6391ab524b23e0e0219c41f)
Signed-off-by: Tvrtko Ursulin <tursulin@ursulin.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 430ad4ef7146..7da0ad854ed2 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -3250,7 +3250,9 @@ static void intel_psr_configure_full_frame_update(struct intel_dp *intel_dp)
 
 static void _psr_invalidate_handle(struct intel_dp *intel_dp)
 {
-	if (intel_dp->psr.psr2_sel_fetch_enabled) {
+	struct intel_display *display = to_intel_display(intel_dp);
+
+	if (DISPLAY_VER(display) < 20 && intel_dp->psr.psr2_sel_fetch_enabled) {
 		if (!intel_dp->psr.psr2_sel_fetch_cff_enabled) {
 			intel_dp->psr.psr2_sel_fetch_cff_enabled = true;
 			intel_psr_configure_full_frame_update(intel_dp);
@@ -3338,7 +3340,7 @@ static void _psr_flush_handle(struct intel_dp *intel_dp)
 	struct intel_display *display = to_intel_display(intel_dp);
 	struct drm_i915_private *dev_priv = to_i915(display->drm);
 
-	if (intel_dp->psr.psr2_sel_fetch_enabled) {
+	if (DISPLAY_VER(display) < 20 && intel_dp->psr.psr2_sel_fetch_enabled) {
 		if (intel_dp->psr.psr2_sel_fetch_cff_enabled) {
 			/* can we turn CFF off? */
 			if (intel_dp->psr.busy_frontbuffer_bits == 0)
@@ -3355,11 +3357,13 @@ static void _psr_flush_handle(struct intel_dp *intel_dp)
 		 * existing SU configuration
 		 */
 		intel_psr_configure_full_frame_update(intel_dp);
-	}
 
-	intel_psr_force_update(intel_dp);
+		intel_psr_force_update(intel_dp);
+	} else {
+		intel_psr_exit(intel_dp);
+	}
 
-	if (!intel_dp->psr.psr2_sel_fetch_enabled && !intel_dp->psr.active &&
+	if ((!intel_dp->psr.psr2_sel_fetch_enabled || DISPLAY_VER(display) >= 20) &&
 	    !intel_dp->psr.busy_frontbuffer_bits)
 		queue_work(dev_priv->unordered_wq, &intel_dp->psr.work);
 }
-- 
2.50.1



