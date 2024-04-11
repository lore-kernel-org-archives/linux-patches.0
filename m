Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA43140E3D;
	Thu, 11 Apr 2024 10:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831052; cv=none; b=qk2n36gTjP4SzBjYpXqjPxv3siOyAFRymNKkXh0dd7g5YBafGM2R6/D/Iro4RDy7KkgmK8MP5u62BFUY18q4UzpF+149dswgyr7+oJLAxJ/3rm43Wssp3CUTNVT6t3MMjdrzUv3JolUlfGXq/70nCUmNG9Exzazsw24siCfLn+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831052; c=relaxed/simple;
	bh=czFLmSbOes7MTA0cA+WPlPd3/elLzU+hLicCp/XooWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opbfDwwpKIWDz2szxDxSdO8EOpmmupraHqwMazLRlOyKS4mBqaQCyzsCYEUMh78ss6h8Vqze73t98UG4Dg6dB9C/DQlIBMoU/YaYiTNlHQ0uQflu+3DSflNkp/9+Z1yGk8OyUvxIv+ZCsvHToXxph2ZG5opHRPG7Kk3zj9/SCbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZ4KwyyM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZ4KwyyM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D46C43399;
	Thu, 11 Apr 2024 10:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831052;
	bh=czFLmSbOes7MTA0cA+WPlPd3/elLzU+hLicCp/XooWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZ4KwyyML+11pezDC5MVz5pPSrgKICW4du2EyNV/7uqGxjOCcwVvB2joXJOXP0vCx
	 vYHJ9DFX1q8VVCcKV37uF8YwbjtljW70APbnX+vQoc5AztvM+qUnasmSwxBb0yu1t2
	 rhJMuXfQ3iAjK8N4kUa0r6UtKrbDlHx/SFaIdxl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Aric Cyr <aric.cyr@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 190/215] drm/amd/display: Fix nanosec stat overflow
Date: Thu, 11 Apr 2024 11:56:39 +0200
Message-ID: <20240411095430.574694860@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aric Cyr <aric.cyr@amd.com>

[ Upstream commit 14d68acfd04b39f34eea7bea65dda652e6db5bf6 ]

[Why]
Nanosec stats can overflow on long running systems potentially causing
statistic logging issues.

[How]
Use 64bit types for nanosec stats to ensure no overflow.

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/inc/mod_stats.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/inc/mod_stats.h b/drivers/gpu/drm/amd/display/modules/inc/mod_stats.h
index 3812094b52e8f..88b312c3eb43a 100644
--- a/drivers/gpu/drm/amd/display/modules/inc/mod_stats.h
+++ b/drivers/gpu/drm/amd/display/modules/inc/mod_stats.h
@@ -51,10 +51,10 @@ void mod_stats_update_event(struct mod_stats *mod_stats,
 		unsigned int length);
 
 void mod_stats_update_flip(struct mod_stats *mod_stats,
-		unsigned long timestamp_in_ns);
+		unsigned long long timestamp_in_ns);
 
 void mod_stats_update_vupdate(struct mod_stats *mod_stats,
-		unsigned long timestamp_in_ns);
+		unsigned long long timestamp_in_ns);
 
 void mod_stats_update_freesync(struct mod_stats *mod_stats,
 		unsigned int v_total_min,
-- 
2.43.0



