Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3370192D70;
	Tue, 10 Sep 2024 10:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963430; cv=none; b=WN+7E6FjqKm5JFO76N6J0QOdIwtIKWzZX1Ga775lbpXaGWCh61Pju9xmP+IGkKqObhPLX30pSqmGZCOy5gvV63s1w0Z4fcnMj46aIkAFDP/Ck4H8gScSobA7j+u46hTMSfy0T9uafewsU0rU6W0Z7Iv1GPWxHZjwxWx+lK9JzZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963430; c=relaxed/simple;
	bh=tCa9Vh24ra9mAqNHrdUZ33vMiABjKueHYGDZDmBsYXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDr3RvRz98Ni5WY5C1djxoEf3YqhMza8clgSAERrierkyZMXC1nWNIYRh9idsVE9y3vyDyaYzJ0+0CjivlMdw2ddtnlalGKkfMcxtmMsB0mnwpL+dXCfDIvF7WTZS4ORNnLWv/2hmYAPEVIC/8HCOt5dqZTjwugdS16kH39QPkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0662snTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0662snTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB6BC4CECF;
	Tue, 10 Sep 2024 10:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963429;
	bh=tCa9Vh24ra9mAqNHrdUZ33vMiABjKueHYGDZDmBsYXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0662snTyI/yGRmfPstbcQDCOvcnr6WHH21goBN7wzHomcgpCZx+8Ub6tPzF0oh5SD
	 CTzNKYvboJ6Zw6E5N10JQiRfxNcwYfOcTZfK7vNblcTQfxF+0v7cDp39BEmkP1kEO9
	 vyBM3Dov5WTMGD1q9MfODvRw3KwR1vL1oEA83s+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Tim Huang <Tim.Huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/214] drm/amdgpu: Fix out-of-bounds read of df_v1_7_channel_number
Date: Tue, 10 Sep 2024 11:30:49 +0200
Message-ID: <20240910092559.888097661@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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
index 2d01ac0d4c11..2f5af5ddc5ca 100644
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



