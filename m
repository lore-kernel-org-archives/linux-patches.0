Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7D21C861A;
	Tue, 31 Mar 2026 16:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975334; cv=none; b=RtAPhuRB7umxb3Fq22mQj1iC5GuavaMRquHGdKuLrPm6kItTPnVPxn40cagihHJO6ykHArE0F8/f2m7JA91Qi37CGOh4w86dFGCGrTDOlXYQgXIdA+7IlY3faVv+0PyvZ8UEaV8GSHs+4KIPTyl+nnA81rsJ41o24qwkbZSYr80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975334; c=relaxed/simple;
	bh=hN/QO3R8uIQ0eePPb7M7vngSJjOvdvGUur7KzjBOvpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sr4mJ5BJbw+g1p9X75CJn1Kh9Ka/BVw4iGreI/wLi+X0VSd/M6LDPWVHefRprNZdQOd5alA/q20fTN7RWCD0Wf98OhrN5vBFr9uqfjzm8f4KvHwuINKPi04rB+L/dEuIjXCEEItKoHBNU3fTMEMPeg7XfiAX/3xJJu5FIJd+JG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uL2Sr1L8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uL2Sr1L8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13387C19423;
	Tue, 31 Mar 2026 16:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975334;
	bh=hN/QO3R8uIQ0eePPb7M7vngSJjOvdvGUur7KzjBOvpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uL2Sr1L8nv8MMT4TQ08/O49ky4Gdsmh/xjk0qrpcLEVnb4pg9lPvEbWUXxvoDo14k
	 5doITN1XywqJafssyRM65W7eC9aucDhNTsESoOilHSbSgcw7hJqd/zdYtoxAqZYLAS
	 JAZCSinQKYo5GRLxY21IfJi8ohTlMW39Q06Mh5tQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.19 254/342] iomap: fix invalid folio access when i_blkbits differs from I/O granularity
Date: Tue, 31 Mar 2026 18:21:27 +0200
Message-ID: <20260331161808.302172556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joanne Koong <joannelkoong@gmail.com>

commit bd71fb3fea9945987053968f028a948997cba8cc upstream.

Commit aa35dd5cbc06 ("iomap: fix invalid folio access after
folio_end_read()") partially addressed invalid folio access for folios
without an ifs attached, but it did not handle the case where
1 << inode->i_blkbits matches the folio size but is different from the
granularity used for the IO, which means IO can be submitted for less
than the full folio for the !ifs case.

In this case, the condition:

  if (*bytes_submitted == folio_len)
    ctx->cur_folio = NULL;

in iomap_read_folio_iter() will not invalidate ctx->cur_folio, and
iomap_read_end() will still be called on the folio even though the IO
helper owns it and will finish the read on it.

Fix this by unconditionally invalidating ctx->cur_folio for the !ifs
case.

Reported-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Link: https://lore.kernel.org/linux-fsdevel/b3dfe271-4e3d-4922-b618-e73731242bca@wdc.com/
Fixes: b2f35ac4146d ("iomap: add caller-provided callbacks for read and readahead")
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Link: https://patch.msgid.link/20260317203935.830549-1-joannelkoong@gmail.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -506,6 +506,7 @@ static int iomap_read_folio_iter(struct
 	loff_t length = iomap_length(iter);
 	struct folio *folio = ctx->cur_folio;
 	size_t folio_len = folio_size(folio);
+	struct iomap_folio_state *ifs;
 	size_t poff, plen;
 	loff_t pos_diff;
 	int ret;
@@ -517,7 +518,7 @@ static int iomap_read_folio_iter(struct
 		return iomap_iter_advance(iter, length);
 	}
 
-	ifs_alloc(iter->inode, folio, iter->flags);
+	ifs = ifs_alloc(iter->inode, folio, iter->flags);
 
 	length = min_t(loff_t, length, folio_len - offset_in_folio(folio, pos));
 	while (length) {
@@ -548,11 +549,15 @@ static int iomap_read_folio_iter(struct
 
 			*bytes_submitted += plen;
 			/*
-			 * If the entire folio has been read in by the IO
-			 * helper, then the helper owns the folio and will end
-			 * the read on it.
+			 * Hand off folio ownership to the IO helper when:
+			 * 1) The entire folio has been submitted for IO, or
+			 * 2) There is no ifs attached to the folio
+			 *
+			 * Case (2) occurs when 1 << i_blkbits matches the folio
+			 * size but the underlying filesystem or block device
+			 * uses a smaller granularity for IO.
 			 */
-			if (*bytes_submitted == folio_len)
+			if (*bytes_submitted == folio_len || !ifs)
 				ctx->cur_folio = NULL;
 		}
 


