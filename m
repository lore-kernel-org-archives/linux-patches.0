Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8C61990D1;
	Thu,  5 Sep 2024 09:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529505; cv=none; b=CXXOSvrVeUYy8puxHiuiqHLcL6ay0b9Qae7FjQ0oWEAklGOZEFNRj6/5sk9nHF3hhGUlt7LzBEx7VSOB5VMs3pmt1mCBUXnnwwXLQWpe4WCRzYcx6wBz66nN147vAkpnGbN5TalyIOHqstDBGqsCbz97Tw9t6CNEMrgLGBzn4iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529505; c=relaxed/simple;
	bh=k692qTcEbliJQ5k9lfJjeHtLzPZ/uW5Swv8bWXxYpsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bblTv6zZCoMhufOX+hr50AiS1+LFHpbSbR3oAC0OjlARmt6nOPAmMkoYX9p6kVoVlKQ0C6uMEpxEePoQwhYMx9UJrdwunv3uHjl+njaJtfkwQ+EUCMkkFSnXmjbVlJKsSTnMXTxX+DlTVilEFmb4Snw8NhavPWqQAFfGuOIYTFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcvMY7Bq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcvMY7Bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BFCC4CEC3;
	Thu,  5 Sep 2024 09:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529505;
	bh=k692qTcEbliJQ5k9lfJjeHtLzPZ/uW5Swv8bWXxYpsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcvMY7BqP8l+FpD4c8ef/SWllvU0MHmTsGdn5XzFx1yqG5dl48PALjnptYIANvv28
	 5DZhfgF29ELef7XIxk40R30f6RsjdoxaqGABhB2y7rqeQgX/HRqM19DG5DOCe5b4Gg
	 GagspG8kPHEWP6wDkqjS0LEXrBopJM9bBtig+tnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <Tim.Huang@amd.com>,
	Yang Wang <kevinyang.wang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 053/184] drm/amdgpu: fix uninitialized scalar variable warning
Date: Thu,  5 Sep 2024 11:39:26 +0200
Message-ID: <20240905093734.314337361@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <Tim.Huang@amd.com>

[ Upstream commit 0fa4c25db8b791f79bc0d5a0cd58aff9ad85186b ]

Clear warning that field bp is uninitialized when
calling amdgpu_virt_ras_add_bps.

Signed-off-by: Tim Huang <Tim.Huang@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 972a58f0f492..f5fedf1be236 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -395,6 +395,8 @@ static void amdgpu_virt_add_bad_page(struct amdgpu_device *adev,
 	else
 		vram_usage_va = adev->mman.drv_vram_usage_va;
 
+	memset(&bp, 0, sizeof(bp));
+
 	if (bp_block_size) {
 		bp_cnt = bp_block_size / sizeof(uint64_t);
 		for (bp_idx = 0; bp_idx < bp_cnt; bp_idx++) {
-- 
2.43.0



