Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D807925F98B;
	Sun,  1 Jun 2025 23:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748820602; cv=none; b=RdTLnMrjCgNQAE0pqwkhjITyxK8oGnHBYHUZIEZ77t03rudwMYdtFAso8CETuXAkUdmF32oyocp6Uc13hqGX+JTuHH+niQPst99rOz8xiKKgnpz7Mg/xhC2zqbZ6FhdLy8RPC1Nl8w4Wq7ugD5uFRG+tdDOo2ALTthPxQuQbH3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748820602; c=relaxed/simple;
	bh=ExUb3XPj01j3N04jN2LbEtnh9g5+U+o43q9FHoAJoR4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kcA9WGMec1O80uxDYfLnKnI47nANx5D+Gll1N5wVmHkVKZRM8CuF6g/6UXg2FDSmY3k17mHLAQ7fD1viF1CMNdLZ9p26N6AzKZWCI8C/MAMJqW9xl6vZi1RXFwHvi8tG6V1Tq0ovV+4+IXEAe8xsDwzcwMV1gzxODuCXgznZ3Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NvAthikN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NvAthikN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A73CC4CEE7;
	Sun,  1 Jun 2025 23:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748820601;
	bh=ExUb3XPj01j3N04jN2LbEtnh9g5+U+o43q9FHoAJoR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NvAthikNj7clStM8Juu50yQ6/oyjWzXAPV1RCeBWS0OwYRQ6w1+xqP8Iz3N8VERWM
	 3mFVtoYrxdmq7qDaCA0ZrNWeM8w+FWdLZRFMd1AXkTpqNKhcWEM2LY9lYvTEo73OA3
	 9gE6Ftg1BNqDuMZQObpa0t7TCFPaUpCJk+8zp3angAczX34w3FDKEIGLov7dXEHbMf
	 c+xfb1B6Q4VdWdFxf3WNMaK+zk6XMgPL2bQUH+TuFinzXy54sIsQXr9pTEcuiRSWKg
	 Ak54xNBynvc6oLRwimICoMrUZw6ioDLVCXJbqNnayhowp/PjdmWY3RwwxYdhr/17Eo
	 OuPDEU6KAk8HQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Jesse.Zhang" <Jesse.Zhang@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	"Shaoyun . liu" <Shaoyun.liu@amd.com>,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	sunil.khatri@amd.com,
	Jack.Xiao@amd.com,
	srinivasan.shanmugam@amd.com,
	shaoyun.liu@amd.com,
	Jiadong.Zhu@amd.com,
	Hawking.Zhang@amd.com,
	michael.chen@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 008/102] drm/amdgpu: Fix API status offset for MES queue reset
Date: Sun,  1 Jun 2025 19:28:00 -0400
Message-Id: <20250601232937.3510379-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250601232937.3510379-1-sashal@kernel.org>
References: <20250601232937.3510379-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Jesse.Zhang" <Jesse.Zhang@amd.com>

[ Upstream commit ad7c088e31f026d71fe87fd09473fafb7d6ed006 ]

The mes_v11_0_reset_hw_queue and mes_v12_0_reset_hw_queue functions were
using the wrong union type (MESAPI__REMOVE_QUEUE) when getting the offset
for api_status. Since these functions handle queue reset operations, they
should use MESAPI__RESET union instead.

This fixes the polling of API status during hardware queue reset operations
in the MES for both v11 and v12 versions.

Signed-off-by: Jesse Zhang <jesse.zhang@amd.com>
Reviewed-By: Shaoyun.liu <Shaoyun.liu@amd.com>
Reviewed-by: Prike Liang <Prike.Liang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees based on
the following analysis: ## Bug Analysis The commit fixes a clear
functional bug where `mes_v11_0_reset_hw_queue()` and
`mes_v12_0_reset_hw_queue()` functions were using the wrong union type
(`MESAPI__REMOVE_QUEUE`) to get the API status offset for polling
completion. Since these functions handle **reset** operations, they
should use the `MESAPI__RESET` union instead. ## Code Changes Assessment
1. **Small and contained**: The fix changes only 2 lines across 2 files:
- `mes_v11_0.c:480`: `offsetof(union MESAPI__REMOVE_QUEUE, api_status)`
→ `offsetof(union MESAPI__RESET, api_status)` - `mes_v12_0.c:500`: Same
change 2. **Logical correctness**: The functions create `union
MESAPI__RESET mes_reset_queue_pkt` packets but were polling using the
wrong union offset. This is a clear mismatch that could cause incorrect
polling behavior. 3. **No architectural changes**: This is purely a bug
fix that aligns the API status polling with the correct packet type. ##
Impact Assessment - **Affects GPU queue management**: MES (Micro Engine
Scheduler) queue reset is a critical operation for AMD GPUs -
**Potential for silent failures**: Wrong offset polling could lead to
improper completion detection - **User-visible impact**: Could cause GPU
hangs or incorrect queue state management - **Low regression risk**: The
fix aligns the code with its intended design ## Comparison with Similar
Commits All 5 provided similar commits were marked "NO" for backporting
because they: - Added new APIs/features (commits #1, #2) - Made
functional changes to queue reset behavior (commits #3, #4, #5) In
contrast, this commit: - Fixes an existing bug without adding features -
Maintains existing behavior while correcting implementation - Follows
the stable tree rule of "important bugfixes with minimal risk" ## Stable
Tree Criteria Met ✅ **Important bugfix**: Fixes incorrect API status
polling in GPU queue reset ✅ **Minimal risk**: Two-line change with
clear logic ✅ **No new features**: Pure correctness fix ✅ **Contained
change**: Limited to MES driver subsystem ✅ **Clear side effects**:
Improves reliability of queue reset operations This commit represents
exactly the type of focused bug fix that stable trees are designed to
include.

 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
index 68bb334393bb6..ec7ef8763f932 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -477,7 +477,7 @@ static int mes_v11_0_reset_hw_queue(struct amdgpu_mes *mes,
 
 	return mes_v11_0_submit_pkt_and_poll_completion(mes,
 			&mes_reset_queue_pkt, sizeof(mes_reset_queue_pkt),
-			offsetof(union MESAPI__REMOVE_QUEUE, api_status));
+			offsetof(union MESAPI__RESET, api_status));
 }
 
 static int mes_v11_0_map_legacy_queue(struct amdgpu_mes *mes,
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
index 6b121c2723d66..53d059a2a42e0 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -500,7 +500,7 @@ static int mes_v12_0_reset_hw_queue(struct amdgpu_mes *mes,
 
 	return mes_v12_0_submit_pkt_and_poll_completion(mes, pipe,
 			&mes_reset_queue_pkt, sizeof(mes_reset_queue_pkt),
-			offsetof(union MESAPI__REMOVE_QUEUE, api_status));
+			offsetof(union MESAPI__RESET, api_status));
 }
 
 static int mes_v12_0_map_legacy_queue(struct amdgpu_mes *mes,
-- 
2.39.5

