Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13703CEB8A;
	Wed, 30 Sep 2026 19:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794930; cv=none; b=lbyL5ADaP9EoN5/sesugNmEj2AlKyC0EkX2yVTBt8lAQuzRK+/E/dqlaU/sAlXoNU9ZmMTkqMnO+GepxxVsNeEeQITNy7CMDVgvEw60r/H1/EZjb4xQOQ17woC1Ii4WyrXbrleSb0NQm6wn8oN8YE5DWbD7ESIblilOP+kBxOk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794930; c=relaxed/simple;
	bh=meVtUX2SusDF1zTi4S4SWm6ZbzuQfUxZ64h4q9KwMfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vc5g6ELoC5jarn/wG68b9y2Fv9hmJBLvQv+SmPEYMx17PoR80+yCtL8eh+Ti7nSLXxnmffKqNwrTZpRy+bPNBpr/gM1OTcrP30QKECi54kL9M81TZxyRSVL9Q3nVNZkjAEbh+Hbsl/yFpSryUYZRNttRYcAWsAZIwj6FqqP+IXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMyGNSEq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMyGNSEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B301F000FF;
	Wed, 30 Sep 2026 19:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794929;
	bh=yFP7DJZlT/MLxH7x7GxTV1hRlmpY/iMJ+zTYcb41fZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VMyGNSEqWx67MyOuEqPRVS+1SlG2O2FnMRMVjsxeK7V7HYhrLT8GrJXYzfYDbllae
	 xqpW0Xeb+ykzbf5SnDWkfHLnaNvKKMhsRG2Q7mECXPODDDJO8nd+2uHqxKBPKvI/q2
	 lHkXKiMSzIFFbPxA0xntUmpGsvGeYDFJr1Gr+3/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Ahmet Memis <ali@iusegentoo.com>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0384/1193] ufs: do not treat unreadable directory blocks as empty
Date: Wed, 30 Sep 2026 17:17:48 +0200
Message-ID: <20260930152442.716178507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memis <ali@iusegentoo.com>

[ Upstream commit 08edfb34ee9ca54383970c65ed3a6013e84f5e16 ]

ufs_empty_dir() scans every directory block to decide whether a
directory is empty before rmdir() removes it. When ufs_get_folio()
cannot read or validate a block it returns an error pointer, and the
loop currently skips that block with continue and keeps scanning the
remaining blocks.

If none of the readable blocks hold an entry, the function returns 1
and the caller unlinks the directory. A directory whose contents live
in a block that cannot be read, for example because of an I/O error or
corrupted directory metadata, is therefore seen as empty and removed,
losing the entries it still holds.

Follow the ext2 behaviour and treat an unreadable block as a reason to
consider the directory not empty, so rmdir() fails instead of
discarding data that could not be verified.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
Link: https://patch.msgid.link/20260801013942.279992-1-ali@iusegentoo.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ufs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ufs/dir.c b/fs/ufs/dir.c
index 8c7f7ee6d0f83..ca95046b2def1 100644
--- a/fs/ufs/dir.c
+++ b/fs/ufs/dir.c
@@ -606,7 +606,7 @@ int ufs_empty_dir(struct inode * inode)
 
 		kaddr = ufs_get_folio(inode, i, &folio);
 		if (IS_ERR(kaddr))
-			continue;
+			return 0;
 
 		de = (struct ufs_dir_entry *)kaddr;
 		kaddr += ufs_last_byte(inode, i) - UFS_DIR_REC_LEN(1);
-- 
2.53.0



