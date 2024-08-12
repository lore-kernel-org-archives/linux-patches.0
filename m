Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD38134AC;
	Mon, 12 Aug 2024 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480107; cv=none; b=b/f5z2iJEy4YvP23RVfzaT280vBaoX6fIrGRD+cn5ED3gIxbkoRjtkjfD7T52t+gxQGCDd+1oSRxztQfNFka2MBFVaNN+lhsrZFYWFwdw8iyAETSIo76lBkUW80tN/Io5R01DYSf+xRv1bse+/nA1BdWcH+fYv05tRwQjljvgDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480107; c=relaxed/simple;
	bh=JgQkRbQEWSJvkqMjrDKWYu+5VGHerXqGYLVUskdvm6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKQxot8Fy7RT3EOQg4UMpkOuRgW1gv9lSRm3GY98v7/85Nj8vBfcsp2kfz2713iEaMSBKBm7JOjBuB6FeNvv/fYlB8noKoIEvS0RzlC/Wky2vTqRiXTwAhSM5Z82pSqeuhDes4bC5mLUU35fSUDuz/kbfZw4qioDGkI+8glGIds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dA3QCtGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dA3QCtGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9984DC32782;
	Mon, 12 Aug 2024 16:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480107;
	bh=JgQkRbQEWSJvkqMjrDKWYu+5VGHerXqGYLVUskdvm6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dA3QCtGUBlnw69Cq4X5IurmoLXCWacog3JYvoD/ZokmrgOP0CxA8YmvgifoJrKLtg
	 lUcnBuxxOAf5Ur1K+GWyCMJzuSX6i0Axcsxl3rL7Q2DKdQi43tbtuRdR0PCclMktS+
	 7GSFVI3QwNnjgV+lrryzEihR40VSxD/eeXF7pJqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Chung <chiahsuan.chung@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Roman Li <roman.li@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 099/263] drm/amd/display: Add null checks for stream and plane before dereferencing
Date: Mon, 12 Aug 2024 18:01:40 +0200
Message-ID: <20240812160150.333112292@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 15c2990e0f0108b9c3752d7072a97d45d4283aea ]

This commit adds null checks for the 'stream' and 'plane' variables in
the dcn30_apply_idle_power_optimizations function. These variables were
previously assumed to be null at line 922, but they were used later in
the code without checking if they were null. This could potentially lead
to a null pointer dereference, which would cause a crash.

The null checks ensure that 'stream' and 'plane' are not null before
they are used, preventing potential crashes.

Fixes the below static smatch checker:
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn30/dcn30_hwseq.c:938 dcn30_apply_idle_power_optimizations() error: we previously assumed 'stream' could be null (see line 922)
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dcn30/dcn30_hwseq.c:940 dcn30_apply_idle_power_optimizations() error: we previously assumed 'plane' could be null (see line 922)

Cc: Tom Chung <chiahsuan.chung@amd.com>
Cc: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Cc: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Roman Li <roman.li@amd.com>
Cc: Hersen Wu <hersenxs.wu@amd.com>
Cc: Alex Hung <alex.hung@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
index ed9141a67db37..5b09d95cc5b8f 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn30/dcn30_hwseq.c
@@ -919,6 +919,9 @@ bool dcn30_apply_idle_power_optimizations(struct dc *dc, bool enable)
 			stream = dc->current_state->streams[0];
 			plane = (stream ? dc->current_state->stream_status[0].plane_states[0] : NULL);
 
+			if (!stream || !plane)
+				return false;
+
 			if (stream && plane) {
 				cursor_cache_enable = stream->cursor_position.enable &&
 						plane->address.grph.cursor_cache_addr.quad_part;
-- 
2.43.0



