Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EDD46EF61;
	Tue, 21 Jul 2026 22:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672517; cv=none; b=aZnQLXnSnXvfOu3urhjUCqdHNsH5A4sEShlt0QGmy44XqIxsT1Xe8d/D4/E1D32tLvflxDIW5FQzmXoYSoKy4EoGkqBRVxO8LFfCojIMz19ZlE//LdkqqUBb30W9osZrk0CRrYU9yprlP/oARTcleIEx1QLdxrpC8SXSjD+jEYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672517; c=relaxed/simple;
	bh=j+B5Jy7pw1eV3NAbnxGojs1hxLOf4NggKr8GYy30+6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Njng8UfyO+cElhBkEsWTqYZjz4yFc2FJe/jrd0phgsCG2a3MT+4tUDP8OL2YXQWnvpUpRic2BOrx0g08NI71N4Wt/xF8AmsCR58CQvgG8NY1mKxYnaElbgj1fnQuqFRYtJmZQjQ8Rpgp08vHR7VO9NfuppT/X4FRzlvgG9dt5Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnnOnouo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnnOnouo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2484C1F000E9;
	Tue, 21 Jul 2026 22:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672515;
	bh=/yquZgh4JCiuurpa+6f8CqWp1QHd/qXTz1cZeN2G0Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnnOnouonuBU/VXVOSSt8E4TW7D28gSHtOqrxDiOHlm2nGkcD344veiivbeGsQJeS
	 7ZZEAXGq9WHspxltqhZbQ07NYS9kn3n2RvnFo5lwPCfOkvMKf5VIfiRsI94o8Cwyt6
	 m3UtopVX6Dm30bVneijRGv7MF2D4jZqKXtXmo8fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 654/843] dm-bufio: fix wrong count calculation in dm_bufio_issue_discard
Date: Tue, 21 Jul 2026 17:24:49 +0200
Message-ID: <20260721152420.779867221@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


