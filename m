Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775007;
	b=NvEZFwZjugWKBUj/nyBuUk7K5IuurJhvBOJxOJbnrIF2HOzBxZ64mHV+maFTZvUeXx4V
	 xNb1+xO3F7+jfxbt4mRldsJVNHWzTXoNKFpSOc666vLbf091U5bQl/uFsO6kaJSbT7XhS
	 +y22P8nGsbf1uOHNn/7TGCYQaa6KDrUeiSKPV3k5wG49UukLVaXs1Wl+qu9XVhI9QYeH4
	 d55fXfjqLcf822owIg8p8TIZE35jGCNeD610BnPty3aA/PKcEj2P6mIgQhM/nNsR9Q1ZQ
	 BEqaiBbfphj5PEmZAPHU6F2r5It4Yo6h0RKqRdRT3lrLfPpAFb4td7mXYowuYT59LsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775007;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pKfzzh7bpLhBHGv17xx76kouwE9LXCz82bJIN1G3mlM=;
	b=tIUOnE6QZmucrSI50L6p1zCM+/6rMFKjA4TCm4C7TYumTjEmEhTDYOqzvUQ3CtU8THA/
	 LiZ+VvDeNUJrMbz07yvmjttU3B4V/fuDyFO1VUbOs6KFdkpTlgI+YeUHJFNXkn3dSHpT6
	 Kyz2KLXyTtQRqyZ7DgV9X2LEjhZw3xT8qJq8aL8m0PQ7pizT8kjvgTyC6hzEHAwQeQcb5
	 XG+0sov5deXbNVH7hLBFX2EJkunRWQjtHkeOqT1+rMEpERQcLXvcRXKSpcf7i6coGeKFo
	 lUWThPXCr0IIvIs1apjJgkVD1Q1ODM2m/8Sxu+coARvmtfeUPKUqHBwkhYolGV+2zZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ynKbWdK1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74312606A31A;
	Fri, 23 Oct 2026 17:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ynKbWdK1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B6C1F01825;
	Fri, 23 Oct 2026 17:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775007;
	bh=pKfzzh7bpLhBHGv17xx76kouwE9LXCz82bJIN1G3mlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ynKbWdK1ueIecsXfEPkIiUKpVA+1CCKZcPYBtBrT4XXuvoFny2Fcw37XTJ3DiGJee
	 cjaKEOh0/Oi2JtEJAKxXjxIj2XX1gMHz5d2qpxIvLIiMU4Pkhpbexwk7LpMcBeWPZO
	 AcVriU0Wp2VCuss95iJhYuCFNJjCU7HeD5jhP/vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 230/242] drm/amdgpu: free the userptr ranges when a CS fails after parser_bos
Date: Fri, 23 Oct 2026 18:41:12 +0200
Message-ID: <20261023163719.286086766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1434,6 +1434,7 @@ static void amdgpu_cs_parser_fini(struct
 int amdgpu_cs_ioctl(struct drm_device *dev, void *data, struct drm_file *filp)
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
+	struct amdgpu_bo_list_entry *e;
 	struct amdgpu_cs_parser parser;
 	int r;
 
@@ -1468,25 +1469,31 @@ int amdgpu_cs_ioctl(struct drm_device *d
 
 	r = amdgpu_cs_patch_jobs(&parser);
 	if (r)
-		goto error_fini;
+		goto error_free_user_pages;
 
 	r = amdgpu_cs_vm_handling(&parser);
 	if (r)
-		goto error_fini;
+		goto error_free_user_pages;
 
 	r = amdgpu_cs_sync_rings(&parser);
 	if (r)
-		goto error_fini;
+		goto error_free_user_pages;
 
 	trace_amdgpu_cs_ibs(&parser);
 
 	r = amdgpu_cs_submit(&parser, data);
 	if (r)
-		goto error_fini;
+		goto error_free_user_pages;
 
 	amdgpu_cs_parser_fini(&parser);
 	return 0;
 
+error_free_user_pages:
+	/* amdgpu_cs_submit() only drops the ranges once it got that far. */
+	amdgpu_bo_list_for_each_userptr_entry(e, parser.bo_list) {
+		amdgpu_hmm_range_free(e->range);
+		e->range = NULL;
+	}
 error_fini:
 	amdgpu_cs_parser_fini(&parser);
 	return r;


