Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9477C21CA13;
	Sat,  7 Jun 2025 10:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290984; cv=none; b=bTm7cb4AvsvF9pkG8ENM7cEqqJf6M0tpnnmKEQusrQ43DDQkT4tGDNaAV9F2469aMxEQXwQA+6U0pYI6PSZ2vKlN2a+h8VN6fmXH2kcJHXxgyJm+hWTl7jz4PpCNLkCzs43S8tgoO63pxJY++xYPhAmQCCkvjpT6YY1Psk7iRpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290984; c=relaxed/simple;
	bh=1rTR0ydZB3BA1sU0flU48md95IhKhnr0OjiuQzKzOmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOwyw6T6G/dnDMvwTx/GEGKUFb497ESq5URiFRf/Jb8Mo7+mPR9Lw1d7DiK2UcF+4Kcuw9MV3GYbotUTlOm3fFy7BQZF1JEr566oIBa4LSSC+eFtZs1xKFfOD1CROsKft4/2Dhuul9+5cwN2edkb5SW5BVOODAQ3HYg3rlnWWo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LbJGz3r4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LbJGz3r4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259CDC4CEE4;
	Sat,  7 Jun 2025 10:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290984;
	bh=1rTR0ydZB3BA1sU0flU48md95IhKhnr0OjiuQzKzOmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LbJGz3r4/o/Toxhkv/Hi7TAgthop9xmykcqBH59PdtqUraVYJ/sMvMBmyZDRJffaM
	 JJJQy1psX7TcLHtNj1+K2nAk0Vox9TpfHHoj4K6AP0RQ/9jHLFJrQbmbKOKOA2Ajyo
	 qGN6t9BGDiZOf6xF6jqGfuWQUhVaLCEh/ehbAbAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH 6.14 09/24] orangefs: adjust counting code to recover from 665575cf
Date: Sat,  7 Jun 2025 12:07:49 +0200
Message-ID: <20250607100718.070158509@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
References: <20250607100717.706871523@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Marshall <hubcap@omnibond.com>

A late commit to 6.14-rc7 (665575cf) broke orangefs. This is a several line
adjustment to some counters needed to keep orangefs from deadlocking
when writing page cache data out to the filesystem.

Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/orangefs/inode.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -32,12 +32,13 @@ static int orangefs_writepage_locked(str
 	len = i_size_read(inode);
 	if (PagePrivate(page)) {
 		wr = (struct orangefs_write_range *)page_private(page);
-		WARN_ON(wr->pos >= len);
 		off = wr->pos;
-		if (off + wr->len > len)
+		if ((off + wr->len > len) && (off <= len))
 			wlen = len - off;
 		else
 			wlen = wr->len;
+		if (wlen == 0)
+			wlen = wr->len;
 	} else {
 		WARN_ON(1);
 		off = page_offset(page);
@@ -46,8 +47,6 @@ static int orangefs_writepage_locked(str
 		else
 			wlen = PAGE_SIZE;
 	}
-	/* Should've been handled in orangefs_invalidate_folio. */
-	WARN_ON(off == len || off + wlen > len);
 
 	WARN_ON(wlen == 0);
 	bvec_set_page(&bv, page, wlen, off % PAGE_SIZE);
@@ -340,6 +339,8 @@ static int orangefs_write_begin(struct f
 			wr->len += len;
 			goto okay;
 		} else {
+			wr->pos = pos;
+			wr->len = len;
 			ret = orangefs_launder_folio(folio);
 			if (ret)
 				return ret;


