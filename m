Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC4A2820B1;
	Tue, 26 Aug 2025 11:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207864; cv=none; b=NnO4PyF/3hyoN7sQQcCbH04bSWxNEdhEDrzxG9GTp+Rc02pxX0YhcAz1KBHTqDmzsRrO+JwtmGyEc0aMuYk5djnolmV7FzGsL2VUSHGQhMi6nekHXOQ4RHsuOSiTcafQrjvi4NOID+WH9y6oKgrlRCVXPP3+H/To9jUsBScgBOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207864; c=relaxed/simple;
	bh=+MSoshW/AjdvTlwcYzkKmQFZpZzyw/pXPzZAQTE8lSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/Mg7nEmT/Ag9m4XV2XC3axZVd0xUSKuOYsmLTlPPl2tvnIHcV4xzE1lJKHPRLKfk7oO/oQv9sXOBr+gcX+trlrM9tv/GG/v6GlgdhqmN+uErzHxsdDu7Mei8o6fZqkBLKrKgk2FtOnpccyF4uAXDDxP/zdDvsdY4YMbUglJTDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fKBDP0OT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fKBDP0OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29233C4CEF1;
	Tue, 26 Aug 2025 11:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207864;
	bh=+MSoshW/AjdvTlwcYzkKmQFZpZzyw/pXPzZAQTE8lSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fKBDP0OTB8O9pUSGUZWMKGGvY6PNRTJOjrUp/qvvG+szvAO7Nf64amKE7v9OH9Uyn
	 7pZsmz+AJv/435vCWvBEo2F3V63f+zGNkwRDqsT9/eNmCwR3OCpVdHKj1W02Ui1VJq
	 71YRUjb5yxUnCClVajLhZCCcl4fsNLZk+xcH7o18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Fanhua Li <lifanhua5@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 345/457] drm/nouveau/nvif: Fix potential memory leak in nvif_vmm_ctor().
Date: Tue, 26 Aug 2025 13:10:29 +0200
Message-ID: <20250826110945.855831696@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fanhua Li <lifanhua5@huawei.com>

[ Upstream commit bb8aeaa3191b617c6faf8ae937252e059673b7ea ]

When the nvif_vmm_type is invalid, we will return error directly
without freeing the args in nvif_vmm_ctor(), which leading a memory
leak. Fix it by setting the ret -EINVAL and goto done.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/all/202312040659.4pJpMafN-lkp@intel.com/
Fixes: 6b252cf42281 ("drm/nouveau: nvkm/vmm: implement raw ops to manage uvmm")
Signed-off-by: Fanhua Li <lifanhua5@huawei.com>
Link: https://lore.kernel.org/r/20250728115027.50878-1-lifanhua5@huawei.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvif/vmm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvif/vmm.c b/drivers/gpu/drm/nouveau/nvif/vmm.c
index 99296f03371a..07c1ebc2a941 100644
--- a/drivers/gpu/drm/nouveau/nvif/vmm.c
+++ b/drivers/gpu/drm/nouveau/nvif/vmm.c
@@ -219,7 +219,8 @@ nvif_vmm_ctor(struct nvif_mmu *mmu, const char *name, s32 oclass,
 	case RAW: args->type = NVIF_VMM_V0_TYPE_RAW; break;
 	default:
 		WARN_ON(1);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto done;
 	}
 
 	memcpy(args->data, argv, argc);
-- 
2.50.1



