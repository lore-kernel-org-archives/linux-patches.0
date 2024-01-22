Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2BF1474AF;
	Tue, 23 Jan 2024 00:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968382; cv=none; b=uCMReCDSR0YlyybBnol9BnxGTNhAW6kxlLI7rfN8s71ay0Kcv8SdA1yJGh4OaTNIM7tWv22yH5L39OI1UZ6/eOl6pCWoVeokjArQUUozUPz30m8DTEU/Y4PnwyQvdPDYs4KXTbcN6Fv7nT8MtuHDsNRLKSoRu+VNkSOQ9n+DYKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968382; c=relaxed/simple;
	bh=GHcJ/GGZg5QdbstZW1GPzlFySJFbt01MkoNqTN4cZ4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PHWkN0+Fns4xuD81V/huVRv+nn8sVw4+klX4q9LmrKruJmPOcW4qOmGf0beJYBXCDppd3nVRTlR4BmXytaUy1A74IQC2hLE64C/qw2n/rP+pI2ehE91WNbXWImNHae1EjOFuwIy2ul5SWIudbsGUO0F8MnawN9OCxbWDKu11plw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jrX6iZQy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jrX6iZQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68EE6C433F1;
	Tue, 23 Jan 2024 00:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968381;
	bh=GHcJ/GGZg5QdbstZW1GPzlFySJFbt01MkoNqTN4cZ4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrX6iZQyvHqBvZlKNaTju3+fIdnmWIZPdTTt+AM9jbCL0fnUF/CSGEzXt2bbNA8nv
	 t16z/y7EbxXuUDb/JrDPqk2qpgrbQxdffgdqv5w966ve8+sIAXDCIE+nVdptIvKIt1
	 B2rjN0+SPR3ol9iQbaulIAJATkXApk+uHFZP1qLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 091/148] drm/radeon/r100: Fix integer overflow issues in r100_cs_track_check()
Date: Mon, 22 Jan 2024 15:57:27 -0800
Message-ID: <20240122235716.059428335@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index b24401f21e93..15241b80e9d2 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -2307,7 +2307,7 @@ int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track)
 	switch (prim_walk) {
 	case 1:
 		for (i = 0; i < track->num_arrays; i++) {
-			size = track->arrays[i].esize * track->max_indx * 4;
+			size = track->arrays[i].esize * track->max_indx * 4UL;
 			if (track->arrays[i].robj == NULL) {
 				DRM_ERROR("(PW %u) Vertex array %u no buffer "
 					  "bound\n", prim_walk, i);
@@ -2326,7 +2326,7 @@ int r100_cs_track_check(struct radeon_device *rdev, struct r100_cs_track *track)
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



