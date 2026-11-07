Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062480;
	b=WQdBXBLxBzzZqVnEfH8Ik2j3cjf+BZOuikTJofEzw50DWoM2IqJQjOcCfUFVS0e21BaU
	 gZai1OYDqrCsVSCfXGICec8qKWPxk1tOGkIimAyxpHHQvRD5Uwcnn0Z01hNiJY6hcTnQ/
	 CiCyEfgPe0VqWXu1x+ijolneWyMIwhPPLjE7qUC1zfvxy7jOGP/0r68g1Eta/1/ZAwvqJ
	 LL/+29oELpi1oLRnqGP5mxC86gMELCC93WzN9z//aQydpndYalO0OotiywyDi/0UZNgPN
	 SeM21+8JkLh03No32UMdeq3pS3r7zvR1EdJdFK3dhi/5gYZz0uIUNwFVsTYbjUH3x4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lq1/chhVQQ+0WK2qTD8oyqBt/GY/MOfD9v41JIFc3zc=;
	b=B9I1bEvIo/29xTSdXWInIbiKycrlrO/aW/HALTyD0bDKF6GOiTqAB1sHtom3oMXnfBnB
	 gNIZG6HHBu+TLkceVN0KpPAWOc8nj09KJJkKYJzry/Jr0cfDIjuqSTT3lohP19RDDZRK/
	 fKX80ZwI7gyljA+h2wWOrScJxQKoAIVq9pIp2KO/AyikCMPqmbcBZ+dVO6zhNLquVXOP7
	 9ucRwqH/QMRClvo0y2YKlonWn8SFNwdyunTRlZ1JtZEOqN22nIFhAqoo18IMswmAXXQ4i
	 KhPmSZBcLeep/Ffp3J1JhrIV/Hpb3vI1KV9KRWsC7J58LazU8cbhEA5yEYJTsraERmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bJSyEiBI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE64606D837;
	Sat,  7 Nov 2026 14:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bJSyEiBI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011791F0089F;
	Sat,  7 Nov 2026 14:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062480;
	bh=lq1/chhVQQ+0WK2qTD8oyqBt/GY/MOfD9v41JIFc3zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJSyEiBIkMDhtC3glRQ1QD0jccD2+2ej9QwMhZJLbFVoAaNcqaFIBfNcXxnH8eC6+
	 7hIv96T0mDLXCp6NpvVvFHzeE1h8VsrPidT3fyWWsH6IZMqaBIpt4aCyyJHA8JRR2C
	 OAmFKNNiMLrzLFFZ2lCpoST1lPNIbTcM/TaXfJZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1382/1536] drm/amdgpu: reject ANONONLY userptrs that span multiple VMAs
Date: Sat,  7 Nov 2026 08:56:38 -0500
Message-ID: <20261107135036.648802308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit d577b68a854d0f590f480777249b041507d0708c ]

For AMDGPU_GEM_USERPTR_ANONONLY, amdgpu_ttm_tt_get_user_pages() only
checks the VMA at the start of the range for a backing file, and
amdgpu_hmm_range_get_pages() then faults in the whole range, across any
other VMAs. The check used to reject ranges ending beyond the first VMA
(vma->vm_end < end), which got lost when the code moved to HMM.

An ANONONLY userptr over one page of file-backed memory is rejected
with -EPERM, but one over an anonymous page followed by the same
file-backed page is accepted.

Restore the check and reject ANONONLY userptrs that cross more than one
VMA. The second userptr is now rejected too.

v2: reject ranges spanning multiple VMAs instead of walking every VMA
    (Christian)
v3: cast num_pages to u64 to avoid an overflow (Christian)

Fixes: 6826cb3b92a3 ("drm/amdgpu: support userptr cross VMAs case with HMM")
Cc: Christian König <christian.koenig@amd.com>
Cc: Philip Yang <Philip.Yang@amd.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 75d753ed4704d5efc72164d9e546b2a282e42ae2)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 93da39a5ce492..b2a90c5168401 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -753,7 +753,8 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages,
 		goto out_unlock;
 	}
 	if (unlikely((gtt->userflags & AMDGPU_GEM_USERPTR_ANONONLY) &&
-		vma->vm_file)) {
+		     (vma->vm_file ||
+		      vma->vm_end < start + (u64)ttm->num_pages * PAGE_SIZE))) {
 		r = -EPERM;
 		goto out_unlock;
 	}
-- 
2.53.0



