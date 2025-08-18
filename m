Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0C527B333;
	Mon, 18 Aug 2025 13:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524076; cv=none; b=b2RYx2axKtdgyTFuWqKbV6FTKTRlfrTT2i8rlDMzXIdz3GQyedlBThTKpM3Hom6zEFQk0F+/S1py//P2sQx7QOBpaFe6dfNbvzqWdG/9knG8+QkKwh9SgZYqZUutwdMSIBlZjsP88plH25kVo4KcNLDsyDEZ+m7wNaujW5c+LBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524076; c=relaxed/simple;
	bh=uggxG3vF7oNftXFMMYfAZUP2uyVDB2ehPy1kFnc8vZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H//WDZ8GeZlNp6wU336jPQf+T2igZlh4xmkZyzXK2tSuKVlUyGuEV1ihYCshvWy6UuPmzpddqdgcggGp/QIXcH2ud03U36juYKs0eUB3T0CsA9gLil+lW+3Eb/yR8hUpflNFG8e/+MTyBHGJj5s143jYTNcoeZ/amGNxODZfiLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2r5d1aTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2r5d1aTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED77C4CEEB;
	Mon, 18 Aug 2025 13:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524076;
	bh=uggxG3vF7oNftXFMMYfAZUP2uyVDB2ehPy1kFnc8vZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2r5d1aTIUNilyce4FYXpCSRQVD+qhsVKoujqZdlEs8WZOQUA+tdKAZHXwioXbnKG6
	 f/OQGp3tJAs5++HhN7x+5dHt7pqiHahlEwvgUB21FVyE7AxptqBWlh9K3nt0/xKm66
	 l973oZP9XRFwETCpzNejBPsALkLqmWp+uQLrlIaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 328/515] drm/amd/display: Only finalize atomic_obj if it was initialized
Date: Mon, 18 Aug 2025 14:45:14 +0200
Message-ID: <20250818124511.060773383@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit b174084b3fe15ad1acc69530e673c1535d2e4f85 ]

[Why]
If amdgpu_dm failed to initalize before amdgpu_dm_initialize_drm_device()
completed then freeing atomic_obj will lead to list corruption.

[How]
Check if atomic_obj state is initialized before trying to free.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 9c01496ba590..75e7af5c5a3e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5309,7 +5309,8 @@ static int amdgpu_dm_initialize_drm_device(struct amdgpu_device *adev)
 
 static void amdgpu_dm_destroy_drm_device(struct amdgpu_display_manager *dm)
 {
-	drm_atomic_private_obj_fini(&dm->atomic_obj);
+	if (dm->atomic_obj.state)
+		drm_atomic_private_obj_fini(&dm->atomic_obj);
 }
 
 /******************************************************************************
-- 
2.39.5



