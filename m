Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9195473C9F;
	Fri,  7 Aug 2026 15:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117130; cv=none; b=oOXG0mKVxh/5w6ILyGC+X4nObqAFR7lX59vZm6uioIoDeHdZwX3RR8LSh20jDKVKA0ai3bbPJDDI3Sbl62dlc7GxBgpRlKgDekgfR+bR+/XMrKBPtFa9KMZJF8flre3RLeMBJ0DMx5k04Ok31mZXlWoWADptBlrCTtZDIA6wgWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117130; c=relaxed/simple;
	bh=+QUIVSjAnt8Pe+Gb8Rm8ZjPMfIDFf3c2vM97wRis9eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cs41ffM6cM5SAW3SCuEwQaxM8tVjGTho4PRoEphbX1rUwNIkDl91xRJU3F8vBgBjMcofXqMwDYs541PIdooSNhMwrM5MGQJ8aGbJyeg65HbuCjHS8Fre+Sf7fguIqXTcSttwY8Bm/eikO5vgki1CY+LwyDWX6O2vZd4eCsNGPFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GgchvPwx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GgchvPwx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 110501F000E9;
	Fri,  7 Aug 2026 15:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117128;
	bh=YqA8KxsOObTfll9E4Hyb1kzSuWt3H4IJvum+ZzlbnNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GgchvPwxvJL117RL5WCP47bz3r7Miu4I4uHVqtYa96pBaHEndDGRzyXvB2CLW5Yhl
	 kOfNdhKt+omJU757S/axUxRM2yROW1DmnY/xmkqmGnLfBK8Npwj0A79VzH/m+NbyGS
	 1MqPMifSu/xRHP5vOdztG6fyiaG7JT2LDD3OadKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <quwenruo.btrfs@gmx.com>,
	Qu Wenruo <wqu@suse.com>,
	Mykola Lysenko <nickolay.lysenko@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 7.1 208/438] btrfs: raid56: fix scrub read assembly submitting no reads
Date: Fri,  7 Aug 2026 16:36:44 +0200
Message-ID: <20260807143432.450127110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykola Lysenko <nickolay.lysenko@gmail.com>

commit c4c0673e4cb15b0c127e6d00732a2427bdd12c11 upstream.

Commit 5387bd958180 ("btrfs: raid56: remove sector_ptr structure")
converted the bio-list membership checks from sector pointers to
physical addresses. The two conversions in rmw_assemble_write_bios()
kept their polarity (skip the sector when it is NOT in the bio list,
i.e. when there is nothing to write), but scrub_assemble_read_bios()
has the opposite polarity -- skip the sector when it IS in the bio
list, because then there is nothing to read -- and the conversion
flipped it:

	-	sector = sector_in_rbio(rbio, stripe, sectornr, 1);
	-	if (sector)
	+	paddr = sector_paddr_in_rbio(rbio, stripe, sectornr, 1);
	+	if (paddr == INVALID_PADDR)
		continue;

Since a parity-scrub rbio's bio list only holds the empty completion
bio, the result is that scrub_assemble_read_bios() submits no reads at
all. finish_parity_scrub() then compares the parity it computes from
the (cached, correct) data stripes against whatever happens to be in
the freshly allocated, uninitialized stripe pages:

  - if the garbage differs from the computed parity, the sector is
    "repaired" and written back -- accidentally producing the correct
    on-disk result;

  - if a recycled page happens to still hold the old (correct) parity
    content, the sector is deemed clean, dropped from dbitmap, and the
    actually-corrupt on-disk parity is left in place. (Scrub reports
    no errors either way: there is no counter for P/Q corruption by
    design, so the bug here is purely the failure to read and repair.)

The second case is intermittent because it depends on page-allocator
recycling. Observed with fstests btrfs/297 (raid5, 2 devices): the
corrupted P stripe intermittently stays corrupt after a scrub --
roughly 1/10 runs on x86-64 KVM and up to 7/8 on a UML build whose
timing favors page reuse.

Since the bio-list check can never be true for a parity-scrub rbio --
raid56_parity_alloc_scrub_rbio() adds a single empty completion bio
(asserting bi_size == 0), bio_paddrs[] is only populated by
index_rbio_pages() which is never called for BTRFS_RBIO_PARITY_SCRUB,
and rbio_can_merge() refuses to merge rbios of different operations --
remove the dead check entirely and assert the invariant instead, as
suggested by Qu Wenruo.

After this fix the injected corruption is read, detected and repaired
in every run (8/8 UML, 10/10 KVM), and the new assertion never fires
across the full fstests raid group.

Fixes: 5387bd958180 ("btrfs: raid56: remove sector_ptr structure")
CC: stable@vger.kernel.org # 7.1+
Suggested-by: Qu Wenruo <quwenruo.btrfs@gmx.com>
Assisted-by: Claude:claude-fable-5
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Mykola Lysenko <nickolay.lysenko@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/raid56.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 3f2896e793e3..ca94c9e3d563 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -2911,13 +2911,12 @@ static int scrub_assemble_read_bios(struct btrfs_raid_bio *rbio)
 			continue;
 
 		/*
-		 * We want to find all the sectors missing from the rbio and
-		 * read them from the disk. If sector_paddr_in_rbio() finds a sector
-		 * in the bio list we don't need to read it off the stripe.
+		 * A parity-scrub rbio carries no data in its bio list: the
+		 * only bio there is the empty completion bio added by
+		 * raid56_parity_alloc_scrub_rbio().  Every sector is read
+		 * from the stripe, so only assert that invariant here.
 		 */
-		paddrs = sector_paddrs_in_rbio(rbio, stripe, sectornr, 1);
-		if (paddrs == NULL)
-			continue;
+		ASSERT(!sector_paddrs_in_rbio(rbio, stripe, sectornr, 1));
 
 		paddrs = rbio_stripe_paddrs(rbio, stripe, sectornr);
 		/*
-- 
2.55.0



