Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64351A76B3;
	Tue, 30 Jul 2024 17:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360372; cv=none; b=k5O+qTNikEmoXHBI2PWBBufyhIuwLguKEAuOf6uhi+C6dg+ffKIsU+DQjSmsTW/yFqzzkoiefGLKqukisXuv4xt/o4ICVj5z/4vYlQVPW8IJkkzZliFCqvXfAui7WkI9ijF3x/qzigXAIBoktNxzFKThHQlUO51CoW1BDwAy1Tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360372; c=relaxed/simple;
	bh=4la6gZ7VHnYnoPpaIUInRf7RGwkiW+FAeNz83IiTh18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XNT26yq6VFifpzZa6kIGJpZA/QrXnDVr68j2/Jt7YIdxEkUCmoYjKLA4YrtHSRUi3p5r1TZ3A06UbXOC/WQAJEyUOXZTysSrPX4jB8tSwXUDEnUfhfto6wVDi1u8o75RJClBq4n4OnkEhJf19/gbhU1dc6xNLk2HzzYLiP+Ibuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osy70y5v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osy70y5v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38052C32782;
	Tue, 30 Jul 2024 17:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360372;
	bh=4la6gZ7VHnYnoPpaIUInRf7RGwkiW+FAeNz83IiTh18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osy70y5v+Y6veMLP9iggdsuAyvGYe7nifRC9yJFxopVaFdz5RyszeC8ClXnMws/69
	 /m+INyGEP1eCsG1aLUJkXQbIKqKI6OerVfXnbLMgZrx5XO59R+JkaFAdn5KFr3Y1ZD
	 9/PXuLBSXiy9bikb9dzmj+Tam7Ex82fIMG0uLTEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Mateusz=20Jo=C5=84czyk?= <mat.jonczyk@o2.pl>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Paul Luse <paul.e.luse@linux.intel.com>,
	Xiao Ni <xni@redhat.com>,
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Subject: [PATCH 6.10 678/809] md/raid1: set max_sectors during early return from choose_slow_rdev()
Date: Tue, 30 Jul 2024 17:49:14 +0200
Message-ID: <20240730151751.683503374@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Jończyk <mat.jonczyk@o2.pl>

commit 36a5c03f232719eb4e2d925f4d584e09cfaf372c upstream.

Linux 6.9+ is unable to start a degraded RAID1 array with one drive,
when that drive has a write-mostly flag set. During such an attempt,
the following assertion in bio_split() is hit:

	BUG_ON(sectors <= 0);

Call Trace:
	? bio_split+0x96/0xb0
	? exc_invalid_op+0x53/0x70
	? bio_split+0x96/0xb0
	? asm_exc_invalid_op+0x1b/0x20
	? bio_split+0x96/0xb0
	? raid1_read_request+0x890/0xd20
	? __call_rcu_common.constprop.0+0x97/0x260
	raid1_make_request+0x81/0xce0
	? __get_random_u32_below+0x17/0x70
	? new_slab+0x2b3/0x580
	md_handle_request+0x77/0x210
	md_submit_bio+0x62/0xa0
	__submit_bio+0x17b/0x230
	submit_bio_noacct_nocheck+0x18e/0x3c0
	submit_bio_noacct+0x244/0x670

After investigation, it turned out that choose_slow_rdev() does not set
the value of max_sectors in some cases and because of it,
raid1_read_request calls bio_split with sectors == 0.

Fix it by filling in this variable.

This bug was introduced in
commit dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
but apparently hidden until
commit 0091c5a269ec ("md/raid1: factor out helpers to choose the best rdev from read_balance()")
shortly thereafter.

Cc: stable@vger.kernel.org # 6.9.x+
Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
Fixes: dfa8ecd167c1 ("md/raid1: factor out choose_slow_rdev() from read_balance()")
Cc: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: Paul Luse <paul.e.luse@linux.intel.com>
Cc: Xiao Ni <xni@redhat.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Link: https://lore.kernel.org/linux-raid/20240706143038.7253-1-mat.jonczyk@o2.pl/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--

Tested on both Linux 6.10 and 6.9.8.

Inside a VM, mdadm testsuite for RAID1 on 6.10 did not find any problems:
	./test --dev=loop --no-error --raidtype=raid1
(on 6.9.8 there was one failure, caused by external bitmap support not
compiled in).

Notes:
- I was reliably getting deadlocks when adding / removing devices
  on such an array - while the array was loaded with fsstress with 20
  concurrent processes. When the array was idle or loaded with fsstress
  with 8 processes, no such deadlocks happened in my tests.
  This occurred also on unpatched Linux 6.8.0 though, but not on
  6.1.97-rc1, so this is likely an independent regression (to be
  investigated).
- I was also getting deadlocks when adding / removing the bitmap on the
  array in similar conditions - this happened on Linux 6.1.97-rc1
  also though. fsstress with 8 concurrent processes did cause it only
  once during many tests.
- in my testing, there was once a problem with hot adding an
  internal bitmap to the array:
	mdadm: Cannot add bitmap while array is resyncing or reshaping etc.
	mdadm: failed to set internal bitmap.
  even though no such reshaping was happening according to /proc/mdstat.
  This seems unrelated, though.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240711202316.10775-1-mat.jonczyk@o2.pl
---
 drivers/md/raid1.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -680,6 +680,7 @@ static int choose_slow_rdev(struct r1con
 		len = r1_bio->sectors;
 		read_len = raid1_check_read_range(rdev, this_sector, &len);
 		if (read_len == r1_bio->sectors) {
+			*max_sectors = read_len;
 			update_read_sectors(conf, disk, this_sector, read_len);
 			return disk;
 		}


