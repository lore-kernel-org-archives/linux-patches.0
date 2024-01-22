Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F84A12A167;
	Tue, 23 Jan 2024 00:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971061; cv=none; b=c9LqtWT+Img3Rx1pHrXIN0lM6s8GvCsTY6iiMSFcXQBmnOQwp9tnUYo3NQMnhzombudfI9/HxsFGCpgn6K2tJ4zk/OMJwYPc0/izl/FhDTm4Jl1FjSjlrvZcc9kdQm3PgF0L7dmJEkCn955p/ggNTMhn4dLv7LPBUn7jAi0ZOa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971061; c=relaxed/simple;
	bh=LOUMln+V0+mM7I3qzqEFMZ1KI6K1ijTARpxBuQ8931A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEJv6leQMvusM1GMRqbLbdxSz66RzrIQ7rzRR8qN3/Tq+CbUIQ2e1xVchJUOajdeAAUlfg8ZQEZgWVs+7cvhSVdav0WQHv1UWbMuU6/tRAhc4WlHFdnGa44Vycj0kH9xJwVAFwDRJpVNWB6smWKTAmU1DOiE0KokOuYrVM0HSK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bncKxBnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bncKxBnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA8EC43399;
	Tue, 23 Jan 2024 00:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971061;
	bh=LOUMln+V0+mM7I3qzqEFMZ1KI6K1ijTARpxBuQ8931A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bncKxBnfGlH5SuhD9dm7i+vfsJIVoNFeB11o1jqJe9gE+mw1wUvx8iQ2L6TxSWF0B
	 LufxxaQvWw3v4Az1jQ82pxFmIRRQngk+GChwpZMBSgKChOzSip83+wIgY6cmqC4+PE
	 GLbKv2E7hcWZa70f2bzQoiSFBOoOym6+zdPfwnRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/417] drm/radeon/r100: Fix integer overflow issues in r100_cs_track_check()
Date: Mon, 22 Jan 2024 15:55:41 -0800
Message-ID: <20240122235757.849650014@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d4f09ecc3d22..f336b5b3b11f 100644
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



