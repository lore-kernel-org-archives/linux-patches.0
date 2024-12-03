Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7626A1F75A4;
	Tue,  3 Dec 2024 15:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240991; cv=none; b=jDYnPmV66uARBEKRW6mt7iAGndFuSYvpvE+t4zR2DLzU1txgJpINL5Yva+N3uv0z9Ms2X260OoYgysHUbpAIkENGAPj93j7Bx2D+jH7cljETrHump8/o1P3xy5lOspT4e3Zjxl1U+SQvOonzR4VPbXa58OAjyccbltNSrJvrqhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240991; c=relaxed/simple;
	bh=jhE5V6I82iy0zSk2sGzWJ4he4XTauOnCneDAkapjlrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+Ql12KTOV6KpOknn0mcam/ZQvWGPLwlTcR1VQ9FgE5MTVIayYIds2FsbFetShC7bNnS81W3sFe4hU3teOIUTODGSw7yThcsoszAH5oc/55fYepn9UOt9Es0tbE+ChCFZOE6W0r1CDlYPqAIqsqiN/LACg9/POL4crw80yNUf2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1q61xdFm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1q61xdFm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74460C4CED6;
	Tue,  3 Dec 2024 15:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240990;
	bh=jhE5V6I82iy0zSk2sGzWJ4he4XTauOnCneDAkapjlrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1q61xdFmDmCbOKX5CdlXWOt6FQj2oZWdYIokfXPSsrTKVbcqG0BZIdtp1vHiqeX3V
	 Rcki5/rtb45ov/OdzucYy/xY6vmhAnTv4RWx5ye2tilwUFBEXYuj1FpdQ7fBNAoc36
	 q0ShR3yTyRc0ETUo/JN00cOEXJypS5UI5Mh3zOv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Li Huafei <lihuafei1@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 294/826] drm/amdgpu: Fix the memory allocation issue in amdgpu_discovery_get_nps_info()
Date: Tue,  3 Dec 2024 15:40:21 +0100
Message-ID: <20241203144755.234486791@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



