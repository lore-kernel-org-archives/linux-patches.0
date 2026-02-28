Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8E8355049
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301031; cv=none; b=TXjYECY63vvKt46HyfdB6iFQzod0DHjssnK6IOQsTabUtQtrNKFUN6TAPw+3nQAeb/HXWTt6EeGiUYFzWSPKDrZWcHcgvqu0D1shKd5LXyMVgfrGYpFh/EUbIf3Xd18YJ9yFatpkXqfvSLV+vNeeTHZ+zWHqyY3it4RDU/VChgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301031; c=relaxed/simple;
	bh=T9FGvJhnf/Nzrx56iXUJ+P2/8aqv2CDO+boMUZgDRfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TklOMi/5f3RwW7usrQiMyVzwWOGj/20VYBSoc/DRYWibUEjC3Yo1wun2YR7cVQ5/LDs//kHiAYARjMC7z5A3q1TqeFQfyNExsT0/hkyRH3gaLqFmD31T2DijcZ9Wny5cRNC3hh/xh3q35VIjIPcST4CcDzkUDiw/KasfDs5M1+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=efYMmLor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="efYMmLor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08A58C19423;
	Sat, 28 Feb 2026 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301031;
	bh=T9FGvJhnf/Nzrx56iXUJ+P2/8aqv2CDO+boMUZgDRfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efYMmLorXpq50ZYEQx7hBcPCgCCBtWzXTPsyBlSLZAT6mVypZaXCG3wg1LO2H+6Ot
	 glOupue9QBey10OJR1HpeyG5VioxyhjGk0BdEIqbkZW1qpjcPc5/W20Cuajf9p8PKq
	 L08O6C6vSfb3UYiGzBqmbljqXKfT3h6p3MNEBtbWqed0Euz+V9RsUrS+JAP7OKV/oB
	 8jfha6nr30A4cXmPjUFQ4sGGACjjyJOnhU4nyYdtkfGaKP23kRo8wuk/hcQhzzckHm
	 IZ/CTXIoi8TZxExx6ZGDJWHYRxUj7BuAaJzl8QVoGqGT4PhWhj7uu2gIj6u4osE0H6
	 4lkerwKrsWNZA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Xiao Kan <814091656@qq.com>,
	Xiao Kan <xiao.kan@samsung.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/752] drm: Account property blob allocations to memcg
Date: Sat, 28 Feb 2026 12:38:00 -0500
Message-ID: <20260228174750.1542406-169-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Xiao Kan <814091656@qq.com>

[ Upstream commit 26b4309a3ab82a0697751cde52eb336c29c19035 ]

DRM_IOCTL_MODE_CREATEPROPBLOB allows userspace to allocate arbitrary-sized
property blobs backed by kernel memory.

Currently, the blob data allocation is not accounted to the allocating
process's memory cgroup, allowing unprivileged users to trigger unbounded
kernel memory consumption and potentially cause system-wide OOM.

Mark the property blob data allocation with GFP_KERNEL_ACCOUNT so that the memory
is properly charged to the caller's memcg. This ensures existing cgroup
memory limits apply and prevents uncontrolled kernel memory growth without
introducing additional policy or per-file limits.

Signed-off-by: Xiao Kan <814091656@qq.com>
Signed-off-by: Xiao Kan <xiao.kan@samsung.com>
Link: https://patch.msgid.link/tencent_D12AA2DEDE6F359E1AF59405242FB7A5FD05@qq.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_property.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_property.c b/drivers/gpu/drm/drm_property.c
index 596272149a359..3c88b5fbdf28c 100644
--- a/drivers/gpu/drm/drm_property.c
+++ b/drivers/gpu/drm/drm_property.c
@@ -562,7 +562,7 @@ drm_property_create_blob(struct drm_device *dev, size_t length,
 	if (!length || length > INT_MAX - sizeof(struct drm_property_blob))
 		return ERR_PTR(-EINVAL);
 
-	blob = kvzalloc(sizeof(struct drm_property_blob)+length, GFP_KERNEL);
+	blob = kvzalloc(sizeof(struct drm_property_blob) + length, GFP_KERNEL_ACCOUNT);
 	if (!blob)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.0

