Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92779502B8D;
	Mon, 31 Aug 2026 13:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183722; cv=none; b=j4FidDurQKqehQ+Pg5rUGLXEEK+C7tbnvQjFhlKCeLRcytpaOni9FtR0bKwVUpc1tFM1Lhj4SutqPcAsfHXpc1CF4/9PFCiaidsx4EBxdTF33GR6UHOhqsAbIjcCj/9ue5von7OiQMENpOWMiZ4ibyXm5aIabclsNIFNfz9RBpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183722; c=relaxed/simple;
	bh=jqA9iTdJHhSUYxxVaQ1Jj4rd/kKO4eB76mg9to9Cnzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rXUdxxwUEAE87c0LpWN/SMVlneuqzofG0jPpwlUvDovYAtr7WMDkfcNfZQaFG0MT1RDc75AP1TsZvt61+/iNSa+Ia6qmxFE1+KeK/tDoF26h6qqSue9iESwwh6jXU9B4kJSFQJ9bq/yyfH5PH1OqZhlRUIcnx0YZsCuEaCahJR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L4V7VWjo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L4V7VWjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941801F00ACF;
	Mon, 31 Aug 2026 13:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183720;
	bh=DqpZCsgyUaeY20xlaeBW1YrZsbWreZj43KRBA/qOcAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4V7VWjo8FDe18pno9q+ouJX1P9xloZdn9uMYcE+zVxBBtAoxd5l9fHqAk9Z0OkNl
	 MWwreyGF4OIg+1G21F9ivk4fiVVKvhPeiBqkvcoOq/NRg+4DXoVmPTl5JPH2PiEkbD
	 88B5TAPaVFL7QDiqgo9nX+oO+GdwSCSq+KzulG+VWX1dGa5RdGH5cel+YZLRbG0afk
	 /uPLzQPJYLHLZ8/TeKXHJgu/ViY07wMniSQr9ec6p6M8VxYQ7DvJs4gXdQ4fbxL3C3
	 c0JxIPlI6Dq6UrqfEKItC6/POmwOS+YYwXIzAzsw89MzpcWNTVgYOzK7vhflS8CJ93
	 /sFIKNDoilLKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fangzhi Zuo <Jerry.Zuo@amd.com>,
	"Sun peng (Leo) Li" <sunpeng.li@amd.com>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	harry.wentland@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] drm/amd/display: Fix 8K Mode Not Parsed by EDID
Date: Mon, 31 Aug 2026 09:24:52 -0400
Message-ID: <20260831133314.4125787-264-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit 9b3aa1dec7c364b0d7b171dcc00ab1092e362aef ]

[why]
The 8K120/8K240 timings live in DisplayID extension blocks 2 and 3
of this EDID. The EDID is a 4-block (512-byte) HDMI 2.1 EDID
that uses HF-EEODB.
drm core reads and parses this correctly, but amdgpu rebuilds its own copy.
Only 2 of 4 blocks were copied into sink->dc_edid, that leads to
drm_edid_connector_add_modes() never sees blocks 2 and 3.

[how]
Directly populate edid_blob_ptr with a blob whose length is the full,
and HF-EEODB-aware size.

Reviewed-by: Sun peng (Leo) Li <sunpeng.li@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 11a90eaf5c808ba800249dda0d481c35d0888589)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The branch check finished: commit `11a90eaf5c808` (“Fix 8K Mode Not
Parsed by EDID”) is on `linux-next/master` only, not in the local
`v6.18.44` tree. That matches the earlier finding — the fix is in
mainline development and still needs to be backported to 6.18.y if
selected.

The backport recommendation remains **YES** for this tree.

 .../amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 20 ++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
index d0f770dd0a956..c2de763d621d3 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
@@ -1031,11 +1031,25 @@ enum dc_edid_status dm_helpers_read_local_edid(
 			continue;
 
 		edid = drm_edid_raw(drm_edid); // FIXME: Get rid of drm_edid_raw()
-		if (!edid ||
-		    edid->extensions >= sizeof(sink->dc_edid.raw_edid) / EDID_LENGTH)
+		/*
+		 * Use the length of the EDID property blob populated by
+		 * drm_edid_connector_update() above. It reflects the true number
+		 * of EDID blocks, including any HDMI Forum EDID Extension Override
+		 * Data Block (HF-EEODB) count, which the raw byte 0x7e extension
+		 * count can hide (e.g. HDMI 8K sinks).
+		 */
+		if (!edid || !connector->edid_blob_ptr ||
+		    connector->edid_blob_ptr->length > sizeof(sink->dc_edid.raw_edid))
 			return EDID_BAD_INPUT;
 
-		sink->dc_edid.length = EDID_LENGTH * (edid->extensions + 1);
+		/*
+		 * FIXME: amdgpu_dm today does not consider the HF-EEODB, which
+		 * may contain additional mode info for sinks. This is a
+		 * workaround until dc_edid is refactored out from DC into
+		 * amdgpu_dm's ownership, allowing amdgpu_dm to use drm_edid
+		 * directly
+		 */
+		sink->dc_edid.length = connector->edid_blob_ptr->length;
 		memmove(sink->dc_edid.raw_edid, (uint8_t *)edid, sink->dc_edid.length);
 
 		/* We don't need the original edid anymore */
-- 
2.53.0

