Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950D718757C;
	Mon, 12 Aug 2024 16:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478783; cv=none; b=UWi4sge+sEjMJu9gEVpjMBa5kvzJaSZNQChjH/9NA79jw6Er3aym1Z32pTL0rysdB3nWoWPmq+sA0Of1Kp107wLR+cXr4UrbU61iBv2zQwJ9dXbcXMjPfuZgcwbcUSjI79tS38NmZyNc/qJWOcqCSoITBitYmbo19p+01NdFf2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478783; c=relaxed/simple;
	bh=OZTkzagJjaTEHpIHRNDNFMeqynEknPvzck1/v5Wk//0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ga9I1ioWwVN9Ut8lkiCP6VtX+SW7zBXnCNPhBkA8TZlGBwsPTGCOmOtK2adLhk0ht087tET/r/HFB5wvGgx13BiyGlbxcieyfM64M65Hn8y8F9E3gsO5HJ+tacwSWBTlmmDK79j7jZ7lF0Il98RsMuSdnn+0GM/G5k4e4MuAg5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAzn5Bks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAzn5Bks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECD89C4AF09;
	Mon, 12 Aug 2024 16:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478783;
	bh=OZTkzagJjaTEHpIHRNDNFMeqynEknPvzck1/v5Wk//0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAzn5BksTwjoEMIkA6Q4g9Au39iQNb3Bo3qLLDhbk6D4r0sK1PtXJv1JR60aL5rQS
	 IjlJRzg+JhCm71NmZJsonJIzresbHr7dvz8wkRls4SyxllV0h0tOcsLtoUZOsYv0zo
	 bKR6UcvwpAZOAuq35AQnVAatDpojy73/WINJrBFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/150] drm/amdgpu: Fix the null pointer dereference to ras_manager
Date: Mon, 12 Aug 2024 18:01:57 +0200
Message-ID: <20240812160126.557991403@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit 4c11d30c95576937c6c35e6f29884761f2dddb43 ]

Check ras_manager before using it

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index ee83d282b49a8..4b7b3278a05f1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -1679,12 +1679,15 @@ static void amdgpu_ras_interrupt_process_handler(struct work_struct *work)
 int amdgpu_ras_interrupt_dispatch(struct amdgpu_device *adev,
 		struct ras_dispatch_if *info)
 {
-	struct ras_manager *obj = amdgpu_ras_find_obj(adev, &info->head);
-	struct ras_ih_data *data = &obj->ih_data;
+	struct ras_manager *obj;
+	struct ras_ih_data *data;
 
+	obj = amdgpu_ras_find_obj(adev, &info->head);
 	if (!obj)
 		return -EINVAL;
 
+	data = &obj->ih_data;
+
 	if (data->inuse == 0)
 		return 0;
 
-- 
2.43.0



