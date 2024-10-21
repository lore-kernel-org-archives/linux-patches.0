Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA846195FEC;
	Mon, 21 Oct 2024 10:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507628; cv=none; b=e6EJKxw4GvhTmBs/xnHIyPOJrPlwqKGTqVKPKXRFCMZz3fraTwibIHKfgZaUmowUX7mdIfbBecCgKRYZEBt8KL2NJ6gAMKyew3w781aPXLJIEUq5v9OZW90Ftv7lNDctDr/NLCzmJo3LwTJoMDHoBAh7quKva9p0j7UXC7INOoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507628; c=relaxed/simple;
	bh=cgP1F22Hk4Gp2UXtL4iUNNkZmijDOm6Txs2euu4fhWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sL8YOMLJrbjqrwcjLLu9+t3VLn8/63k0RwtnvbRSA5rkAsf/3+1yALCICE222++6z4dAXcS9Dl1Lk3FW8a+kQ/k1hTJLXlfZKId7R+mCBMtlHEAsH0XVpF4MEUyJAbuDdpzNtOlYXB0/QUJR03SW2PgYJlyWpz3lVrM7/quGXc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDFEf0WA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDFEf0WA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15438C4CEC3;
	Mon, 21 Oct 2024 10:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507627;
	bh=cgP1F22Hk4Gp2UXtL4iUNNkZmijDOm6Txs2euu4fhWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDFEf0WARIqiDmsWIYuBbDPiqfmmd8JLsFovaLWOz/EC4mZjKvlr66kWAzciT69Aw
	 w+FMsZ6Nydh5So2/4fQM27BUEyd2YO0mFgyGiubibwzXyuQp3oa1L0xbQdTyb/qPNE
	 WxEy78hFsWaIJ489+GIGrrSQ13I6erI0t7F1HRXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 17/82] udf: Convert udf_link() to new directory iteration code
Date: Mon, 21 Oct 2024 12:24:58 +0200
Message-ID: <20241021102247.917311718@linuxfoundation.org>
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

[ Upstream commit dbfb102d16fb780c84f41adbaeb7eac907c415dc ]

Convert udf_link() to use new directory iteration code for adding entry
into the directory.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -1222,27 +1222,21 @@ static int udf_link(struct dentry *old_d
 		    struct dentry *dentry)
 {
 	struct inode *inode = d_inode(old_dentry);
-	struct udf_fileident_bh fibh;
-	struct fileIdentDesc cfi, *fi;
+	struct udf_fileident_iter iter;
 	int err;
 
-	fi = udf_add_entry(dir, dentry, &fibh, &cfi, &err);
-	if (!fi) {
+	err = udf_fiiter_add_entry(dir, dentry, &iter);
+	if (err)
 		return err;
-	}
-	cfi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
-	cfi.icb.extLocation = cpu_to_lelb(UDF_I(inode)->i_location);
+	iter.fi.icb.extLength = cpu_to_le32(inode->i_sb->s_blocksize);
+	iter.fi.icb.extLocation = cpu_to_lelb(UDF_I(inode)->i_location);
 	if (UDF_SB(inode->i_sb)->s_lvid_bh) {
-		*(__le32 *)((struct allocDescImpUse *)cfi.icb.impUse)->impUse =
+		*(__le32 *)((struct allocDescImpUse *)iter.fi.icb.impUse)->impUse =
 			cpu_to_le32(lvid_get_unique_id(inode->i_sb));
 	}
-	udf_write_fi(dir, &cfi, fi, &fibh, NULL, NULL);
-	if (UDF_I(dir)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
-		mark_inode_dirty(dir);
+	udf_fiiter_write_fi(&iter, NULL);
+	udf_fiiter_release(&iter);
 
-	if (fibh.sbh != fibh.ebh)
-		brelse(fibh.ebh);
-	brelse(fibh.sbh);
 	inc_nlink(inode);
 	inode->i_ctime = current_time(inode);
 	mark_inode_dirty(inode);


