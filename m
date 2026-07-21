Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C481F2135AD;
	Tue, 21 Jul 2026 18:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658998; cv=none; b=eZ5JggrPhvJnrteM1bwibf4UzKmQrSUTcKeVoY3BGnqkaQfAPDJK1UIOUxcqb793/bGTuXbJt0pzS9hqdb8u4kx5zjgUf92fvQ8WoqBr49+tDtmxIdBHqd6BPaklCzUhr5UkdcSBrWrYKwYzOZ1kS8B8+dWlVp7asGjs7YhfHnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658998; c=relaxed/simple;
	bh=+oLhFgUXzoUsjboCO4T4MDthn/8iduFF/36IEwaxK+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWhmKTKDiICbO6D56TIV2OoNSpAZZKY5vh4rfjuc0/RPm0BpFgOdQ0aPR/xoLrOJv6V+5ALNmJ++2Ra+K/O00r+kXEDFltQyHEL/qubt6bOsOti66tALFWM0W8yEAGb8V+xdCbSfCkeSbwV75CJsDfzt+fOOjO15HraiejjQFOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6KQSFoG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6KQSFoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F6481F000E9;
	Tue, 21 Jul 2026 18:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658997;
	bh=XdRj8ZEPkF3tLmy7NUGEARgS+i/N5D0FB9Vo2qza/3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6KQSFoGUgnjzaF1EFOs+WwikJ6pe8Xe6xErPlydvH6+tqN3xlTwX5Gof/6fa4DW+
	 3Ue8XHZYjz5dbGlkcyWbf2K6RYPnfg/zHk4pZQ/2r/R8SErQi3BYzsZRtcsGqUqTz3
	 8UZ/B9EUMa5bnsJarTjQ4CYBMkfMeCBxnQQNBEbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.18 1356/1611] dm-integrity: fix a bug if the bio is out of limits
Date: Tue, 21 Jul 2026 17:24:32 +0200
Message-ID: <20260721152545.957114649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 5a266764fadaff8b5c1fe37a186ebf9b09cb953e upstream.

If dm_integrity_check_limits fails, the code would exit with
DM_MAPIO_KILL. However, the range would be already locked at this point,
and it wouldn't be unlocked, resulting in a deadlock. Let's move the
limit check up, so that when it exits, no resources are leaked.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4.6
Fixes: fb0987682c62 ("dm-integrity: introduce the Inline mode")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-integrity.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2522,6 +2522,9 @@ static int dm_integrity_map_inline(struc
 	if (unlikely((bio->bi_opf & REQ_PREFLUSH) != 0))
 		return DM_MAPIO_REMAPPED;
 
+	if (unlikely(!dm_integrity_check_limits(ic, bio->bi_iter.bi_sector, bio)))
+		return DM_MAPIO_KILL;
+
 retry:
 	if (!dio->integrity_payload) {
 		unsigned digest_size, extra_size;
@@ -2586,10 +2589,6 @@ skip_spinlock:
 
 	dio->bio_details.bi_iter = bio->bi_iter;
 
-	if (unlikely(!dm_integrity_check_limits(ic, bio->bi_iter.bi_sector, bio))) {
-		return DM_MAPIO_KILL;
-	}
-
 	bio->bi_iter.bi_sector += ic->start + SB_SECTORS;
 
 	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);


