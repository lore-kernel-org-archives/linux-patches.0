Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC5A1F8934;
	Mon, 21 Oct 2024 10:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507535; cv=none; b=UNCCqpTfWcmf4bd0A7ByC94PXvMWGv+nciZU6Khtz5PsGdYjac5CtxDdvA3P9XN3IYjx6tGqMnBwuE4LEXQoOVCb2r5BR5KKLp4mwZSkDJHAro2e09u14TDB00ioR7+Zey94FaAyZfckDo/+RHtOgFdC8rTcvihK0Tx2Ers+PaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507535; c=relaxed/simple;
	bh=3kGIRrLAYUQiVKEJ3KU7u/FODe+4kjXpE/S8mBe+niw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANs5pbg7dnz4lSeWYAaH8v9RQtEz55cGXi+A1SUnbpAMOpxJHhUfOKEbs0EP7v4Nr3zhhEkI6rmx9QO7znfgscunXL+DrIvZ61lDhEUlgDXw5o3d+s5d9QLXRA85VsD8Pz/d0/ecFpiq13E5lLYWUY4WFhIqBQNE+of9JE+7Hl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YaF4/T/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YaF4/T/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBBBC4CEC3;
	Mon, 21 Oct 2024 10:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507534;
	bh=3kGIRrLAYUQiVKEJ3KU7u/FODe+4kjXpE/S8mBe+niw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YaF4/T/KxPQIDfHEl2X7+bRIqQIIAea5JSuCOu/1Wk5ZmhCQiXr8SH2yjjPsAgUYG
	 89IwOExXI0RSn0X9uekAeYVp6gKQtDDtstFw2faAnk2jov+vBHZgMadoexOpjbR7hX
	 ZOZIeJ0G3xJdpjQrU6DNF8BFqSqemlZLJnZtaz3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 10/82] udf: Convert udf_get_parent() to new directory iteration code
Date: Mon, 21 Oct 2024 12:24:51 +0200
Message-ID: <20241021102247.630043168@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jan Kara <jack@suse.cz>

[ Upstream commit 9b06fbef4202363d74bba5459ddd231db6d3b1af ]

Convert udf_get_parent() to use udf_fiiter_find_entry().

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1368,17 +1368,15 @@ static struct dentry *udf_get_parent(str
 {
 	struct kernel_lb_addr tloc;
 	struct inode *inode = NULL;
-	struct fileIdentDesc cfi;
-	struct udf_fileident_bh fibh;
+	struct udf_fileident_iter iter;
+	int err;
 
-	if (!udf_find_entry(d_inode(child), &dotdot_name, &fibh, &cfi))
-		return ERR_PTR(-EACCES);
+	err = udf_fiiter_find_entry(d_inode(child), &dotdot_name, &iter);
+	if (err)
+		return ERR_PTR(err);
 
-	if (fibh.sbh != fibh.ebh)
-		brelse(fibh.ebh);
-	brelse(fibh.sbh);
-
-	tloc = lelb_to_cpu(cfi.icb.extLocation);
+	tloc = lelb_to_cpu(iter.fi.icb.extLocation);
+	udf_fiiter_release(&iter);
 	inode = udf_iget(child->d_sb, &tloc);
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);


