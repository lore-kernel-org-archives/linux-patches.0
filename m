Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEA114AD35;
	Thu, 23 May 2024 13:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470455; cv=none; b=FbRzy5P6hpQgdn3/Tf2ZSbxZ1si0T5thUlVD3gJ0dYc7Yd1d417n0PHQR7v51Pinu8x/4RATc6JJiXIXvWPkr6cGnzxJLFUGxCXQ07g0bptP8m2ild8psPUSKgZUeAid7ic7duwKTfjb/Z5roaJASxQpH+w448BsvlPvU078lGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470455; c=relaxed/simple;
	bh=GhkzrMJGnTqGMmC5YeR1C2oUT6L0cSshbBs35Im1M90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EUVPADsB4sPFi2+62ywpv2hrtoa7vhoFLqBb7iNoSzVmV60wZ0ZRZakBFILqDzbawraRNamiZKIIMrY+ISlkltnqVbtk7rhyJVo+Kwp0QeBa4l9DMks6o/4rdeyKoULXZsTDCEMMfioDQ6LYSj3+w14aFrnNoHtfe63ScMp5GNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QBaJU++A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QBaJU++A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D6CC3277B;
	Thu, 23 May 2024 13:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470455;
	bh=GhkzrMJGnTqGMmC5YeR1C2oUT6L0cSshbBs35Im1M90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QBaJU++Ax3lS+TbpNxgm0UOLJeprFQfDBkEiWlm8o/oMWG18iam/4YGmeQLQh3+5v
	 n4dFxCAhYoU16BQ0vnqd+yomC4dmBxjtMRLGZUdkFhcYIsqzi5zWuiqPew1Tgslrnn
	 h765/wTDQ8MRxlWxk8Y4zuMZqc+7aFo+JCavslVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>
Subject: [PATCH 6.1 35/45] drm/amdgpu: Fix possible NULL dereference in amdgpu_ras_query_error_status_helper()
Date: Thu, 23 May 2024 15:13:26 +0200
Message-ID: <20240523130333.822945036@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit b8d55a90fd55b767c25687747e2b24abd1ef8680 upstream.

Return invalid error code -EINVAL for invalid block id.

Fixes the below:

drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c:1183 amdgpu_ras_query_error_status_helper() error: we previously assumed 'info' could be null (see line 1176)

Suggested-by: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Tao Zhou <tao.zhou1@amd.com>
Cc: Hawking Zhang <Hawking.Zhang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[Ajay: applied AMDGPU_RAS_BLOCK_COUNT condition to amdgpu_ras_query_error_status()
       as amdgpu_ras_query_error_status_helper() not present in v6.6, v6.1
       amdgpu_ras_query_error_status_helper() was introduced in 8cc0f5669eb6]
Signed-off-by: Ajay Kaher <ajay.kaher@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -974,6 +974,9 @@ int amdgpu_ras_query_error_status(struct
 	if (!obj)
 		return -EINVAL;
 
+	if (!info || info->head.block == AMDGPU_RAS_BLOCK_COUNT)
+		return -EINVAL;
+
 	if (info->head.block == AMDGPU_RAS_BLOCK__UMC) {
 		amdgpu_ras_get_ecc_info(adev, &err_data);
 	} else {


