Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87639307492;
	Thu, 20 Aug 2026 17:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247634; cv=none; b=DyTCUQ1ZSxtugHWuiqPayzf9y7YZx46cN4JOSJkSNSqnUh0zTAjS02QufYCcYpZG7dqFEK7zNHhOwfGbMUOSOlvEVUP4bCLMx2M/mZAijlyU8j8xTeapH1PV3lExbc2WEJAi/FFffSN5XlcOVmaL8nlHDiZckPiWNdksTZAFOok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247634; c=relaxed/simple;
	bh=6LrY2XupXVCqoEXJ7+l2tYsk4s5nJ5qqXLIqJbqE7kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fp1I4BUW6irtYezluxpFEzWfK93573iGj3o8RkYQc0Fjo3PPD1wMNq5dSvTnEPE5D3aT7p+qWIj/wr9SLLoWYwkv/KQvRVw39CnupxW6VagQkoGeULKMJf3h4nR1dIvu9xjRfRfEeLdUg5s5lZFLzVtYgOB1vzTxAuPtWtecjGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArCUdZ4T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArCUdZ4T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F7C1F000E9;
	Thu, 20 Aug 2026 17:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247632;
	bh=1OloWyQqSbptLORZuTh0sW02sZxUyb/LyvsLbjw2wkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArCUdZ4TVxddQEc4KXQIA5S0L1BIHDZaZ87xYuTSQntwA7Ns4uyyzjEMJVvRGkKpW
	 ej6Eae8PkmLfXgGycCeYBU5lBumVy4FvrQjGPtG1B/wVyP/JrOKpAhgsbVa/3ZCRN2
	 RuUzDdEBXj/Zm0Bl6eVrxANwpgcj54rjGqZyl8rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Theodore Tso" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Matt Turner <mattst88@gmail.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/166] iomap: hold state_lock over call to ifs_set_range_uptodate()
Date: Thu, 20 Aug 2026 16:55:36 +0200
Message-ID: <20260820145213.462302350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit 279d5fc3227f04ef2c6125e5c440e7952173a89a ]

Patch series "Add folio_end_read", v2.

The core of this patchset is the new folio_end_read() call which
filesystems can use when finishing a page cache read instead of separate
calls to mark the folio uptodate and unlock it.  As an illustration of its
use, I converted ext4, iomap & mpage; more can be converted.

I think that's useful by itself, but the interesting optimisation is that
we can implement that with a single XOR instruction that sets the uptodate
bit, clears the lock bit, tests the waiter bit and provides a write memory
barrier.  That removes one memory barrier and one atomic instruction from
each page read, which seems worth doing.  That's in patch 15.

The last two patches could be a separate series, but basically we can do
the same thing with the writeback flag that we do with the unlock flag;
clear it and test the waiters bit at the same time.

This patch (of 17):

This is really preparation for the next patch, but it lets us call
folio_mark_uptodate() in just one place instead of two.

Link: https://lkml.kernel.org/r/20231004165317.1061855-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20231004165317.1061855-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 9c7d8f7c8994 ("iomap: fix out-of-bounds bitmap_set() with zero-length range")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/iomap/buffered-io.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -57,30 +57,32 @@ static inline bool ifs_block_is_uptodate
 	return test_bit(block, ifs->state);
 }
 
-static void ifs_set_range_uptodate(struct folio *folio,
+static bool ifs_set_range_uptodate(struct folio *folio,
 		struct iomap_folio_state *ifs, size_t off, size_t len)
 {
 	struct inode *inode = folio->mapping->host;
 	unsigned int first_blk = off >> inode->i_blkbits;
 	unsigned int last_blk = (off + len - 1) >> inode->i_blkbits;
 	unsigned int nr_blks = last_blk - first_blk + 1;
-	unsigned long flags;
 
-	spin_lock_irqsave(&ifs->state_lock, flags);
 	bitmap_set(ifs->state, first_blk, nr_blks);
-	if (ifs_is_fully_uptodate(folio, ifs))
-		folio_mark_uptodate(folio);
-	spin_unlock_irqrestore(&ifs->state_lock, flags);
+	return ifs_is_fully_uptodate(folio, ifs);
 }
 
 static void iomap_set_range_uptodate(struct folio *folio, size_t off,
 		size_t len)
 {
 	struct iomap_folio_state *ifs = folio->private;
+	unsigned long flags;
+	bool uptodate = true;
+
+	if (ifs) {
+		spin_lock_irqsave(&ifs->state_lock, flags);
+		uptodate = ifs_set_range_uptodate(folio, ifs, off, len);
+		spin_unlock_irqrestore(&ifs->state_lock, flags);
+	}
 
-	if (ifs)
-		ifs_set_range_uptodate(folio, ifs, off, len);
-	else
+	if (uptodate)
 		folio_mark_uptodate(folio);
 }
 


