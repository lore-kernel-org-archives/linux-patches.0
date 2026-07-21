Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C4A47044D;
	Tue, 21 Jul 2026 19:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663921; cv=none; b=Es68/U88akVZyPIrUkxAGedXen3bcvhN0qpJ97A3n+s0MSvaMIHuufFNRXDb0FUvOB4CpV8vbRSOA2fcK50qnSkaeep0YnZQ23gmy9xvf055IA41ZBa+mAO10M18YCck1EciVwUdbcwiqPTBezdg9g6AL1Gs4Ig7orLIzwTnSzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663921; c=relaxed/simple;
	bh=EOsMjj1M7m1Aj0f9mPFrymQNrTOwdBad5NbkKJ2vK1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Grg8X037sCjDvqQZ00m7OAMasrJ/hoNMteb0gKv6FXK980eu0yXqpCKPFQWUpkb3VsSAZSYgdgOnhKKIxXtn6NrCAggmhj71Pwe4P25o75q6/3awRVayIlwaOwjrppHm3dBSPEABPhBjE0MTMFmR6mUF/6N1TOXFCy9xH1KtMR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCZdlP60; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCZdlP60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4715A1F00A3D;
	Tue, 21 Jul 2026 19:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663916;
	bh=gmV0OSgwPpr0bcvJYtNf0Ti2zcQRvyQP6g5y2eo8YVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VCZdlP60Ql5QsvcGmlnNloiN0pI2neORJ00KQ+n0Kw0KxwflT9u9cYQi6tRhiehsm
	 O2Q1OOxtlW8H7zGw6+Hc3KYs0hrEIr2P9TSclDXhM9W7pIJpqYs22M/PVAg4OtaCSG
	 Lxe7yJttlPbVaS5LzNPuciHzufC4ygifrX69QAkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 1003/1276] dm-bufio: fix wrong count calculation in dm_bufio_issue_discard
Date: Tue, 21 Jul 2026 17:24:06 +0200
Message-ID: <20260721152508.455639683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 422f1d4f141eaa3a6e4199ceec86cc6b9bf26570 upstream.

block_to_sector converts a block number to a sector number and adds
c->start to the result. It is inappropriate to use this function for
converting the number of blocks to a number to sectors because c->start
would be incorrectly added to the result.

Luckily, the only target that uses dm_bufio_issue_discard is dm-ebs,
which sets c->start to 0, so this bug is latent.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: 6fbeb0048e6b ("dm bufio: implement discard")
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-bufio.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2216,7 +2216,9 @@ int dm_bufio_issue_discard(struct dm_buf
 	struct dm_io_region io_reg = {
 		.bdev = c->bdev,
 		.sector = block_to_sector(c, block),
-		.count = block_to_sector(c, count),
+		.count = likely(c->sectors_per_block_bits >= 0) ?
+			count << c->sectors_per_block_bits :
+			count * (c->block_size >> SECTOR_SHIFT),
 	};
 
 	if (WARN_ON_ONCE(dm_bufio_in_request()))


