Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1159712CDA5;
	Tue, 23 Jan 2024 00:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971454; cv=none; b=C3adfzljUQnX3t/svTORLBbjjK3C67blhYSczDrK4fYDHUrMCpsO8WCBvd7RQ/RRa49lzMXH6kJZJamh+01d9dHYHyvEn6SsAW6+8iZkozuTEir1ZcU5zxYR+OZFwvDAeYa4X+NImUzDEG9OBjB4MEXPpEhOTLAc88VcK6OkIdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971454; c=relaxed/simple;
	bh=s/90pfQYsEXmbfAULhUq+oIbRFwG0RMcDpc5pheEAEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1jE/av14DwmohfIGASO4qS/lICe9B3jVeranB6a80IyQo2Ji2vWfa22/JYkwODxS6aPc5F3s9HhCNtei0vVqkpww2cEEpGz/PwxAwpM7CES4c39PhI6Uy120BnIoK8VVAtElA/DhXQGmfeRKkVvTgvZgTk8tqDn3jd89Tk9EXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLMwhl1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLMwhl1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A801FC433F1;
	Tue, 23 Jan 2024 00:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971453;
	bh=s/90pfQYsEXmbfAULhUq+oIbRFwG0RMcDpc5pheEAEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLMwhl1SsfQJDhdlXb3u3Qr2+ypEQHA8NpBNY2Qq3f9YRwLd3lyAVo7wZ8MbB//f/
	 JCqGvivLTzMasrPNblLgNgbseqjUOyqqHiyH8aTcryjF8aGNvtNq1lwj02nkMpUHkF
	 dL70KnjmhW3OPtbvohFxjPjDlMky+GqKir8w7Clc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 153/286] drm/radeon/r100: Fix integer overflow issues in r100_cs_track_check()
Date: Mon, 22 Jan 2024 15:57:39 -0800
Message-ID: <20240122235738.056276559@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index 24c8db673931..6e4600c21697 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -2313,7 +2313,7 @@ int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track)
 	switch (prim_walk) {
 	case 1:
 		for (i = 0; i < track->num_arrays; i++) {
-			size = track->arrays[i].esize * track->max_indx * 4;
+			size = track->arrays[i].esize * track->max_indx * 4UL;
 			if (track->arrays[i].robj == NULL) {
 				DRM_ERROR("(PW %u) Vertex array %u no buffer "
 					  "bound\n", prim_walk, i);
@@ -2332,7 +2332,7 @@ int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track)
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



