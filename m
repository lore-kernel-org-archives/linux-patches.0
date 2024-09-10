Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE0318B487;
	Tue, 10 Sep 2024 09:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961359; cv=none; b=a145PifLbQNEVCp/PWjHbCXlS1uJYQbW5btzxI9aoxfKEWDadzNqutl2a6MvLMfBry0hx1CiVI3jglOOFvRtdR163xwXtuQIW+Tox08Ysyt5Cl1S5ura5NKeWeL0ZUGQaqF5zhDaubJS/ziF38M+IBu44qUNN7FpZLnLScJpbXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961359; c=relaxed/simple;
	bh=NFL1xzmmx2/jWQpPOzDINsXZjltTjW5mKhtAfT5ZyHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tTXPVSeY6VgAjVhv+85e4sAgM81Mvu670iQD/Hc2NQXiwN8YYX4II68g5GZdCtn4LeCT2lQxAEZB1uNvnZy4jnNH6MPO6NU0jyeHpwbQJ+nJWwT0/omkA1irqBQ0HCxNgtQnfXhGhHSkI623O1tWZaODtBR/jMIbrNmGvq/lsyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vm7HgAVw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vm7HgAVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79421C4CEC3;
	Tue, 10 Sep 2024 09:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961358;
	bh=NFL1xzmmx2/jWQpPOzDINsXZjltTjW5mKhtAfT5ZyHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vm7HgAVw5CYkDZrDui7+fZzo88V/2naKK2OpBsWWHNmv4i8CJEpTpoDOBImG7LZQN
	 99qMFDPi7U4ng4fFXmQ/1uwlhF+tUVajQfvmd6k1ZTDHErrnhEH0Wa6TXeQmFwoDJf
	 Qb/lWTQnzEzD6bWUubV6PV0vi/YIEBsRSkksHnNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=BCrg=20Billeter?= <j@bitron.ch>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 6.10 042/375] fuse: clear PG_uptodate when using a stolen page
Date: Tue, 10 Sep 2024 11:27:19 +0200
Message-ID: <20240910092623.655012129@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit 76a51ac00ca2a72fe3e168b7fb0e70f75ba6f512 upstream.

Originally when a stolen page was inserted into fuse's page cache by
fuse_try_move_page(), it would be marked uptodate.  Then
fuse_readpages_end() would call SetPageUptodate() again on the already
uptodate page.

Commit 413e8f014c8b ("fuse: Convert fuse_readpages_end() to use
folio_end_read()") changed that by replacing the SetPageUptodate() +
unlock_page() combination with folio_end_read(), which does mostly the
same, except it sets the uptodate flag with an xor operation, which in the
above scenario resulted in the uptodate flag being cleared, which in turn
resulted in EIO being returned on the read.

Fix by clearing PG_uptodate instead of setting it in fuse_try_move_page(),
conforming to the expectation of folio_end_read().

Reported-by: Jürg Billeter <j@bitron.ch>
Debugged-by: Matthew Wilcox <willy@infradead.org>
Fixes: 413e8f014c8b ("fuse: Convert fuse_readpages_end() to use folio_end_read()")
Cc: <stable@vger.kernel.org> # v6.10
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index a11461ef6022..67443ef07285 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -775,7 +775,6 @@ static int fuse_check_folio(struct folio *folio)
 	    (folio->flags & PAGE_FLAGS_CHECK_AT_PREP &
 	     ~(1 << PG_locked |
 	       1 << PG_referenced |
-	       1 << PG_uptodate |
 	       1 << PG_lru |
 	       1 << PG_active |
 	       1 << PG_workingset |
@@ -820,9 +819,7 @@ static int fuse_try_move_page(struct fuse_copy_state *cs, struct page **pagep)
 
 	newfolio = page_folio(buf->page);
 
-	if (!folio_test_uptodate(newfolio))
-		folio_mark_uptodate(newfolio);
-
+	folio_clear_uptodate(newfolio);
 	folio_clear_mappedtodisk(newfolio);
 
 	if (fuse_check_folio(newfolio) != 0)
-- 
2.46.0



