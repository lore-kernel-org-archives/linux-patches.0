Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BB934753C;
	Mon,  4 May 2026 13:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903028; cv=none; b=gQw1cK04GE6QcrWN+dUG/0Rd6pChRRTC7hA6u6942jdjGwVXdox5fu543tMsfIedrHVfx3MEypV9wM5tN+N67uRy6k0KOxGOAfgIWPjoE92WHFAR/yp16fDHcX9DZWa5TaqS3T1Y4in2dJCNyMOqE7oK9pepf9eLnA/TpylL7As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903028; c=relaxed/simple;
	bh=501bUnos8n6bV6xacU+EMU5yUTvsODO0pLXAN6vNN6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ab9lxuVAIEDv3Cvirl76T3EeQys3JDOjIGt8dHFrjV4RAAaWQk2GoU7L4JioNyBT2tY8+x0E+8TPdNwkpm1my15BbOoDYAkJBIhrU+Dpwx+gYB99FYFhJ4QK4/1HRyAzmf5Soe71JaAcuHQCF0MuqyaxiMKxZf3dt5JX9M7brSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N82IaxwR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N82IaxwR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD013C2BCB8;
	Mon,  4 May 2026 13:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903028;
	bh=501bUnos8n6bV6xacU+EMU5yUTvsODO0pLXAN6vNN6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N82IaxwR0ZTEO0KFoR7HCnf1ysh4R0EOm93wCkm7YnBFXV29DkaKgobm9baaPeWWO
	 CG8oiuqbsCWrRzirOt4WWzFdb305cQ+y3CNHM5PIplTAaxFZFnEt4WR56H0gdLbrR/
	 bZN+SUKcnnLbBGGR8Jn4RD7TATYmJ4FA2/KzW/C8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Hunt <johunt@akamai.com>,
	Yu Kuai <yukuai@fnnas.com>
Subject: [PATCH 7.0 076/307] md/raid10: fix deadlock with check operation and nowait requests
Date: Mon,  4 May 2026 15:49:21 +0200
Message-ID: <20260504135145.674045191@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1184,7 +1184,7 @@ static void raid10_read_request(struct m
 	}
 
 	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
-		raid_end_bio_io(r10_bio);
+		free_r10bio(r10_bio);
 		return;
 	}
 
@@ -1372,7 +1372,7 @@ static void raid10_write_request(struct
 
 	sectors = r10_bio->sectors;
 	if (!regular_request_wait(mddev, conf, bio, sectors)) {
-		raid_end_bio_io(r10_bio);
+		free_r10bio(r10_bio);
 		return;
 	}
 


