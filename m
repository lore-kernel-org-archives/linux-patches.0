Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4820194A64;
	Thu,  5 Sep 2024 09:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529545; cv=none; b=fc1CsznP96FOJClrDyjnkjHDGyPDvZCIpd5q2EFWSkfYJJvXHxqMsDq1YqC9WIH53EsMbzfGiY9pECwCDWxINR3R/o8TBQw8B9RLZe4pzK5WLk7NjC7J1VPDYc+/Zr+xvP9p+yrCHdFA074QURPFh1QtvuHKJXNFmv8M+AG1nvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529545; c=relaxed/simple;
	bh=uYe5Rkf6PuCf6HvfSn0fNBSSXlzJ0vIM8EeCndCn0I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a+Sbc6eZVKAFyXnrz4PPvx8SxH30FswNQ6XJA9wtg0nrdrHcNx2fpVhcHtuKDuhHz7lEdY+xcQ8R6MO1e28ZBwjddH8gw2osu1dZoiDKG5Cr/Jnd/V3P0WsBZDaQyWv2CgupNUjY3UQFhK6xDa94U+26zIHLLSo7JlHlves1jk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqBSfG95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqBSfG95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44632C4CEC3;
	Thu,  5 Sep 2024 09:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529545;
	bh=uYe5Rkf6PuCf6HvfSn0fNBSSXlzJ0vIM8EeCndCn0I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqBSfG95SKKVZIL3OxIl1fJAAVx6WnQ7Sa+sDzg8mnHjPDZ55+XacF2IVcgNyL4Qp
	 Z53Llkq9b3eClp+yDVKEOLzwQz9VgKD5kRMOwhVG/viFFEZ9vatXEc6cOJrq1n1FsJ
	 xJLqY4FW98IYVCba/nSNm8kUfKIAgvaAMMsGMG74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 068/184] drm/amd/display: Check link_index before accessing dc->links[]
Date: Thu,  5 Sep 2024 11:39:41 +0200
Message-ID: <20240905093734.893799018@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 8aa2864044b9d13e95fe224f32e808afbf79ecdf ]

[WHY & HOW]
dc->links[] has max size of MAX_LINKS and NULL is return when trying to
access with out-of-bound index.

This fixes 3 OVERRUN and 1 RESOURCE_LEAK issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_exports.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_exports.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_exports.c
index c6c35037bdb8..dfdfe22d9e85 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_exports.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_exports.c
@@ -37,6 +37,9 @@
 #include "dce/dce_i2c.h"
 struct dc_link *dc_get_link_at_index(struct dc *dc, uint32_t link_index)
 {
+	if (link_index >= MAX_LINKS)
+		return NULL;
+
 	return dc->links[link_index];
 }
 
-- 
2.43.0



