Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ADB3F54B8;
	Tue, 17 Mar 2026 16:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766737; cv=none; b=lJvysiHCRqtNLi7ThL5rKzqdUEXp/Gf0R8Ocz/nIOCQP1BXTRXxHOrEKygKTWpEItS9irpmk7+qOH/TLgAQ7EYPI7D9iWFM7tVlm8S+uK8yI99lVxKG3Nym08TZQfcsnSmPMkEY9r5Q+0XVZH+KFDtqw/nNQoJpqbE3Q8hqmFnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766737; c=relaxed/simple;
	bh=CbZhMM63BONPtA0QsFU/Ti+I5D+kpBnX/nUdQ+RHte8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W70+VI7p0zEM3VKxTWNcR0fO05BhwN74j+DOSYyugZAvabUU1mq1vR6dPYr3FubD1y26lIciR/hqlufwXMggHhWTfiYWlbtQ4pq0UqjGIUVsGZ0XcA8OhtNr3P0C+keCyibWAzN+BnJdW3iFFv1w0NmlDU9Ho3A4kUFTm/oJXSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCbGdppn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCbGdppn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C674C4CEF7;
	Tue, 17 Mar 2026 16:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766737;
	bh=CbZhMM63BONPtA0QsFU/Ti+I5D+kpBnX/nUdQ+RHte8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCbGdppnwF6Pfijm8ZSSqQVshJEp2V0ook55lkbnuC+oQOz4A7CnnrvexQnJ+vQ36
	 kD/hZvuv1xwOz62cI9m5aSLboaR2LhuxGtq6DmlKXU0se1372TK3x3TFGonQCK3BdC
	 NAWRiynNqSPEKiUO2zsdfVbEsEaC5ry6IEwTxUqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.19 303/378] drm/amd: Fix NULL pointer dereference in device cleanup
Date: Tue, 17 Mar 2026 17:34:20 +0100
Message-ID: <20260317163018.151419340@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 062ea905fff7756b2e87143ffccaece5cdb44267 upstream.

When GPU initialization fails due to an unsupported HW block
IP blocks may have a NULL version pointer. During cleanup in
amdgpu_device_fini_hw, the code calls amdgpu_device_set_pg_state and
amdgpu_device_set_cg_state which iterate over all IP blocks and access
adev->ip_blocks[i].version without NULL checks, leading to a kernel
NULL pointer dereference.

Add NULL checks for adev->ip_blocks[i].version in both
amdgpu_device_set_cg_state and amdgpu_device_set_pg_state to prevent
dereferencing NULL pointers during GPU teardown when initialization has
failed.

Fixes: 39fc2bc4da00 ("drm/amdgpu: Protect GPU register accesses in powergated state in some paths")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit b7ac77468cda92eecae560b05f62f997a12fe2f2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3404,6 +3404,8 @@ int amdgpu_device_set_cg_state(struct am
 		i = state == AMD_CG_STATE_GATE ? j : adev->num_ip_blocks - j - 1;
 		if (!adev->ip_blocks[i].status.late_initialized)
 			continue;
+		if (!adev->ip_blocks[i].version)
+			continue;
 		/* skip CG for GFX, SDMA on S0ix */
 		if (adev->in_s0ix &&
 		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX ||
@@ -3443,6 +3445,8 @@ int amdgpu_device_set_pg_state(struct am
 		i = state == AMD_PG_STATE_GATE ? j : adev->num_ip_blocks - j - 1;
 		if (!adev->ip_blocks[i].status.late_initialized)
 			continue;
+		if (!adev->ip_blocks[i].version)
+			continue;
 		/* skip PG for GFX, SDMA on S0ix */
 		if (adev->in_s0ix &&
 		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX ||


