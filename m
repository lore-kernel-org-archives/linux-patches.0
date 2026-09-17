Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C004398F5;
	Thu, 17 Sep 2026 18:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671323; cv=none; b=gE/gntmeo8pcsi7QORegXMoU1vg0VR3aCVDxPmrrps5Tx/jW1aRp63BxKUB7i6coYtp+7jqlE0qbKGXeR5RlOZm9R8LUxuIi4S9n+ZVjmJRE+3iyWIqxHkFzAIwQznaSXmD2eFgzU62T2p2W4607oqTDC0RWls9sCuvavjaiKXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671323; c=relaxed/simple;
	bh=yPysgLz6FRsB08DZKf02mx2tAlk/hBIG/FhQ6hCRWmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhQTMVveBzQt249+K71PlkLv6dZe9HmI2TDVCGxsSvtINHobSzdK8hHF1WFpVHppQlE+lsSG4ptHcsD78zAVavwiB8RE89V22+O8YtrfXpsl9pkIurS/p8jNeVXZaN60u+2bsqnkGI4vuJd+LIcjiDiXwBXGrJrQ5HnHGBYgXuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nt0LWwyc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nt0LWwyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CB51F000FF;
	Thu, 17 Sep 2026 18:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671322;
	bh=s2MaMJMigmIYiQ1Q6h/dn4qyVUAppS2W5gTJI1EVsUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nt0LWwycDrLhNiyssXz8SHGtf0uq00egFNYoVqhU9zM9EmNEAta4/nwtPuZ+XuMXO
	 agoEIwJx0GyHItm9sumGQuYueLuK1sK+PQYwvhOzTnb+lI7CFqxGmX+ewPcnaL5T21
	 oLw6HlHSlqayihi5slMTSpAoA7xQSGnzo6DmNSBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0939/1102] Revert "slab: reset slab->obj_ext when freeing and it is OBJEXTS_ALLOC_FAIL"
Date: Thu, 17 Sep 2026 16:14:42 +0100
Message-ID: <20260917151604.218949329@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 13c6ff1d4662f28701f80120b15c32b6b3db4bd9.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9087fd9a83b72..e2634fe919f67 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2161,15 +2161,8 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 		return;
 
 	obj_exts = slab_obj_exts(slab);
-	if (!obj_exts) {
-		/*
-		 * If obj_exts allocation failed, slab->obj_exts is set to
-		 * OBJEXTS_ALLOC_FAIL. In this case, we end up here and should
-		 * clear the flag.
-		 */
-		slab->obj_exts = 0;
+	if (!obj_exts)
 		return;
-	}
 
 	for (i = 0; i < objects; i++) {
 		unsigned int off = obj_to_index(s, slab, p[i]);
-- 
2.53.0



