Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C5E174ED1;
	Wed,  3 Jul 2024 10:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004151; cv=none; b=TgGvOMAHcUlZKCTEWxnoFky723bR1930tKj28YBPlOMQ1ZeQqheQRkrlByXDPHmDiR+rgc2H5OxBHtxdRYVI3BVCZ1nKtjuDArXlQx+/mpFyrJzqfr4JJ2YCky1+D3t9BOJU84xuzwoOBRuIvId1As/UplxHGQnCgvQJiloS/ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004151; c=relaxed/simple;
	bh=mv4T47r0Ybfy8eJxLTbo65WYTahyaZfv9wipe8jsvLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4l1UZ9FLfGrpnIOhZc9tzC0E7BvbS3hr/jRYqF1q6EymJLuocjwPtzHC0aod+XZyM4ojKPB01eZCxRAXd2nK8THvzA3lovMO1KGOON0Wr5wa0aA7kPFCcDjzZGa15rseeAFQs0y5+Eouj2B80tVOa7tjQunfnYxbEkKSVJKnng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2c7I18lj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2c7I18lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C34C2BD10;
	Wed,  3 Jul 2024 10:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004151;
	bh=mv4T47r0Ybfy8eJxLTbo65WYTahyaZfv9wipe8jsvLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2c7I18ljGcyvFQYjp8S31zJuZus36uICW2CRnmfaajwvCuEdmideSnXJZVLdyKjZ8
	 ialMzrkQRLaEUiW8PVUG7z/Ue/Mmvznp0/2zBXl/Ygm3AoX7UXV/IhDYpgWqbXW0ks
	 +kfB9KkYh09000hwpmgI3loWHLmbGN/TSw/6n0y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 138/189] drm/amdgpu: fix UBSAN warning in kv_dpm.c
Date: Wed,  3 Jul 2024 12:39:59 +0200
Message-ID: <20240703102846.690866284@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit f0d576f840153392d04b2d52cf3adab8f62e8cb6 ]

Adds bounds check for sumo_vid_mapping_entry.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3392
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/kv_dpm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/kv_dpm.c b/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
index 6eb6f05c11367..56e15f5bc8225 100644
--- a/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
+++ b/drivers/gpu/drm/amd/amdgpu/kv_dpm.c
@@ -163,6 +163,8 @@ static void sumo_construct_vid_mapping_table(struct amdgpu_device *adev,
 
 	for (i = 0; i < SUMO_MAX_HARDWARE_POWERLEVELS; i++) {
 		if (table[i].ulSupportedSCLK != 0) {
+			if (table[i].usVoltageIndex >= SUMO_MAX_NUMBER_VOLTAGES)
+				continue;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_7bit =
 				table[i].usVoltageID;
 			vid_mapping_table->entries[table[i].usVoltageIndex].vid_2bit =
-- 
2.43.0



