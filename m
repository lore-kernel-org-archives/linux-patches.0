Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC332D8778;
	Tue, 15 Jul 2025 13:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587334; cv=none; b=GHcePk52lojxW8GSUdGq17FVNrpIt8qS3Li7ln+fxSuXZCvoQP/xFUZ0+Id3zDxe0MJwU5NG6e/oXnAvW5bqhAFtv8xI0RptsoR8Mg7tBa559quAjANFYszlv2tY7B190ptT6xnCv8Ch7Irlx3FtTfojdwXx+oVPeSuHU85AJGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587334; c=relaxed/simple;
	bh=q3+uLxMtplaBEroW9NHP2qjSkdu9H7HGBPcPW7kNVLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebxD64/gjEnr1n0NTude4pMFkjp/sa8u3AmDiY0TnmVdZt9U68DjKcc4MbCxbwOIQrgC3INgSOFu5MjA/rI+m0//13sxo1ZCOqIpnfH00NGjLKqltminCjgkDlrXQ06S5zcawa4GWYw5Cvnyeb7Ela1tJTHb5weSz2WHKw4kSIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XgMKsgIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XgMKsgIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FEEC4CEE3;
	Tue, 15 Jul 2025 13:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587334;
	bh=q3+uLxMtplaBEroW9NHP2qjSkdu9H7HGBPcPW7kNVLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XgMKsgIso5T64fFnuDih3gjCvomIs6SDWWcFZ3tmvkpbWYp83MoHLINjTCleA6ACq
	 AatqLRnN8UVtPHeb+/2zCqQIAsJ80or+YOS2bWybXJuaUJ4/MSlQaOkbaU4R9QFC7K
	 Ghj6BKP73Bs2K6+L3hdH3YH75zF9glJ9EVpJ708s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yue Hu <huyue2@coolpad.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 61/88] erofs: allocate extra bvec pages directly instead of retrying
Date: Tue, 15 Jul 2025 15:14:37 +0200
Message-ID: <20250715130757.016541663@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 05b63d2beb8b0f752d1f5cdd051c8bdbf532cedd ]

If non-bootstrap bvecs cannot be kept in place (very rarely), an extra
short-lived page is allocated.

Let's just allocate it immediately rather than do unnecessary -EAGAIN
return first and retry as a cleanup.  Also it's unnecessary to use
__GFP_NOFAIL here since we could gracefully fail out this case instead.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Link: https://lore.kernel.org/r/20230526201459.128169-2-hsiangkao@linux.alibaba.com
Stable-dep-of: 99f7619a77a0 ("erofs: fix to add missing tracepoint in erofs_read_folio()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 50dd104dbaabf..ff82610eb14c9 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -238,12 +238,17 @@ static int z_erofs_bvec_enqueue(struct z_erofs_bvec_iter *iter,
 				struct z_erofs_bvec *bvec,
 				struct page **candidate_bvpage)
 {
-	if (iter->cur == iter->nr) {
-		if (!*candidate_bvpage)
-			return -EAGAIN;
-
+	if (iter->cur >= iter->nr) {
+		struct page *nextpage = *candidate_bvpage;
+
+		if (!nextpage) {
+			nextpage = alloc_page(GFP_NOFS);
+			if (!nextpage)
+				return -ENOMEM;
+			set_page_private(nextpage, Z_EROFS_SHORTLIVED_PAGE);
+		}
 		DBG_BUGON(iter->bvset->nextpage);
-		iter->bvset->nextpage = *candidate_bvpage;
+		iter->bvset->nextpage = nextpage;
 		z_erofs_bvset_flip(iter);
 
 		iter->bvset->nextpage = NULL;
@@ -744,10 +749,8 @@ static bool z_erofs_collector_end(struct z_erofs_decompress_frontend *fe)
 	z_erofs_bvec_iter_end(&fe->biter);
 	mutex_unlock(&pcl->lock);
 
-	if (fe->candidate_bvpage) {
-		DBG_BUGON(z_erofs_is_shortlived_page(fe->candidate_bvpage));
+	if (fe->candidate_bvpage)
 		fe->candidate_bvpage = NULL;
-	}
 
 	/*
 	 * if all pending pages are added, don't hold its reference
@@ -896,24 +899,13 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 	if (cur)
 		tight &= (fe->mode >= Z_EROFS_PCLUSTER_FOLLOWED);
 
-retry:
 	err = z_erofs_attach_page(fe, &((struct z_erofs_bvec) {
 					.page = page,
 					.offset = offset - map->m_la,
 					.end = end,
 				  }), exclusive);
-	/* should allocate an additional short-lived page for bvset */
-	if (err == -EAGAIN && !fe->candidate_bvpage) {
-		fe->candidate_bvpage = alloc_page(GFP_NOFS | __GFP_NOFAIL);
-		set_page_private(fe->candidate_bvpage,
-				 Z_EROFS_SHORTLIVED_PAGE);
-		goto retry;
-	}
-
-	if (err) {
-		DBG_BUGON(err == -EAGAIN && fe->candidate_bvpage);
+	if (err)
 		goto out;
-	}
 
 	z_erofs_onlinepage_split(page);
 	/* bump up the number of spiltted parts of a page */
-- 
2.39.5



