Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E3931E115;
	Mon, 18 Aug 2025 13:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524426; cv=none; b=EcrhUURq6v41maNCV3gnC2nUU5PkCAwLOr1Jt/+ZlC6KhloEud5eH+O/iUX3YAafpSTpavawnp+Xa9jxjgEWePZ5+eiX/ljiLdM6lS/SsDTIdBi0WVQUbBYwOqr8LdG+SmqX9e7H5ed+nMxqlmVdEJX+xu4S7Gny8BOp978xHTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524426; c=relaxed/simple;
	bh=TT4xYXKjbpC4G5eQyN4DiM+eqCKB2NUEkjMFHHOcALk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K0ncNoYcezA7oPIMlMoK6QHajeDr1UlLhb1KrYHQqW7s5r8wYYwEkCWKBZloFARZH6AJM64k7zZwTuwTZX8rExZiHF6N9kTOAKFTYkS7f8CkAxINnxkB0BkjAOiV2XkcYhIsCrMEdByz+mI2/nk1p6Zl2OLS6VMeslPCABs6lM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKEIZzwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKEIZzwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2C3C113D0;
	Mon, 18 Aug 2025 13:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524426;
	bh=TT4xYXKjbpC4G5eQyN4DiM+eqCKB2NUEkjMFHHOcALk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKEIZzwuzTu3s6MfdZfSM8h1iBu8L+i8sz2mn5+ncCql+QjRLKvV9CwzgQWWosCsJ
	 JrJw1fJ+wK9tgfcm7Lr7mZv4LHh8HitasqZvrA2KcWXfbIdCZ3OoAPTFi930W6SXCd
	 b1p4krK3iG5IHS99s+3DfnUFeibbUK5m2h2Y5KY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Janna Martl <janna.martl109@gmail.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 436/515] drm/i915/psr: Do not trigger Frame Change events from frontbuffer flush
Date: Mon, 18 Aug 2025 14:47:02 +0200
Message-ID: <20250818124515.211960856@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4e938bad808c..ccefdcb833dd 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -3171,7 +3171,9 @@ static void intel_psr_configure_full_frame_update(struct intel_dp *intel_dp)
 
 static void _psr_invalidate_handle(struct intel_dp *intel_dp)
 {
-	if (intel_dp->psr.psr2_sel_fetch_enabled) {
+	struct intel_display *display = to_intel_display(intel_dp);
+
+	if (DISPLAY_VER(display) < 20 && intel_dp->psr.psr2_sel_fetch_enabled) {
 		if (!intel_dp->psr.psr2_sel_fetch_cff_enabled) {
 			intel_dp->psr.psr2_sel_fetch_cff_enabled = true;
 			intel_psr_configure_full_frame_update(intel_dp);
@@ -3259,7 +3261,7 @@ static void _psr_flush_handle(struct intel_dp *intel_dp)
 	struct intel_display *display = to_intel_display(intel_dp);
 	struct drm_i915_private *dev_priv = to_i915(display->drm);
 
-	if (intel_dp->psr.psr2_sel_fetch_enabled) {
+	if (DISPLAY_VER(display) < 20 && intel_dp->psr.psr2_sel_fetch_enabled) {
 		if (intel_dp->psr.psr2_sel_fetch_cff_enabled) {
 			/* can we turn CFF off? */
 			if (intel_dp->psr.busy_frontbuffer_bits == 0)
@@ -3276,11 +3278,13 @@ static void _psr_flush_handle(struct intel_dp *intel_dp)
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



