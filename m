Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C2F49659;
	Mon, 14 Oct 2024 15:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919178; cv=none; b=j5Kx9wa/ROl9GH6JnIyY+bc7ZBImMOAmMjazdV0NwtPPy6UALnbYzTETeQOAms+gE101AK33G6S776+w1fFzGVvrOYgFhpLRku2ARypjgoCQNoBUeEeRWUyVO+IlD3i37Io+NFOGRx0pQ5G9DXz7/a2xiGelJHfypxmnxXTG2bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919178; c=relaxed/simple;
	bh=MkN3jo81Jp60mX45XpLX7jcWm197rI4EZ+0EAzBDo7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlWqtbMyNi4S1Trc2EgbbS9w3T4XXQYQux/AmrX6AjJ9QyUFaMOJwtf1igxnDokgJSTmXU/I9JRba8MFAjj/U3bLbfuKpTldnQdRIVdtWJzBOrlDLzYtUBBhQgAcGEYSRbgPMAh2BL4ni7itJAaL3NUpZEax+FNH533nn+qko/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7iad2vB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7iad2vB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9462C4CEC3;
	Mon, 14 Oct 2024 15:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919178;
	bh=MkN3jo81Jp60mX45XpLX7jcWm197rI4EZ+0EAzBDo7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7iad2vBKLjpAen9+CBt2fLlP5J/Ed9i4BbN3Vrq3H6cNRXNGkrerajD+UT4/N1Lq
	 xkSn/3d4LqueAAtQVL7KxS/tnm5cm5xuLScu+uuSmhSJHu/FTmxe76QYDps8rcMrhE
	 DJczo8uBsb6r4tRKrbUwyrV02kfRbXPcA+K53KfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 503/798] drm/amd/pm: ensure the fw_info is not null before using it
Date: Mon, 14 Oct 2024 16:17:37 +0200
Message-ID: <20241014141237.738653056@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index 182118e3fd5f3..2ca93a1f0b8e1 100644
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



