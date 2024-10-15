Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBDD1C07DF;
	Tue, 15 Oct 2024 13:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997995; cv=none; b=WW33JDyjxYqablVcX4PGK1Ey/B8ibWMPdKD5+WmH7sWHYrMK0CHS4IXoLi7bToBorZnjdmVfUKnygfrMpeV4lBVZD24wUjf/gCr03A2r2RwmJqLbwMmX2/3NhnfMRAkGltk5q9Xh1EVjfWdTxboxe+vU/nkaobGAt2wPb5W+h8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997995; c=relaxed/simple;
	bh=8qmWZ0DBn5uQsE1DMxFPh+iO0ZHWOuURIiN3OWtHCD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtDFt+n8QN9o+A80QoMIaZK7ChRcPnhi3u0iKsceU+10UYhryQuhfivRWhxbiHZPWMpyfHDqqrYyIyEgoCVauIQxjpzoE/BzKIHZp8zcDfcKsW+8UIo89hucRNiLFeg/CI20iXxoB+kREMWCwz+S3mVF7xAl9OBZOMkCGWrZ6GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=diO0Nh6G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="diO0Nh6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F988C4CEC6;
	Tue, 15 Oct 2024 13:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997995;
	bh=8qmWZ0DBn5uQsE1DMxFPh+iO0ZHWOuURIiN3OWtHCD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=diO0Nh6GiQiM6ZnLGbblgCa0WMZDMi6odB48pUkoPF8pUF7uFjRVfExS2gqVNQMnS
	 gWqR72f9UV1G4LifaHIuKVqZn+sGAAeUvUmT7lAocWA/B9K+iuVSWYlOTPSmHzbVbd
	 DorygA9mmbm9R6SIc8Tclk4NNLxPhJ0Lrw3O3E1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Jesse Zhang <jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 349/518] drm/amd/pm: ensure the fw_info is not null before using it
Date: Tue, 15 Oct 2024 14:44:13 +0200
Message-ID: <20241015123930.440005367@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6606511891e34..04bf14cdefadf 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/processpptables.c
@@ -1189,6 +1189,8 @@ static int init_overdrive_limits(struct pp_hwmgr *hwmgr,
 	fw_info = smu_atom_get_data_table(hwmgr->adev,
 			 GetIndexIntoMasterTable(DATA, FirmwareInfo),
 			 &size, &frev, &crev);
+	PP_ASSERT_WITH_CODE(fw_info != NULL,
+			    "Missing firmware info!", return -EINVAL);
 
 	if ((fw_info->ucTableFormatRevision == 1)
 	    && (le16_to_cpu(fw_info->usStructureSize) >= sizeof(ATOM_FIRMWARE_INFO_V1_4)))
-- 
2.43.0



