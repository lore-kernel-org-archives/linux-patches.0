Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208898;
	b=lKXdlKb3OsjuQggSuJbc6ReqwbRRoXVet29qiwTzH1ONrx4VzsFWcwSrIPGbp1n/qhpA
	 k8y9bpy+k46sqdxGEV5Yx2fuN29K+ShYO3BQKxqhxzbvfM03fsJzniEN8nuE0tSKK59pQ
	 wGDW1ysxvjJ9PYkFOTsp2anEk9UTX289A9eJFx1V7gDgLfWSEBJ4ucWa8ret3vJCHBYix
	 R8vAZyxtyEd8DR6TMfJgqaap6Q86iKFwpp/zUY3AjCWEHAYu4ViKuTEY84mPlIwVQ1pWS
	 xQyXuBWagH5hdmNGDKuZ+R29MZY7GUjHb7OYnjY2BLuO2bItRahhsvzX7FiqNj7fyGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208898;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SIQe5MSL0Ifp8AKchoOGbFcAp5rYfwN5E1UiA7Hpcvs=;
	b=QeP1wlwINyeB0H4t2WRYBFVaSqeuyDmWt/bLtDCmZEYVXkSvvQH1ceEWVJOkVt4dgn3o
	 JhDszeR//BXZlBg/IRBm7xFMAu7q5TdesPEA5Eligxtnm8S1zfy591amw966xnMKFXQsH
	 xLETcsRt4nTbBmj9RP5pDM3pdjyPLj1Vsn8RzALaBwO7A+jIMU+2i2Dm5L5xvZ4SOblWt
	 R25Nhqb1PYBGQiezcUMRIeXiA8z8GUc9O8R14t9ZLvio3pbFuaY2hz3x4y62Dt64c3lS4
	 tfD87T/tNkI9zRdW8ZAENSWW3M8bfNwAW+glgd2hvkeizLCod1tG/yM6GbMoHQbkalg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IVmlMVOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0BE606A321;
	Wed, 28 Oct 2026 17:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IVmlMVOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0878D1F01825;
	Wed, 28 Oct 2026 17:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208897;
	bh=SIQe5MSL0Ifp8AKchoOGbFcAp5rYfwN5E1UiA7Hpcvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IVmlMVOjg0Sh4na5HLa/sjfNOIYh+Dkhjm8IPrJh+m4LJWMpj/j+/EOWNf0+7dnwo
	 UX9VvbgnkgNgw6dnZvo/II0VkRpQ78ni2N58SPIv97De8MNkkvxS9+tdgmhpVBZ9z/
	 HeVHcvNgd2SeHL0TxQN3De2u6utzdApHG5eutEAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 279/516] drm/amdgpu: fix ACP MFD device leak on init failure
Date: Wed, 28 Oct 2026 17:57:11 +0100
Message-ID: <20261028170010.100371505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit f0013046151b7467e62c471c1c83d63ea255799c ]

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
[ sashal: adapted the error-path changes to the single device_for_each_child() call in acp_hw_init(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
index 173ac5677d467..0f359f1fb041b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_acp.c
@@ -354,7 +354,7 @@ static int acp_hw_init(void *handle)
 	r = device_for_each_child(adev->acp.parent, &adev->acp.acp_genpd->gpd,
 				  acp_genpd_add_device);
 	if (r)
-		goto failure;
+		goto failure_remove_mfd;
 
 	/* Assert Soft reset of ACP */
 	val = cgs_read_register(adev->acp.cgs_device, mmACP_SOFT_RESET);
@@ -371,7 +371,7 @@ static int acp_hw_init(void *handle)
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
 			r = -ETIMEDOUT;
-			goto failure;
+			goto failure_remove_mfd;
 		}
 		udelay(100);
 	}
@@ -389,7 +389,7 @@ static int acp_hw_init(void *handle)
 		if (--count == 0) {
 			dev_err(&adev->pdev->dev, "Failed to reset ACP\n");
 			r = -ETIMEDOUT;
-			goto failure;
+			goto failure_remove_mfd;
 		}
 		udelay(100);
 	}
@@ -399,6 +399,11 @@ static int acp_hw_init(void *handle)
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
-- 
2.53.0



