Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7702B335BA;
	Thu, 13 Feb 2025 14:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457170; cv=none; b=nKpZsmBzF4cHeGHVFLcQhBYnfPb9Lgnq7C7DpNCAvkDSPDHGZhAXnETht4/F8T5PHHr9ctfGgM+C3F0ENL7hxmL5oE7RpMKGu/HWFsk4jdxQqqpq+OPsIVbwM2xAK1/gi8EZzrRCAjPy+7J9mNMEkDnjlMG+QfwhcxEeymGXxYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457170; c=relaxed/simple;
	bh=lr9vFPK9Vjse7u/VJThUiBc24CC2p6MMOepdUBTJXsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1FTTxZvxzP+5NT2jSt02sULwc0urnFKTLPYWA6cQjoHKBFyN2ICasq7IbyZZgbQlXulToB1ID3J8NCtY6cbLcBS+EAOeZ/Ib96GDmEv56Sznbd/ZphI5SS2bALwmM0cID6aPjojUcKQre6S1rTd8KIfjetualnGfNy3iw+XbhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AR0T/YKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AR0T/YKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD37DC4CED1;
	Thu, 13 Feb 2025 14:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457170;
	bh=lr9vFPK9Vjse7u/VJThUiBc24CC2p6MMOepdUBTJXsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AR0T/YKdLb/X5R/kvw6IhRLH6Jk2PTKeWV3yoqjqv2ru3nSomtPLKv//Qh40Y5tEw
	 fwceR3v5W6WEbRtrGJmdI2I50QfML3P/wLtfvsQgzTWpXkwea73vdRbXWtVGjH/fzz
	 BfQCmb/ztcL51LFN4BqbtWsOCViHoYCgzcGeUabE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Fangzhi Zuo <Jerry.Zuo@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/422] drm/amd/display: Fix Mode Cutoff in DSC Passthrough to DP2.1 Monitor
Date: Thu, 13 Feb 2025 15:23:05 +0100
Message-ID: <20250213142437.949496946@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangzhi Zuo <Jerry.Zuo@amd.com>

[ Upstream commit e56ad45e991128bf4db160b75a1d9f647a341d8f ]

Source --> DP2.1 MST hub --> DP1.4/2.1 monitor

When change from DP1.4 to DP2.1 from monitor manual, modes higher than
4k120 are all cutoff by mode validation. Switch back to DP1.4 gets all
the modes up to 4k240 available to be enabled by dsc passthrough.

[why]
Compared to DP1.4 link from hub to monitor, DP2.1 link has larger
full_pbn value that causes overflow in the process of doing conversion
from pbn to kbps.

[how]
Change the data type accordingly to fit into the data limit during
conversion calculation.

Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
Signed-off-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
index 754dbc544f03a..5bdf44c692180 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
@@ -1691,16 +1691,16 @@ int pre_validate_dsc(struct drm_atomic_state *state,
 	return ret;
 }
 
-static unsigned int kbps_from_pbn(unsigned int pbn)
+static uint32_t kbps_from_pbn(unsigned int pbn)
 {
-	unsigned int kbps = pbn;
+	uint64_t kbps = (uint64_t)pbn;
 
 	kbps *= (1000000 / PEAK_FACTOR_X1000);
 	kbps *= 8;
 	kbps *= 54;
 	kbps /= 64;
 
-	return kbps;
+	return (uint32_t)kbps;
 }
 
 static bool is_dsc_common_config_possible(struct dc_stream_state *stream,
-- 
2.39.5



