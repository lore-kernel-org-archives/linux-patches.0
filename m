Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81264376A09;
	Wed, 30 Sep 2026 18:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794323; cv=none; b=Zxh4ZIFRooRUuNXAVjYLRPIj5LTwseBLMu0mEQcyydPHuITBPx+dUx2tZuA8xE6rzKStRvR+UkCBTg/dSLXqo4WgkfAoYTDnaQkUzP6HeuY0GQZjYVU3Sbfv8b9sbDeEAsBH/luJSOO5l/efF8jMNIY/lI6KZtkdYYFxJds78TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794323; c=relaxed/simple;
	bh=xmG40S206AGj9Gbqu6pzbZveFFWl4mpEGL9E+QXcBCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8+c4i0mECNuFfOoLyptpEkTKBMuzdvglRgiqfZAENdfCbhOg/7Q7FhUXnVXmOyYukPxiTvTgiMPMDMErn95fJHZoM3oNVjeO2XDRF58KzYt6/Zu8tTh/vadvbb3Pbk3uvTKjsJjg8M6P3HVmfUB8VjgWDhmQMv0zbWRrM9UG1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fK7s5RxS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fK7s5RxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DE01F000FF;
	Wed, 30 Sep 2026 18:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794322;
	bh=ygxn6pJMQj0xyHUahOgSZRw3d3/paJXhImASWqhno9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fK7s5RxSehgNGWdXadFPhseGVcfPqJzGb/imnuJq1MeJqlL7m3mG5/QSSbnXyJ8F+
	 piUuyEOBpt0/i5ss+s4DFB3kSS9+3yMFLfJJQQ6hWsnFbkSGWt9p1kk3LGJZ0F5wdl
	 bZY2owk4QcCDF4aLsXViECGqOhbeFwuRKvEcKGc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asad Kamal <asad.kamal@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0170/1193] drm/amd/pm: bound pp_dpm_set_pp_table() memcpy
Date: Wed, 30 Sep 2026 17:14:14 +0200
Message-ID: <20260930152437.969179371@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit f193e71fa9fab2e68ef85201b106e8f580d3a25b ]

The powerplay path allocates hardcode_pp_table once with kmemdup(...,
soft_pp_table_size). memcpy(..., size) used the sysfs store count (up to
PAGE_SIZE) with no upper bound, causing heap overflow. Reject
writes where size exceeds soft_pp_table_size.

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
index 3a454aab62ce8..413d73c1577be 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c
@@ -680,6 +680,9 @@ static int pp_dpm_set_pp_table(void *handle, const char *buf, size_t size)
 	if (!hwmgr || !hwmgr->pm_en)
 		return -EINVAL;
 
+	if (size > hwmgr->soft_pp_table_size)
+		return -EINVAL;
+
 	if (!hwmgr->hardcode_pp_table) {
 		hwmgr->hardcode_pp_table = kmemdup(hwmgr->soft_pp_table,
 						   hwmgr->soft_pp_table_size,
-- 
2.53.0



