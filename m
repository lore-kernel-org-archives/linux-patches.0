Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D5861675;
	Mon,  4 Mar 2024 21:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587800; cv=none; b=nhifQ2xwcnIDsnCEtMLHmnXbI+U7UN9OLpGNv8gEcGpEbrUrgDsFc2KX/8pY8YdyI+USqWpaBDfXSTxaHjZW3ZQdM0N8wz91dTiKR/oyoAWTn9Okn1VE2EkZJd+VdCDepZZy9qNLnRGGZJsjzcIY0wgoMhJrFQPiR4bdX9zFo3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587800; c=relaxed/simple;
	bh=yb030ubKD9mJbGQE//r285ACHyo31kfXg+lI+EcZOKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVc9KHuc5Mk9r/iz/93B/wODRwkpBf3hEXzrLlJT17q9u3iOugznhyIq+Nuk26FuOMoTiMuMYK9nmvUuOtpkqPmmjc06RlVYozQf61Pt0Bc9xKrPDWIcT5z7fde9v0hAsgTRSaXCbJ4ioPA7Z+H0aiha/ew2vlpqJOBvbCl+qzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tlJnsZUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tlJnsZUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69358C433C7;
	Mon,  4 Mar 2024 21:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587800;
	bh=yb030ubKD9mJbGQE//r285ACHyo31kfXg+lI+EcZOKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tlJnsZUDpPMjvKO25Fn7ctgHpvfAPQjwbLIhsiuN3LGrTDcO90dDWI1JNCPp4hpeT
	 XqSUG7S2URZHnR6Ot0PxYbr+Y9mvFrot+aqMpgiNdqVpDiGSFuFjiLSEARhkNV1P08
	 +P96w3u98tCUjVBkfLzL9aqV+Eol7ef1kGv/dDPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sid Pranjale <sidpranjale127@protonmail.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 071/162] drm/nouveau: keep DMA buffers required for suspend/resume
Date: Mon,  4 Mar 2024 21:22:16 +0000
Message-ID: <20240304211554.129164305@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

From: Sid Pranjale <sidpranjale127@protonmail.com>

[ Upstream commit f6ecfdad359a01c7fd8a3bcfde3ef0acdf107e6e ]

Nouveau deallocates a few buffers post GPU init which are required for GPU suspend/resume to function correctly.
This is likely not as big an issue on systems where the NVGPU is the only GPU, but on multi-GPU set ups it leads to a regression where the kernel module errors and results in a system-wide rendering freeze.

This commit addresses that regression by moving the two buffers required for suspend and resume to be deallocated at driver unload instead of post init.

Fixes: 042b5f83841fb ("drm/nouveau: fix several DMA buffer leaks")
Signed-off-by: Sid Pranjale <sidpranjale127@protonmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
index a41735ab60683..d66fc3570642b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -1054,8 +1054,6 @@ r535_gsp_postinit(struct nvkm_gsp *gsp)
 	/* Release the DMA buffers that were needed only for boot and init */
 	nvkm_gsp_mem_dtor(gsp, &gsp->boot.fw);
 	nvkm_gsp_mem_dtor(gsp, &gsp->libos);
-	nvkm_gsp_mem_dtor(gsp, &gsp->rmargs);
-	nvkm_gsp_mem_dtor(gsp, &gsp->wpr_meta);
 
 	return ret;
 }
@@ -2163,6 +2161,8 @@ r535_gsp_dtor(struct nvkm_gsp *gsp)
 
 	r535_gsp_dtor_fws(gsp);
 
+	nvkm_gsp_mem_dtor(gsp, &gsp->rmargs);
+	nvkm_gsp_mem_dtor(gsp, &gsp->wpr_meta);
 	nvkm_gsp_mem_dtor(gsp, &gsp->shm.mem);
 	nvkm_gsp_mem_dtor(gsp, &gsp->loginit);
 	nvkm_gsp_mem_dtor(gsp, &gsp->logintr);
-- 
2.43.0



