Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7728848C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AF40C433EF;
	Fri, 10 Mar 2023 14:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458187;
	bh=MvdYw3jbdfjJE1iBHegemyYKVmUMm17bIwoW/vTva/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFDTUIqoie1z4tzentwlrqgJ7MsTG1oNq1rSHZEI7SgFNJf/vU5K7WxLVR8i+asvV
	 qA1KMxi1d37brka5oCdYKI7LbRr8w+J5K7xCWSik4tJ8/9y8CMpMGoJ6HYTiFqh+ET
	 BjpZOr00VYbwUXonnKp5Layb5ouGkc6mi6v9J2iI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+0937935b993956ba28ab@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 4.19 153/252] udf: Do not update file length for failed writes to inline files
Date: Fri, 10 Mar 2023 14:38:43 +0100
Message-Id: <20230310133723.445413298@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit 256fe4162f8b5a1625b8603ca5f7ff79725bfb47 upstream.

When write to inline file fails (or happens only partly), we still
updated length of inline data as if the whole write succeeded. Fix the
update of length of inline data to happen only if the write succeeds.

Reported-by: syzbot+0937935b993956ba28ab@syzkaller.appspotmail.com
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/file.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -148,26 +148,24 @@ static ssize_t udf_file_write_iter(struc
 		goto out;
 
 	down_write(&iinfo->i_data_sem);
-	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
-		loff_t end = iocb->ki_pos + iov_iter_count(from);
-
-		if (inode->i_sb->s_blocksize <
-				(udf_file_entry_alloc_offset(inode) + end)) {
-			err = udf_expand_file_adinicb(inode);
-			if (err) {
-				inode_unlock(inode);
-				udf_debug("udf_expand_adinicb: err=%d\n", err);
-				return err;
-			}
-		} else {
-			iinfo->i_lenAlloc = max(end, inode->i_size);
-			up_write(&iinfo->i_data_sem);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB &&
+	    inode->i_sb->s_blocksize < (udf_file_entry_alloc_offset(inode) +
+				 iocb->ki_pos + iov_iter_count(from))) {
+		err = udf_expand_file_adinicb(inode);
+		if (err) {
+			inode_unlock(inode);
+			udf_debug("udf_expand_adinicb: err=%d\n", err);
+			return err;
 		}
 	} else
 		up_write(&iinfo->i_data_sem);
 
 	retval = __generic_file_write_iter(iocb, from);
 out:
+	down_write(&iinfo->i_data_sem);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB && retval > 0)
+		iinfo->i_lenAlloc = inode->i_size;
+	up_write(&iinfo->i_data_sem);
 	inode_unlock(inode);
 
 	if (retval > 0) {


