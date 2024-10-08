Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71321779B1;
	Tue,  8 Oct 2024 12:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391193; cv=none; b=oRmxC5Ak2ZsNCtvF7gYG0IebaI7jvD692RuQdGCQ83XB/JBJZsiIQR9StPDXZDwjmM6vXm6Gu+Kuhhk27pJGy6Mu4Xzhfbvy/QlCJL6sUzi9nsMk7zUjW9kc5BrIflIOi56mqkVtyVb+5jqz4xFSL8FsJ6RfYmsQADq/BZhCJvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391193; c=relaxed/simple;
	bh=9xS9rkUM4YD5j/TUCuC7HnGaM/GhPOoY+g4ZifFx5Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IgJurNfJVm71lUt8mWC9FMibjCptdhwXcmR+5DFH30h+VnueH9puDpuvQigcunQFxn5tCG+K6UWpkzUDo3rqiuMFOZCY+ni98yKuquvQTMMOyNB/yzj0+4ZiFOab/TSSz/ZJ7BYIDgtwQ+Yy5rVQiiewdN/3GshDZIhGz0Nu5uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2A0znOL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2A0znOL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BCFC4CEC7;
	Tue,  8 Oct 2024 12:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391192;
	bh=9xS9rkUM4YD5j/TUCuC7HnGaM/GhPOoY+g4ZifFx5Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2A0znOL14P4r0jALFCWw1g+bkrOGC++XWuCOC+135JW0eXM8Bmy01mIPCR4KuPhfP
	 4Vxkn8ObAI1JvRESL7JhnPUL3gjhqO4Nn+eE3vqstKGN8p2eIWgwGBrjdgsLY35uYf
	 J0ouaLWtr4H00NSdu0h8RwJq6VBMWUpgwgk9dh7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Animesh Manna <animesh.manna@intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 006/558] drm/i915/psr: Do not wait for PSR being idle on on Panel Replay
Date: Tue,  8 Oct 2024 14:00:36 +0200
Message-ID: <20241008115702.470908493@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 9498f2e24ee0133d486667c9fa4c27ecdaadc272 ]

We do not have ALPM on DP Panel Replay. Due to this SRD_STATUS[SRD State]
doesn't change from SRDENT_ON after Panel Replay is enabled until it gets
disabled.

On eDP Panel Replay DEEP_SLEEP is not reached.
_psr2_ready_for_pipe_update_locked is waiting DEEP_SLEEP bit getting reset.

Take these into account in Panel Replay code by not waiting PSR getting
idle after enabling VBI.

Fixes: 29fb595d4875 ("drm/i915/psr: Panel replay uses SRD_STATUS to track it's status")
Cc: Animesh Manna <animesh.manna@intel.com>
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: Animesh Manna <animesh.manna@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240906070033.289015-5-jouni.hogander@intel.com
(cherry picked from commit a2d98feb4b0013ef4f9db0d8f642a8ac1f5ecbb9)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 9cb1cdaaeefa7..d404ad93e91c7 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2746,13 +2746,6 @@ static int _psr1_ready_for_pipe_update_locked(struct intel_dp *intel_dp)
 				       EDP_PSR_STATUS_STATE_MASK, 50);
 }
 
-static int _panel_replay_ready_for_pipe_update_locked(struct intel_dp *intel_dp)
-{
-	return intel_dp_is_edp(intel_dp) ?
-		_psr2_ready_for_pipe_update_locked(intel_dp) :
-		_psr1_ready_for_pipe_update_locked(intel_dp);
-}
-
 /**
  * intel_psr_wait_for_idle_locked - wait for PSR be ready for a pipe update
  * @new_crtc_state: new CRTC state
@@ -2775,12 +2768,10 @@ void intel_psr_wait_for_idle_locked(const struct intel_crtc_state *new_crtc_stat
 
 		lockdep_assert_held(&intel_dp->psr.lock);
 
-		if (!intel_dp->psr.enabled)
+		if (!intel_dp->psr.enabled || intel_dp->psr.panel_replay_enabled)
 			continue;
 
-		if (intel_dp->psr.panel_replay_enabled)
-			ret = _panel_replay_ready_for_pipe_update_locked(intel_dp);
-		else if (intel_dp->psr.sel_update_enabled)
+		if (intel_dp->psr.sel_update_enabled)
 			ret = _psr2_ready_for_pipe_update_locked(intel_dp);
 		else
 			ret = _psr1_ready_for_pipe_update_locked(intel_dp);
-- 
2.43.0



