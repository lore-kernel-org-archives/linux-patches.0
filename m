Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4330B1DE89F;
	Tue,  8 Oct 2024 13:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393500; cv=none; b=EAdYm8LSNpBVpgM3Eoeb8XYLt0ONU0PZBnE5y8JBniwggduWAvxdKVl3cGaBYlJNVps9oLfGMMKOAtFbEvb0tzM/dVkSzH9B2QsP7D5tRH+z7nkIV84VYbtul/y4fEpZb+YCsrlvnGnVfYkAwrfbFUYsS7nn2tIuoqBwJrNbrZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393500; c=relaxed/simple;
	bh=BiqpidloBbHw5fVM8zFp2xHIIZO6W7VQA5IagyrPgQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SY+dagopwqzvVJK3R/CWMrgUkAx0elAnG7XY5P7brRilzTM4cH1dW/w63580ddNzgbSpq/3IAXcTut4b5j/WM+5timCgGnE+rz8ucfOwanu3bGdbECD87iap9q3f9R3L7h2f8jiqZOkw2ThV1BS3KYgEMjVyHJ34SpyAqdVmr5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sv81vqMc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sv81vqMc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A5AC4CEC7;
	Tue,  8 Oct 2024 13:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393500;
	bh=BiqpidloBbHw5fVM8zFp2xHIIZO6W7VQA5IagyrPgQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sv81vqMch9KlBRSpY/bvIuWTLrlnaY0riOF5hpXRBo0V/AQT+rlrQzUtb+pYV0ZjF
	 d90IXlmJ6kU5ilovuw6ePSSl3NlUGtjZhS0S3l05SwCOGadQxbiEgzemU8wmLG+28x
	 i9WLzKw9lm+8VSHR423ZUeD2NQopf0FFMbLs5K7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/386] drm/amd/pm: ensure the fw_info is not null before using it
Date: Tue,  8 Oct 2024 14:06:56 +0200
Message-ID: <20241008115636.153012284@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Huang <tim.huang@amd.com>

[ Upstream commit 186fb12e7a7b038c2710ceb2fb74068f1b5d55a4 ]

This resolves the dereference null return value warning
reported by Coverity.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Reviewed-by: Jesse Zhang <jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
index 5794b64507bf9..56a2257525806 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
@@ -1185,6 +1185,8 @@ static int init_overdrive_limits(struct pp_hwmgr *hwmgr,
 	fw_info = smu_atom_get_data_table(hwmgr->adev,
 			 GetIndexIntoMasterTable(DATA, FirmwareInfo),
 			 &size, &frev, &crev);
+	PP_ASSERT_WITH_CODE(fw_info != NULL,
+			    "Missing firmware info!", return -EINVAL);
 
 	if ((fw_info->ucTableFormatRevision == 1)
 	    && (le16_to_cpu(fw_info->usStructureSize) >= sizeof(ATOM_FIRMWARE_INFO_V1_4)))
-- 
2.43.0



