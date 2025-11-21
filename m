Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5FE309DCE;
	Fri, 21 Nov 2025 13:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733381; cv=none; b=eeAVwLOHFEYbbZoqPgAXNju3hyFJ6QumsT/vHxZ6LbXfx6Tv0558mpdhb8AO4BEp3w4rWEwxNP2r1FG698RXBg7gla5FWQ5481nSkqNegHvn3iqs6b1zuQZgERf8FWyYhnM74jJuo6WrX7XMKRo95guHKJCPSZbASFfUmiElO3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733381; c=relaxed/simple;
	bh=ZRsgT9LvG+z6UIWlGrSqs4krPeuSkZV5zflfnuGFaHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ixQt7LfTPZ5u9nHK0q8j1r4fNuJ16wI+zoPYy/in6gqC0pGZ3/hIr4Ab2ecADxhSYmhmkShs9nOcLpYM45XMhZQoh5U+6sRrk84OLpOgqUhprOUBuuPw1mXsVM+kj//hjP5NLcNXgP+86Wn4cH2BURCxMFybDUq7VAkzMz0GtCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxLs8PhY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxLs8PhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBD5C4CEF1;
	Fri, 21 Nov 2025 13:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733381;
	bh=ZRsgT9LvG+z6UIWlGrSqs4krPeuSkZV5zflfnuGFaHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxLs8PhYaPrnbPXOjBYjqZp2xQ6qzAMilNFBxdROeB67bK+meaZGqYiep73i/MPs7
	 vatTVADwmVCHE/39M6UG9Rv/0T8eUBGA+lg92/IvqTNTSAvywfJwxpgPisafpCM0RQ
	 Dp5FWp/kJUR9gtin7ZPj7rs4KtgGRsm6MShOqkic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Prasad N <sprasad@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	Mark A Whiting <whitingm@opentext.com>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.6 422/529] cifs: stop writeback extension when change of size is detected
Date: Fri, 21 Nov 2025 14:12:01 +0100
Message-ID: <20251121130246.029604868@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Shyam Prasad N <sprasad@microsoft.com>

cifs_extend_writeback can pick up a folio on an extending write which
has been dirtied, but we have aclamp on the writeback to an i_size
local variable, which can cause short writes, yet mark the page as clean.
This can cause a data corruption.

As an example, consider this scenario:
1. First write to the file happens offset 0 len 5k.
2. Writeback starts for the range (0-5k).
3. Writeback locks page 1 in cifs_writepages_begin. But does not lock
page 2 yet.
4. Page 2 is now written to by the next write, which extends the file
by another 5k. Page 2 and 3 are now marked dirty.
5. Now we reach cifs_extend_writeback, where we extend to include the
next folio (even if it should be partially written). We will mark page
2 for writeback.
6. But after exiting cifs_extend_writeback, we will clamp the
writeback to i_size, which was 5k when it started. So we write only 1k
bytes in page 2.
7. We still will now mark page 2 as flushed and mark it clean. So
remaining contents of page 2 will not be written to the server (hence
the hole in that gap, unless that range gets overwritten).

With this patch, we will make sure not extend the writeback anymore
when a change in the file size is detected.

This fix also changes the error handling of cifs_extend_writeback when
a folio get fails. We will now stop the extension when a folio get fails.

Cc: stable@kernel.org # v6.3~v6.9
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Acked-by: David Howells <dhowells@redhat.com>
Reported-by: Mark A Whiting <whitingm@opentext.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/file.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 1058066913dd6..1f0a53738426e 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2747,8 +2747,10 @@ static void cifs_extend_writeback(struct address_space *mapping,
 				  loff_t start,
 				  int max_pages,
 				  loff_t max_len,
-				  size_t *_len)
+				  size_t *_len,
+				  unsigned long long i_size)
 {
+	struct inode *inode = mapping->host;
 	struct folio_batch batch;
 	struct folio *folio;
 	unsigned int nr_pages;
@@ -2779,7 +2781,7 @@ static void cifs_extend_writeback(struct address_space *mapping,
 
 			if (!folio_try_get(folio)) {
 				xas_reset(xas);
-				continue;
+				break;
 			}
 			nr_pages = folio_nr_pages(folio);
 			if (nr_pages > max_pages) {
@@ -2799,6 +2801,15 @@ static void cifs_extend_writeback(struct address_space *mapping,
 				xas_reset(xas);
 				break;
 			}
+
+			/* if file size is changing, stop extending */
+			if (i_size_read(inode) != i_size) {
+				folio_unlock(folio);
+				folio_put(folio);
+				xas_reset(xas);
+				break;
+			}
+
 			if (!folio_test_dirty(folio) ||
 			    folio_test_writeback(folio)) {
 				folio_unlock(folio);
@@ -2934,7 +2945,8 @@ static ssize_t cifs_write_back_from_locked_folio(struct address_space *mapping,
 
 			if (max_pages > 0)
 				cifs_extend_writeback(mapping, xas, &count, start,
-						      max_pages, max_len, &len);
+						      max_pages, max_len, &len,
+						      i_size);
 		}
 	}
 	len = min_t(unsigned long long, len, i_size - start);
-- 
2.51.0



