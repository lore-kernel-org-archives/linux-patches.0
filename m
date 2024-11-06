Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF1E1CC14B;
	Wed,  6 Nov 2024 13:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898885; cv=none; b=t/3aZ5j2IJxDV96+Vit1gmaPUMKThrQvBBCFkklC+koO2wfHHB/sF03A492faVvRVkgKZoh78Bb1W324KcD/ASNBPzxngLegsvZQ4EAJkmBlHzNxIocWChLn/vdt30vnPx+agS/leQhlXoJGoNqElgyidwDRF7MLeo7yIUT3F7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898885; c=relaxed/simple;
	bh=Vl1bEQc0RVarfuJRgxLWWwowsadGTztwiGzW04BtfoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQDzOT3uejzFfE7IBilS3Z2CXiMTc5l7Kt+9VvASFWjnlzz7vgzvi4vcKS//LVrZTcXXHjz/lhU+H8jFMJowpN0pNYcjFvwMAXw+O1s7RXM5MILbD+u9m39BZSd+7d3V41Vj7q1ymNbysuYY5VOV3vBXD/vO6yg3BRkfYAUT1A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yiNtXIgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yiNtXIgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AE0C4CECD;
	Wed,  6 Nov 2024 13:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898885;
	bh=Vl1bEQc0RVarfuJRgxLWWwowsadGTztwiGzW04BtfoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiNtXIguHisa1ZMRxhGu38sQd+zgxaubyOk5/xO4qUwAvMwBkU1oI/PgEKyGiWcDP
	 HK1OYAXeYzEd8JbmQvKDvnGE5wKZEjcaryN6U14rkxf6aGTdTIIC6DwomFiVyvl3Qv
	 FuiCj6nxI1MS6BxqOi17fcRn4vZ+tjVNYqktvGl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonatan Maman <Ymaman@Nvidia.com>,
	Gal Shalom <GalShalom@Nvidia.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.4 351/462] nouveau/dmem: Fix vulnerability in migrate_to_ram upon copy error
Date: Wed,  6 Nov 2024 13:04:04 +0100
Message-ID: <20241106120340.199486455@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

From: Yonatan Maman <Ymaman@Nvidia.com>

commit 835745a377a4519decd1a36d6b926e369b3033e2 upstream.

The `nouveau_dmem_copy_one` function ensures that the copy push command is
sent to the device firmware but does not track whether it was executed
successfully.

In the case of a copy error (e.g., firmware or hardware failure), the
copy push command will be sent via the firmware channel, and
`nouveau_dmem_copy_one` will likely report success, leading to the
`migrate_to_ram` function returning a dirty HIGH_USER page to the user.

This can result in a security vulnerability, as a HIGH_USER page that may
contain sensitive or corrupted data could be returned to the user.

To prevent this vulnerability, we allocate a zero page. Thus, in case of
an error, a non-dirty (zero) page will be returned to the user.

Fixes: 5be73b690875 ("drm/nouveau/dmem: device memory helpers for SVM")
Signed-off-by: Yonatan Maman <Ymaman@Nvidia.com>
Co-developed-by: Gal Shalom <GalShalom@Nvidia.com>
Signed-off-by: Gal Shalom <GalShalom@Nvidia.com>
Reviewed-by: Ben Skeggs <bskeggs@nvidia.com>
Cc: stable@vger.kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241008115943.990286-3-ymaman@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_dmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -139,7 +139,7 @@ static vm_fault_t nouveau_dmem_fault_cop
 	if (!spage || !(args->src[0] & MIGRATE_PFN_MIGRATE))
 		return 0;
 
-	dpage = alloc_page_vma(GFP_HIGHUSER, vmf->vma, vmf->address);
+	dpage = alloc_page_vma(GFP_HIGHUSER | __GFP_ZERO, vmf->vma, vmf->address);
 	if (!dpage)
 		return VM_FAULT_SIGBUS;
 	lock_page(dpage);


