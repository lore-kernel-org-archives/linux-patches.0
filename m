Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C2C1C07DF;
	Tue, 15 Oct 2024 13:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997947; cv=none; b=leKcxLAMhLBgObBnOQthqtAlhFY2+SOHnx/HUTeMNvA5m8GvOl0gLYsldzyvpvzzvC29CpiBJKUtK7F3aCXvFuYWIleIafnqyWsWQxj82kBd8Q2X8EUXGboYsHmh3JB5AAWvMXUI9FJoj1lFX1WOLht9HZA3QAL5WfuHm82l2pU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997947; c=relaxed/simple;
	bh=zIUArzRRXKITLj1iOOXkzTeRlVY0ZppFiB4g4zj+Gac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UMz7t3otCYxE1l7qpAEPQnrOEfrQ/gxrqB+za/2YebH3eCM5L4sFw38WGwPmJYLDWkk2XupZaGgijkpoRoeuxtSgBvz7CPMfxSpD9rpWVz2KnO9JOGq0GTxTO+iV4gMG2vwIR/7OXHNhYeuF2C7GLkemlbwlA2HHeyNvZPKEPeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtZyBTrB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtZyBTrB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD50C4CEC6;
	Tue, 15 Oct 2024 13:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997947;
	bh=zIUArzRRXKITLj1iOOXkzTeRlVY0ZppFiB4g4zj+Gac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtZyBTrBVPiY4NVNqZjuZ7OAsdwY19SQPqroTGEAtGTcuCqg6/pbFpF6LPhtfJRFW
	 DfDXHy9oIXN5JJHL7LLuyug/v/4TVF6S6e7rp/y2WrlRnG+stIuZT/qA5hjXcBjGzB
	 uZk7eiPV7eylGhpsACSSdP3jPFxgEqly5qufWBkw=
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
Subject: [PATCH 5.10 333/518] drm/amd/display: Check null pointers before using dc->clk_mgr
Date: Tue, 15 Oct 2024 14:43:57 +0200
Message-ID: <20241015123929.827650730@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0587598009233..661907e8a7dec 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3083,7 +3083,8 @@ void dc_allow_idle_optimizations(struct dc *dc, bool allow)
 	if (allow == dc->idle_optimizations_allowed)
 		return;
 
-	if (dc->hwss.apply_idle_power_optimizations && dc->hwss.apply_idle_power_optimizations(dc, allow))
+	if (dc->hwss.apply_idle_power_optimizations && dc->clk_mgr != NULL &&
+	    dc->hwss.apply_idle_power_optimizations(dc, allow))
 		dc->idle_optimizations_allowed = allow;
 }
 
-- 
2.43.0



