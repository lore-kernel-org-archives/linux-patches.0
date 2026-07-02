Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC47433E87;
	Thu,  2 Jul 2026 16:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011591; cv=none; b=lLySKEUJt2/VIbK0qelYjmywMIp9VOa/LIyq/15IBBc1OTZcUbI/BdqrIVDr3Ifhl3NjYJQVzpyCwKSxeKO1CIEaJfqkrXR1bOF9CSmK7VkhzwsbG0T6okhKpxx0SEEoSilYNGivpMdmMmzUXSDRjup8AJJ3vzPkalI6034Dkb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011591; c=relaxed/simple;
	bh=RoFvOg+DiInAI9DD3wtSv/ma3Bx86e82kAxXLiNe9sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USE0M//6Jqvn7oCfcOOnlaOOuqOuoDp0g+OWH1ifzPC1kKk715iyzDNsGOi5w2YzhiOmAY5zm7a71utI2LgnSaTz8J2K0Xj3XxZU2wOoqjar4Chpbykcqx2K+WJk8wGPzIgOu08Y9HQEsbYhm8xH/6oaWysDShjQIWvfmQXLt08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a5PIINNC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a5PIINNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E12B1F00A3A;
	Thu,  2 Jul 2026 16:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011590;
	bh=yqx9mBlJC4mh0t3DaeRfhSuw590oPHC81b//5TU6hWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a5PIINNCjz26Me+ivM/DaOc36eT8DIXXyYeFC5Xn059awJ19+QeTEZQmIlKxMstBM
	 wrKinksUXCRIakExj0IYFDE91wg8nwhWsn8/fwJZ8caovaJRKWkJtXD9K05ZeHu7p5
	 osNwWI3wlpblY3Rga7nfKTvw+SUd2SnDlthZaA2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.1 059/120] f2fs: fix missing read bio submission on large folio error
Date: Thu,  2 Jul 2026 18:20:55 +0200
Message-ID: <20260702155114.183965302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

From: Wenjie Qi <qiwenjie@xiaomi.com>

commit 74c8d2ec95c59a5651ecd975c466998af1961fd4 upstream.

f2fs_read_data_large_folio() can keep a read bio across multiple
readahead folios.  If a later folio hits an error before any of its
blocks are added to the bio, folio_in_bio is false and the current error
path returns immediately after ending that folio.

This can leave the bio accumulated for earlier folios unsubmitted.  Those
folios then never receive read completion, and readers can wait
indefinitely on the locked folios.

Route errors through the common out path so any pending bio is submitted
before returning.  Stop consuming more readahead folios once an error is
seen, and only wait on and clear the current folio when it was actually
added to the bio.

Cc: stable@kernel.org
Fixes: a5d8b9d94e18 ("f2fs: fix to unlock folio in f2fs_read_data_large_folio()")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/data.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2495,7 +2495,7 @@ static int f2fs_read_data_large_folio(st
 	unsigned nrpages;
 	struct f2fs_folio_state *ffs;
 	int ret = 0;
-	bool folio_in_bio;
+	bool folio_in_bio = false;
 
 	if (!IS_IMMUTABLE(inode) || f2fs_compressed_file(inode)) {
 		if (folio)
@@ -2611,18 +2611,17 @@ submit_and_realloc:
 	}
 	trace_f2fs_read_folio(folio, DATA);
 err_out:
-	if (!folio_in_bio) {
+	if (!folio_in_bio)
 		folio_end_read(folio, !ret);
-		if (ret)
-			return ret;
-	}
+	if (ret)
+		goto out;
 	if (rac) {
 		folio = readahead_folio(rac);
 		goto next_folio;
 	}
 out:
 	f2fs_submit_read_bio(F2FS_I_SB(inode), bio, DATA);
-	if (ret) {
+	if (ret && folio_in_bio) {
 		/* Wait bios and clear uptodate. */
 		folio_lock(folio);
 		folio_clear_uptodate(folio);


