Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41951B4141;
	Fri, 22 Aug 2025 12:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755866242; cv=none; b=NJITBw0hsOGEk+vXeDNjvPyQ6xXML3ePL5QwZENsZWEglY2/bEdG+WV0FOZ0h9Trwi6DzaMv8PblwMwsg36HQmJnAZLk3ZGmslFOU16fR1btV0bzieU76MIhNhAeKibJabJ5VP71lhesKNjG4cw6HUgCkmxCQ7VEwn4PHwrj58U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755866242; c=relaxed/simple;
	bh=elT8X7DYPgdZi3Sajd9EsCoSGB60VRYTMIRiIQ8KgF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzQMaF97kc8cGH/reL2nFYZPc+Z3Ur7iNiKhMbvFwo6PuPVlLJvidEiMsCdpAPMgYcrIY+lmCsZ9C3ksbRJX7/SNiXpNxUOjRiOdqazbx0CQudyJM9af77MpMuQHl6RaQVOLSNvp8ACehPp78fYPFImTK4tLlpxWxPHQmqnkEIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwplbCf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwplbCf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DC6C4CEED;
	Fri, 22 Aug 2025 12:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755866241;
	bh=elT8X7DYPgdZi3Sajd9EsCoSGB60VRYTMIRiIQ8KgF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwplbCf8B1kyrjJRTRdUVZDXlCwsNqJcWaQQabS5uu2Ll4sWe9+8fahiKAkg5tvPU
	 dDAfF/n7kRUGnzSmVqIC+FlUOjO8xqs0OYR0HFYH29enDq7x78xDIK4ocSSv40T0iZ
	 oCxQAZqYCoOh17ux2cPx/gPbveEnzplwqrV0EUkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.16 2/9] ext4: move the calculation of wbc->nr_to_write to mpage_folio_done()
Date: Fri, 22 Aug 2025 14:37:02 +0200
Message-ID: <20250822123516.876292565@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250822123516.780248736@linuxfoundation.org>
References: <20250822123516.780248736@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit f922c8c2461b022a2efd9914484901fb358a5b2a upstream.

mpage_folio_done() should be a more appropriate place than
mpage_submit_folio() for updating the wbc->nr_to_write after we have
submitted a fully mapped folio. Preparing to make mpage_submit_folio()
allows to submit partially mapped folio that is still under processing.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20250707140814.542883-3-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2027,6 +2027,7 @@ int ext4_da_get_block_prep(struct inode
 static void mpage_folio_done(struct mpage_da_data *mpd, struct folio *folio)
 {
 	mpd->start_pos += folio_size(folio);
+	mpd->wbc->nr_to_write -= folio_nr_pages(folio);
 	folio_unlock(folio);
 }
 
@@ -2057,8 +2058,6 @@ static int mpage_submit_folio(struct mpa
 	    !ext4_verity_in_progress(mpd->inode))
 		len = size & (len - 1);
 	err = ext4_bio_write_folio(&mpd->io_submit, folio, len);
-	if (!err)
-		mpd->wbc->nr_to_write -= folio_nr_pages(folio);
 
 	return err;
 }


