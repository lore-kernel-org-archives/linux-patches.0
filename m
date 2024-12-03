Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8907F1F7545;
	Tue,  3 Dec 2024 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238629; cv=none; b=lGy8TIgDlwhjZv7dF9+5pwojoIJ5t6tazMpZhynwpVL6h8/HjTFD4s0yOcKf0J1PtL7xP6jEUHSPfaeaJjokvCPQUdGeOv2enO6tt9dkPWPlJv04x60KGRYxBGxGHO51pQeZlq+w+Eju8swVhXpwotCUJmb1LEMAycB6Lzh8Lrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238629; c=relaxed/simple;
	bh=kFyja+B6QLVc0wSkETfotY3fv52FcY9XCgYHwtDbym0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bw0ryFZeYr7a0/pC2Cv3x7cctI8Okg/YMobeu43MQWAATk3oQzm0SBInxIUVi6H1DfbqCCJhwlZYUeoAJ7e48GzUY27JwWqqmehqm4DLnP15mSM63CL0XhepN1ppTE/yxL2OEi9bFaTnxfxU+A7iHRPgnLtpchfQVq4IVpof4/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SG47AyMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SG47AyMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2FBC4CECF;
	Tue,  3 Dec 2024 15:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238629;
	bh=kFyja+B6QLVc0wSkETfotY3fv52FcY9XCgYHwtDbym0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SG47AyMad+dLARmlm8btWLYkeDBCRzixWp6HsGzACeppyMFT/kf9sh3kJQT1NWJlO
	 4Xz8vLzeahc99xNBV5GCMF3O/txujkfAOoSkG5YnlNEqpcPz7cAXUks+hdEjpYPLyo
	 aY1WSCpNXcmeI+K+UnvxVs4J50g5oeNsjtesdjKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Li Huafei <lihuafei1@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 312/817] drm/amdgpu: Fix the memory allocation issue in amdgpu_discovery_get_nps_info()
Date: Tue,  3 Dec 2024 15:38:04 +0100
Message-ID: <20241203144007.995444567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Huafei <lihuafei1@huawei.com>

[ Upstream commit a1144da794adedb9447437c57d69add56494309d ]

Fix two issues with memory allocation in amdgpu_discovery_get_nps_info()
for mem_ranges:

 - Add a check for allocation failure to avoid dereferencing a null
   pointer.

 - As suggested by Christophe, use kvcalloc() for memory allocation,
   which checks for multiplication overflow.

Additionally, assign the output parameters nps_type and range_cnt after
the kvcalloc() call to prevent modifying the output parameters in case
of an error return.

Fixes: b194d21b9bcc ("drm/amdgpu: Use NPS ranges from discovery table")
Suggested-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Li Huafei <lihuafei1@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index 4bd61c169ca8d..ca8091fd3a24f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -1757,11 +1757,13 @@ int amdgpu_discovery_get_nps_info(struct amdgpu_device *adev,
 
 	switch (le16_to_cpu(nps_info->v1.header.version_major)) {
 	case 1:
+		mem_ranges = kvcalloc(nps_info->v1.count,
+				      sizeof(*mem_ranges),
+				      GFP_KERNEL);
+		if (!mem_ranges)
+			return -ENOMEM;
 		*nps_type = nps_info->v1.nps_type;
 		*range_cnt = nps_info->v1.count;
-		mem_ranges = kvzalloc(
-			*range_cnt * sizeof(struct amdgpu_gmc_memrange),
-			GFP_KERNEL);
 		for (i = 0; i < *range_cnt; i++) {
 			mem_ranges[i].base_address =
 				nps_info->v1.instance_info[i].base_address;
-- 
2.43.0



