Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EDB77F1B;
	Mon,  8 Apr 2024 13:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582011; cv=none; b=OB9AMvRoumNcwt6sWrzP5Dh/w6f9R6Hket4pp2VSvJf31K7Q3sSGdF3Bq7v+mwc7jLhC8ppzAtapG1EDcqnBmtqvYwIR/2OtY7gBU55aS7YTQZLKCysuHXbDVpEFG1/1pKbdwoWUQKuoxKqTxljXxswgAXBsecSGoPiZmFXmJ0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582011; c=relaxed/simple;
	bh=4SyZfx+9InlhIBsJpau/cJ+3HybbgM0oTbHSmEgBOvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FDeJ9WCNEPONIORJ3kv/vh/6Y10iabdL9FIomMwseYfipiAIqhmkADM53ad0i7SMgMhZng9MoFM1mwKIiwG7id8Tk6MZtWdPzXKLU/YzzXP3zHUrwSwVGG/It9eQ1dzfowzpPewC7h7WSMnpdVzde9nI9HanA4xFU/D92lSMUrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZniIDCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZniIDCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D60BC433F1;
	Mon,  8 Apr 2024 13:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582011;
	bh=4SyZfx+9InlhIBsJpau/cJ+3HybbgM0oTbHSmEgBOvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZniIDCcGoz5M6u2U+1jvFTZFWL5YfD3AipdInQMrjCdvACgLfMYbWVGoHgWeypYY
	 +iFWusqYGwpRyc7kP4KCSp63REINQeYwNPp5KbOoCcFvEHN/7EBsqjK1N96n0jzZaC
	 SaMl8ZobQndXr1dqXJqmJ4kkVzNOtY9XWuX36Zz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/138] drm/amd: Add concept of running prepare_suspend() sequence for IP blocks
Date: Mon,  8 Apr 2024 14:58:05 +0200
Message-ID: <20240408125258.430163089@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit cb11ca3233aa3303dc11dca25977d2e7f24be00f ]

If any IP blocks allocate memory during their hw_fini() sequence
this can cause the suspend to fail under memory pressure.  Introduce
a new phase that IP blocks can use to allocate memory before suspend
starts so that it can potentially be evicted into swap instead.

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: ca299b4512d4 ("drm/amd: Flush GFXOFF requests in prepare stage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 12 +++++++++++-
 drivers/gpu/drm/amd/include/amd_shared.h   |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 902a446cc4d38..77e35b919b064 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4180,7 +4180,7 @@ static int amdgpu_device_evict_resources(struct amdgpu_device *adev)
 int amdgpu_device_prepare(struct drm_device *dev)
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
-	int r;
+	int i, r;
 
 	if (dev->switch_power_state == DRM_SWITCH_POWER_OFF)
 		return 0;
@@ -4190,6 +4190,16 @@ int amdgpu_device_prepare(struct drm_device *dev)
 	if (r)
 		return r;
 
+	for (i = 0; i < adev->num_ip_blocks; i++) {
+		if (!adev->ip_blocks[i].status.valid)
+			continue;
+		if (!adev->ip_blocks[i].version->funcs->prepare_suspend)
+			continue;
+		r = adev->ip_blocks[i].version->funcs->prepare_suspend((void *)adev);
+		if (r)
+			return r;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/include/amd_shared.h b/drivers/gpu/drm/amd/include/amd_shared.h
index f175e65b853a0..34467427c9f97 100644
--- a/drivers/gpu/drm/amd/include/amd_shared.h
+++ b/drivers/gpu/drm/amd/include/amd_shared.h
@@ -294,6 +294,7 @@ struct amd_ip_funcs {
 	int (*hw_init)(void *handle);
 	int (*hw_fini)(void *handle);
 	void (*late_fini)(void *handle);
+	int (*prepare_suspend)(void *handle);
 	int (*suspend)(void *handle);
 	int (*resume)(void *handle);
 	bool (*is_idle)(void *handle);
-- 
2.43.0



