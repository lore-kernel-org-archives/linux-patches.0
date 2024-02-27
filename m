Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFE954BD4;
	Tue, 27 Feb 2024 13:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041744; cv=none; b=drOSGSg/M4DmQs9w/gQfSh7c8Z4DVJiEMiu90NxX5rVmqda3uwQQkjdoh220b0yzx9hJ2n1opDMbDnC0x1xqY2BvIEmjNT30aahTfl99pbT9JUgI3SBgM8ayYdODAdhCCoz21SIkv9tNi7T7JWPN9Pvs24jfTqcOoysuw7BHP4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041744; c=relaxed/simple;
	bh=MmKoRrTNBKMb3yk4p7959emtvd2Ek/IS4gEnUcZtQas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/ajk93hZOCEK8E9gCokmHdqI5LrY4tRtssO/pSWGQOj8AvPU3H9IPZ4UPXt8nPf/KcV3EHC1aDQrRQhsg/Gm9itf6uN0Eu43cPj4D3XQYgqI5a2QxgnBDxBV2uEEGz1rY6uC4CHQd93mQvrP8q/jeUyky5q376a0qnKDdJBeZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Raz6LS4u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Raz6LS4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFE7C433C7;
	Tue, 27 Feb 2024 13:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041744;
	bh=MmKoRrTNBKMb3yk4p7959emtvd2Ek/IS4gEnUcZtQas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Raz6LS4ulumXJ/9u3poCPMGWAH+sNGYsdfy91GuX5iOCdJdEA7pUR967b9zjFuSwz
	 HDjdjI72HrYYi5yXwp4vE2Gl+SSo953pvVCf6mKq9xPGP6VdSbeVH+f2Df8jhDRUte
	 0TbQxxwctPhZ5tLc4xk/9wkk30cdTlHHSyCXUY60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/299] drm/amdkfd: Use correct drm device for cgroup permission check
Date: Tue, 27 Feb 2024 14:22:44 +0100
Message-ID: <20240227131627.675752503@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukul Joshi <mukul.joshi@amd.com>

[ Upstream commit 4119734e06a7f30e7e8eb666692a58b85dca0269 ]

On GFX 9.4.3, for a given KFD node, fetch the correct drm device from
XCP manager when checking for cgroup permissions.

Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index 3287a39613959..12ee273e87e1e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -1482,10 +1482,15 @@ void kfd_dec_compute_active(struct kfd_node *dev);
 
 /* Cgroup Support */
 /* Check with device cgroup if @kfd device is accessible */
-static inline int kfd_devcgroup_check_permission(struct kfd_node *kfd)
+static inline int kfd_devcgroup_check_permission(struct kfd_node *node)
 {
 #if defined(CONFIG_CGROUP_DEVICE) || defined(CONFIG_CGROUP_BPF)
-	struct drm_device *ddev = adev_to_drm(kfd->adev);
+	struct drm_device *ddev;
+
+	if (node->xcp)
+		ddev = node->xcp->ddev;
+	else
+		ddev = adev_to_drm(node->adev);
 
 	return devcgroup_check_permission(DEVCG_DEV_CHAR, DRM_MAJOR,
 					  ddev->render->index,
-- 
2.43.0



