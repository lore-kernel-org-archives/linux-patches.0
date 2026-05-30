Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583B0352027;
	Sat, 30 May 2026 17:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163885; cv=none; b=F30WKEXGnBFPw+DHVsFEH7ycnc/GIpe0NRWPuQmLdXYfdgMRqNFW7Ri8qP2j2piXZFwV/wbxe+DvxbmGOwvD5RVtMwugtfh17VUowRh+3kFNfYkof6DoXW2zc56VZupn7sj0PeRgD72UerIB91U6iQj1Q/NxhvxK0fZkGqoeUg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163885; c=relaxed/simple;
	bh=DCDrH4FO7BnQf3tmKhi7rGqA2Viej1/8OXq3am4jrbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsv0Jm+Hmv8GgW/2tCTOjFmcnhrAvjqZ+8mxWNf4U0cMspGSEaa8oiacRd+pHzJHO37IG3Jt5EhQG2yMi3z90EVulfCX9Qw7HFqWCBbbBYNg5Wii6yonx1oN+oJr7iF1WBFSMcp2AH07B0oFiUzwaMo0eLsYXex+ApeO9UxovEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRsLzh3k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRsLzh3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108621F00893;
	Sat, 30 May 2026 17:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163881;
	bh=auDS5JC4vZEULDurI6Paz6xgGNYxJ6p7sURHMttEkiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oRsLzh3kM/Ar73igDu1oaF8Da3yWoybplJvGcnVnE/fFApXeofsO3QSdlxKgEzThM
	 To0m66CiATX8Vg1ucpeOHIzRoeiXqjLz/Uczz2OVg8zTwyPEIwxaQ94oKSWmPUmpmw
	 CKjtQVD8dmX2DhiufB/NeZwpbs9mM/f+ndxYGJDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 389/776] devres: fix missing node debug info in devm_krealloc()
Date: Sat, 30 May 2026 18:01:43 +0200
Message-ID: <20260530160250.552630667@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit f813ec9e84b4d0ca81ec1da94ab07bfb4a29266c ]

Fix missing call to set_node_dbginfo() for new devres nodes created by
devm_krealloc().

Fixes: f82485722e5d ("devres: provide devm_krealloc()")
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/20260202235210.55176-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/devres.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 58e8e2be26ac7..6e4b43c5c3075 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -907,6 +907,8 @@ void *devm_krealloc(struct device *dev, void *ptr, size_t new_size, gfp_t gfp)
 	if (!new_dr)
 		return NULL;
 
+	set_node_dbginfo(&new_dr->node, "devm_krealloc_release", new_size);
+
 	/*
 	 * The spinlock protects the linked list against concurrent
 	 * modifications but not the resource itself.
-- 
2.53.0



