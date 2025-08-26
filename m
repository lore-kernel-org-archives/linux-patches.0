Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7D0283FDF;
	Tue, 26 Aug 2025 11:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208363; cv=none; b=Re8d0EbPv1T4jaey6O9OZ7TOxHjdY4x0PoQU2WzCGMrVMJktWlzNJdZXt1rOsXyKyls9uIe+/98ryZjEEUF+TFoxxmKelYQdo9Mfsl/5nqAQd594RWN537b8uPZxfRalxiHayWoQUzCorhI3xweyV2j7UyhB9Atm6uawB/hUfCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208363; c=relaxed/simple;
	bh=CWbQgXMgImhs5k6V44Lp9nl3VE9DCFbS5/DqZ3j6xo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOt1K7YGnkMDdFk2TEV45CN4HvUwDk0Xr3dFFuCvWV7Ww9mf2X9jA54sYj4DdR6Xhp7PLYl4xRrh1Br/tuER0Rj8OL0W3/DTRfyWMcdL6X/2v1yeyObxalCjSy0aD4/KOPtmvCj//FXRrnIYOnlTSNxyLeykTo5U3VR2sK+gXXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xxMshh/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xxMshh/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F928C4CEF1;
	Tue, 26 Aug 2025 11:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208363;
	bh=CWbQgXMgImhs5k6V44Lp9nl3VE9DCFbS5/DqZ3j6xo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xxMshh/eN9SMjunLDbamVE4Kmme4q7XHOwqC+Glx9HQ5Iy9AXzw8Q2vPI8U4BVZZ/
	 cdbK3G5Tj7uHocFfranEtPKOLSCVve88RoftvWhxCF8Na7+zHZ0y0vh9hmvUl8aQke
	 tbzn/S+uzlvgtLq35d+9+oJWkwkqNcbBo2EV2SPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xaver Hugl <xaver.hugl@kde.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 083/322] amdgpu/amdgpu_discovery: increase timeout limit for IFWI init
Date: Tue, 26 Aug 2025 13:08:18 +0200
Message-ID: <20250826110917.675657761@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Xaver Hugl <xaver.hugl@kde.org>

commit 928587381b54b1b6c62736486b1dc6cb16c568c2 upstream.

With a timeout of only 1 second, my rx 5700XT fails to initialize,
so this increases the timeout to 2s.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3697
Signed-off-by: Xaver Hugl <xaver.hugl@kde.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9ed3d7bdf2dcdf1a1196630fab89a124526e9cc2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -273,7 +273,7 @@ static int amdgpu_discovery_read_binary_
 	int i, ret = 0;
 
 	if (!amdgpu_sriov_vf(adev)) {
-		/* It can take up to a second for IFWI init to complete on some dGPUs,
+		/* It can take up to two second for IFWI init to complete on some dGPUs,
 		 * but generally it should be in the 60-100ms range.  Normally this starts
 		 * as soon as the device gets power so by the time the OS loads this has long
 		 * completed.  However, when a card is hotplugged via e.g., USB4, we need to
@@ -281,7 +281,7 @@ static int amdgpu_discovery_read_binary_
 		 * continue.
 		 */
 
-		for (i = 0; i < 1000; i++) {
+		for (i = 0; i < 2000; i++) {
 			msg = RREG32(mmMP0_SMN_C2PMSG_33);
 			if (msg & 0x80000000)
 				break;


