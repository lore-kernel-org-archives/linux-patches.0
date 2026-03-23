Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700583AEF53;
	Mon, 23 Mar 2026 14:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275115; cv=none; b=C6Y/VqFcyXRwSXxheZQdAcRmXQAt+xAV0o0F/IS5aniQSMZAeY5kRxW3d2deQdMj7zOrzMPhX6bEb8T0GpyB0pu+Vrma/HigD7dVp6OdqID5bz1EeKiddjscIMG9uodZ7Xiftq+khHYTfh1pi83stiW5qxHMVIL4fWj3oyPHSnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275115; c=relaxed/simple;
	bh=ZVHDlUimiVi9FS0Cx7NA763o2qOOHd2vl1ZFGOSUmHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayAztq/cl9/4BU/BTIZBAZimHNvHVlbY5eTjD5W9KUZBdKCZvTAkMDJbA6q8RTFvT+rSh9kxmEfPa8q7eyexzx/k0Z36JIwI8i5fx4ntW0Vo6rOSxSkOIzRQ11vJQt8CD2dxLeht2X+i+T4u68Aw92c6GYofrj4IVYApOzUvypQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yR7wpcR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yR7wpcR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0030DC2BC9E;
	Mon, 23 Mar 2026 14:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275115;
	bh=ZVHDlUimiVi9FS0Cx7NA763o2qOOHd2vl1ZFGOSUmHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yR7wpcR71Edn0VJficUzIGiWPsSEQEIyi04u3PYshZos48gAAHqaPJiVspCEtl3Xd
	 da+FGOksx25tRaqNB61jhlIBhjD8N0Yp9FMjCi8ZFdHCu6WPF1RzlqkXxj4+4cJBeY
	 eQzNgse8bKmCCpB2zsVT7+EYhTYdmziIDP1NFXQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brad Spengler <brad.spengler@opensrcsec.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/481] drm/vmwgfx: Fix invalid kref_put callback in vmw_bo_dirty_release
Date: Mon, 23 Mar 2026 14:39:43 +0100
Message-ID: <20260323134525.295337643@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 09e938498442c..84d1d05346185 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c
@@ -274,6 +274,13 @@ int vmw_bo_dirty_add(struct vmw_buffer_object *vbo)
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
@@ -288,7 +295,7 @@ void vmw_bo_dirty_release(struct vmw_buffer_object *vbo)
 {
 	struct vmw_bo_dirty *dirty = vbo->dirty;
 
-	if (dirty && kref_put(&dirty->ref_count, (void *)kvfree))
+	if (dirty && kref_put(&dirty->ref_count, vmw_bo_dirty_free))
 		vbo->dirty = NULL;
 }
 
-- 
2.51.0



