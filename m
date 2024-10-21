Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C3B1E5731;
	Mon, 21 Oct 2024 10:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507633; cv=none; b=DeBxJ1J/V4Gbm4GYy9WBdZhFkSusmFbzl3/LwDxSZDBbPkYRXqK8KEYN+AIoWbVFUJSzJOf0FJrsOntDH/iT3+wt0o/NTBSXrvkq7ZJHzkXnPMFmkZa2DhFtm/juIjuV1FFgkR0X+O4tC1GusNIa2kjXZvDwWIGX/TlunYWOzhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507633; c=relaxed/simple;
	bh=FXrq6wj8jyeXk5t5qxM3/PwtASSHk7paIMSYXb28skA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kn7r8iQs1eNzWSTd49R/GsF7OS7ZPeECVrM9LjDZTJvR1z0BNAPBFiJfDjBJe9tYnTCMA0C2nUuB7xyTkKDX6E0bLS0TH7tSV2BM5F5Zrt7TlajonxD2m9gsGSc0n1pooLLcT5de0aP3tYO269YVmrhO2skxSgRk153c7p3g2GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9SFMuHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9SFMuHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303A3C4CEC7;
	Mon, 21 Oct 2024 10:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507633;
	bh=FXrq6wj8jyeXk5t5qxM3/PwtASSHk7paIMSYXb28skA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9SFMuHaNrWn8o3kJCrkh56FwIFHhYoJCyeKsYIyM5bMuCEePwy+nfzbNDHXECgKX
	 GrVaygQG5ENFMKU0NH5puQD68o5BmbuTTmG3hpxJhEgroF6k833WMUZDX++73FMT2Q
	 fmPqw3bgpZBcbtP8LUDTw/mOTGSeLFh66UQOyKb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 09/82] udf: Convert udf_lookup() to use new directory iteration code
Date: Mon, 21 Oct 2024 12:24:50 +0200
Message-ID: <20241021102247.591708512@linuxfoundation.org>
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

[ Upstream commit 200918b34d158cdaee531db7e0c80b92c57e66f1 ]

Convert udf_lookup() to use udf_fiiter_find_entry() for looking up
directory entries.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -366,25 +366,22 @@ static struct dentry *udf_lookup(struct
 				 unsigned int flags)
 {
 	struct inode *inode = NULL;
-	struct fileIdentDesc cfi;
-	struct udf_fileident_bh fibh;
-	struct fileIdentDesc *fi;
+	struct udf_fileident_iter iter;
+	int err;
 
 	if (dentry->d_name.len > UDF_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	fi = udf_find_entry(dir, &dentry->d_name, &fibh, &cfi);
-	if (IS_ERR(fi))
-		return ERR_CAST(fi);
+	err = udf_fiiter_find_entry(dir, &dentry->d_name, &iter);
+	if (err < 0 && err != -ENOENT)
+		return ERR_PTR(err);
 
-	if (fi) {
+	if (err == 0) {
 		struct kernel_lb_addr loc;
 
-		if (fibh.sbh != fibh.ebh)
-			brelse(fibh.ebh);
-		brelse(fibh.sbh);
+		loc = lelb_to_cpu(iter.fi.icb.extLocation);
+		udf_fiiter_release(&iter);
 
-		loc = lelb_to_cpu(cfi.icb.extLocation);
 		inode = udf_iget(dir->i_sb, &loc);
 		if (IS_ERR(inode))
 			return ERR_CAST(inode);


