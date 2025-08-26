Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678852798ED;
	Tue, 26 Aug 2025 11:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208806; cv=none; b=pgAzHpMQy/AB64veCJLiU5OFQTncM1b3oedDP6wOYL+tbF1fiGXt1dkQQrOiYTnHj0F+lDlapSY3Nbm+7W2MBECRGOcmPs2LjLuVyqJJ1opcihlMTaeWeIDR1FFhVr3zJgDGTcslPRJsogvos0QZYxNfmfrJp6xjpczF7qMr6cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208806; c=relaxed/simple;
	bh=886EuZxj0veUgzYeHNGxYwlEJfJQL9dCaBeWzWsYnTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYv72cFty4aKzWLomA1Pl4KZrgm0V4q7iQHXaOklyo0cW9pxAWbKmXBOn/i/agwzdP0U1B5mMslCHwuOeHRAE5umwTbu2t7LYGuZye42P05eexI5nfFrpX8E3vogcQZPfhzOifzZ7n/x4G2F087C/xfnPbGIcvIshmpSCHsWQN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SrhwhPGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SrhwhPGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE039C113CF;
	Tue, 26 Aug 2025 11:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208806;
	bh=886EuZxj0veUgzYeHNGxYwlEJfJQL9dCaBeWzWsYnTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrhwhPGfGvu1G3AIn2G92lycNnHOGGpXEgLbbRYx0/hhsDk3OuSva1HlIZj6ztYyH
	 DMaSg/KJBE9Yx9MUtK1VauGUWBOr/QjsCU4oCjwn/9sXm39pd9KFwxhqx/gZwCctr2
	 E7rnt92DFB3zS3+U571vLk2waHYiLbk1lsNPbDog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Fanhua Li <lifanhua5@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 253/322] drm/nouveau/nvif: Fix potential memory leak in nvif_vmm_ctor().
Date: Tue, 26 Aug 2025 13:11:08 +0200
Message-ID: <20250826110922.180854556@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



