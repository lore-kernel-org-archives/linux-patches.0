Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F22366546;
	Tue,  6 Jan 2026 18:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722435; cv=none; b=K5qPtw7KJJu7BYH2AoHHtZT+ZWVS/UyHXexv8jMaxUi0OmmOv5qJd4RNXts/GjAVHO+FS/5P0++49mJwuo7mxhUOo+GOwAV0zzpBEnYOTxF1tjOVwhmMPdTI39k7Q1p7kvookEwn3u56OBW+rdetdDx3znrpyYT1wS6TPW+rQFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722435; c=relaxed/simple;
	bh=sB4W9KaDS4WKxbqvoTEHYOdVlrBrA/bRD1VXqiWGk4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABci4AuslF2rNTbW+3J4jk4vIkjB4IHpu+tzeV0HVxTJh6dX4F7FqnJ1sgaDqP8F83aunWRi7Ch1076W7SFqkn3IF9ilGjjU1T4gVACad7adMFCfiS5EWf2qaTGTX2l0LK3NuL97VqWEtigb+JIspdmOykn84tfJuNakdQaZa+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwzIPkHD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwzIPkHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FC0C116C6;
	Tue,  6 Jan 2026 18:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722435;
	bh=sB4W9KaDS4WKxbqvoTEHYOdVlrBrA/bRD1VXqiWGk4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YwzIPkHD+LYbUiG2+hTIT2D/xDxS7JLFm827K2/84osQGoyRuuRFFVv2mi4UMAvYA
	 683ntjWSBEBZn+3THp/Itus6hCJ7u17AuKeO63nT7SvzQTNvWfrNDvdwMuLlJoEYZd
	 /w0GIiWdXpfeqntbs4mzujEtrkj2mikU+jTWYtM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Konstantin <answer2019@yandex.ru>,
	Matthew Schwartz <matthew.schwartz@linux.dev>
Subject: [PATCH 6.18 262/312] Revert "drm/amd: Skip power ungate during suspend for VPE"
Date: Tue,  6 Jan 2026 18:05:36 +0100
Message-ID: <20260106170557.325676747@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

commit 3925683515e93844be204381d2d5a1df5de34f31 upstream.

Skipping power ungate exposed some scenarios that will fail
like below:

```
amdgpu: Register(0) [regVPEC_QUEUE_RESET_REQ] failed to reach value 0x00000000 != 0x00000001n
amdgpu 0000:c1:00.0: amdgpu: VPE queue reset failed
...
amdgpu: [drm] *ERROR* wait_for_completion_timeout timeout!
```

The underlying s2idle issue that prompted this commit is going to
be fixed in BIOS.
This reverts commit 2a6c826cfeedd7714611ac115371a959ead55bda.

Fixes: 2a6c826cfeed ("drm/amd: Skip power ungate during suspend for VPE")
Cc: stable@vger.kernel.org
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reported-by: Konstantin <answer2019@yandex.ru>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220812
Reported-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3416,11 +3416,10 @@ int amdgpu_device_set_pg_state(struct am
 		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX ||
 		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_SDMA))
 			continue;
-		/* skip CG for VCE/UVD/VPE, it's handled specially */
+		/* skip CG for VCE/UVD, it's handled specially */
 		if (adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_UVD &&
 		    adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_VCE &&
 		    adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_VCN &&
-		    adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_VPE &&
 		    adev->ip_blocks[i].version->type != AMD_IP_BLOCK_TYPE_JPEG &&
 		    adev->ip_blocks[i].version->funcs->set_powergating_state) {
 			/* enable powergating to save power */


