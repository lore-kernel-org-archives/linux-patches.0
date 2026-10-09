Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F0F3B19DE;
	Fri,  9 Oct 2026 14:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556484; cv=none; b=esImq3Rea+3B4aH5tSYnP89t47DXQIbbiL/VL1lLlBxs3JtrOw6elyobkAreOfcGmHexdCaU8o0q9DIgJiFw8PNFyjkdflkLeBGxf0+s3p9Kt/sIRnZ+jaJEiBkAk0bxk22Tw2f83vXT+aJWRKlW2dpfXulVn04G+ObIEW3+ju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556484; c=relaxed/simple;
	bh=kOMS6Y524RR0SleXbSbgI6FRgQa6DpmZFv9tHdb2srE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCyDDY5MsaBA5V4e4bOQbpxFY3j9lnQvZP578ZWVuZMJ+cxLfRIWwVQdvwexhD4TFLG1gNyOnZkh1WjF8oFdgsq48i6fR7eWsW/fC90xn8/pLWFlj6m1NtlRhF9D9qevutZ6IOYadfNfFL974cdYIyW29bMG6zZVqidjEg4vql0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evNJN0ql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evNJN0ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A6C1F000FF;
	Fri,  9 Oct 2026 14:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556482;
	bh=GC8eklR/3/Iz5Jwx317k3e5kqAmFi0zKiebqb81CPDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=evNJN0qlgpQffDwAlDCC0WrBPjFociTIUYQTTektzjjiSuM+4ARuc6O/cs2OcaCw+
	 iO/09DYnEy1b45VyuUdUWRglW+IRqZ9J8SIHs1xzJ4o+x1BmB3IV0h3kmMy5Ewz7Fn
	 NgtBd8xAI2KyGrylWYBbvrraVkw7IerhucDjOOFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 188/428] drm/amdgpu: fix ACP MFD device leak on init failure
Date: Fri,  9 Oct 2026 16:08:45 +0200
Message-ID: <20261009140950.272212003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit f0013046151b7467e62c471c1c83d63ea255799c upstream.

acp_hw_init() registers ACP child devices with mfd_add_devices() before
attaching them to the ACP power domain and initializing the hardware.

If attaching a child to the power domain fails, or if the ACP reset or
clock enable operation times out, the failure path frees only the
source cell, resource, and platform-data allocations. The child
platform devices already registered by mfd_add_devices() remain
registered and are never released.

Remove the children from the power domain and unregister the MFD
devices on failures that occur after mfd_add_devices() succeeds. Keep
mfd_add_devices() failures on the existing cleanup path since the MFD
core already rolls back partially registered children itself.

The issue was identified by a static analysis tool I developed and
confirmed by manual review.

Fixes: 25030321ba28 ("drm/amd: add pm domain for ACP IP sub blocks")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 63da68d6a2279ec945581c990c5a59a5ae8b5560)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
@@ -318,7 +318,7 @@ static int acp_hw_init(struct amdgpu_ip_
 		r = device_for_each_child(adev->acp.parent, &adev->acp.acp_genpd->gpd,
 					  acp_genpd_add_device);
 		if (r)
-			goto failure;
+			goto failure_remove_mfd;
 		break;
 	}
 	default:
@@ -443,7 +443,7 @@ static int acp_hw_init(struct amdgpu_ip_
 		r = device_for_each_child(adev->acp.parent, &adev->acp.acp_genpd->gpd,
 					  acp_genpd_add_device);
 		if (r)
-			goto failure;
+			goto failure_remove_mfd;
 	}
 
 	/* Assert Soft reset of ACP */
@@ -461,7 +461,7 @@ static int acp_hw_init(struct amdgpu_ip_
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
 			r = -ETIMEDOUT;
-			goto failure;
+			goto failure_remove_mfd;
 		}
 		udelay(100);
 	}
@@ -479,7 +479,7 @@ static int acp_hw_init(struct amdgpu_ip_
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
 			r = -ETIMEDOUT;
-			goto failure;
+			goto failure_remove_mfd;
 		}
 		udelay(100);
 	}
@@ -489,6 +489,11 @@ static int acp_hw_init(struct amdgpu_ip_
 	cgs_write_register(adev->acp.cgs_device, mmACP_SOFT_RESET, val);
 	return 0;
 
+failure_remove_mfd:
+	device_for_each_child(adev->acp.parent, NULL,
+			      acp_genpd_remove_device);
+	mfd_remove_devices(adev->acp.parent);
+
 failure:
 	kfree(adev->acp.i2s_pdata);
 	kfree(adev->acp.acp_res);


