Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2B72F531B;
	Sat, 12 Sep 2026 12:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215316; cv=none; b=i4MCLo9UBYY/ILuP/EnnrT/DegrlHKAyeh/iU+NV2MFFakQPZ3CX0mdsaBzjSUNAXE8J4LZIvjqQflig+HVE02IlgvNS/JzWjwcq1hEwpKD6VAOpZ9i9dPO4zzvP2FIakHYmu9eGiZ2c4mQjn4XL388REzUuBvVH4PPZoMJCTlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215316; c=relaxed/simple;
	bh=KJKmsXuP+YBU1Z9lwXvpa0YzCxA7Ux1xcSK1AGqSJ6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HowEZpNjPDjOR1K6MJy/9T2LuBmqkAivkEP1NOJn9OXtjPFTrCMYv8+GSXnO/UyrxSY71x1kxk7OO1Hu01gFjMHEEqJ366F6hCsx2doEfq/TpK1fB1xvdNQbrmrKvN7LsUA8I3jUS8UaFFEFyDRmAZqLyIa0skHZTttj/qWVMgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZaRc7Sr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZaRc7Sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A033E1F000FF;
	Sat, 12 Sep 2026 12:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215313;
	bh=cOWRl8PPF+U8UpqKB+4jfWVgTy5+26LjD+v6JnslN/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZaRc7Srqi8o6FsV9dlBl0KJl6B+2XOOKzYTSRaNbQ107hvIkQn0j+uiRu+/9u3+M
	 sfhHH0LdWz8jrdhWi06AtbUHJYoZGYix7nreCIIK1Pxi5F4OQ/y3EK/YpzksjABYo/
	 q6ArhJdlnYNXp4GUQDr/kWi7TBcDbTYQsP0nqV3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Atish Patra <atishp@meta.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0505/1376] crypto: ccp - Fix memory leak in SEV INIT_EX path
Date: Sat, 12 Sep 2026 08:48:51 +0200
Message-ID: <20260912065618.794261152@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Atish Patra <atishp@meta.com>

[ Upstream commit c8e53ada20d352b0f1bdc3e58405a9edab897a2e ]

allocated pages in _init_ext_path are never freed and sev_init_ex_buffer
is left pointing at the leaked memory in case of any failures during the
function..

Fix by adding an error path that frees the pages and clears
sev_init_ex_buffer. Make sure we only free the memory if the failure
happens before the conversion. Otherwise, we may end up trying to free
up converted pages in case of reclaim failure. rmp_mark_pages_firmware
failures should be rare enough to avoid more code complexity to track
down which pages were reclaimed/leaked vs which are not.

Fixes: 7364a6fbca45 ("crypto: ccp: Handle non-volatile INIT_EX data when SNP is enabled")

Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Atish Patra <atishp@meta.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d6a0773d6da8f..6dc380537ece9 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1244,7 +1244,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 	if (sev_init_ex_buffer)
 		return 0;
 
-	page = alloc_pages(GFP_KERNEL, get_order(NV_LENGTH));
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, get_order(NV_LENGTH));
 	if (!page) {
 		dev_err(sev->dev, "SEV: INIT_EX NV memory allocation failed\n");
 		return -ENOMEM;
@@ -1254,7 +1254,7 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 
 	rc = sev_read_init_ex_file();
 	if (rc)
-		return rc;
+		goto err_free;
 
 	/* If SEV-SNP is initialized, transition to firmware page. */
 	if (sev->snp_initialized) {
@@ -1263,11 +1263,22 @@ static int __sev_platform_init_handle_init_ex_path(struct sev_device *sev)
 		npages = 1UL << get_order(NV_LENGTH);
 		if (rmp_mark_pages_firmware(__pa(sev_init_ex_buffer), npages, false)) {
 			dev_err(sev->dev, "SEV: INIT_EX NV memory page state change failed.\n");
-			return -ENOMEM;
+			rc = -ENOMEM;
+			/*
+			 * Pages can be in an inconsistent state, don't release them back to the
+			 * system.
+			 */
+			goto err_reset;
 		}
 	}
 
 	return 0;
+
+err_free:
+	__free_pages(page, get_order(NV_LENGTH));
+err_reset:
+	sev_init_ex_buffer = NULL;
+	return rc;
 }
 
 static int __sev_platform_init_locked(int *error)
-- 
2.53.0



