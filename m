Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9679415F13;
	Tue, 21 Jul 2026 21:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670320; cv=none; b=rNdBErmhUf80Q2EbsFMDe2IrQdkuLqOrwtCjNUNfAJ208B9ZEaeOHE22np+CbEVbhNPHaHtYtuzsGXjE1J97D7wqaGQOMTIfnrq4QPuawtJKsIcWrVGNKh3XZ5zzF1Ne3L5z5BzrUya6xq3LtjGqhRxpGPWw/unkoD41GiZzFBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670320; c=relaxed/simple;
	bh=XFeSrvC7C/iPRpD42XF0u7XrsxPmo/5edho8GDwXdd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kyz+i/goTe/MxDq5RrHZFyJVrdMZUcbArCV0chx6u8FLtKNiiF/CwecmNO2BOPwPv6v7ocKXZBKy2dnmATdK5857bIsJce6qSPh4N5OCM7owD+BuGdE4SfIzbT6NwZZz6VNGnKUpBx9Qo1TQ66bRXqtSzMU+MFAdkgjjJWeb7HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3amEAfE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3amEAfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6AB1F000E9;
	Tue, 21 Jul 2026 21:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670319;
	bh=HpqTllSnJWg3oYQK9x8k7MzfsF9EMEaC0SkKvWFiwoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k3amEAfEmTAsS5Irr3Sr8v6olF2ZtFqMPWVHGizk2cPDgQu/g7OparTRNJec3APcl
	 18+xvI+96VZE8FHTCdnPoChluVyAkutI9n6I/hBpucbHaKWG8QXb5/Gbuuv1ATcpLA
	 sKE9jzCN2NicEBFUPE46ZQQw5sBri3ruDuf/q2DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 0845/1067] dm-bufio: fix wrong count calculation in dm_bufio_issue_discard
Date: Tue, 21 Jul 2026 17:24:06 +0200
Message-ID: <20260721152443.453089536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -1395,7 +1395,9 @@ int dm_bufio_issue_discard(struct dm_buf
 	struct dm_io_region io_reg = {
 		.bdev = c->bdev,
 		.sector = block_to_sector(c, block),
-		.count = block_to_sector(c, count),
+		.count = likely(c->sectors_per_block_bits >= 0) ?
+			count << c->sectors_per_block_bits :
+			count * (c->block_size >> SECTOR_SHIFT),
 	};
 
 	BUG_ON(dm_bufio_in_request());


