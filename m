Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FDD304BCB;
	Sat, 30 May 2026 17:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163390; cv=none; b=Rpvx9ZhPgPF4CcRZS3vgrWmUU1M3srxF5KrSwhwQx0q4vuCSOlX77tQuwZTxY4vJetComQmWfx8i2K2Geety7zJI5lh1SbQBK2GA61u9fj1GGaJyJUe0l1RCZxd/pkqUaPxjoiGwBN8nVDMeMQnO1kTMiCUrDj6Vst6p3WqE/ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163390; c=relaxed/simple;
	bh=QCJ3qo2uSCQai/Gv1qigeX2zhcLW5wo6gn/xmYtNj1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzpYnHR7hMvoqauVUG7+aQA/h6Nuswfe549CJkn/tcf0oh+sQxo2teWc3WaQFIyg7SxuGwT6pn8fyV5qzkGKwbD0peCG0SHs4NsN3QxBo1gEVeeaIHQwHRcjK52Gx3hCfchI9eSffjzCq0i4skum92VPhAdpYEoyUETcJYjLRgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2BgyUS22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2BgyUS22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8881F00893;
	Sat, 30 May 2026 17:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163389;
	bh=ZaKoy+VeADy27dUhKYQjIG8hbKZvPW0ythV0o6enWPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2BgyUS22/3hJ6fWduJkac56k/HAXqFpuYc/GA/AcOJPtB9prKt/itueiEGHycRTB9
	 /r6v0sbIhSGJTzsxgvtxUFucNFbOWbIO870Wzvds+w7McO826Ghe+r1NnmkNnbkeP/
	 v9Zy+Fnb78jUBXS+mdQSg/MxEIS02kXU9RYArbi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sohei Koyama <skoyama@ddn.com>,
	Andreas Dilger <adilger@dilger.ca>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 244/776] ext4: fix missing brelse() in ext4_xattr_inode_dec_ref_all()
Date: Sat, 30 May 2026 17:59:18 +0200
Message-ID: <20260530160246.839562574@linuxfoundation.org>
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

From: Sohei Koyama <skoyama@ddn.com>

commit 77d059519382bd66283e6a4e83ee186e87e7708f upstream.

The commit c8e008b60492 ("ext4: ignore xattrs past end")
introduced a refcount leak in when block_csum is false.

ext4_xattr_inode_dec_ref_all() calls ext4_get_inode_loc() to
get iloc.bh, but never releases it with brelse().

Fixes: c8e008b60492 ("ext4: ignore xattrs past end")
Signed-off-by: Sohei Koyama <skoyama@ddn.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>
Link: https://patch.msgid.link/20260406074830.8480-1-skoyama@ddn.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1112,7 +1112,7 @@ ext4_xattr_inode_dec_ref_all(handle_t *h
 {
 	struct inode *ea_inode;
 	struct ext4_xattr_entry *entry;
-	struct ext4_iloc iloc;
+	struct ext4_iloc iloc = { .bh = NULL };
 	bool dirty = false;
 	unsigned int ea_ino;
 	int err;
@@ -1207,6 +1207,8 @@ ext4_xattr_inode_dec_ref_all(handle_t *h
 			ext4_warning_inode(parent,
 					   "handle dirty metadata err=%d", err);
 	}
+
+	brelse(iloc.bh);
 }
 
 /*


