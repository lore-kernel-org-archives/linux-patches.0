Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8F1296D3C;
	Mon, 12 May 2025 17:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071767; cv=none; b=LcHcvtyJWz5bfQ3dYiXy1MUhhXV+DInYM7nZyMgVlGGjJvp614m2pwP2yzyXIcFRoi4XUojzAsPwPJSj1JkNdrpFqdpIp92vhf82i/igmCBzZHZ5BshRUg7qHSbK0zdanimYVJ+CbHNFeETFrVNxJHalU4YYZbC9YLTMiQnK4yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071767; c=relaxed/simple;
	bh=7bgAWczTkDZsKezQ8pB8ukTG912n/RHOBJrcg2Jox/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eu6/zN9o3rWzeRu3siLt98CVmT4ZZOn/Km/Se0ytXU2sXOgdv7dbxGlLZJc3heGvtICgzZIcontYURIwRg/gcgckQTwp0SqAe53c1etdTAFo9GjyprkLvAni3FFag8Zh+6OsB24in+586fklgfAWrcHcbcYw1+EeG7or7c3Z/+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZGWX1+Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZGWX1+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F2CC4CEE7;
	Mon, 12 May 2025 17:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071767;
	bh=7bgAWczTkDZsKezQ8pB8ukTG912n/RHOBJrcg2Jox/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZGWX1+ZsHix6HFz1R28gpRw2gMTB1G8mnqRVw4WiLyDXefFWFxNxqa4Yz5hVG1Gm
	 NjG5Ec6X4zj6cD0z8oULcK8TLrpSx+DoeNG52pPcMWZgd5nfzO5Qk3cecNb+IRLBXy
	 BitjTj7C6yb1tT6uAgDv68OPkHQth0dl2C5ZDfws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Gao Xiang <xiang@kernel.org>,
	Hongbo Li <lihongbo22@huawei.com>
Subject: [PATCH 6.14 002/197] fs/erofs/fileio: call erofs_onlinefolio_split() after bio_add_folio()
Date: Mon, 12 May 2025 19:37:32 +0200
Message-ID: <20250512172044.439910580@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

commit bbfe756dc3062c1e934f06e5ba39c239aa953b92 upstream.

If bio_add_folio() fails (because it is full),
erofs_fileio_scan_folio() needs to submit the I/O request via
erofs_fileio_rq_submit() and allocate a new I/O request with an empty
`struct bio`.  Then it retries the bio_add_folio() call.

However, at this point, erofs_onlinefolio_split() has already been
called which increments `folio->private`; the retry will call
erofs_onlinefolio_split() again, but there will never be a matching
erofs_onlinefolio_end() call.  This leaves the folio locked forever
and all waiters will be stuck in folio_wait_bit_common().

This bug has been added by commit ce63cb62d794 ("erofs: support
unencoded inodes for fileio"), but was practically unreachable because
there was room for 256 folios in the `struct bio` - until commit
9f74ae8c9ac9 ("erofs: shorten bvecs[] for file-backed mounts") which
reduced the array capacity to 16 folios.

It was now trivial to trigger the bug by manually invoking readahead
from userspace, e.g.:

 posix_fadvise(fd, 0, st.st_size, POSIX_FADV_WILLNEED);

This should be fixed by invoking erofs_onlinefolio_split() only after
bio_add_folio() has succeeded.  This is safe: asynchronous completions
invoking erofs_onlinefolio_end() will not unlock the folio because
erofs_fileio_scan_folio() is still holding a reference to be released
by erofs_onlinefolio_end() at the end.

Fixes: ce63cb62d794 ("erofs: support unencoded inodes for fileio")
Fixes: 9f74ae8c9ac9 ("erofs: shorten bvecs[] for file-backed mounts")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Gao Xiang <xiang@kernel.org>
Tested-by: Hongbo Li <lihongbo22@huawei.com>
Link: https://lore.kernel.org/r/20250428230933.3422273-1-max.kellermann@ionos.com
Signed-off-by: Gao Xiang <xiang@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/fileio.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -150,10 +150,10 @@ io_retry:
 				io->rq->bio.bi_iter.bi_sector = io->dev.m_pa >> 9;
 				attached = 0;
 			}
-			if (!attached++)
-				erofs_onlinefolio_split(folio);
 			if (!bio_add_folio(&io->rq->bio, folio, len, cur))
 				goto io_retry;
+			if (!attached++)
+				erofs_onlinefolio_split(folio);
 			io->dev.m_pa += len;
 		}
 		cur += len;


