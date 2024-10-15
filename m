Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983001D1512;
	Tue, 15 Oct 2024 12:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993636; cv=none; b=DO5NSp5bzYXfcuIsTnkzt8uwPKdm1N+ltZXHNrL9vZqOOAnT4uCh1GVHCNR4TLlG00a17SJgTaTg0vWTWCSaTc/YG/20WDj0j93gKPa2axigEk2lcB1YUu7BqaXRGr34xCAssVBjQvuDFkWqgKAL43oCKDz8Qvo9fsiBFQUCFYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993636; c=relaxed/simple;
	bh=CdFr9FvN1g9+lEc/IzIR+cwKR5tImDBa2D6tWyf7W1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYssNWD4tb/8XoPvCOJdG4Uk57fzzK0oby3amv201dF6HsrSUN93Tk3MU1c52kTjd6M8EUddNvsVoh2VWViQPgFN6jZBiM4FU0FHdQylpZIPM2PuoiKSsWU++FVqjjB4VhO6UN59ANN7SDZi+o9RveMW3PCM+Av2xJwaGiY2J6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJe9StIy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJe9StIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC224C4CEC6;
	Tue, 15 Oct 2024 12:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993636;
	bh=CdFr9FvN1g9+lEc/IzIR+cwKR5tImDBa2D6tWyf7W1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJe9StIyVOHXw3OFiDVYSL2rTPbENdNuJ7Fcj/ebfpyDET6v1pWavX+igNF1+ofCa
	 e20p9g+r4hd4U9+YZmfogZdO/KflYir5E1lFOCKmxN43DE1rUhYrFhPXPm+QhqBrG8
	 XD1I+mcdjwIWPSA7OcWotNEDZVmv3iCR+wNsiK+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 470/691] drm/amd/pm: ensure the fw_info is not null before using it
Date: Tue, 15 Oct 2024 13:26:58 +0200
Message-ID: <20241015112458.998824656@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



