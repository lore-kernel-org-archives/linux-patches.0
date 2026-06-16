Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C897A47AF5F;
	Tue, 16 Jun 2026 17:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631543; cv=none; b=m4kCwsIoM/KByh8vAvfKBBUzbhE6anLw8E22jFIIEa2cc929RqdQxOcQN39IAXdFocu9t8QGoKT0WtChiPJ/8vwrGg945VfNf4nYkICEHxcF5i49tg2gifI5T6f5yPrGzao3DLmpLCqcM5WsLGTJOjQEQFxPgK2hi6syJQPE+rE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631543; c=relaxed/simple;
	bh=GSwWbXs8P9R8aWIxeKY1MnfnSsRq3rtWHxJK7DZDwGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1NyAkrIO5ersT7C/QwmRn1KXnj5sfhNJjS5xV6//+kis2BSDV6g07IRzCAN37sGaYgvzY9aayIYbPt6eGWcbU/g/C/w5/85nYWhjLSzo3kCVUKCT9u3GXj1YA/Y5AIBTx0nDsR2Yxgt4gFgkrUlycFNHqUNFPTYKogPZ8dG84c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xi0l/qm/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xi0l/qm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A641F000E9;
	Tue, 16 Jun 2026 17:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631542;
	bh=39hU1MKv8G6nhGDWAoKnP/UQINX41V15RWRmLufg2l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xi0l/qm/6NYrSuUCgMBlL6BDUGxi5PaYoR7+EpmjwF+hj/nyT3n+tOZSd9q9ENEaM
	 RHzU24sLdKYCI5395jcOBndoGHLU2PfstTXarHbvpsXgIw8aO+jmmzzsi9153yvFOt
	 NTXT2J32bZj+ldF0j7GhtjXysaT0EYB8D7GCyH7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregg Leventhal <gleventhal@janestreet.com>,
	Eric Hagberg <ehagberg@janestreet.com>,
	Brian Foster <bfoster@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 239/522] iomap: dont revert iov_iter on partially completed buffered writes
Date: Tue, 16 Jun 2026 20:26:26 +0530
Message-ID: <20260616145137.165861985@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Foster <bfoster@redhat.com>

Gregg reports that the iomap retry behavior for nonblocking (nowait)
append writes is broken. The problem occurs when an append write is
first submitted in non-blocking mode (i.e. via io_uring), partially
completes before hitting -EAGAIN, and then is resubmitted from
blocking context.

The specific problem is that at least one iteration of the loop in
iomap_write_iter() completes in non-blocking context and thus has
bumped i_size. The next iteration hits -EAGAIN, reverts the iov_iter
and returns. io_uring retries the entire append write from blocking
context, but since i_size has already been increased, the data that
was partially written on the first attempt is rewritten at the new
i_size. This is essentially an intra-write data corruption since the
data written to the file does not reflect the write from userspace.

This problem is already fixed on master as of commit 1a1a3b574b97
("iomap: advance the iter directly on buffered writes"). That commit
was primarily intended to clean up iomap iter state tracking, but it
also happened to remove the iov_iter revert and thus accidentally
fix this problem as well. Without the revert, iomap will commit
partial progress internally and loop once more before it more than
likely hits -EAGAIN and returns partial progress consistent with the
inode updates. This means the blocking retry from io_uring will pick
up where the first attempt left off at the current i_size and
perform the remainder of the write correctly.

Cc: <stable@vger.kernel.org>
Fixes: 18e419f6e80a ("iomap: Return -EAGAIN from iomap_write_iter()")
Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
Reported-by: Eric Hagberg <ehagberg@janestreet.com>
Signed-off-by: Brian Foster <bfoster@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index c3408ba636632a..243cb2ec76ed2e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -821,10 +821,6 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		length -= status;
 	} while (iov_iter_count(i) && length);
 
-	if (status == -EAGAIN) {
-		iov_iter_revert(i, written);
-		return -EAGAIN;
-	}
 	return written ? written : status;
 }
 
-- 
2.53.0



