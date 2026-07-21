Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D21946A5F6;
	Tue, 21 Jul 2026 17:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654883; cv=none; b=tGDHRACtUZOR4Yj++lZkK1BgUjLtkPC8W7IFeftkrJFGyn6rURRLpk5Xz0mErrxc675laA7FzIEJA56IPS7Ahjrrc6o8/an1gWAH93Rc89Uzt+0gtXgULe90g/dZ07hnDYGN/Hu4GFPxQU1c+ZKbn2aW0hhCdH6ikKxyTfZP1Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654883; c=relaxed/simple;
	bh=hvijwWVdEF5R346r2ykq9/TfL2pLN9KEuksK4XOti30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMu07NzpNPvB1nGnOz/WM2cxViN+tnPQGgPOAkjEmL6d2sqUrJ4iulL7EJ3HoCRjL6TSUL3rxPffiSwAS4h3Vvp+4xaWEE1SPB69KxOa+iFcFe6VHxysGPF0VnyOk01+1alk2TXkmPbQDlW4jwfE09sMD4Oq4xT1PDSz0eRcky4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QcCMjNzX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QcCMjNzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BB01F000E9;
	Tue, 21 Jul 2026 17:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654881;
	bh=f7nstWjL4kKsuVpJczP6bVm7dpiyUd4lv9QKXxlUdyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QcCMjNzXvE/FR5B7LbdZEkOxeZ0G0eH0BIj06TLrR1FM343Uae+TMdQk0iEKm8VRa
	 Q/zweljWC0p9xXlhn5msHmHZyYtT7WYXIqRdkX9aFu9dMhcebwj9nst1yYYoKxVuOV
	 worNYYFJdO1GSpCOjpjwShkJ4oXNWFkN795jQJnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.1 1846/2077] dm-bufio: fix wrong count calculation in dm_bufio_issue_discard
Date: Tue, 21 Jul 2026 17:25:19 +0200
Message-ID: <20260721152636.278435956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
@@ -2238,7 +2238,9 @@ int dm_bufio_issue_discard(struct dm_buf
 	struct dm_io_region io_reg = {
 		.bdev = c->bdev,
 		.sector = block_to_sector(c, block),
-		.count = block_to_sector(c, count),
+		.count = likely(c->sectors_per_block_bits >= 0) ?
+			count << c->sectors_per_block_bits :
+			count * (c->block_size >> SECTOR_SHIFT),
 	};
 
 	if (WARN_ON_ONCE(dm_bufio_in_request()))


