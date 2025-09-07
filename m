Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94AC2D528;
	Sun,  7 Sep 2025 20:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276877; cv=none; b=eeotYDN4/h2+Ve0rmCcCpGyXTNs7Ivgez8pOFa3msK4ZfwUG86a19ctyBtGPNbUFEXuE8YIr+bwzRs5st7X5hxE52MdSbyM68G2Hi6AwPgJ1qbIyP9Rn9TGb/pgA7MST5l5KSaMxA8CYlXJ4GJR51DBO00oseNj2OOiI1PvElQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276877; c=relaxed/simple;
	bh=MnDdFVDundXDx2cLXcEkBSvv2rTPRysDp9oCtU3tZ94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pu8o19K2BbGr1Yaz3c35qvOg1FUI53+ohMTm1aCg2eQ3xpbqfeXgJtOa7t2fUgYuVJ/MeqUvmUtDhY/mwFBreaahNPwHCEGwxB++SV5uW/IF4NCYvQFuLAlgv2F7zgXue9AhNOD/gtWeauFj7d772p8DpKNjxtK+no1xRaBAvQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFkgIZXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFkgIZXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED60C4CEF0;
	Sun,  7 Sep 2025 20:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276877;
	bh=MnDdFVDundXDx2cLXcEkBSvv2rTPRysDp9oCtU3tZ94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DFkgIZXyvWTada3NlJ3AMKgmxcnnfEw+9GRbR5zuBd9lRvIfKsry860zXtCd2kMHH
	 HGUh0vbMx9FnBgVfi8oX8phhnY6ecKAlk+9R/92J9UxN5YmfeuhszDBLzdfwzRRrnc
	 9xklqpcprKs673B5sXSpmsqU2XDRqhy+Z8ZRIiyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/175] tee: fix memory leak in tee_dyn_shm_alloc_helper
Date: Sun,  7 Sep 2025 21:56:52 +0200
Message-ID: <20250907195615.295364766@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 50a74d0095cd23d2012133e208df45a298868870 ]

When shm_register() fails in tee_dyn_shm_alloc_helper(), the pre-allocated
pages array is not freed, resulting in a memory leak.

Fixes: cf4441503e20 ("tee: optee: Move pool_op helper functions")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/tee_shm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 915239b033f5f..2a7d253d9c554 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -230,7 +230,7 @@ int tee_dyn_shm_alloc_helper(struct tee_shm *shm, size_t size, size_t align,
 	pages = kcalloc(nr_pages, sizeof(*pages), GFP_KERNEL);
 	if (!pages) {
 		rc = -ENOMEM;
-		goto err;
+		goto err_pages;
 	}
 
 	for (i = 0; i < nr_pages; i++)
@@ -243,11 +243,13 @@ int tee_dyn_shm_alloc_helper(struct tee_shm *shm, size_t size, size_t align,
 		rc = shm_register(shm->ctx, shm, pages, nr_pages,
 				  (unsigned long)shm->kaddr);
 		if (rc)
-			goto err;
+			goto err_kfree;
 	}
 
 	return 0;
-err:
+err_kfree:
+	kfree(pages);
+err_pages:
 	free_pages_exact(shm->kaddr, shm->size);
 	shm->kaddr = NULL;
 	return rc;
-- 
2.50.1



