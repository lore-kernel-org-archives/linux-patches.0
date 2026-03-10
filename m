Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4810346E7A;
	Tue, 10 Mar 2026 11:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140769; cv=none; b=cn7b6mlBqAO4icibP4wI7XEAKaPr82e8VcGHPCwm8cPQyAaOneOwYIXkrcWbsS6am+mD7eesCSHVvhuGVCJljX6dOckeS11xIcnxDHYPA85qOFU8wkgh+isfomPo7b0ZOQvzAqkzdr22JtoK73LmdQNwMESdBQf0BJudkOe/8uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140769; c=relaxed/simple;
	bh=36VkCf1QQuJZWzdgeoq6GL+tcgS0EPmoXav0euEbhtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkFZONeeaMcjhkomT+W30V2lylw/yHmBt23HACn6HY9f8/8tBcpnhDYqfAthvZ2POA+0JmahSPEiyn7GnvLIIqNrL/fFicYvtx+JKkRYwXD8rxNs31xYLIsAIK/+VlV9hvUu9LsqWlwtjI1yhi4xDFNdcQsD2uHZqRz/IihvnLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dw1U0WR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dw1U0WR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF549C2BC86;
	Tue, 10 Mar 2026 11:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140769;
	bh=36VkCf1QQuJZWzdgeoq6GL+tcgS0EPmoXav0euEbhtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dw1U0WR8gKsziadd8DECfK2eIGp3rJuTn3NKSNmv5o9jkE5Su20NLMgaR6tfLxbmW
	 ObMxmgbAxLsDDY4uwUOedC5U5ovDzThH48SK/qIT3h8umPKcOMNZIzqbcQ+L7fY6Kg
	 VNmUDP+qU3oXJfsKQTYu7UxIkeXgkqVgbag5i4L5x4LuMa0rrLAoKxdafv79+K0TW9
	 QXx2NS/BbKWbnWqNWCcGDDgmI4JZaO0JkpBhsqrn+Gx1kKNUQ2Oxxt0NJpyspYVGmw
	 ScVH4cs0LGz+EYTpDk8yJQGaRHlXGWo3jcRJ/5RKsPns9XCpTYOH2sF6GEsJm8iSwP
	 8259D+/QjT3UA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brad Spengler <brad.spengler@opensrcsec.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 002/311] drm/vmwgfx: Fix invalid kref_put callback in vmw_bo_dirty_release
Date: Tue, 10 Mar 2026 07:00:49 -0400
Message-ID: <5e7945b0ea4bdd2225f00b508987d79d410e7d75.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

