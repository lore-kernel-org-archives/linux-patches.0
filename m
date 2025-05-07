Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B2F29A0;
	Wed,  7 May 2025 19:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644611; cv=none; b=V3QP4Bn8QAve1H4VlMnglqL9CNPJKiKLk5U2OSOsWujtRT+Jrm6JXgyZ28tnVjcf48Rt//Od8kdSk+2bHK0EbcIsv4WxB4sPK8QH8x3oT1ciQdWO6lPV/RU3qXIY0OVqGCooOV1gFHtuBTGR955IDnqESgzbun2o1VJg/lPu5Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644611; c=relaxed/simple;
	bh=gAHXktefNIQcMNo2bz0K4MY4e2kYEFU2Qm2LtzaOGF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GK59JovgV30RpYbHe+Sx4NuUqJJeb+e0IkrWDTd8iu4k+lMh44wkQmnP+Fb4odtjDeeBME93gjDVf1bgO4M8z2J/McmtETgxyu0s2H8ifYelDAxUxPiYGk9N0lIvnhHqadQBpAa6GauMR9+Spz+YJpRKIhV5C5CJknvYjf9PTvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqCJ3AFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqCJ3AFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A20C4CEE2;
	Wed,  7 May 2025 19:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644611;
	bh=gAHXktefNIQcMNo2bz0K4MY4e2kYEFU2Qm2LtzaOGF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqCJ3AFStdFZ7zDbX7f6Vmev1j5aovATQsQy1129qN+K+xAZH6JEtPYCnKf45hLxn
	 zkoYx5/BD8PjMYUGYFf3NPXPEoua4FwrI9NEvAyTnp9N4MYMxpaFkco/6ZiJnOKTz3
	 N3zrKc0M3wMTWBQsW4yl1hTWjib1Izgqtw6lku0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@mailbox.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 100/164] drm/tests: shmem: Fix memleak
Date: Wed,  7 May 2025 20:39:45 +0200
Message-ID: <20250507183825.024251666@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit 48ccf21fa8dc595c8aa4f1d347b593dcae0727d0 ]

The drm_gem_shmem_test_get_pages_sgt() gets a scatter-gather table using
the drm_gem_shmem_get_sg_table() function and rightfully calls
sg_free_table() on it. However, it's also supposed to kfree() the
returned sg_table, but doesn't.

This leads to a memory leak, reported by kmemleak. Fix it by adding a
kunit action to kfree the sgt when the test ends.

Reported-by: Philipp Stanner <phasta@mailbox.org>
Closes: https://lore.kernel.org/dri-devel/a7655158a6367ac46194d57f4b7433ef0772a73e.camel@mailbox.org/
Fixes: 93032ae634d4 ("drm/test: add a test suite for GEM objects backed by shmem")
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://lore.kernel.org/r/20250408140758.1831333-1-mripard@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_gem_shmem_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/tests/drm_gem_shmem_test.c b/drivers/gpu/drm/tests/drm_gem_shmem_test.c
index fd4215e2f982d..925fbc2cda700 100644
--- a/drivers/gpu/drm/tests/drm_gem_shmem_test.c
+++ b/drivers/gpu/drm/tests/drm_gem_shmem_test.c
@@ -216,6 +216,9 @@ static void drm_gem_shmem_test_get_pages_sgt(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, sgt);
 	KUNIT_EXPECT_NULL(test, shmem->sgt);
 
+	ret = kunit_add_action_or_reset(test, kfree_wrapper, sgt);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
 	ret = kunit_add_action_or_reset(test, sg_free_table_wrapper, sgt);
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
-- 
2.39.5



