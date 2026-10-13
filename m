Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A705547CA69;
	Tue, 13 Oct 2026 11:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892357; cv=none; b=QgTxVc2vWQPEQ14Cp/HF7KHESVMR/wZn9TTKP6ijVIf1ibI7yS+36zqt0SQ6qaySwW1bnMWR5h1gSdCpakw0aoYMySfsyraGgQnyQNeMJ7DmHOMBzWSufYYCECPOHPUivgM5SMxlMYeIkqURjxzBVC4xa7DQo0wlbKuo7uxG3nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892357; c=relaxed/simple;
	bh=2J3lyGTUJ3/ltQa0m45tCg2j+VkWbh9tcXv1vh3tvYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YGGw2p5rL+MgYShsYIxdH9dNGCnXf9bRnkqk0Z4uXVFx8pLgSPXRL41MoT3XMtNAwFCDUcA8QM7RocVnHatlquoISdMiP4zgNsmB+NTqqMLQNzj5Q4hdO/i4oE/jsoXwEc4WVVjIK3biEpzzJn/kH3z3h2lt6CjQAR1ZFA4EfPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=magnnNxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="magnnNxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D881F00893;
	Tue, 13 Oct 2026 11:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892356;
	bh=gLDJGnolrtsnvJg1g7jG5BbSiAJEW3sGC32g5bXytyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=magnnNxwO0xdslW7ROrFxW7O9oorYYKnsFzVE9TbjEv0z3nUahZC05foCd7mQfAG8
	 OD3A7lAOtQIo9d41AhLBrrvntrJR0KNOMTlVWkIzgcd0lfWaJ2Gdb6ZMWGnmXBvhwc
	 MbXqPUnEknabrwnOJP0fhmP+c0zl+K5wlR0sN1n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 146/281] drm/amd/display: disable self-refresh on tearing flips
Date: Tue, 13 Oct 2026 13:37:42 +0200
Message-ID: <20261013112858.701672495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Li <sunpeng.li@amd.com>

commit 2e54a92e0136c3ff5c7b542b95bf0940ad6687bf upstream.

[Why & How]

Immediate (tearing) flips breaks self refresh state machine assumptions,
so disable PSR/Replay for them.

Tested-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit acbdd213b37e095f15685f3e3ee6d35defa05616)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10397,6 +10397,13 @@ static void amdgpu_dm_enable_self_refres
 	struct amdgpu_dm_connector *aconn =
 		(struct amdgpu_dm_connector *)acrtc_state->stream->dm_stream_context;
 
+	if (!acrtc_state->base.async_flip) {
+		amdgpu_dm_psr_set_event(dm, acrtc_state->stream, false,
+			psr_event_immediate_flip, false);
+		amdgpu_dm_replay_set_event(dm, acrtc_state->stream, false,
+			replay_event_immediate_flip, false);
+	}
+
 	/* Decrement skip count when SR is enabled and we're doing fast updates. */
 	if (acrtc_state->update_type == UPDATE_TYPE_FAST &&
 	    (psr->psr_feature_enabled || pr->replay_feature_enabled)) {
@@ -10810,6 +10817,18 @@ static void amdgpu_dm_commit_planes(stru
 			spin_unlock_irqrestore(&pcrtc->dev->event_lock, flags);
 		}
 		mutex_lock(&dm->dc_lock);
+		/*
+		 * Tearing (immediate) flips cannot work with panel self-refresh
+		 * features. The event is cleared by
+		 * amdgpu_dm_enable_self_refresh() once async flips stop.
+		 */
+		if (immediate_flip) {
+			dc_exit_ips_for_hw_access(dm->dc);
+			amdgpu_dm_psr_set_event(dm, acrtc_state->stream, true,
+				psr_event_immediate_flip, true);
+			amdgpu_dm_replay_set_event(dm, acrtc_state->stream, true,
+				replay_event_immediate_flip, true);
+		}
 		update_planes_and_stream_adapter(dm->dc,
 					 acrtc_state->update_type,
 					 planes_count,


