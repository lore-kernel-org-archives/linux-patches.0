Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C8D3F825C;
	Tue, 21 Jul 2026 17:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654387; cv=none; b=l1GVfPWch38JX6oMrA09S5RzXCbY90JfY59FZ+WkkZwZgeESd5l8+w15Yy8pYnLVKiQrOGTL0sk77deL/giCd0MAtNWCkfFnkO01P//vb7BF0JphPnPDkN67KDaqbL5Rj7zKhz0aHrwSGR8jSl9KsyDzQTNq4y4GHr0YOm1z5WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654387; c=relaxed/simple;
	bh=nQ2Pcl8qnP+Kzj64TSrutakog2/h7F7i1pEO7L6O00U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kP4HgV2T28U9SQQO6Z7vjrZGxoFbUtguPwPtjuubfD895d8MRwjs6M0Z+FbWojUGKP3I17k3QubnV+mDKpzGH0Q0ktLj4sDvbeoKzNt43HiHSgxw6wOOOVMnDGHD0JyGIRsQ0RZCH8JYxxWIJwC8TKIboAtaPiD9rhTycu9wk94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFzEYqE7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFzEYqE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE45F1F000E9;
	Tue, 21 Jul 2026 17:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654386;
	bh=mrOPPZoR4zvLy8K130TBXzKgvU4xo0BrO47huF+6oUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SFzEYqE7BLvaOQMTSzrfa2GLydtnWIO7++Ro2fZ2THmzRuLUanyMgEUlS0uJlXA34
	 j1GR4uNx4KCNfZzkzVkD6Stiw3BOaN2hYDzQXOEJmmz4zvsll/7DkYuuCMYL3u7zet
	 3TO+UW5wpTC+sXmsS+S557UMsWqCMX1Tq32JdtaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.1 1685/2077] ntfs: add bounds check before accessing EA entries
Date: Tue, 21 Jul 2026 17:22:38 +0200
Message-ID: <20260721152632.494512898@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

commit 937282f7d15b593d0be765fa2ced164130ec87f7 upstream.

in ntfs_ea_lookup and ntfs_listxattr, this verifies that there is enough
space in the EA entry before accessing the next_entry_offset field of
the EA entry.

Cc: stable@vger.kernel.org # v7.1
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/ea.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/fs/ntfs/ea.c
+++ b/fs/ntfs/ea.c
@@ -53,11 +53,11 @@ static int ntfs_ea_lookup(char *ea_buf,
 	loff_t offset, p_ea_size;
 	unsigned int next;
 
-	if (ea_buf_size < sizeof(struct ea_attr))
-		goto out;
-
 	offset = 0;
 	do {
+		if (ea_buf_size - offset < sizeof(struct ea_attr))
+			break;
+
 		p_ea = (const struct ea_attr *)&ea_buf[offset];
 		next = le32_to_cpu(p_ea->next_entry_offset);
 		p_ea_size = next ? next : (ea_buf_size - offset);
@@ -479,13 +479,13 @@ ssize_t ntfs_listxattr(struct dentry *de
 	if (ea_info_qsize > ea_buf_size || ea_info_qsize == 0)
 		goto out;
 
-	if (ea_info_qsize < sizeof(struct ea_attr)) {
-		err = -EIO;
-		goto out;
-	}
-
 	offset = 0;
 	do {
+		if (ea_info_qsize - offset < sizeof(struct ea_attr)) {
+			err = -EIO;
+			goto out;
+		}
+
 		p_ea = (const struct ea_attr *)&ea_buf[offset];
 		next = le32_to_cpu(p_ea->next_entry_offset);
 		ea_size = next ? next : (ea_info_qsize - offset);


