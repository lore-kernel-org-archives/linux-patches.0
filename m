Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07AD1ABEC9;
	Mon, 14 Oct 2024 15:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918977; cv=none; b=VWTqsyluf1nIiXp1uDPnEo6PTsT3xbDgAFt8rx2g1rNpzpeGc4s1CPAMDtjAleV+j43mhuUhfkn36Pug+PtH6MNc3xfjhajHA7ABuTZgjie8mcC/eA8va8hg3g5ASofsiXJijMdZTnW/mte78WiTygyGaED6QvhX8rtCFKj9FHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918977; c=relaxed/simple;
	bh=3jGcYOX2Kamps0j6hYqeBhOuuFVAs40LjJYxVRy5eJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tj+9lHYb6vEdf0u6G6zrOzttlx80WZzBtcVynkQ/eYa15NSAB7xaiXMtQ2F1lAsXdi+bJ8BApW+uTyA/tq4HEGJaXI14wsOdurEMiNQMa3ON+rnTgUM/7ByI38hE46/xdztGrsLspEGH8V0pX5J/TDQ8MXgTUixiMpAinGldOPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BoJel4GF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BoJel4GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B82C4CEC3;
	Mon, 14 Oct 2024 15:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918976;
	bh=3jGcYOX2Kamps0j6hYqeBhOuuFVAs40LjJYxVRy5eJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoJel4GFNRIWWZewlKPJZvXe/ZM/tVr4rCqdk75uLzdN4VWuZAWdM4akjHdWTPTwM
	 CO7OIXaR+MJMRZTupTqq9TQUY/f9dd8gwziprvVNvA0rFeZvvOPNAEtyEq6NsQaALT
	 J8hcHE/NvrFbVpGb5MZEavHpBSlk46R7hzuzRxgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 478/798] drm/amd/display: Check null pointers before using dc->clk_mgr
Date: Mon, 14 Oct 2024 16:17:12 +0200
Message-ID: <20241014141236.752890455@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 95d9e0803e51d5a24276b7643b244c7477daf463 ]

[WHY & HOW]
dc->clk_mgr is null checked previously in the same function, indicating
it might be null.

Passing "dc" to "dc->hwss.apply_idle_power_optimizations", which
dereferences null "dc->clk_mgr". (The function pointer resolves to
"dcn35_apply_idle_power_optimizations".)

This fixes 1 FORWARD_NULL issue reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index b424465238afc..2d514e2e91a04 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -4516,7 +4516,8 @@ void dc_allow_idle_optimizations(struct dc *dc, bool allow)
 	if (allow == dc->idle_optimizations_allowed)
 		return;
 
-	if (dc->hwss.apply_idle_power_optimizations && dc->hwss.apply_idle_power_optimizations(dc, allow))
+	if (dc->hwss.apply_idle_power_optimizations && dc->clk_mgr != NULL &&
+	    dc->hwss.apply_idle_power_optimizations(dc, allow))
 		dc->idle_optimizations_allowed = allow;
 }
 
-- 
2.43.0



