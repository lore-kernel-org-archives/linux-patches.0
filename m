Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D76731D72A;
	Mon, 27 Oct 2025 18:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591221; cv=none; b=Xgs1igK4g++/KYDwqcTafmKCpB7yQBgTEV/UbFsAWHI3BkYZ4MOCI1eTuc0FN3XFWYfqDJqN5yxpacPbzWqgKgbSBsFeEuFBvMNZTGFyqs8yKe5XT5jG7dd6i6tJ8ym9+Rz4h0gQBMlOBPKTHI9di3rRa9oT4pBzIeIFi3mCuMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591221; c=relaxed/simple;
	bh=GA2I6VCuALDTsYwuWA8lWVLAcYwaRJ8YnGtgQcE99oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tbg8Do0NvjJEMdavwD1CvmrYdW9kYPG05mnVVdyvUxN5E/LjLMvmsqcrphrt3p+jv0vTWTsPax8Nigz0SLtoOmoEHYTa+sLW1GdR8fL+i0PbV8/FpkI9ZaTDhtKsNexuRxuHNrYPmHlNZb2ZlbYjFbmnwveocY28wIi4kF3yvT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrdIejgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrdIejgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93FFC4CEF1;
	Mon, 27 Oct 2025 18:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591221;
	bh=GA2I6VCuALDTsYwuWA8lWVLAcYwaRJ8YnGtgQcE99oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrdIejgqEUL+mEPo5RAZO9WQOkk6/XFNVf2d8DKOw9UaohCYKZenxFlr8IXvnxRlK
	 eKabN6XflTvkL3V1Zbynie4mEviG0iDFWRwU7jklFD59UOFMgk189y1rXvG8pzC6d7
	 HWmpvKg8Nrl0Qz0Bkt24hoYVTstFaLzcbK9lS9xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuzey Arda Bulut <kuzeyardabulut@gmail.com>,
	Ian Forbes <ian.forbes@broadcom.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/332] drm/vmwgfx: Fix Use-after-free in validation
Date: Mon, 27 Oct 2025 19:32:44 +0100
Message-ID: <20251027183527.547561774@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit dfe1323ab3c8a4dd5625ebfdba44dc47df84512a ]

Nodes stored in the validation duplicates hashtable come from an arena
allocator that is cleared at the end of vmw_execbuf_process. All nodes
are expected to be cleared in vmw_validation_drop_ht but this node escaped
because its resource was destroyed prematurely.

Fixes: 64ad2abfe9a6 ("drm/vmwgfx: Adapt validation code for reference-free lookups")
Reported-by: Kuzey Arda Bulut <kuzeyardabulut@gmail.com>
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://lore.kernel.org/r/20250926195427.1405237-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_validation.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
index cc1cfc827bb9a..44bb3ccc31574 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_validation.c
@@ -342,8 +342,10 @@ int vmw_validation_add_resource(struct vmw_validation_context *ctx,
 		}
 	}
 	node->res = vmw_resource_reference_unless_doomed(res);
-	if (!node->res)
+	if (!node->res) {
+		hash_del_rcu(&node->hash.head);
 		return -ESRCH;
+	}
 
 	node->first_usage = 1;
 	if (!res->dev_priv->has_mob) {
-- 
2.51.0



