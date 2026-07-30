Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AA75C613;
	Thu, 30 Jul 2026 14:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422242; cv=none; b=l0tx2LqAKGVeAZMnLznXWyVuNYJo/VGjaAz7Svsamyf2uej6nEkWphIqlwE4CpiaWMBSXJ89sLVs65hh40RpYtrcDIkXO/+8Eo1tqy0bPFZXdsGcKf2KuQ5EgeGYv1WxYGiLOF770gaep1tM11Jhcge2MkqgF2NOf62XS2WNITc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422242; c=relaxed/simple;
	bh=TPTGiMWuZ7oD/uwwfCi5eI0gejZi6dc7Llv1x6L6ZDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dii63Tt1Bb/LNIZItSpg5ZNdtsKGtixaMArfnb0hpR5BUTMJKTItuaNuBvyn9nh0YyhP2I5ZE+nuMy3YZDSip/hobYqiHoXTDQaIct/Cvy4clyk2PRVGucVQbubQz1G5xqwp4VbGAoL5wnxU6y0AYBTVKblZkYNpajR3HKb/0w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOnWNgMu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOnWNgMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B691F000E9;
	Thu, 30 Jul 2026 14:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422241;
	bh=ZRWAfVnAXM+T4XHu0BOwkrSfaUQJONeMuOw/eHpN5ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oOnWNgMuTjO6UABa41cxjtRWNGyBZN6t2JWYxOI1MqBSScgYA37wYD2Oft43AlND1
	 XKbheT839P5jVFYuym5LU+SsBHiFTUmukamKkvwscBeFsaHtWPUJsmAnvTSogDbWDj
	 OFb86EzCnqCuW5zMhPU7NP0w/Sjhe9EULzZ9twyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhankar Milind Sardeshpande <Shubhankar.MilindSardeshpande@amd.com>,
	Suresh Guttula <Suresh.Guttula@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 373/744] drm/amd/pm: re-enable MC access after PrepareMp1ForUnload on SMU V15 APUs
Date: Thu, 30 Jul 2026 16:10:46 +0200
Message-ID: <20260730141452.215277663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubhankar Milind Sardeshpande <Shubhankar.MilindSardeshpande@amd.com>

commit 76589bcc73f477ef2b3b90e4fae6a7a4dfd925af upstream.

During smu_v15_0_0_system_features_control(), the driver sends a
PrepareMp1ForUnload message to PMFW. PMFW then performs nBIF and SYSHUB
function-level resets (FLR), disabling PCIe CFG space reset, which
clears the framebuffer enable bit to zero and disables MC (memory controller)
access from the host.

Re-enable MC access via the nbio mc_access_enable callback right after
PrepareMp1ForUnload completes in smu_v15_0_0_system_features_control().

Signed-off-by: Shubhankar Milind Sardeshpande <Shubhankar.MilindSardeshpande@amd.com>
Signed-off-by: Suresh Guttula <Suresh.Guttula@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 840a3c5aeae779a3bc75d7f747c3ed18b1af6507)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0_0_ppt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu15/smu_v15_0_0_ppt.c
@@ -227,9 +227,14 @@ static int smu_v15_0_0_system_features_c
 	struct amdgpu_device *adev = smu->adev;
 	int ret = 0;
 
-	if (!en && !adev->in_s0ix)
+	if (!en && !adev->in_s0ix) {
 		ret = smu_cmn_send_smc_msg(smu, SMU_MSG_PrepareMp1ForUnload, NULL);
 
+		/* SMU resets BIF_FB_EN to zero, re-enable MC access on APUs with SMU V15 */
+		if (!ret && adev->nbio.funcs && adev->nbio.funcs->mc_access_enable)
+			adev->nbio.funcs->mc_access_enable(adev, true);
+	}
+
 	return ret;
 }
 


