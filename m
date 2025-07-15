Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843112E5428;
	Tue, 15 Jul 2025 13:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585946; cv=none; b=eN5rXznzvngNRas5NSD1ebQIZw75AhZEqFNGtnON02lxDlMl28znjbNryyOmVfXOvcrwmStomJFA12MH9UOTRjY7XzsXDLzm5UjfiNgUJusyJ2uXwtxtGIweczFB9m6chljwmM9gVXi0QmrkX6TxXr4BUTpaohqD3ONrDBq389E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585946; c=relaxed/simple;
	bh=QjmFWsz56SOOi7EEtw7D6jdNjGTSJu3Jn91RFDsfMuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=slut7NqelD3uCgNc/+z00yEw3//IibGcv+StrcZ69UBu2mtNWq5ifNvWPHIniWrLd05LgiY7SEV9mQ0s5ngLmmloRXqymEAE7+/eMGBvQtnLRmbCQzlHo69AV6dSiZuffkTSs81jeoxEXn5RF3oMoJtRqZxV8NRyHGi1wvmX6t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYIa0YIi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYIa0YIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1765CC4CEE3;
	Tue, 15 Jul 2025 13:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585946;
	bh=QjmFWsz56SOOi7EEtw7D6jdNjGTSJu3Jn91RFDsfMuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYIa0YIio0nqG+hdS23SvXD4dOp+c82+btNJtL4WoOwvzraE/zil/NlGSEqDhEkDu
	 V0xTjzVcGSStHjHacP43DsZKRNmjrbExnGqgIhOFtQmY4ejpSp0x11c4FpiUEPMhga
	 RkcD/3G2RlzbNLPZUGbBQH64MnOq+mtFUuPzDnS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerald Gibson <gerald.gibson@oracle.com>,
	=?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
	Yu Kuai <yukuai3@huawei.com>
Subject: [PATCH 6.6 040/109] md/md-bitmap: fix GPF in bitmap_get_stats()
Date: Tue, 15 Jul 2025 15:12:56 +0200
Message-ID: <20250715130800.485095030@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Håkon Bugge <haakon.bugge@oracle.com>

commit c17fb542dbd1db745c9feac15617056506dd7195 upstream.

The commit message of commit 6ec1f0239485 ("md/md-bitmap: fix stats
collection for external bitmaps") states:

    Remove the external bitmap check as the statistics should be
    available regardless of bitmap storage location.

    Return -EINVAL only for invalid bitmap with no storage (neither in
    superblock nor in external file).

But, the code does not adhere to the above, as it does only check for
a valid super-block for "internal" bitmaps. Hence, we observe:

Oops: GPF, probably for non-canonical address 0x1cd66f1f40000028
RIP: 0010:bitmap_get_stats+0x45/0xd0
Call Trace:

 seq_read_iter+0x2b9/0x46a
 seq_read+0x12f/0x180
 proc_reg_read+0x57/0xb0
 vfs_read+0xf6/0x380
 ksys_read+0x6d/0xf0
 do_syscall_64+0x8c/0x1b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

We fix this by checking the existence of a super-block for both the
internal and external case.

Fixes: 6ec1f0239485 ("md/md-bitmap: fix stats collection for external bitmaps")
Cc: stable@vger.kernel.org
Reported-by: Gerald Gibson <gerald.gibson@oracle.com>
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Link: https://lore.kernel.org/linux-raid/20250702091035.2061312-1-haakon.bugge@oracle.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-bitmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2119,8 +2119,7 @@ int md_bitmap_get_stats(struct bitmap *b
 
 	if (!bitmap)
 		return -ENOENT;
-	if (!bitmap->mddev->bitmap_info.external &&
-	    !bitmap->storage.sb_page)
+	if (!bitmap->storage.sb_page)
 		return -EINVAL;
 	sb = kmap_local_page(bitmap->storage.sb_page);
 	stats->sync_size = le64_to_cpu(sb->sync_size);


