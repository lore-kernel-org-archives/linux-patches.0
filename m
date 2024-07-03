Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACAA17DA3A;
	Wed,  3 Jul 2024 11:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005152; cv=none; b=IbFwbtYaMZk/p71fFLHrc3oYdzQNffVLhMEvWvUEgZCTIxivyogvhYhrlMNurQWJ8yyiqhpXHMe3TNv57wN45ueWvD2u0FUOVKZW9pkuTpvgmtFJeddLnmBanjTT1CSg9qs4ddBrfpQKO5ib5cnghta7Hc28pn4dTlgGIiwynO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005152; c=relaxed/simple;
	bh=EcPh9+4/iWeBqgl6cYDpbEklCiya2L/DyMLRmH7cviM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBWht85r9OaX5wXrLfr9eqNM5FS4cC4S+NodObNs1V1BSns72Sx+VcD0fr0JfK0UXK4RVXYbXfiDPjUsdL+oOykn+13PAowgmNk/qo22HEoMBqCa0cnjnt2hU11TZabbqJ8NWvLe5iZ5mvbioM/m0Vm90mNMXvOdnVAJ6Syovso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmstfgHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmstfgHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A31C2BD10;
	Wed,  3 Jul 2024 11:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005152;
	bh=EcPh9+4/iWeBqgl6cYDpbEklCiya2L/DyMLRmH7cviM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmstfgHLnDf2NzYNhf8Qo/0REl5/5nffA63jk74ptxyx25J53otF0wc+GhbByGGlO
	 KBB9E2zzl0QC546xyMdvvK1ufxb3nlZvHhEaqHGDAVItSPWZgWMef3BjOUzOyliz3m
	 5AZkLNnM5gqLluwGt99rGtHs8s/e/mOmHx1XwS58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH 5.10 278/290] nfs: Leave pages in the pagecache if readpage failed
Date: Wed,  3 Jul 2024 12:40:59 +0200
Message-ID: <20240703102914.649179367@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 0b768a9610c6de9811c6d33900bebfb665192ee1 upstream.

The pagecache handles readpage failing by itself; it doesn't want
filesystems to remove pages from under it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/read.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -103,12 +103,8 @@ static void nfs_readpage_release(struct
 	if (nfs_error_is_fatal_on_server(error) && error != -ETIMEDOUT)
 		SetPageError(page);
 	if (nfs_page_group_sync_on_bit(req, PG_UNLOCKPAGE)) {
-		struct address_space *mapping = page_file_mapping(page);
-
 		if (PageUptodate(page))
 			nfs_readpage_to_fscache(inode, page, 0);
-		else if (!PageError(page) && !PagePrivate(page))
-			generic_error_remove_page(mapping, page);
 		unlock_page(page);
 	}
 	nfs_release_request(req);


