Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546A032ED21;
	Thu, 17 Sep 2026 15:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659622; cv=none; b=GvXwnHCS9nuGC/lJly1zvY5D8ryL5xFk/sVn/VAFu0VwrW8El7jt968JINWJkfqgTxXPReOQpuc8bdHY90nb8oByGacODIjEsC3gC8ERyquyctYaBBPIIPqT/xLfYBG/KVq8PQuhNNLZv58H83JDSCOp1lUiMhIh5znfWnYL3bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659622; c=relaxed/simple;
	bh=vAMK0YBFzqyJiw6J8Op1HO6qmfdXYpllIv2JtFTEOz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IB0x33heNn5t2JH1azAxfnhrba7J2JcSe4RzCwIV+WbdM7px/uaD+WxGf4+x/oSoS0HuhJOyoBjOAuUd/+ZacRJZoRUSISPtVIxN9GK7b2G2yGbeLDC5mNZXdjVbDTtZ7Ocdl6WUQmco+qRr+V9kUZ1a7T7w0KtvenU/LMmMbI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2ci4Ows; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2ci4Ows"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DE01F00899;
	Thu, 17 Sep 2026 15:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659616;
	bh=Vu5DJhocJ6BPB/G3x9qFd+j85pkfju81IOBeUxx/qhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2ci4Ows9n54U/6Pkfn0QuJVqxM/xjbWqdPZ6bjdGslxnKfuyaSYp4QCcsM7lKg9L
	 hzKhVZzzYetZuC+t/shq/7ffQQTLVhWeDXh7sp/GTD6m8zjGtmifHsylPUaJyvq8Ek
	 mlrEygmsF486ehMexqoNamt5+lD5ASJ45Kp/bXnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengyu Zhu <hudsonzhu@tencent.com>,
	Gao Xiang <xiang@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 315/733] erofs: delimit inode_share cache key components
Date: Thu, 17 Sep 2026 16:10:23 +0100
Message-ID: <20260917151359.329621033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengyu Zhu <hudsonzhu@tencent.com>

[ Upstream commit 96bf9831fbf423b8104f7948cd8fe7007ecfb46c ]

Previously, inode_share keys were encoded as follows:

  fingerprint || domain_id

It would be better to have a separator between the fingerprint and domain
ID so that the fingerprint won't be parsed as part of a domain ID.

Change the key encoding as follows:

  domain_id || '\0' || fingerprint

Since domain_id is a NUL-terminated string, this makes the in-memory key
indices unambiguous.

Signed-off-by: Chengyu Zhu <hudsonzhu@tencent.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Fixes: e0bf7d1c074d ("erofs: support user-defined fingerprint name")
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/xattr.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/erofs/xattr.c b/fs/erofs/xattr.c
index df7ea019526d7..57cfb75207824 100644
--- a/fs/erofs/xattr.c
+++ b/fs/erofs/xattr.c
@@ -620,8 +620,8 @@ int erofs_xattr_fill_inode_fingerprint(struct erofs_inode_fingerprint *fp,
 {
 	struct erofs_sb_info *sbi = EROFS_SB(inode->i_sb);
 	struct erofs_xattr_prefix_item *prefix;
+	int domainlen, valuelen, base_index;
 	const char *infix;
-	int valuelen, base_index;
 
 	if (!test_opt(&sbi->opt, INODE_SHARE))
 		return -EOPNOTSUPP;
@@ -633,17 +633,18 @@ int erofs_xattr_fill_inode_fingerprint(struct erofs_inode_fingerprint *fp,
 	valuelen = erofs_getxattr(inode, base_index, infix, NULL, 0);
 	if (valuelen <= 0 || valuelen > (1 << sbi->blkszbits))
 		return -EFSCORRUPTED;
-	fp->size = valuelen + (domain_id ? strlen(domain_id) : 0);
+	domainlen = strlen(domain_id);
+	fp->size = domainlen + 1 + valuelen;
 	fp->opaque = kmalloc(fp->size, GFP_KERNEL);
 	if (!fp->opaque)
 		return -ENOMEM;
+	memcpy(fp->opaque, domain_id, domainlen + 1);
 	if (valuelen != erofs_getxattr(inode, base_index, infix,
-				       fp->opaque, valuelen)) {
+				       fp->opaque + domainlen + 1, valuelen)) {
 		kfree(fp->opaque);
 		fp->opaque = NULL;
 		return -EFSCORRUPTED;
 	}
-	memcpy(fp->opaque + valuelen, domain_id, fp->size - valuelen);
 	return 0;
 }
 #endif
-- 
2.53.0



