Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A6033768F;
	Mon, 18 Aug 2025 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525651; cv=none; b=NtEco5XCaAzE3QHLsjJXoAieORL+qexbFFCR3vQdE0WF35iDZebbB86kYC7+Yy8VK5LysQto0Ubv/COTY07f0h35fNFrc3ud35jcv4PKk/k53eKCd6EmyOf9m8obXzBdlhflSQYtU9jnDy587J/9JQ5Q5rIpuFRxngdU9WBOkLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525651; c=relaxed/simple;
	bh=gCt9as5gVwfvrKvevpnb3pZqlqtB4DQsNawItUMM0hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=twxMN0ZxYxTqVhb6ZcwOEcVFqI4kqAGCFChj6FViDEsvLYvq37TfioeAj2KwVeXRI6B8FAIcn717C8tQLxIoG8eEUW7q3pXqZ0dEEA+2urjR8ZeaefQ8P85z7GD/Y7xcYMZY7GuRMY4pgdhL920bxs86Y4kb4m1psPOzGhZ94HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hi12ze5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hi12ze5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23322C4CEEB;
	Mon, 18 Aug 2025 14:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525651;
	bh=gCt9as5gVwfvrKvevpnb3pZqlqtB4DQsNawItUMM0hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hi12ze5GsEeqpl/OZskjM2XK913PZKfRzmlo4r1/Ki+F4Hv5aC+2QrMTAGdicbCl5
	 sqoMvju1emDSuECjbww10HVjzaZ+ecT/EhZrWDd5hxkh3NRQR9VxuCyyM4pjEHjAZo
	 Lm138yzHJdJNXo7X9wQNTuFGE5M98Ss+5/oFqVc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ganglxie <ganglxie@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 326/570] drm/amdgpu: clear pa and mca record counter when resetting eeprom
Date: Mon, 18 Aug 2025 14:45:13 +0200
Message-ID: <20250818124518.414072797@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 2c58e09e56f9..2ddedf476542 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -476,6 +476,8 @@ int amdgpu_ras_eeprom_reset_table(struct amdgpu_ras_eeprom_control *control)
 
 	control->ras_num_recs = 0;
 	control->ras_num_bad_pages = 0;
+	control->ras_num_mca_recs = 0;
+	control->ras_num_pa_recs = 0;
 	control->ras_fri = 0;
 
 	amdgpu_dpm_send_hbm_bad_pages_num(adev, control->ras_num_bad_pages);
-- 
2.39.5



