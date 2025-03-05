Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C373E2528E4;
	Wed,  5 Mar 2025 18:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198754; cv=none; b=iDC0I/xN6p0q8LNLha+ilDUuwUdHmNvRswR17U3uoJoW8TjUkhAlT1mLsTFbUBYePXSCS1WsapzZ6DifHEURIAgMRVfzE16JFJffP4aCBQ37RaLMbAAKHwTqCUF82Fh827WN3P7W1Lmi0UkQOkmYqtzP/Fa80GPcGzPmRwhF1Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198754; c=relaxed/simple;
	bh=VcsfFrB+RcISIf5OITFpGw0JZvLIlALImw7NrPvKUpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uSRjp1H/ZIplzer9mLrLF/TZfeg6OgsRw83f7rfJMYJpqaHtfMdZEEFg3oBOZiVl5EzmKKKHq87Qfw5zs8jLvXEl3qlI+Kumx2zXB+K1DHeT88562hd/Rle7D2bhIPl/w70zMb4bQ7f8jPW6v0Znj2CiqF+0WyuJTlsxDKzG+UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGaKlUSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGaKlUSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499B5C4CED1;
	Wed,  5 Mar 2025 18:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198754;
	bh=VcsfFrB+RcISIf5OITFpGw0JZvLIlALImw7NrPvKUpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YGaKlUSAILpE5961c0ciEdWqAhs8X+7vs+wHDb7EE0/9w5CSLD2Nl3NnOcf3/0ro0
	 n2AjZwRTFbjQ691kenvnIly2+O1xTBbJo4y0HLZZLl9yU4tEfxTE+NfaJiIk1EWsGB
	 DVtXJrkSt72AZOluvqpfukVAreNZzxVZv5bXDAR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Heusel <christian@heusel.eu>,
	=?UTF-8?q?Mantas=20Mikul=C4=97nas?= <grawity@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.13 137/157] fuse: revert back to __readahead_folio() for readahead
Date: Wed,  5 Mar 2025 18:49:33 +0100
Message-ID: <20250305174510.808272354@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit 0c67c37e1710b2a8f61c8a02db95a51fe577e2c1 upstream.

In commit 3eab9d7bc2f4 ("fuse: convert readahead to use folios"), the
logic was converted to using the new folio readahead code, which drops
the reference on the folio once it is locked, using an inferred
reference on the folio. Previously we held a reference on the folio for
the entire duration of the readpages call.

This is fine, however for the case for splice pipe responses where we
will remove the old folio and splice in the new folio (see
fuse_try_move_page()), we assume that there is a reference held on the
folio for ap->folios, which is no longer the case.

To fix this, revert back to __readahead_folio() which allows us to hold
the reference on the folio for the duration of readpages until either we
drop the reference ourselves in fuse_readpages_end() or the reference is
dropped after it's replaced in the page cache in the splice case.
This will fix the UAF bug that was reported.

Link: https://lore.kernel.org/linux-fsdevel/2f681f48-00f5-4e09-8431-2b3dbfaa881e@heusel.eu/
Fixes: 3eab9d7bc2f4 ("fuse: convert readahead to use folios")
Reported-by: Christian Heusel <christian@heusel.eu>
Closes: https://lore.kernel.org/all/2f681f48-00f5-4e09-8431-2b3dbfaa881e@heusel.eu/
Closes: https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/issues/110
Reported-by: Mantas Mikulėnas <grawity@gmail.com>
Closes: https://lore.kernel.org/all/34feb867-09e2-46e4-aa31-d9660a806d1a@gmail.com/
Closes: https://bugzilla.opensuse.org/show_bug.cgi?id=1236660
Cc: <stable@vger.kernel.org> # v6.13
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c  |    6 ++++++
 fs/fuse/file.c |   13 +++++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -836,6 +836,12 @@ static int fuse_check_folio(struct folio
 	return 0;
 }
 
+/*
+ * Attempt to steal a page from the splice() pipe and move it into the
+ * pagecache. If successful, the pointer in @pagep will be updated. The
+ * folio that was originally in @pagep will lose a reference and the new
+ * folio returned in @pagep will carry a reference.
+ */
 static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 {
 	int err;
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -955,8 +955,10 @@ static void fuse_readpages_end(struct fu
 		fuse_invalidate_atime(inode);
 	}
 
-	for (i = 0; i < ap->num_folios; i++)
+	for (i = 0; i < ap->num_folios; i++) {
 		folio_end_read(ap->folios[i], !err);
+		folio_put(ap->folios[i]);
+	}
 	if (ia->ff)
 		fuse_file_put(ia->ff, false);
 
@@ -1048,7 +1050,14 @@ static void fuse_readahead(struct readah
 		ap = &ia->ap;
 
 		while (ap->num_folios < cur_pages) {
-			folio = readahead_folio(rac);
+			/*
+			 * This returns a folio with a ref held on it.
+			 * The ref needs to be held until the request is
+			 * completed, since the splice case (see
+			 * fuse_try_move_page()) drops the ref after it's
+			 * replaced in the page cache.
+			 */
+			folio = __readahead_folio(rac);
 			ap->folios[ap->num_folios] = folio;
 			ap->descs[ap->num_folios].length = folio_size(folio);
 			ap->num_folios++;


