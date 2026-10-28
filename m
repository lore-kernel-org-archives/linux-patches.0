Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207824;
	b=KSi+Idb39g0Y5im+UxyNda4aJA3h9sNHAIUNgTkdsUE74taqhuO7foNIQd2+XK+V/gUP
	 uwaS2f0K3zmv6zgIJ+evw9bqc9q18Q+SBA6xGLF/lWv++nSMzXI8gENF3TRyutILS/OqH
	 XOnHVsYHi07XMrgt+dkgMtWzdwCLcIZBlBTz/JTB/of74SZJXQc06qIcLQcJjjDf/6EKg
	 /eE3DISl0ISUwCPbHcut9cfmyGJS5AU0ix7MsWR4ubSl56n1Bh2fxZ1H40L9d1GXR/Q8T
	 0p3Ysq47Uu8QG2ML03LOtKqoB2UNUHzJBATz1orBqj5LeDpn9HqbfGaXqN2wN1uN5xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207824;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UfHObstQtcurB/1NZByElXfhiYSYaO7TOLg+fDmEFxE=;
	b=W/oSEsb3QwWa6RdT++s+g7BUHA4lshluIlwWA3NHAeING1fTypttFJ5lNtGLOSV4eW2H
	 qqqjOGwADNkM6SJHmtHB+aJ0zhNlE3TnOBtHaOGiWJ2WT1cAj3a6UXE378NgB0NKFBIo0
	 DeOF18QQBMQHLP5Ist5dWXi2nZyW5gvPdsaa/5dVk4vJDO7urLYVgSAhlIncBMH1DLXRl
	 1o4OONs4MH+IFHWkfpSusdxdVgF7AMpUuO0j8dSzeOZXXVOeufAQPZi6fvXIHxz3qQ+6t
	 0T6809xWppWLCCxfaMv4AQ9dK4jzFT37rkssv9rF11mmvrNVEDkK5wOmqu05VnKQ18w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SI+3c1b0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE11606A31C;
	Wed, 28 Oct 2026 17:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SI+3c1b0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEF31F01825;
	Wed, 28 Oct 2026 17:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207823;
	bh=UfHObstQtcurB/1NZByElXfhiYSYaO7TOLg+fDmEFxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SI+3c1b017/jgMmeIYzKEtkIU2pX56tY81pm3dWNqomwIvZga1Tf0qiFN03vhnmxN
	 Nq+qu2XuBT8JmDssvr8kGZOnu20BDtnuTEy6ijQaAIjcQ40V0bOprUjvQWmZBSXq9G
	 HLwVkk0eJMpKdncL8v/agc9+YmKu1RcKzQBPi1h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 152/247] drm/amdgpu: free the userptr ranges when a CS fails after parser_bos
Date: Wed, 28 Oct 2026 17:59:15 +0100
Message-ID: <20261028165951.011655819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 1b4da805a0ba354a549ce07459c871c17dd94fe0 ]

amdgpu_cs_parser_bos() allocates an HMM range for every userptr entry of
the BO list and looks up the user pages. Those ranges are only freed when
amdgpu_cs_parser_bos() itself fails or when amdgpu_cs_submit() checks
them under the notifier lock. If amdgpu_cs_patch_jobs(),
amdgpu_cs_vm_handling(), amdgpu_cs_sync_rings() or the early part of
amdgpu_cs_submit() fails, nothing frees them: neither
amdgpu_cs_parser_fini() nor amdgpu_bo_list_free() touch e->range.

Each such CS then leaks the range, its hmm_pfns array (8 bytes per page
of the userptr BO) and the BO reference the range holds. An IB on a ring
that patches the CS in place (e.g. VCN) with an unmapped va_start fails
in amdgpu_cs_patch_ibs() and takes this path.

Free the ranges on those error paths. Ranges amdgpu_cs_submit() already
dropped are NULL, so freeing them again is a no-op.

Fixes: fec8fdb54e8f ("drm/amdgpu: fix userptr HMM range handling v2")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c52a9542ed7cfd527feb938bd0accada2ac8d267)
Cc: stable@vger.kernel.org
[ sashal: Adapted cleanup to use amdgpu_ttm_tt_get_user_pages_done() in the existing error_backoff path. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index eb5f528459ecd..528f0aeac36c6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1449,6 +1449,7 @@ static void amdgpu_cs_parser_fini(struct amdgpu_cs_parser *parser)
 int amdgpu_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
+	struct amdgpu_bo_list_entry *e;
 	struct amdgpu_cs_parser parser;
 	int r;
 
@@ -1503,6 +1504,11 @@ int amdgpu_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 	return 0;
 
 error_backoff:
+	/* amdgpu_cs_submit() only drops the ranges once it got that far. */
+	amdgpu_bo_list_for_each_userptr_entry(e, parser.bo_list) {
+		amdgpu_ttm_tt_get_user_pages_done(e->bo->tbo.ttm, e->range);
+		e->range = NULL;
+	}
 	mutex_unlock(&parser.bo_list->bo_list_mutex);
 
 error_fini:
-- 
2.53.0



