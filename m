Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35C61DE3A3;
	Tue,  8 Oct 2024 12:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392003; cv=none; b=osvievXP/3F3xk9HrMAPjxzrvC4QwiMp1E9nhtlE54FX3chGvZK3RJedIeuHtTFRA1tcM0GKl3THCd+/5PiN6LHMBOguP2bl2CXGbrc6MwnZSty5D3FjaTx03MrM9AulJjY5oU2mPOkpZhWzw76IV87c2q+J5Px1Y3FzJ0uLUi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392003; c=relaxed/simple;
	bh=XNHfl0pIERliQ5sNrqtYjBLQFdtAhLItyxSstCD37rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lzku6VFeGiQkxQ3mSAiasDSuxUef7nZNzJmlstN97ZjtFXmSbjuMjQUO0rXxv6J+AA3fclbmK2tV25dvHBd/2JrfW1Yit1WlfDrPktYO7/shCRtWXomXvqBxnG6m4r+YZNUDouabV4aX78B4Wscyc3+22CGWpB5hpbGUr1AYMdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSarKk39; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSarKk39"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C405C4CECC;
	Tue,  8 Oct 2024 12:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392003;
	bh=XNHfl0pIERliQ5sNrqtYjBLQFdtAhLItyxSstCD37rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CSarKk39wR2yioKFZ8L/zNoyFjUHTM8lGA4XzCcf8nzc/xEZNQ8P5wZef4CDzHx5z
	 ZRxByJpymIBFEAL43Srk47JzropUnTio8uuHErPfB9UPJ8Iqa3NfZpdJCCpWXOUA58
	 hTz00hW9zfSLL7WOEDgxesYzYsJaRzfJb40TvRts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 288/558] drm/amd/pm: ensure the fw_info is not null before using it
Date: Tue,  8 Oct 2024 14:05:18 +0200
Message-ID: <20241008115713.659523225@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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
index ca1c7ae8d146d..f06b29e33ba45 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
@@ -1183,6 +1183,8 @@ static int init_overdrive_limits(struct pp_hwmgr *hwmgr,
 	fw_info = smu_atom_get_data_table(hwmgr->adev,
 			 GetIndexIntoMasterTable(DATA, FirmwareInfo),
 			 &size, &frev, &crev);
+	PP_ASSERT_WITH_CODE(fw_info != NULL,
+			    "Missing firmware info!", return -EINVAL);
 
 	if ((fw_info->ucTableFormatRevision == 1)
 	    && (le16_to_cpu(fw_info->usStructureSize) >= sizeof(ATOM_FIRMWARE_INFO_V1_4)))
-- 
2.43.0



