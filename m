Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA933DEAC8;
	Mon,  4 May 2026 14:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904484; cv=none; b=WXI9j1NvKgvQAIvWQTL4inDygXRMiskRnRtOxtMEJMbtYAzIFe0APumAPrcmykFOmojsIK612Hj5IB/Fc1fhpn2vW/c3s7ti/ryanemqA9Z9wIhFlon0vqiWY9Wjm5eKN/jaJhBQL95Ye2aE50v3r/1IJ6/qOiUeO3kYKAo6sPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904484; c=relaxed/simple;
	bh=nBSeOpXkAsrfVgnh+IXrriU6vYH+w1mkHnrscLY8tSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cr2abEUJbXmMMtSJivLPt4csqRW9AYnuU2qfrFGvJ2OcXeQMyVDterISvMAyb4iY39R+GaDtFSn0z/KrNX7KYL5rw2VtpSrcCW1GNP+fFbfB1lZL0y9B1uB75HiSQkGNz6XKohb8VMz/na0GCfywBAtMakbuD4Ny7VRUjITrXxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwvzMJWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwvzMJWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E9CC2BCF4;
	Mon,  4 May 2026 14:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904483;
	bh=nBSeOpXkAsrfVgnh+IXrriU6vYH+w1mkHnrscLY8tSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwvzMJWVyNsSo9yWJoeuSI5GswfwDP9liWxhgE3knpgwmtDMpdmNQmxDwgYItZcec
	 iYixw0O3hHKkBnkDtL5oVNwZKAPkCG6mOxcVYkjnwVUhVfzKnURyvKaxdO51fnSnqb
	 Rb2BgFApvmAEXksw6wGk3ESUeBqjOpQGH0S90SeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>
Subject: [PATCH 6.12 056/215] erofs: fix the out-of-bounds nameoff handling for trailing dirents
Date: Mon,  4 May 2026 15:51:15 +0200
Message-ID: <20260504135132.222870944@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit d18a3b5d337fa412a38e776e6b4b857a58836575 upstream.

Currently we already have boundary-checks for nameoffs, but the trailing
dirents are special since the namelens are calculated with strnlen()
with unchecked nameoffs.

If a crafted EROFS has a trailing dirent with nameoff >= maxsize,
maxsize - nameoff can underflow, causing strnlen() to read past the
directory block.

nameoff0 should also be verified to be a multiple of
`sizeof(struct erofs_dirent)` as well [1].

[1] https://sashiko.dev/#/patchset/20260416063511.3173774-1-hsiangkao%40linux.alibaba.com

Fixes: 3aa8ec716e52 ("staging: erofs: add directory operations")
Fixes: 33bac912840f ("staging: erofs: keep corrupted fs from crashing kernel in erofs_readdir()")
Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Closes: https://lore.kernel.org/r/A0FD7E0F-7558-49B0-8BC8-EB1ECDB2479A@outlook.com
Cc: stable@vger.kernel.org
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/dir.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

--- a/fs/erofs/dir.c
+++ b/fs/erofs/dir.c
@@ -18,20 +18,18 @@ static int erofs_fill_dentries(struct in
 		const char *de_name = (char *)dentry_blk + nameoff;
 		unsigned int de_namelen;
 
-		/* the last dirent in the block? */
-		if (de + 1 >= end)
-			de_namelen = strnlen(de_name, maxsize - nameoff);
-		else
+		/* non-trailing dirent in the directory block? */
+		if (de + 1 < end)
 			de_namelen = le16_to_cpu(de[1].nameoff) - nameoff;
+		else if (maxsize <= nameoff)
+			goto err_bogus;
+		else
+			de_namelen = strnlen(de_name, maxsize - nameoff);
 
-		/* a corrupted entry is found */
-		if (nameoff + de_namelen > maxsize ||
-		    de_namelen > EROFS_NAME_LEN) {
-			erofs_err(dir->i_sb, "bogus dirent @ nid %llu",
-				  EROFS_I(dir)->nid);
-			DBG_BUGON(1);
-			return -EFSCORRUPTED;
-		}
+		/* a corrupted entry is found (including negative namelen) */
+		if (!in_range32(de_namelen, 1, EROFS_NAME_LEN) ||
+		    nameoff + de_namelen > maxsize)
+			goto err_bogus;
 
 		if (!dir_emit(ctx, de_name, de_namelen,
 			      le64_to_cpu(de->nid), d_type))
@@ -40,6 +38,10 @@ static int erofs_fill_dentries(struct in
 		ctx->pos += sizeof(struct erofs_dirent);
 	}
 	return 0;
+err_bogus:
+	erofs_err(dir->i_sb, "bogus dirent @ nid %llu", EROFS_I(dir)->nid);
+	DBG_BUGON(1);
+	return -EFSCORRUPTED;
 }
 
 static int erofs_readdir(struct file *f, struct dir_context *ctx)
@@ -67,7 +69,7 @@ static int erofs_readdir(struct file *f,
 		}
 
 		nameoff = le16_to_cpu(de->nameoff);
-		if (nameoff < sizeof(struct erofs_dirent) || nameoff >= bsz) {
+		if (!nameoff || nameoff >= bsz || (nameoff % sizeof(*de))) {
 			erofs_err(sb, "invalid de[0].nameoff %u @ nid %llu",
 				  nameoff, EROFS_I(dir)->nid);
 			err = -EFSCORRUPTED;


