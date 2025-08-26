Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A8AFBF0;
	Tue, 26 Aug 2025 13:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214055; cv=none; b=rswPBlAq6HJuSdzEqbgAY8k9IeYVol4LtGD5R7o5BawzNtKgI9RhoSm6X6s6tcTvqw3Yr5qjtHfOgGeODnQVdAB9Bs/yXUH8TtzRB3rJ8tEjX6cUi7abeWD49TKSBIvZ1+2CzUxo45aj1FTEQakOczqEJrvWJC+n2RYcxT0wn8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214055; c=relaxed/simple;
	bh=GGXd1+av8+S2acf8qIznnCCquUWHxULXrWQEPs13dgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2UFNkaFICRsq6DfHH8v1LuhUSRaYm3BiU3qXhGuPFVqMK5imtcK4kD//Dm4dE6JMADSLPSIZZJzACpVOWv3FhppfBL/KX4QR1RUyQWpHu3nVzHq3JAjw05MGc7JrAliQTWjFWYMvfXysqA7Th+ttY8C8EnX0+JyY3Ias+8tNoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BU0fj9Q3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BU0fj9Q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C69C4CEF1;
	Tue, 26 Aug 2025 13:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214055;
	bh=GGXd1+av8+S2acf8qIznnCCquUWHxULXrWQEPs13dgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BU0fj9Q3i+64fula+85qvvdP4jxxNsdpDUWzghL+OS5+K/UnKqg7B0Bq7ONIyTv5/
	 YBzTb1X0pmFGhre8nhZcQPE7iYpTv06XQvRJhTrCw+GLC3+JsZUZ3fAdL2Kb1mZ5Cy
	 vn5O4tOY9axjPdFgJPUTYzMVYseSQvaSseau4K+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Fanhua Li <lifanhua5@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 549/587] drm/nouveau/nvif: Fix potential memory leak in nvif_vmm_ctor().
Date: Tue, 26 Aug 2025 13:11:38 +0200
Message-ID: <20250826111006.985818396@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



