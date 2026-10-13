Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E89D4F475B;
	Tue, 13 Oct 2026 12:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894987; cv=none; b=XFfRoG5y2blvXv/6mTG69CwuVTySqnM3xAVWen5NQEG9PPmSN0/4Apf8rZrz6//v1hHMUQRlS9Sje6DE4vc+nztIvVQr3JBgIOnOnj0Exy4qfpSdxB9SOb4kwroCLs3F7Dz0q4yBVT7TijkgB8YW7J8pCYveEit/yy1eXFObUCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894987; c=relaxed/simple;
	bh=REsiFBirugwBq26eG34E/rhukV3Q1CsndJevtWTgsns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W5cBESLCKbZNKOiVhvyCOPqmIwlnR/fIvS1rALw0eEpfkAlnD8VtAQDUy22PbrIPwyNdqp3kfoyTqTQ45tlcleDXlKxTPhnhH2beQu0aLkDbNAV0b8XoKRmReByaEvdPDWCcjerEL6xQBAvUViEjIqq0uMfFdMCN+dlp5cXcksc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McvXw0Mf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McvXw0Mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD131F000FF;
	Tue, 13 Oct 2026 12:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894986;
	bh=GDR/pnUQ8uRzXOG2478ci5lXbQ3LywHuH73ppbUe6ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=McvXw0MfplZ6ZVudkK9uwCqMXviMgu+CWdqwXkKfdhzPWE1rhRkNcrlFssNIHF0+T
	 E0mDrx/TAqnjl1W+oDVyO5B1FXHKxV1EKBT5Gu3jTZPslWa9q+Q+yWJdGpQ1D69gY1
	 hBbxQySSNYr9O2zd1zfdFAJijvKinj+7Wqrt3QU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 122/497] drm/amdgpu: fix ACP MFD device leak on init failure
Date: Tue, 13 Oct 2026 13:34:49 +0200
Message-ID: <20261013112910.786995545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


