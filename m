Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F89253358;
	Mon, 23 Jun 2025 13:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684751; cv=none; b=fPICTt349mNsVih14buPe8C/pYWUUMu3YCK/Ar4FUAqYYIK0P6556pZ0/Yfm4UkdqIKZXHulZq57INZ5qL4Prrv4GJaxPYVFcaOFrrvgdBhhpfcHMwC/mKy7LdnwQIDbKhU/bBVnsv62Qv7u9ULriv9wVMBqm00moTkyLs8gMNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684751; c=relaxed/simple;
	bh=gnZbk53Lmg+PV2YFpbwCIi3HSzlJBOauhe16DN82lPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MLNbb98m70PFMWeNcjNrBtXkIEC09SxSt0cFs7keqAekezXJzDG9nJLhJ5+Yx37g+UtcCpRnmUpHs4TUxn6miIbySl3MnRMiF0N8d7GyCWBSnULuwbvhOvRnuL4xR8ZO8m/uU3WjgDPuIMLEuBIJHvHQRs4mDEe1O4NvTle8Z+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQzB80zg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQzB80zg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7482C4CEEA;
	Mon, 23 Jun 2025 13:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684751;
	bh=gnZbk53Lmg+PV2YFpbwCIi3HSzlJBOauhe16DN82lPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQzB80zg0vsVYIXtMtu+bv5XcDc4muzIKq03GON54U0IjjCEQhhPRYF6I7EuJLEJH
	 VHNr0n8a/T+J5E5sMjKmngEhYliE+AqK625X+qTv9NF22jGTRfHgmOp/q0XNOa0HT2
	 tLG0Ijqp3mfi+dgtvICeGv28IKfrcSFPX2HkstVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.15 125/592] f2fs: fix to return correct error number in f2fs_sync_node_pages()
Date: Mon, 23 Jun 2025 15:01:23 +0200
Message-ID: <20250623130703.243820410@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 43ba56a043b14426ca9ecac875ab357e32cb595e upstream.

If __write_node_folio() failed, it will return AOP_WRITEPAGE_ACTIVATE,
the incorrect return value may be passed to userspace in below path,
fix it.

- sync_filesystem
 - sync_fs
  - f2fs_issue_checkpoint
   - block_operations
    - f2fs_sync_node_pages
     - __write_node_folio
     : return AOP_WRITEPAGE_ACTIVATE

Cc: stable@vger.kernel.org
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/node.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -2107,10 +2107,14 @@ write_node:
 
 			ret = __write_node_page(&folio->page, false, &submitted,
 						wbc, do_balance, io_type, NULL);
-			if (ret)
+			if (ret) {
 				folio_unlock(folio);
-			else if (submitted)
+				folio_batch_release(&fbatch);
+				ret = -EIO;
+				goto out;
+			} else if (submitted) {
 				nwritten++;
+			}
 
 			if (--wbc->nr_to_write == 0)
 				break;


