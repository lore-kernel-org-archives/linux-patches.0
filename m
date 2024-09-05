Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B709218D65E;
	Thu,  5 Sep 2024 09:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530153; cv=none; b=q5D48w1UiB9dKi13OXCY0LZvREmbHA0WXq8uwUz7/gEbDz7b9RFThTthTTG68fz4K9bYr2ZyNDOHZxAoACDzzTe3OfHGOEeSxczvMJjeYXepvEQFl4pNbM3rBpTrgBxvl77P6wbSHsSajPYejVZ2hcAJQLGW311pp6L3RgnJ1L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530153; c=relaxed/simple;
	bh=bDiDqh1Brgt1AYs0gqqKg/z9qgi3C6JFKNnZTn6T6K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohqivwdTx3RcWte8ZGauDxwQYmyvshQTk7dOCQV3TeAh+bvc6XQaEgAuXbRHRVfvpwmMib1ZaN59xRGz0UMjU9ZT6paVbrsEH5FfezIpYgrYA9IJxvE189os3VFEEzsQvRc+DhQVLfwcI+bwPgQL4LFQjMEPSEPhDedU1F9cI4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUg5ekrm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUg5ekrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43360C4CEC3;
	Thu,  5 Sep 2024 09:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530153;
	bh=bDiDqh1Brgt1AYs0gqqKg/z9qgi3C6JFKNnZTn6T6K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zUg5ekrmSpmeAHoE/pUOgrdv5YLn3bKEr0LB09WM6kP1QfVoeXLmKqKQ6Ew3ojzG8
	 1jGy43XQbApHw7yngiPvWuJg5/zYCuEvvcSHog65zo/R4CwJtD3hm09/XK/qLWU8UX
	 s18ziymnRryG3Y8FuPk16srM4NryjYy/2g/GMhT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/132] drm/amdgpu: Fix out-of-bounds read of df_v1_7_channel_number
Date: Thu,  5 Sep 2024 11:40:58 +0200
Message-ID: <20240905093725.018737187@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

[ Upstream commit d768394fa99467bcf2703bde74ddc96eeb0b71fa ]

Check the fb_channel_number range to avoid the array out-of-bounds
read error

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Tim Huang <Tim.Huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/df_v1_7.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/df_v1_7.c b/drivers/gpu/drm/amd/amdgpu/df_v1_7.c
index 5dfab80ffff2..cd298556f7a6 100644
--- a/drivers/gpu/drm/amd/amdgpu/df_v1_7.c
+++ b/drivers/gpu/drm/amd/amdgpu/df_v1_7.c
@@ -70,6 +70,8 @@ static u32 df_v1_7_get_hbm_channel_number(struct amdgpu_device *adev)
 	int fb_channel_number;
 
 	fb_channel_number = adev->df.funcs->get_fb_channel_number(adev);
+	if (fb_channel_number >= ARRAY_SIZE(df_v1_7_channel_number))
+		fb_channel_number = 0;
 
 	return df_v1_7_channel_number[fb_channel_number];
 }
-- 
2.43.0



