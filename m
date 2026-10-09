Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31A2A125AA;
	Fri,  9 Oct 2026 14:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556421; cv=none; b=Ws2v9p1YfVWlwevqx/XDOivGpSOmr4FEmNugfTY9eHzmWrbOSd0AQQT9eqNH0MQskVDAMALMj4JmAkrQbsvOQLSaiCuVD7cgVHddsibKs0fJg4zuEpuB1pf1G8dW3wl6Fzixc5SEJZ+bIOJ+pg6DCpL+i+JURGPPhjB9avzfn6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556421; c=relaxed/simple;
	bh=KMB5tnyAojtzxtJhloJ/Z6FdDuP7kzk1w28v8AfeZ2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKosGvegRvSx4cFlE2oCoqmBjn2IQGNTEtxIAI9oRlUGTF0mtYscVLGYEHHrHUvsoRIrMgk6fJ10ZcY7qnM7tZDqcL15bHi1sPmLGG10lQQAq8+BzPXFCuwKPAFyRZ+BBHjxyqB6JXm2g6FqElcoyP2c1Z8Kvad3FtXFiC46jPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgBT6ZrS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgBT6ZrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D701F000FF;
	Fri,  9 Oct 2026 14:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556419;
	bh=tB+hbiXPNORA16Z7TY5LMncWPuxRl6LbdtfpAn8xQg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgBT6ZrScMw44qjZxEl3s0lyRQB7td+tcZSpHmzMo0ZZi1osbC9FG0VRT4LwtFj7u
	 2Kc2SrUn81aL1PqfYijDgvDplDl1Uy+pdVYIs20k/TuEsF/ZAiNWsqL3vaMIuHIyXN
	 qS9qeNNhppJV74DKHcUYzKjQAT0bOH6s/HvGoHSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Polack <spolack+git@mailbox.org>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 173/428] drm/amd/display: Fix stale replay_events after mod_power stream removal
Date: Fri,  9 Oct 2026 16:08:30 +0200
Message-ID: <20261009140949.951917888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Polack <spolack+git@mailbox.org>

commit b76a5b7bee22556914f7cde210f695ef162d81bf upstream.

[Why]
mod_power_remove_stream() shifts the remaining power_entity slots down
but does not move replay_events, and mod_power_add_stream() does not
initialize it. replay_events therefore stay bound to the map slot
instead of the stream.

When several streams are disabled in one atomic commit,
amdgpu_dm_mod_power_update_streams() removes them one after another.
The eDP stream can then be looked up in a slot whose stale
replay_events already have replay_event_hw_programming set, so
amdgpu_dm_replay_set_event() returns early ("already in desired state")
without calling mod_power_set_replay_event(). Replay is not disabled
before the eDP panel is powered off. After DPMS on, the sink reports
neither replay state nor frame lock (DPCD 0x378 = 0x00, no error bits),
so the HPD IRQ recovery does not trigger and the panel stays black
until a full modeset.

Seen with an eDP panel using FreeSync Replay plus two DP-MST displays:
DPMS off/on of all outputs leaves eDP black, while DPMS of eDP alone
works. Doing an eDP-only DPMS first makes the next all-output DPMS
fail reliably.

[How]
Shift replay_events together with the PSR cached fields in
mod_power_remove_stream() and initialize it to replay_event_vsync in
mod_power_add_stream(), matching the psr_event_vsync initial value used
for PSR (both vsync events are driven together by
amdgpu_dm_crtc_set_static_screen_optimze()).

Tested on 7.3.0-rc3 (238650ef6c7c): the reproducer above now recovers
reliably, and Replay still engages when the screen is idle.

The issue was debugged with help from an AI assistant (Claude), which
analysed ftrace/kprobe traces and the driver source, pointed to the
missing replay_events handling and suggested this change. I collected
the traces and built and tested the fix on the affected hardware.

Fixes: 4cef2ac4c795 ("drm/amd/display: Introduce power module on Linux")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Simon Polack <spolack+git@mailbox.org>
Reviewed-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3d47e38e271195435e125527b224d11cfdb777b1)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/power/power.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/modules/power/power.c
+++ b/drivers/gpu/drm/amd/display/modules/power/power.c
@@ -333,6 +333,7 @@ bool mod_power_add_stream(struct mod_pow
 		core_power->map[core_power->num_entities].psr_enabled = 0;
 		core_power->map[core_power->num_entities].psr_events = psr_event_vsync;
 		core_power->map[core_power->num_entities].psr_power_opt = 0;
+		core_power->map[core_power->num_entities].replay_events = replay_event_vsync;
 		core_power->num_entities++;
 		return true;
 	}
@@ -392,6 +393,7 @@ bool mod_power_remove_stream(struct mod_
 		core_power->map[i].psr_enabled = core_power->map[i + 1].psr_enabled;
 		core_power->map[i].psr_events = core_power->map[i + 1].psr_events;
 		core_power->map[i].psr_power_opt = core_power->map[i + 1].psr_power_opt;
+		core_power->map[i].replay_events = core_power->map[i + 1].replay_events;
 
 		memcpy(core_power->map[i].psr_context, core_power->map[i + 1].psr_context, sizeof(struct mod_power_psr_context));
 		memset(core_power->map[i + 1].psr_context, 0, sizeof(struct mod_power_psr_context));


