Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0FB381D4;
	Fri, 24 Nov 2023 18:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klA7TcKn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7471C433C7;
	Fri, 24 Nov 2023 18:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850304;
	bh=inlokrHkU2Ny+f7ftSB1jZF7tbl7AR99Al3G+XAiFG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klA7TcKnjzedcbfHPv1sxl/vn+zJrokJYeR4tNVkJcl8WQEm/g+gsAflFpPJs0tLk
	 VulzjTHdDeD6rWepqIemV7JFsx0cYl3wBXk9yGVwrtCpujcGNsy5STvBIrxi2mAhti
	 5RsewtBT75QlF/KLmWo/t/bxd6pUhkUAp7IX59Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 527/530] drm/amd/display: fix a NULL pointer dereference in amdgpu_dm_i2c_xfer()
Date: Fri, 24 Nov 2023 17:51:33 +0000
Message-ID: <20231124172044.239156395@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit b71f4ade1b8900d30c661d6c27f87c35214c398c upstream.

When ddc_service_construct() is called, it explicitly checks both the
link type and whether there is something on the link which will
dictate whether the pin is marked as hw_supported.

If the pin isn't set or the link is not set (such as from
unloading/reloading amdgpu in an IGT test) then fail the
amdgpu_dm_i2c_xfer() call.

Cc: stable@vger.kernel.org
Fixes: 22676bc500c2 ("drm/amd/display: Fix dmub soft hang for PSR 1")
Link: https://github.com/fwupd/fwupd/issues/6327
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -7430,6 +7430,9 @@ static int amdgpu_dm_i2c_xfer(struct i2c
 	int i;
 	int result = -EIO;
 
+	if (!ddc_service->ddc_pin || !ddc_service->ddc_pin->hw_info.hw_supported)
+		return result;
+
 	cmd.payloads = kcalloc(num, sizeof(struct i2c_payload), GFP_KERNEL);
 
 	if (!cmd.payloads)


