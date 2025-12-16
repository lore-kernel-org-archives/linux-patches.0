Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A1133EB1A;
	Tue, 16 Dec 2025 11:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884596; cv=none; b=AmorBhFioqSSPEDJUVEMtZaY19rZXHhr/jYZQluvsAMT+HgCagegl6hm92MualMsQfwAwnM13JhyeZHYT2kO6AA2u/nC/w6gYH/4qrd8fkNFv69kAoZXjH+bci5qyzgYWxKWUQnpiK+pJ8ao9fpWr9hKib0Ro6GSweLU+Oxv/Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884596; c=relaxed/simple;
	bh=OY1OuznpxEh2nq6AtVBofuF+jYtodM4Qsa+/Rkx328g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E//fyUyt1BAuu4DBpRAJScvd1LEg1TTrPIlpF9PtMtAEfz366YZFAo1ZUVq+/Um32iuz+3Y6eWNfDBi/GN5TKOYoDxKMOwsU+9SucCHEo9H2u925jm7DIxUTAHGJFwteMmcf/TGSWC8TT38EjvnjwN02hzcBV6wBgk5PSyz7qTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrsXxRfm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrsXxRfm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88360C4CEF1;
	Tue, 16 Dec 2025 11:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884596;
	bh=OY1OuznpxEh2nq6AtVBofuF+jYtodM4Qsa+/Rkx328g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrsXxRfmBpS6iPKRdQnNTR5K5UZhPlCDIrWWpCsBrmmShLsYF+5xxdrv8F4PlQmUl
	 J9FAF6T4OMC1gYBn7J+I7EWdDUy82o41G32TfGD3gQtWe3h413wLGZUClkMKcearoN
	 /PF/b7J9ztuAg1w5O0IK9pM/r84zfKk/sL3BuSmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Rosenberg <olrose55@gmail.com>,
	Will Rosenberg <whrosenb@asu.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 240/354] kernfs: fix memory leak of kernfs_iattrs in __kernfs_new_node
Date: Tue, 16 Dec 2025 12:13:27 +0100
Message-ID: <20251216111329.608256836@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Will Rosenberg <whrosenb@asu.edu>

[ Upstream commit 382b1e8f30f779af8d6d33268e53df7de579ef3c ]

There exists a memory leak of kernfs_iattrs contained as an element
of kernfs_node allocated in __kernfs_new_node(). __kernfs_setattr()
allocates kernfs_iattrs as a sub-object, and the LSM security check
incorrectly errors out and does not free the kernfs_iattrs sub-object.

Make an additional error out case that properly frees kernfs_iattrs if
security_kernfs_init_security() fails.

Fixes: e19dfdc83b60 ("kernfs: initialize security of newly created nodes")
Co-developed-by: Oliver Rosenberg <olrose55@gmail.com>
Signed-off-by: Oliver Rosenberg <olrose55@gmail.com>
Signed-off-by: Will Rosenberg <whrosenb@asu.edu>
Link: https://patch.msgid.link/20251125151332.2010687-1-whrosenb@asu.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 5dc90a498e75d..116ada5bc27c7 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -662,11 +662,14 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 	if (parent) {
 		ret = security_kernfs_init_security(parent, kn);
 		if (ret)
-			goto err_out3;
+			goto err_out4;
 	}
 
 	return kn;
 
+ err_out4:
+	simple_xattrs_free(&kn->iattr->xattrs, NULL);
+	kmem_cache_free(kernfs_iattrs_cache, kn->iattr);
  err_out3:
 	spin_lock(&kernfs_idr_lock);
 	idr_remove(&root->ino_idr, (u32)kernfs_ino(kn));
-- 
2.51.0



