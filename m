Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9942F5B;
	Sat, 25 Oct 2025 16:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408699; cv=none; b=mtzkEZDLFqdYcDZ9Qu0e9peTEZHPabcYl4TybVv1IDkW0rRZbtJJYxRO7ozJmGWBkEHJQy8v8kDN9AhDwbnJ/5yuzi23Aj6OpLgVQDsjl1GMQTJajggPJ/jEixI1SLtcwsesL1Olo57mDe8ecl/ET/j6MxpPSHtlKFU3yZDsPMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408699; c=relaxed/simple;
	bh=nGgQwYfbBEArWf9fYh4tSV9zo5WGqz0DjPRRY2BdDyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k1cpmGUDT4M81x5WpT06IgvQNPV+OScWTrIMUITbbVblaVbIxP565MvWklkF5SIjYxwfnlQ9p2IfkoGtviOQfi82n80R6skqZp5xqbdIyZtfZmKGjNZbfiCLa6M8Pn7zeOUpsLwgp0sYydQgL2xTgIsw6pcyU/FAg5LQwJ2jmso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTz8P1LP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTz8P1LP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAE2C4CEFB;
	Sat, 25 Oct 2025 16:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408699;
	bh=nGgQwYfbBEArWf9fYh4tSV9zo5WGqz0DjPRRY2BdDyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTz8P1LPsl3G5xImTOx128Ehqjio5f+X0UZowy8Pl+78yUGB9Jjt+kt4vDCHgH2Eb
	 8+CiuOKooDRTRoSuYkaX3Ce71e0bx1zDfQww9tlBUfixYhk6gARe3wbPGxUNYP9knI
	 RFRZe6y6+iaQfzUeDA80GxfYpgGhgXDZcUnuiSzcnlHramQdUDTyaLTGsfu7OmEPOR
	 f7HLtLF9Qa7OAdXL6Gpgcfs/gm8a4s4J12WMkw89tFbD/DGmjouLC5CARCA5RmHtdi
	 +68ZDINsDeGrXb+VKe0LbIQ4ce3wiISdp2ZJTG2xJso7fZwoMG+rLKFZAIj1oqIzwJ
	 xs1hKkL27Vpgw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	lijo.lazar@amd.com,
	alexandre.f.demers@gmail.com,
	kees@kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amdgpu/atom: Check kcalloc() for WS buffer in amdgpu_atom_execute_table_locked()
Date: Sat, 25 Oct 2025 11:54:36 -0400
Message-ID: <20251025160905.3857885-45-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit cc9a8e238e42c1f43b98c097995137d644b69245 ]

kcalloc() may fail. When WS is non-zero and allocation fails, ectx.ws
remains NULL while ectx.ws_size is set, leading to a potential NULL
pointer dereference in atom_get_src_int() when accessing WS entries.

Return -ENOMEM on allocation failure to avoid the NULL dereference.

Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- The patch adds a defensive check around the workspace allocation in
  `amdgpu_atom_execute_table_locked()`, returning `-ENOMEM` when
  `kcalloc(4, ws, GFP_KERNEL)` fails instead of leaving `ectx.ws` NULL
  while `ectx.ws_size` is non-zero
  (`drivers/gpu/drm/amd/amdgpu/atom.c:1248-1253`). This prevents the
  subsequent interpreter from walking a NULL pointer.
- Without the change, the interpreter’s operand fetch path dereferences
  `ctx->ws[idx]` whenever a table accesses working-space entries
  (`drivers/gpu/drm/amd/amdgpu/atom.c:268-269`), so any allocation
  failure in the original code leads directly to a NULL-pointer oops
  during table execution.
- `amdgpu_atom_execute_table()` is invoked across display, power, and
  firmware programming flows (e.g.,
  `drivers/gpu/drm/amd/pm/powerplay/hwmgr/ppatomctrl.c:235`,
  `drivers/gpu/drm/amd/amdgpu/atombios_crtc.c:101`), so the existing bug
  can crash the GPU driver during many user-visible operations under
  memory pressure; failing gracefully with `-ENOMEM` is far safer.
- The fix is self-contained (one function, no ABI or behavioral changes
  beyond returning an existing error code) and mirrors established error
  handling elsewhere in the driver, so the regression risk is minimal
  while the payoff—eliminating a reproducible crash under allocation
  failure—is high.
- No prerequisite features are involved, making the patch suitable for
  all supported stable kernels carrying this AtomBIOS interpreter;
  consider following up with the analogous radeon path, which shares the
  same pattern, to maintain parity.

 drivers/gpu/drm/amd/amdgpu/atom.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/atom.c b/drivers/gpu/drm/amd/amdgpu/atom.c
index 427b073de2fc1..1a7591ca2f9a0 100644
--- a/drivers/gpu/drm/amd/amdgpu/atom.c
+++ b/drivers/gpu/drm/amd/amdgpu/atom.c
@@ -1246,6 +1246,10 @@ static int amdgpu_atom_execute_table_locked(struct atom_context *ctx, int index,
 	ectx.last_jump_jiffies = 0;
 	if (ws) {
 		ectx.ws = kcalloc(4, ws, GFP_KERNEL);
+		if (!ectx.ws) {
+			ret = -ENOMEM;
+			goto free;
+		}
 		ectx.ws_size = ws;
 	} else {
 		ectx.ws = NULL;
-- 
2.51.0

