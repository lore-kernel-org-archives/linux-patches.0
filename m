Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F2222A7E0;
	Mon, 18 Aug 2025 13:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523872; cv=none; b=qWYJiEXU1scIc4h/UMTTaF6fPFJFjaEk9AkZrHlMX9rZVi3s1zzmQ64B7OLvUoGXMdBDGcqYLpadYjiwadKqMGUam2a5LKlbywE8Ii0vL0/OQCCUN1KqFDr9Qhir64NVHX0FraaDLYg5FiN3wQEhB7LvtHFaZoTLtaI+pdIPqUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523872; c=relaxed/simple;
	bh=TQUfqSVVPhAAQyrkuKczSGCK//MikjQk50jj2J2csHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9yTOp95QDPl3f/YK2EYApP083NI+XpnBag0l09TmInqyCodgwbKK13jOC2JtytvJlAOJCmxAmv+9d7+QtotmjiGwEF3QiGvngWW0ipGraB+ftmfVZJaZCkgNBjdwfvukUM2Qeh/Nw1FJJ+mLalCDJnJNCThjUsM3GuljLvrAsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UlVQG1Hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UlVQG1Hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E438C4CEEB;
	Mon, 18 Aug 2025 13:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523872;
	bh=TQUfqSVVPhAAQyrkuKczSGCK//MikjQk50jj2J2csHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UlVQG1HnLiIVHsU7lo4ioJL//ejQIW6LS+bH9cKuaSI2J0KpCaldRxaMFfr26GmnH
	 tOUEvPHH21P0tCawmZi5AbA6MnOvFczzLBWftN7yJpVyh2mFYAzt7ryzEA/Sc+szy5
	 I5Tog1osoXkGHiOrYD1uZjBsdmstuff1eppJEddw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ganglxie <ganglxie@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 299/515] drm/amdgpu: clear pa and mca record counter when resetting eeprom
Date: Mon, 18 Aug 2025 14:44:45 +0200
Message-ID: <20250818124509.939651368@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ganglxie <ganglxie@amd.com>

[ Upstream commit d0cc8d2b7df1848f98f0fea8135ba706814b1d13 ]

clear pa and mca record counter when resetting eeprom, so that
ras_num_bad_pages can be calculated correctly

Signed-off-by: ganglxie <ganglxie@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index e979a6086178..1a7ec674f579 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -475,6 +475,8 @@ int amdgpu_ras_eeprom_reset_table(struct amdgpu_ras_eeprom_control *control)
 
 	control->ras_num_recs = 0;
 	control->ras_num_bad_pages = 0;
+	control->ras_num_mca_recs = 0;
+	control->ras_num_pa_recs = 0;
 	control->ras_fri = 0;
 
 	amdgpu_dpm_send_hbm_bad_pages_num(adev, control->ras_num_bad_pages);
-- 
2.39.5



