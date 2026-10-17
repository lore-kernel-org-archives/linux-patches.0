Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EA93AA4E8;
	Sat, 17 Oct 2026 17:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256468; cv=none; b=fsGOWXyYqLS8WrGbaq7hQzk+Q5Y9HTtMiwiTEGuxlGx3X6zKkwIptRC/af/wFJJXdST2kAl78Upgeeo1f190b7uILlgYFAr5lFIE3x9yScT6dWCAvvAL5OEBNl5OyKGQ3xuFQT85yF4BMyu+xMR5eduJ3y4YaR7KKRclSfnQ+7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256468; c=relaxed/simple;
	bh=rDJRiZdMx2T95G0koX1eILy7EaAiZCx64hVim3QLwXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdzREO6HXmO8eVGx/jb9UOd0QlaGnVdYkVd4nTBxmgd8IQvLba2y7MesYzVGA3dV/RMlPaYIe140y1wgE6FHfMfoPcGLnADjs7jmCeDhalvIg0a1KJ+lPh/oM05xyeo2c1bu3eb3KQs5GkYmwwDZ9XN/Qt20fNeakvhDqwiUNQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hQCj2EF4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hQCj2EF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090CE1F000C4;
	Sat, 17 Oct 2026 17:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256467;
	bh=aD74xR/DK9kTh9MmOl/Epws73BafaDUrykv8rm5vhBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hQCj2EF4+PbwP8epJ8hwq9Vwh9qn3asBY+5tNZZR4JlMfEkRy+HAhh7MEmdpoWQBu
	 wu/Usfwi4J3cI6io6z6EAlBuBOdKNjpadiNedtd/VgMNgPfN0ecHqWhrNM+OSJ8Kku
	 S/qzh3MPWHrq0V4NwEUwgPnub826wkEWYdNkse/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 0244/1674] drm/amdgpu: fix ACP MFD device leak on init failure
Date: Sat, 17 Oct 2026 17:41:56 +0200
Message-ID: <20261017160437.392181500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -324,7 +324,7 @@ static int acp_hw_init(void *handle)
 		r = device_for_each_child(adev->acp.parent, &adev->acp.acp_genpd->gpd,
 					  acp_genpd_add_device);
 		if (r)
-			goto failure;
+			goto failure_remove_mfd;
 		break;
 	}
 	default:
@@ -446,7 +446,7 @@ static int acp_hw_init(void *handle)
 		r = device_for_each_child(adev->acp.parent, &adev->acp.acp_genpd->gpd,
 					  acp_genpd_add_device);
 		if (r)
-			goto failure;
+			goto failure_remove_mfd;
 	}
 
 	/* Assert Soft reset of ACP */
@@ -464,7 +464,7 @@ static int acp_hw_init(void *handle)
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
 			r = -ETIMEDOUT;
-			goto failure;
+			goto failure_remove_mfd;
 		}
 		udelay(100);
 	}
@@ -482,7 +482,7 @@ static int acp_hw_init(void *handle)
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
 			r = -ETIMEDOUT;
-			goto failure;
+			goto failure_remove_mfd;
 		}
 		udelay(100);
 	}
@@ -492,6 +492,11 @@ static int acp_hw_init(void *handle)
 	cgs_write_register(adev->acp.cgs_device, mmACP_SOFT_RESET, val);
 	return 0;
 
+failure_remove_mfd:
+	device_for_each_child(adev->acp.parent, NULL,
+			      acp_genpd_remove_device);
+	mfd_remove_devices(adev->acp.parent);
+
 failure:
 	kfree(i2s_pdata);
 	kfree(adev->acp.acp_res);


