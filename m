Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67FF817592;
	Tue, 30 Apr 2024 11:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476282; cv=none; b=cpWZQ+QKHyMWO+44Mst0LO99Z+8ZSWZadOh7YHt02qvevTpTFVXGTJayyOTxL/vvWgE31/8P+AtXn+Ru/ETpdfdFWsSkp+4H0nXxc1OgC+Uu0+VzBgpTm6Er8dNUkI23u5nwwiwVeW5gT7gZ87upYIXG2+cDHdQS5Lf1GX+yGW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476282; c=relaxed/simple;
	bh=bjSerCmPsuxs8Tf5e0gWrczuUh3w89w4FbpWwE9Z5NY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBeG2MT+VNcEvrCjig5t0y4w/14xwQZv2tLyBQIbAL6Ubl8cXRpGza74ru0NUhh0XKNfXD3dT/Xr1AWOTXCOgUgYuGDgok2oHAG3tmh2zIPxXdeLDG/357YoQpaXLNTpkqWQUPZCI/3c4+CTHMGNFp6UgMlZt2FQO2xelcuJY0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ib9gf8h9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ib9gf8h9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B83C2BBFC;
	Tue, 30 Apr 2024 11:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476282;
	bh=bjSerCmPsuxs8Tf5e0gWrczuUh3w89w4FbpWwE9Z5NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ib9gf8h97U5F95v9MkhBVeW1bHlNtK5PLRXlmJWpPGoRMjugImyY0Y0odd2QssWsM
	 w9UbqjrymPE2WVoq71RIyugbU6tA2NJnPaBMPXAvoH4ZNZudXEb9LYPaljOyen4z9L
	 rgImmDba93/e7ViM3SCmqcp3+woObi0JhEAD44YQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 092/107] drm/amdgpu: Fix leak when GPU memory allocation fails
Date: Tue, 30 Apr 2024 12:40:52 +0200
Message-ID: <20240430103047.373267590@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukul Joshi <mukul.joshi@amd.com>

commit 25e9227c6afd200bed6774c866980b8e36d033af upstream.

Free the sync object if the memory allocation fails for any
reason.

Signed-off-by: Mukul Joshi <mukul.joshi@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1204,6 +1204,7 @@ allocate_init_user_pages_failed:
 err_bo_create:
 	unreserve_mem_limit(adev, size, alloc_domain, !!sg);
 err_reserve_limit:
+	amdgpu_sync_free(&(*mem)->sync);
 	mutex_destroy(&(*mem)->lock);
 	kfree(*mem);
 err:


