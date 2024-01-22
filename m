Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D58155300;
	Tue, 23 Jan 2024 00:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969507; cv=none; b=a0k0Q122tumrBLWdoDMJDYC41/OTrhfK64pf09Ilhi/S+uVK70By/maAVLtmZ50AU186veLbB8EQZK1MMsLfsQ680Nl3zueVAl13cwaY8t4w/02tvVcYG1scabk5hdyubuquYxKoPmOFP2ABoGLNCHc3sW5LEEcDYyYJu+BP+uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969507; c=relaxed/simple;
	bh=V8FD1PM2VHZ9SbQtrJzSEDUSDE5bSoNJHdny5j3aVTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n68VAhO+hrrbe68G3QzcKioCh2UUvhSShurQm5ZnHc2HcnWVknNXPz64dPmyXM2CvXTRrgUu2xPmQii2Wa+aBb6btLc68DViHYvc9AGQok4voh42ISah0It8IDAt0XduZsBM+JY5HSsgoRy84pEXS1RKHhcJ++oDSuWrzDRj8pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RuZ8Luto; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RuZ8Luto"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD8DC43399;
	Tue, 23 Jan 2024 00:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969506;
	bh=V8FD1PM2VHZ9SbQtrJzSEDUSDE5bSoNJHdny5j3aVTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RuZ8LutoXY24m1AZ6dVF3YCmOfN0ZH8oq5wAHbHzfWK4r6pRDbe+y0IMEfIpCiYcE
	 dL7LYq0ALLeJe5hPiLo8GRbm1ffr1G5Gwv/YCCx0C0vO8OwFtADIRaAiX0abckNDbZ
	 CALN+G+/yB16GbuHLsYfby+0wYteAfkk4yjmPVjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 268/641] drm/radeon/r100: Fix integer overflow issues in r100_cs_track_check()
Date: Mon, 22 Jan 2024 15:52:52 -0800
Message-ID: <20240122235826.309730370@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

[ Upstream commit b5c5baa458faa5430c445acd9a17481274d77ccf ]

It may be possible, albeit unlikely, to encounter integer overflow
during the multiplication of several unsigned int variables, the
result being assigned to a variable 'size' of wider type.

Prevent this potential behaviour by converting one of the multiples
to unsigned long.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 0242f74d29df ("drm/radeon: clean up CS functions in r100.c")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/r100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index affa9e0309b2..cfeca2694d5f 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -2321,7 +2321,7 @@ int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track)
 	switch (prim_walk) {
 	case 1:
 		for (i = 0; i < track->num_arrays; i++) {
-			size = track->arrays[i].esize * track->max_indx * 4;
+			size = track->arrays[i].esize * track->max_indx * 4UL;
 			if (track->arrays[i].robj == NULL) {
 				DRM_ERROR("(PW %u) Vertex array %u no buffer "
 					  "bound\n", prim_walk, i);
@@ -2340,7 +2340,7 @@ int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track)
 		break;
 	case 2:
 		for (i = 0; i < track->num_arrays; i++) {
-			size = track->arrays[i].esize * (nverts - 1) * 4;
+			size = track->arrays[i].esize * (nverts - 1) * 4UL;
 			if (track->arrays[i].robj == NULL) {
 				DRM_ERROR("(PW %u) Vertex array %u no buffer "
 					  "bound\n", prim_walk, i);
-- 
2.43.0



