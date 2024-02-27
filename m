Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C3213B7AA;
	Tue, 27 Feb 2024 13:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040714; cv=none; b=elKkIxGxcIr+w3Mw5FZWxYsWwe4Xn6IruGe/w/Dg8dfB1dIqf2Ck0OPofLDAuFx1XhOehi3c8tp0ffREKEQDfUJTH8Iw35AOP7IOvsh+2sA6SpdeWnysrlYBnHSugLqbYZOC6nlvLBSAXh8coZ8lDEDUgzTruzwe+9WBob1tMs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040714; c=relaxed/simple;
	bh=3wATnSOZ+5zHCB8sVeynEQKbAUM0Wla6YmCKP8Hplh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUrkW0iAUM1ZcxYXKdL2/FucGFO5xbO5QgAGPQgYHTMiV7HlC//S+iT0ZneMg0bahBt1TslWJU0yUyQCVMEVhuZxpoMKG1wXa8O2ZyX0jUxa3+TTWCmNaH3L0ac3YIiqMS5pCi9ePDRkdz7V71Z/AUrtpHeNXJcSAw9dCdawReg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHUzWf94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHUzWf94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0E0C433C7;
	Tue, 27 Feb 2024 13:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040713;
	bh=3wATnSOZ+5zHCB8sVeynEQKbAUM0Wla6YmCKP8Hplh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHUzWf94YyzDx/sqG3ZMRVglIwnVbQXhIJUOGruXpLSjY39cFdPJqxVEyisidk3DC
	 lCvWOm6dgCawE+4Ts/BTWwNPWP7OlxPGH2ya1K3MHxeKqBaSqceYLzQHN4epbyFRUt
	 27NcUW0bbLs8r9NyzsaboyM/DRQrpo4oKNahSsPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 056/334] drm/amdkfd: Use correct drm device for cgroup permission check
Date: Tue, 27 Feb 2024 14:18:34 +0100
Message-ID: <20240227131632.377998462@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 28162bfbe1b33..71445ab63b5e5 100644
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



