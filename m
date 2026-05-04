Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8012B1A6827;
	Mon,  4 May 2026 14:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904491; cv=none; b=Znp2/BeapP01kUEmBu7/qWxEJtsn7USlsbJY9arDy9kkPkQ5oKUsxOquoE8I+Do3hsaUyXpsm9K/RU6sfqnobK/AlE1v6+cmWrJd34SbwjDkClJJRSv9panXULDtDfXgF4DzU+l8mQJnCwoZ3hMjo4l+iBmpz+wdupqOZcW4WCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904491; c=relaxed/simple;
	bh=QwlzJ3UUcUbeERQ4Kgl3KMsBHKlBg9IPb2Jo8QcP0Fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssfyHryI7lmKu4Rk8jXWwL1h+9Bf9w2a7la+GPTh1IDP5WDKJtopIRCLo6Qi4mplwQk6C6GRdSiKBkDW+AWh626M9p6W0SQmCGnIZVHo6QKcUGYCFUfhgxuOpJoiOqsvHCSgZKMYJnMUSH6BLVnv7H5b5Jons+k+ikrtIGZhNCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaf2m8tS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaf2m8tS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167BAC2BCB8;
	Mon,  4 May 2026 14:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904491;
	bh=QwlzJ3UUcUbeERQ4Kgl3KMsBHKlBg9IPb2Jo8QcP0Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xaf2m8tSnynaryRtKFFY+hlz/GxPyDQa4hKKmD2xH1YJNAe4nE+xqoxCO/KGcBfF0
	 PYo3gW7Pqn60Wzn7nuF0zKB/o1TgdPaFBGG4HYG4jr7Wti3Jmi2sppBLDrBpZILWzz
	 vtpuPdU8CgHrzv1/z9f3qkLiVa0Kbd3ldnH8MhIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Hunt <johunt@akamai.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 6.12 058/215] md/raid10: fix deadlock with check operation and nowait requests
Date: Mon,  4 May 2026 15:51:17 +0200
Message-ID: <20260504135132.294915488@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Josh Hunt <johunt@akamai.com>

commit 7d96f3120a7fb7210d21b520c5b6f495da6ba436 upstream.

When an array check is running it will raise the barrier at which point
normal requests will become blocked and increment the nr_pending value to
signal there is work pending inside of wait_barrier(). NOWAIT requests
do not block and so will return immediately with an error, and additionally
do not increment nr_pending in wait_barrier(). Upstream change commit
43806c3d5b9b ("raid10: cleanup memleak at raid10_make_request") added a
call to raid_end_bio_io() to fix a memory leak when NOWAIT requests hit
this condition. raid_end_bio_io() eventually calls allow_barrier() and
it will unconditionally do an atomic_dec_and_test(&conf->nr_pending) even
though the corresponding increment on nr_pending didn't happen in the
NOWAIT case.

This can be easily seen by starting a check operation while an application
is doing nowait IO on the same array. This results in a deadlocked state
due to nr_pending value underflowing and so the md resync thread gets stuck
waiting for nr_pending to == 0.

Output of r10conf state of the array when we hit this condition:

crash> struct r10conf
	barrier = 1,
        nr_pending = {
          counter = -41
        },
        nr_waiting = 15,
        nr_queued = 0,

Example of md_sync thread stuck waiting on raise_barrier() and other
requests stuck in wait_barrier():

md1_resync
[<0>] raise_barrier+0xce/0x1c0
[<0>] raid10_sync_request+0x1ca/0x1ed0
[<0>] md_do_sync+0x779/0x1110
[<0>] md_thread+0x90/0x160
[<0>] kthread+0xbe/0xf0
[<0>] ret_from_fork+0x34/0x50
[<0>] ret_from_fork_asm+0x1a/0x30

kworker/u1040:2+flush-253:4
[<0>] wait_barrier+0x1de/0x220
[<0>] regular_request_wait+0x30/0x180
[<0>] raid10_make_request+0x261/0x1000
[<0>] md_handle_request+0x13b/0x230
[<0>] __submit_bio+0x107/0x1f0
[<0>] submit_bio_noacct_nocheck+0x16f/0x390
[<0>] ext4_io_submit+0x24/0x40
[<0>] ext4_do_writepages+0x254/0xc80
[<0>] ext4_writepages+0x84/0x120
[<0>] do_writepages+0x7a/0x260
[<0>] __writeback_single_inode+0x3d/0x300
[<0>] writeback_sb_inodes+0x1dd/0x470
[<0>] __writeback_inodes_wb+0x4c/0xe0
[<0>] wb_writeback+0x18b/0x2d0
[<0>] wb_workfn+0x2a1/0x400
[<0>] process_one_work+0x149/0x330
[<0>] worker_thread+0x2d2/0x410
[<0>] kthread+0xbe/0xf0
[<0>] ret_from_fork+0x34/0x50
[<0>] ret_from_fork_asm+0x1a/0x30

Fixes: 43806c3d5b9b ("raid10: cleanup memleak at raid10_make_request")
Cc: stable@vger.kernel.org
Signed-off-by: Josh Hunt <johunt@akamai.com>
Link: https://lore.kernel.org/linux-raid/20260303005619.1352958-1-johunt@akamai.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid10.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1182,7 +1182,7 @@ static void raid10_read_request(struct m
 	}
 
 	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
-		raid_end_bio_io(r10_bio);
+		free_r10bio(r10_bio);
 		return;
 	}
 
@@ -1381,7 +1381,7 @@ static void raid10_write_request(struct
 
 	sectors = r10_bio->sectors;
 	if (!regular_request_wait(mddev, conf, bio, sectors)) {
-		raid_end_bio_io(r10_bio);
+		free_r10bio(r10_bio);
 		return;
 	}
 


