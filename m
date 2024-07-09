Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C07158201;
	Tue,  9 Jul 2024 11:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524076; cv=none; b=aYEsWSKVodr2KiYHjmKakM1w2uOGw1ZZbd7/rizhk0M5s9nm69Kp7GQ8+29stZYjBoaf3tSxg3bjtM4OX9zOgkheQpNDoHatWMoScLdnxNAk7o3QTt2CWR3inQ9dtPy5fZuSTy6hfnKPJLWNHqEDHzRn3001jXIKCPfWaomi7nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524076; c=relaxed/simple;
	bh=SbLpj1ItduG6att7ET+LUUZ9stXsZ/kV9ATnAa1JkBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwbgAckLRUxA0DIRyey+TDMGvWePK50bSjVGfLe0ufmPTqbNy+D8qH5hBEt2juk64+OwjUce07+AvvOI3XAFC7PkATgoO4z8kMUMYqfsjxCugKN97THlNvZmyIROEi9+YzMFoz79Wu775Rhw1nT9I+fAwgPyEopWEkDAKasFrDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8bJmWUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8bJmWUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8497AC3277B;
	Tue,  9 Jul 2024 11:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524075;
	bh=SbLpj1ItduG6att7ET+LUUZ9stXsZ/kV9ATnAa1JkBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8bJmWUIET/mnsgFOq6AZo3czqsgFPa52M1U3OilCauVdPWCA6HNFga6GWMLvBS4n
	 V7fKUlVbJqM4Dw3t/2ZfictZSebtOIR7Uc0+1awRw0z9TaDFuAk2+d5cM38FHrP5eR
	 RDE2D05VaAkPpIJXe2DoJCnoOIqCn9UcyF2aKcx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 032/197] drm/amd/display: Fix overlapping copy within dml_core_mode_programming
Date: Tue,  9 Jul 2024 13:08:06 +0200
Message-ID: <20240709110710.161926926@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit f1fd8a0a54e6d23a6d16ee29159f247862460fd1 ]

[WHY]
&mode_lib->mp.Watermark and &locals->Watermark are
the same address. memcpy may lead to unexpected behavior.

[HOW]
memmove should be used.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
index 9be5ebf3a8c0b..79cd4c4790439 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
@@ -9460,8 +9460,10 @@ void dml_core_mode_programming(struct display_mode_lib_st *mode_lib, const struc
 
 		/* Copy the calculated watermarks to mp.Watermark as the getter functions are
 		 * implemented by the DML team to copy the calculated values from the mp.Watermark interface.
+		 * &mode_lib->mp.Watermark and &locals->Watermark are the same address, memcpy may lead to
+		 * unexpected behavior. memmove should be used.
 		 */
-		memcpy(&mode_lib->mp.Watermark, CalculateWatermarks_params->Watermark, sizeof(struct Watermarks));
+		memmove(&mode_lib->mp.Watermark, CalculateWatermarks_params->Watermark, sizeof(struct Watermarks));
 
 		for (k = 0; k < mode_lib->ms.num_active_planes; ++k) {
 			if (mode_lib->ms.cache_display_cfg.writeback.WritebackEnable[k] == true) {
-- 
2.43.0



