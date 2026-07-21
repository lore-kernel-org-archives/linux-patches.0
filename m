Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74CE1F3D56;
	Tue, 21 Jul 2026 17:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653820; cv=none; b=MG9yJLht8HhSYb37vaR+tAoDziA1Q08FzTNtLRTmHG3NaJmITr24v0AceqjNm+l0Nl/g1U58Kle/1NlHaM+NvAcJdrwn1TXBZvW6UEIqEra7sfO+aDMbZOTTrpmfRBQaqZsmr9Tg779nFHMAlf2QrkVW2kcqlCCIsvGzFhD6kCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653820; c=relaxed/simple;
	bh=g262EpQLT20so0wD7YQHmoa7laPgLBsD9Anku2B1KI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elCgvePlsl2YYWk4JGh/1lAYm4G5w9wldyfXcSquxNLb8yLH3rzRT2ZJE1DDNVQeQL3mXAs6gewyIc8sp59QMPhAETWEJ5SL/989+JgB2hY8zKd/fSYkweoBXuWyNciMEj8ZFAMtmv0UajuYaM/ot85zyme6D7rv0/Y7Js7D9yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvcDZjk1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvcDZjk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30CD1F000E9;
	Tue, 21 Jul 2026 17:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653819;
	bh=vsjkpbGY0NFY919mFCmHqBIC3D7X1mh8DHrt+kMB3HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nvcDZjk1OMU5jwKXFLcCtgMKIXtJEx/s4LuukPI6/ODXL4Ne4xwi8oNjNzbMHRV10
	 3fFv/1ItkMog8RCl28yV5uUqDz0HwZUs7C4tdE7q5Ee/wNHrkVYfBRTY/z3yhhA/dx
	 2+7X+f3Sb0yC8a4W+kqK59Czw/r8w2lIqfu3HqTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Zhen <max.zhen@amd.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1469/2077] accel/amdxdna: Use unsigned long for nr_pages in amdxdna_hmm_register()
Date: Tue, 21 Jul 2026 17:19:02 +0200
Message-ID: <20260721152627.442800749@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 18aaebdf43366954345a6721ed2bff3ac3c9fa61 ]

nr_pages is declared as u32 in amdxdna_hmm_register(), which may not be
large enough to represent the number of pages for large mappings.

Use unsigned long for nr_pages to avoid potential overflow.

Fixes: ac49797c1815 ("accel/amdxdna: Add GEM buffer object management")
Reviewed-by: Max Zhen <max.zhen@amd.com>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260616061532.3533469-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_gem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index 6e367ddb9e1bec..2ac12b49a70035 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -291,7 +291,7 @@ static int amdxdna_hmm_register(struct amdxdna_gem_obj *abo,
 	unsigned long len = vma->vm_end - vma->vm_start;
 	unsigned long addr = vma->vm_start;
 	struct amdxdna_umap *mapp;
-	u32 nr_pages;
+	unsigned long nr_pages;
 	int ret;
 
 	if (!xdna->dev_info->ops->hmm_invalidate)
-- 
2.53.0



