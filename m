Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774247;
	b=MlmeEniy093IQrm+mCt/3BzRxMUCJQYIEMmIXNp1XSqLvzqCE7KDDbdFUuZJE9co8dZ3
	 1bR6TOsm+asMHnsfnmuWLGGyg0U9Vrc9Mr11wxjGTb6gCpw9qR+bP8ycZpGYAQIyDgx5L
	 L70szsQqXNRWgQK/oV0iqwokxDgzrePmxyqdYUV0+1j95HsdGYPSaMPO2NNqinnnksU5E
	 FJLMaNkE1oYimLspSwg4f5AZsieBkHRSWB5mdGvzLo6GEtaStPUKQ7RYXDXCC3fqiP0OY
	 LR4MHCdrUN+mOuEKMisAfSXj/YX9hyR3HAiueEiN6kmLlp6BwZ/ChrFAhjQdit4CFdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SYY0PU2ZCf9Q0WAZpJhsI1xHN+efHxcTabhyeweu3X0=;
	b=q2j+8t3PjH8BrK3zJt0uIyVG7frWqKNWLv9YtRB7iNJRukHgHaLGR1ewRnhVSgxnFjp9
	 ZtO+Xcae3vfBgONRzHSsb/88s40RFy0qhO2wfRQgbM+z3EcyyZH+ebv+JEkzkANFZ0zdS
	 a+aDyeKryNJd9IU2zUubTmnJ+UPPcNVhWm3ThVEi41uT1oJzJEg49B/nW05k3/qQQaxkd
	 oUBs0tV7IhNxWU9ti8zh3Zav96czhwSfjuDJSh9BtdLdLeAxHVO8gBj1jHjfydgZ4M7xC
	 /Xy7ld/0/kqMcfEk72Yj0H/zznHLuGWczNVGdH+KM1OmxE5mM+BhEFd7d2fVV6LZB9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+y3aMVC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB97F606A31E;
	Fri, 23 Oct 2026 16:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N+y3aMVC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 258A81F01829;
	Fri, 23 Oct 2026 16:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774246;
	bh=SYY0PU2ZCf9Q0WAZpJhsI1xHN+efHxcTabhyeweu3X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N+y3aMVCcONSBs5EtA6ciwumoK/Z/O4pAhTIShAXEHe0i3G4lVkc9xV4JeN5gvZbr
	 t4Q/gTAsC/CJT2tMba5+z44vcHQ7EgRy6FRLHaGdM5Fx+C/OtMjO+obV/LJXEQG6T3
	 bNNa506F4c2fA9kd/Lo6BVysT+apaXBOCKn9q8uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/193] drm/amdgpu: free the userptr ranges when a CS fails after parser_bos
Date: Fri, 23 Oct 2026 18:37:26 +0200
Message-ID: <20261023163718.211283402@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted cleanup to the existing error_backoff path using amdgpu_ttm_tt_get_user_pages_done() before the mutex unlock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1448,6 +1448,7 @@ static void amdgpu_cs_parser_fini(struct
 int amdgpu_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
+	struct amdgpu_bo_list_entry *e;
 	struct amdgpu_cs_parser parser;
 	int r;
 
@@ -1502,6 +1503,11 @@ int amdgpu_cs_ioctl(struct drm_device *d
 	return 0;
 
 error_backoff:
+	/* amdgpu_cs_submit() only drops the ranges once it got that far. */
+	amdgpu_bo_list_for_each_userptr_entry(e, parser.bo_list) {
+		amdgpu_ttm_tt_get_user_pages_done(e->bo->tbo.ttm, e->range);
+		e->range = NULL;
+	}
 	mutex_unlock(&parser.bo_list->bo_list_mutex);
 
 error_fini:


