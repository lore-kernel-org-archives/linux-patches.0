Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A390F5381A;
	Sun,  1 Sep 2024 16:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208329; cv=none; b=s/d8Pqu15uwyes3vOrjIVtXhWPh16JKbVWlUb7iQMb/EIiNLNfHiF6iK2D3hzJ6rWvHGDs5icStdiuTAwdUZyt9bXOSPjt00qcJW9Q5bFPU1IUa7M2mXCWV2rnQbcM4ChZJAjpXlCwCv6KqAJyydJq0V1BjTUX8fa6UITzERMb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208329; c=relaxed/simple;
	bh=beRFZJOQ6Iz7ocz5/s2mXetqtJQqo7/EODMkuWGxvag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnbIz1guh412vZmi/VmnYkoc6QINmFXY7iD5UXhHAxSieTykMJsv/XRgTQGLKgT23ovY6j08TduOTQ1AYXoB0wbFA1Z3Gn5SA2hK0Sr6HsFcfvdRlW90XkCx0Coey8SwX26XtdIZ80mfs3OK/ScevhjJjaPpup8eoxt5CnVt2zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSvS9+Dy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSvS9+Dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11CE9C4CEC3;
	Sun,  1 Sep 2024 16:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208329;
	bh=beRFZJOQ6Iz7ocz5/s2mXetqtJQqo7/EODMkuWGxvag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSvS9+DyggB+lF7178A3oxbR9cyRgccHdIN9030En3GQZYmwPhw9oHbps2iXracl/
	 o8zQqCGFRoF4a5JPH1jsWgY7qAOpUu1fgnkfl2EooJ+NzA0WYgwxw2oE4i9ykSjAzY
	 RXDIw/vPb5IYvLW0q4vcVeH4WELAA19fAd3+mZEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Lu <victorchengchi.lu@amd.com>,
	Vignesh Chander <Vignesh.Chander@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 049/149] drm/amdgpu: Do not wait for MP0_C2PMSG_33 IFWI init in SRIOV
Date: Sun,  1 Sep 2024 18:16:00 +0200
Message-ID: <20240901160819.312305211@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Lu <victorchengchi.lu@amd.com>

[ Upstream commit b32563859d6f61265222ec0f27d394964a8f7669 ]

SRIOV does not need to wait for IFWI init, and MP0_C2PMSG_33 is blocked
for VF access.

Signed-off-by: Victor Lu <victorchengchi.lu@amd.com>
Reviewed-by: Vignesh Chander <Vignesh.Chander@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 9cead81eff63 ("drm/amdgpu: fix eGPU hotplug regression")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
index 0e31bdb4b7cb6..ea5223388cff2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -256,19 +256,21 @@ static int amdgpu_discovery_read_binary_from_mem(struct amdgpu_device *adev,
 	u32 msg;
 	int i, ret = 0;
 
-	/* It can take up to a second for IFWI init to complete on some dGPUs,
-	 * but generally it should be in the 60-100ms range.  Normally this starts
-	 * as soon as the device gets power so by the time the OS loads this has long
-	 * completed.  However, when a card is hotplugged via e.g., USB4, we need to
-	 * wait for this to complete.  Once the C2PMSG is updated, we can
-	 * continue.
-	 */
+	if (!amdgpu_sriov_vf(adev)) {
+		/* It can take up to a second for IFWI init to complete on some dGPUs,
+		 * but generally it should be in the 60-100ms range.  Normally this starts
+		 * as soon as the device gets power so by the time the OS loads this has long
+		 * completed.  However, when a card is hotplugged via e.g., USB4, we need to
+		 * wait for this to complete.  Once the C2PMSG is updated, we can
+		 * continue.
+		 */
 
-	for (i = 0; i < 1000; i++) {
-		msg = RREG32(mmMP0_SMN_C2PMSG_33);
-		if (msg & 0x80000000)
-			break;
-		usleep_range(1000, 1100);
+		for (i = 0; i < 1000; i++) {
+			msg = RREG32(mmMP0_SMN_C2PMSG_33);
+			if (msg & 0x80000000)
+				break;
+			usleep_range(1000, 1100);
+		}
 	}
 
 	vram_size = (uint64_t)RREG32(mmRCC_CONFIG_MEMSIZE) << 20;
-- 
2.43.0



