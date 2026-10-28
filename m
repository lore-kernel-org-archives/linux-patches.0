Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217401;
	b=DwLSDuZovoeNmI+VmBQj8XTOIQgzT9Pc5szAetrQ0j2XTVmBcSy6yhwTC/M4kyWqb6JO
	 zTEhXnpXmFSmuM5nUDTZw9G3ta7U7I80l4qoz6yeAYnFu/7KvHVuv/PoDRGJhKPUEcdlS
	 tvOZIlBNqDRX4HksMnTD19QnKMt10cYKtHxpqgg2JomoQQl50ih0x3mrGhH1Qle/M2Pji
	 hXJYZPuN7oVac148ADbXGVsXs3wauN1TBwnwz1V8Wzc4B7fQFsi0Y08XhPVcooRRTGrFQ
	 Sp313R32witghru9iMyYG54edbJPPxARchxLOH0FuVFEb8vTdL3Nv4FuYvcPWI/UMrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wxUqn7vtSQ+JQpiuL5OJdxcoY/6+vh5uagu7kxHPu5k=;
	b=cx462gt48d5ZtHTB021xj1owY53IixMxpXAWAxv3C4kYYndf1MEkNopYv2t5A97Mx5eT
	 t5z0ShHQx6QY17JZbOX2ad7YomEzaLvx2cwy8zGnSPxaThVWqlXBZa2Nl0NH9AnSes9il
	 IDGG+f4x5/r780Gk6NUy+ImN6IOhBJoBfl3VmHFN6RAMUc/1r81fxJgNUm1pWaCKsqiCa
	 dv4NatSBh5wULTNkP5egi/CUiXNIaUqRy+Os0/6LFgrmlzWlX1CG0498Asq+xGCXhp3aG
	 FPNQ1Kx/qz9M4+G0vVsXPdfTmFrs5Fit9b1t0NfUrHf3GaV+TvpGT8H5XROH4nepC+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFFSlavN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4521606A31A;
	Wed, 28 Oct 2026 19:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XFFSlavN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 008761F01825;
	Wed, 28 Oct 2026 19:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217400;
	bh=wxUqn7vtSQ+JQpiuL5OJdxcoY/6+vh5uagu7kxHPu5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFFSlavNYRq/wKuA5LKNCqTJ2RIeDmpP9M/0t6YBWmws5KReoCZzSfRgl91h8TvCO
	 C9zIJRn4RYZwI/BAN3alIyvn+G9/DWSO2K+uq5ldK7pRuq4bBbO3nR8HSjbGV+++JA
	 Hi0yt3gKvIO/zEDDyKD/vzBZT9QQWKpWGs8/fEPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haojie Li <lihaojie@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1884/1887] drm/amdkfd: fix dma_buf reference leak in get_dmabuf_info
Date: Wed, 28 Oct 2026 18:06:20 +0100
Message-ID: <20261028170542.330548196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haojie Li <lihaojie@kylinos.cn>

[ Upstream commit e6895021a328594368a2a19406a53ffca1ce51c7 ]

When kzalloc fails for metadata_buffer in
amdgpu_amdkfd_get_dmabuf_info(), the function returns -ENOMEM directly
without calling dma_buf_put(), leaking the dma_buf reference obtained
earlier via dma_buf_get().

Fix both issues by:
- Adding an error check after the first amdgpu_bo_get_metadata() call
- Replacing the direct return with r = -ENOMEM and goto out_put to
  ensure dma_buf_put() is called on all error paths

Fixes: f54ce9e8cbd3 ("drm/amdkfd: Let driver decide buffer size at AMDKFD_IOC_GET_DMABUF_INFO ioctl")
Signed-off-by: Haojie Li <lihaojie@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ffa699553332f8caf8688d312279ddcea9e3c141)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index 596abe49c19c4..355173a6ac3d6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -534,6 +534,8 @@ int amdgpu_amdkfd_get_dmabuf_info(struct amdgpu_device *adev, int dma_buf_fd,
 		/* first get metadata_size by buffer = NULL */
 		r = amdgpu_bo_get_metadata(bo, NULL, 0,
 					   metadata_size, NULL);
+		if (r)
+			goto out_put;
 
 		/* user buf_size is bigger than bo metadata_size
 		 * allocate a buf at kernel space and copy */
-- 
2.53.0



