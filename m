Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F60737F007;
	Tue, 10 Mar 2026 11:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141637; cv=none; b=F6adUxNQevCV80o1ue/tPa2kDDBVtCnQI/PC9V4h7BY4XKr5frmCiVuM0XlRIuJwoYmCcgDDg8jkNaSsPqSgMOy11B8dqzhaODSwOUMz8pzrB1uhfIT4UdiVOFki6nVyTPFdIMnYFWbVZG9ehiK3fgOKW6EoRqdynXN3x3Rq0+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141637; c=relaxed/simple;
	bh=36VkCf1QQuJZWzdgeoq6GL+tcgS0EPmoXav0euEbhtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFhCJGBxAJpjRd4hcPSevgNLcvvgoL+Yo5bR0HjcNCRyam3mAQY/AiIBtRs47kI3rZ65wJo2K8eIJGDJ9dOuvsAaSDEAmq5an5YRpXH8gSq5UCp45ukDC0rVI+BNtNMtfaZ+eNehxZBtNN5iB6YECVEM/uUvJRpJZHGHL83+oJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKjNVEb/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKjNVEb/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0D3C2BC9E;
	Tue, 10 Mar 2026 11:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141637;
	bh=36VkCf1QQuJZWzdgeoq6GL+tcgS0EPmoXav0euEbhtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GKjNVEb/gEWKraQJ6hY4xuN4ZS5TIHSyxnPlCj6egYkI7P60khr8/4rH5dXmEghWw
	 /+AfCIOSqXm67/H7cySjWOyfU8hL5Q2fI6V2e8eKHLYqhW+Uxs84Ph0fYWktT8ctQA
	 PYUuIvK6PKK/wCGbVr43p5AX/hT57vvkE/tgsKCoiGOEqyZ8Mt3Mz+KxdiXDcJJI8U
	 OX23HmF9ufip9fYzZM7tkpswo8N5lFSGYmaak86n9o9Twt7eZObZcA0O2WxTu2Bhg5
	 L2R8B+DXGj5ySgJbGm44OJ3RVwjGA880QJmETK9D3hsVfW0ITSjrs7q/z2q9QlHcBq
	 OHg8FoHvU2E2w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brad Spengler <brad.spengler@opensrcsec.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 002/314] drm/vmwgfx: Fix invalid kref_put callback in vmw_bo_dirty_release
Date: Tue, 10 Mar 2026 07:14:21 -0400
Message-ID: <066afb100e3c46b7a04fe72f03ec4b741f5cb820.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Brad Spengler <brad.spengler@opensrcsec.com>

[ Upstream commit 211ecfaaef186ee5230a77d054cdec7fbfc6724a ]

The kref_put() call uses (void *)kvfree as the release callback, which
is incorrect. kref_put() expects a function with signature
void (*release)(struct kref *), but kvfree has signature
void (*)(const void *). Calling through an incompatible function pointer
is undefined behavior.

The code only worked by accident because ref_count is the first member
of vmw_bo_dirty, making the kref pointer equal to the struct pointer.

Fix this by adding a proper release callback that uses container_of()
to retrieve the containing structure before freeing.

Fixes: c1962742ffff ("drm/vmwgfx: Use kref in vmw_bo_dirty")
Signed-off-by: Brad Spengler <brad.spengler@opensrcsec.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Cc: Ian Forbes <ian.forbes@broadcom.com>
Link: https://patch.msgid.link/20260107171236.3573118-1-zack.rusin@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
index fd4e76486f2d1..45561bc1c9eff 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
@@ -260,6 +260,13 @@ int vmw_bo_dirty_add(struct vmw_bo *vbo)
 	return ret;
 }
 
+static void vmw_bo_dirty_free(struct kref *kref)
+{
+	struct vmw_bo_dirty *dirty = container_of(kref, struct vmw_bo_dirty, ref_count);
+
+	kvfree(dirty);
+}
+
 /**
  * vmw_bo_dirty_release - Release a dirty-tracking user from a buffer object
  * @vbo: The buffer object
@@ -274,7 +281,7 @@ void vmw_bo_dirty_release(struct vmw_bo *vbo)
 {
 	struct vmw_bo_dirty *dirty = vbo->dirty;
 
-	if (dirty && kref_put(&dirty->ref_count, (void *)kvfree))
+	if (dirty && kref_put(&dirty->ref_count, vmw_bo_dirty_free))
 		vbo->dirty = NULL;
 }
 
-- 
2.51.0

