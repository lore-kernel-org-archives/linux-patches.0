Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 758C232AABE;
	Sat, 28 Feb 2026 17:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301283; cv=none; b=UpZbw4TwHxvynFGoPs5blFb98/fTa9iVPRl6pGwdjY1epOjnYePfOxSg3R4c5OGxAJNZRSCfmcnVn+lMSXYcSeN/RegD1ouRzP2vL/HjRMI2Tnoa7G9jjVy66QvjHDwLbRWMJnQZHGUmOkvRDIo2mpn0JjNaGG+pDBYP9F461Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301283; c=relaxed/simple;
	bh=felfZVWaTMWH2Djom74FA5Dp7sfnSOwZg8jUAQkEqq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OeNUJf7nJ9qhICR5UyA9Iv6e+bVkdWfoDJoxxoUifT96kRfRC1BS2InISpYEGYUfn5xjmtKQwz2xboukjmpZzQiZUtGPg4R1FbjGe/BSiqkQl8rPuBSnURqj97kmL5XyAnrnrbeFLFB0tt63Vr45VyAaTSdrIwIY7aBrg5LAkAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hhBzj6h1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hhBzj6h1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B140EC116D0;
	Sat, 28 Feb 2026 17:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301283;
	bh=felfZVWaTMWH2Djom74FA5Dp7sfnSOwZg8jUAQkEqq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhBzj6h1UIzEfRRi+qfS/E4zQDZDJuxzgg0ra5WZZv5QlDgt9fOyvZHrvcJdVy5NJ
	 WjKfSXnnUBoYu238MBP6WiUxSY/P0c4vbUQwKJDYbk7asMpd+Ls3zqJmckKA/IK3br
	 7bpfEgYDD+Dmlur4CkbENHxIw2f7Zir8gLxoGztkNNqMT7z09oItasByiIlCjl9d70
	 WZVwIB6Xx8zeXE+CjgzsMh7ANZFL1/a50Ff5DuLiXiLKh+tZG4++z4npA3AUXQkbgR
	 83n0Vhy+0B9dfS9/6OuCWjORqaFOUh2ssd+Q1sqxUF5oOr5mSyhs85cbmuVSpsVnjy
	 h2lWGR8hs+bFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Zimmermann <tzimmermann@suse.de>,
	dri-devel@lists.freedesktop.org,
	stable@vger.kernel.org,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 467/752] drm/tests: shmem: Add clean-up action to unpin pages
Date: Sat, 28 Feb 2026 12:42:58 -0500
Message-ID: <20260228174750.1542406-467-sashal@kernel.org>
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

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit b47b9ecef309459278eb52f02b50eefdeaac4f6d ]

Automatically unpin pages on cleanup. The test currently fails with
the error

[   58.246263] drm-kunit-mock-device drm_gem_shmem_test_get_sg_table.drm-kunit-mock-device: [drm] drm_WARN_ON(refcount_read(&shmem->pages_pin_count))

while cleaning up the GEM object. The pin count has to be zero at this
point.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: d586b535f144 ("drm/shmem-helper: Add and use pages_pin_count")
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.16+
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20251212160317.287409-3-tzimmermann@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_gem_shmem_test.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/tests/drm_gem_shmem_test.c b/drivers/gpu/drm/tests/drm_gem_shmem_test.c
index 872881ec9c30d..1d50bab51ef3f 100644
--- a/drivers/gpu/drm/tests/drm_gem_shmem_test.c
+++ b/drivers/gpu/drm/tests/drm_gem_shmem_test.c
@@ -34,6 +34,9 @@ KUNIT_DEFINE_ACTION_WRAPPER(sg_free_table_wrapper, sg_free_table,
 KUNIT_DEFINE_ACTION_WRAPPER(drm_gem_shmem_free_wrapper, drm_gem_shmem_free,
 			    struct drm_gem_shmem_object *);
 
+KUNIT_DEFINE_ACTION_WRAPPER(drm_gem_shmem_unpin_wrapper, drm_gem_shmem_unpin,
+			    struct drm_gem_shmem_object *);
+
 /*
  * Test creating a shmem GEM object backed by shmem buffer. The test
  * case succeeds if the GEM object is successfully allocated with the
@@ -212,6 +215,9 @@ static void drm_gem_shmem_test_get_sg_table(struct kunit *test)
 	ret = drm_gem_shmem_pin(shmem);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
+	ret = kunit_add_action_or_reset(test, drm_gem_shmem_unpin_wrapper, shmem);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
 	sgt = drm_gem_shmem_get_sg_table(shmem);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sgt);
 	KUNIT_EXPECT_NULL(test, shmem->sgt);
-- 
2.51.0

