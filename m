Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1901D3E49F5;
	Tue, 21 Jul 2026 22:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674351; cv=none; b=ANuTzXS1o1s8czTpvRlnmP2YhXgDCQ9If6WqFkUfH6nutPawtUmWsXbTFi0Dc2f4zkr4aO81Kr8f9NZ5n/DPgQaXtr/GrJ6XjwcNqJODXxm8AQS6a3qWmRsIQujTzwtuY3qktjHPeBhev7zdDsk2dXjkiJeb+GhlH9kUgjcwDhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674351; c=relaxed/simple;
	bh=rgxxAqyqS33hdnFsyKA8TS31FYWVBEdab7wNIK+pKqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUOYmhuk9MrA56eNfkb2hZQNLTaAjOODINmaUZNGHb9mwje8ljNQ+wyz4IPpki9p1gITeaRYvsyzSpNmu6sWGXcJaeqt8o2qXtJK/gPuc9wtJwEUM1gmQyZeK+9BcJp8pvCsZ5pFwpNtEINTrF/LLbCAn5Ueougg5phRoYarGb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVn7IFy0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVn7IFy0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F36B1F000E9;
	Tue, 21 Jul 2026 22:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674350;
	bh=D6GOoRiBb4wD1wAn6Cj873/cTh/QfCGmGGq5cLKHP8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVn7IFy0QSYXEx3rAjYz/Oy4YH8IuwRZCBijy4DNJ6x8DiMt1ZZa4KQhJ6RIYAI2k
	 /9AXr3d4EnMCO0dvrCvHnO2yHbie7PHmd6v6i5/L7FAJSNVdP+9OofuZuP4dpQ+TrD
	 hQIK7WZsFYOLBWmz7Bfv8rPxnFPQhBRimnWoe21M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.10 509/699] dm-bufio: fix wrong count calculation in dm_bufio_issue_discard
Date: Tue, 21 Jul 2026 17:24:28 +0200
Message-ID: <20260721152407.177429271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1375,7 +1375,9 @@ int dm_bufio_issue_discard(struct dm_buf
 	struct dm_io_region io_reg = {
 		.bdev = c->bdev,
 		.sector = block_to_sector(c, block),
-		.count = block_to_sector(c, count),
+		.count = likely(c->sectors_per_block_bits >= 0) ?
+			count << c->sectors_per_block_bits :
+			count * (c->block_size >> SECTOR_SHIFT),
 	};
 
 	BUG_ON(dm_bufio_in_request());


