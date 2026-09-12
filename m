Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96CD33B96B;
	Sat, 12 Sep 2026 09:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205686; cv=none; b=mkJ13bOxBfsDzp8b+I60cik69F5GDmNi2TzFEIzO11VxpK7s9zBdg8Bfso69pKx3GwdE5gwUu6PUrpGgK8clHLL9jumiV8fjV7Chm5BVau9T13kfzRpsaTlf4Gri+g9bfZYg+t9e91Ppgbqpf0obO5hKxtjxjhEyODh3F87VGak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205686; c=relaxed/simple;
	bh=Yz0ttN6pJEOoDNOfVreUjeLDdrlMrCuNSi1nhKJ/JYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQw8HeseM9H3H+MwjDuHrFpdrh/dk04Uz2/+d5EsGOhDzWzn8XwQxNUy/pdM1zXd4ihgnOgI/mOrQnL5PzQH4x0ZuYPoqfAu8+hsAlGQU6kfRp5bZpqDZz2rgO1JWc8ykMnkbfZgm42ZPSdWgykbk8Bwcdv1EJi6s6tVBx7X55I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zo5frapU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zo5frapU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDE51F00893;
	Sat, 12 Sep 2026 09:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205685;
	bh=Jw328u5wPdB2vhRZWmly9GlUNOTeIZqi6lgS97KmxJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zo5frapUAMunQQ/YxTjBSUHFTw7Zj2dskC16FW4Xn3xRfVB8WCBEye3L81Tns13nI
	 9MY706RpM+VathytA41kZaRgiyJQ/XPFqfHJvrDRTzMvjuvt7sW8e7YHxzNK48cgoJ
	 GedlaCcOh9Wo0JAYyDMvJvXFSyzHcKendHPMqQgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0045/1518] udf: Fix data loss when converting inline inodes to out of line
Date: Sat, 12 Sep 2026 08:36:54 +0200
Message-ID: <20260912065624.455830161@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 62333e480d12ab186f89fe2725b372d12f72d5eb ]

When udf_expand_file_adinicb() converts file from inline format to out
of line, we use filemap_fdatawrite() to writeout the data to the new
blocks. However since 36580ed08776 ("udf: Do not allocate blocks on page
writeback") the writeback actually doesn't allocate the new block and
the folio dirty bit is just silently cleared. Thus unless the file is
written to after the conversion (as it can easily happen in case of
truncate up), the data is just lost. Fix the problem by explicitely
allocating the block underlying the data before starting writeback.

Fixes: 36580ed08776 ("udf: Do not allocate blocks on page writeback")
CC: stable@vger.kernel.org
Link: https://patch.msgid.link/20260730104232.4086759-4-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/inode.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -406,6 +406,10 @@ int udf_expand_file_adinicb(struct inode
 {
 	struct folio *folio;
 	struct udf_inode_info *iinfo = UDF_I(inode);
+	struct udf_map_rq map = {
+		.lblk = 0,
+		.iflags = UDF_MAP_CREATE,
+	};
 	int err;
 
 	WARN_ON_ONCE(!inode_is_locked(inode));
@@ -435,20 +439,27 @@ int udf_expand_file_adinicb(struct inode
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_SHORT;
 	else
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_LONG;
+	up_write(&iinfo->i_data_sem);
+
+	/* Allocate the block underlying the data */
+	err = udf_map_block(inode, &map);
+	if (err < 0)
+		goto restore;
+
 	folio_mark_dirty(folio);
 	folio_unlock(folio);
-	up_write(&iinfo->i_data_sem);
 	err = filemap_fdatawrite(inode->i_mapping);
 	if (err) {
 		/* Restore everything back so that we don't lose data... */
 		folio_lock(folio);
+restore:
 		down_write(&iinfo->i_data_sem);
 		memcpy_from_folio(iinfo->i_data + iinfo->i_lenEAttr,
 				folio, 0, inode->i_size);
-		folio_unlock(folio);
 		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
 		iinfo->i_lenAlloc = inode->i_size;
 		up_write(&iinfo->i_data_sem);
+		folio_unlock(folio);
 	}
 	folio_put(folio);
 	mark_inode_dirty(inode);


