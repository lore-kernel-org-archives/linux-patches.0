Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D75A333745;
	Tue, 17 Mar 2026 17:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768331; cv=none; b=mByIVep31yzcSNW+D4s390lQsqsllgO+rPxkpEd9Fx2Hn4m/3IoIweHiA+kBk3mVlgR2q3cFG8L5EY/AjBjntMTKorvK7NuPnpZ4TYBwna1x+wEniMXbWS/kgljBQXBmt4CBUnVUKkDT2XwmCqRm1eLi03Gjq6/MmIQRzo5Gcvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768331; c=relaxed/simple;
	bh=zJVCUtqPyLa19wDgdiRONi/QgBsfXRXCIOYnbGw6oSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vCcJ+5TYj9oN9xCaI9FDBFveusUZKDUZwlJkFkCI7lZBcMYCkYQj7QcTTEA9qvkPUcNMBEmIs8FjoTn5KIMgrd5FpupHLs1SXGp04SlngyZfvjCXKZr7hgEh6ong56fLcFA/glKhpJD5wIhBGt2g7V4Op1LF4w/TQbYb6GpiL1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOMojNBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOMojNBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2FEC19424;
	Tue, 17 Mar 2026 17:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768331;
	bh=zJVCUtqPyLa19wDgdiRONi/QgBsfXRXCIOYnbGw6oSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOMojNBVSJoyGbq2e0LwgJ+WRFKjAvg7ktkZDd+3wlK7CfYsagVqjb3oiYvicQs2l
	 WrROE89V9c9VDWIuikdKlJrbSzkrDqA+73I3yHbHys1wiT80uNrvUBF8hIakuIx1EX
	 +hKGY7XxjdM8jpuau9TisVCzGa5nODMSa0G0TLyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 252/333] drm/amd: Set num IP blocks to 0 if discovery fails
Date: Tue, 17 Mar 2026 17:34:41 +0100
Message-ID: <20260317163008.713501669@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

commit 3646ff28780b4c52c5b5081443199e7a430110e5 upstream.

If discovery has failed for any reason (such as no support for a block)
then there is no need to unwind all the IP blocks in fini. In this
condition there can actually be failures during the unwind too.

Reset num_ip_blocks to zero during failure path and skip the unnecessary
cleanup path.

Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fae5984296b981c8cc3acca35b701c1f332a6cd8)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |    4 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c    |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2814,8 +2814,10 @@ static int amdgpu_device_ip_early_init(s
 		break;
 	default:
 		r = amdgpu_discovery_set_ip_blocks(adev);
-		if (r)
+		if (r) {
+			adev->num_ip_blocks = 0;
 			return r;
+		}
 		break;
 	}
 
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -83,7 +83,7 @@ void amdgpu_driver_unload_kms(struct drm
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
 
-	if (adev == NULL)
+	if (adev == NULL || !adev->num_ip_blocks)
 		return;
 
 	amdgpu_unregister_gpu_instance(adev);


