Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9575D359FB6;
	Fri,  9 Jan 2026 12:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960098; cv=none; b=B8lQ7EAUSqmVMltklA7jf4hY/lD6GDAM1MQkav89J7C2nIIp23x29LfDm8BPWevCaoreBq2/IzMigSrTLhpcpI9O0GgvVQCAgM5QcCbVakmbRcFKZ3Q8xPePYqIuD/yx18Kl9yffwPl+WATspko4jn2zh1VNFcwBEcInIo0Wg18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960098; c=relaxed/simple;
	bh=mRwFwJm7oc8O3rJ9hZIPWQUDQMg50oRFxakgXYFSpq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MttFBako6TLkiJU2AV2sI8CG5X3iKH1nsrOl94QfNIQwip02mCnV+kO4SQ3PM5b19LEXccKyz0NK314hydLIxL2Ayxj+H9Og9whTLxBCTwqn6b5nBsfJUm4tWOymW7C83SFD1jS+f2fRqpX5g08SnU6ktY5aEfEfBr55UX0y6Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1L/sYj4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1L/sYj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F444C4CEF1;
	Fri,  9 Jan 2026 12:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960098;
	bh=mRwFwJm7oc8O3rJ9hZIPWQUDQMg50oRFxakgXYFSpq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1L/sYj49xi2cPa3OKdvAdi0rsjTYvx7B0NeCFrEWhnSvdcQOuwv44xdOJwYrnFsT
	 1A1jOnXYxNkXrfY3Ui6EmgtxSK7KBAppVcGvkRtEEgKbzum9e5h/La9zbRm0UoPvvr
	 rRKzsZL7WfJLtheG1Z6f87WZxj3hV+XkBV9MijkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/737] md/raid5: fix IO hang when array is broken with IO inflight
Date: Fri,  9 Jan 2026 12:36:30 +0100
Message-ID: <20260109112143.434465308@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit a913d1f6a7f607c110aeef8b58c8988f47a4b24e ]

Following test can cause IO hang:

mdadm -CvR /dev/md0 -l10 -n4 /dev/sd[abcd] --assume-clean --chunk=64K --bitmap=none
sleep 5
echo 1 > /sys/block/sda/device/delete
echo 1 > /sys/block/sdb/device/delete
echo 1 > /sys/block/sdc/device/delete
echo 1 > /sys/block/sdd/device/delete

dd if=/dev/md0 of=/dev/null bs=8k count=1 iflag=direct

Root cause:

1) all disks removed, however all rdevs in the array is still in sync,
IO will be issued normally.

2) IO failure from sda, and set badblocks failed, sda will be faulty
and MD_SB_CHANGING_PENDING will be set.

3) error recovery try to recover this IO from other disks, IO will be
issued to sdb, sdc, and sdd.

4) IO failure from sdb, and set badblocks failed again, now array is
broken and will become read-only.

5) IO failure from sdc and sdd, however, stripe can't be handled anymore
because MD_SB_CHANGING_PENDING is set:

handle_stripe
 handle_stripe
 if (test_bit MD_SB_CHANGING_PENDING)
  set_bit STRIPE_HANDLE
  goto finish
  // skip handling failed stripe

release_stripe
 if (test_bit STRIPE_HANDLE)
  list_add_tail conf->hand_list

6) later raid5d can't handle failed stripe as well:

raid5d
 md_check_recovery
  md_update_sb
   if (!md_is_rdwr())
    // can't clear pending bit
    return
 if (test_bit MD_SB_CHANGING_PENDING)
  break;
  // can't handle failed stripe

Since MD_SB_CHANGING_PENDING can never be cleared for read-only array,
fix this problem by skip this checking for read-only array.

Link: https://lore.kernel.org/linux-raid/20251117085557.770572-3-yukuai@fnnas.com
Fixes: d87f064f5874 ("md: never update metadata when array is read-only.")
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Reviewed-by: Li Nan <linan122@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid5.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index f69e4a6a8a592..aad2b8c0c5418 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5002,7 +5002,8 @@ static void handle_stripe(struct stripe_head *sh)
 		goto finish;
 
 	if (s.handle_bad_blocks ||
-	    test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
+	    (md_is_rdwr(conf->mddev) &&
+	     test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags))) {
 		set_bit(STRIPE_HANDLE, &sh->state);
 		goto finish;
 	}
@@ -6829,7 +6830,8 @@ static void raid5d(struct md_thread *thread)
 		int batch_size, released;
 		unsigned int offset;
 
-		if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
+		if (md_is_rdwr(mddev) &&
+		    test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
 			break;
 
 		released = release_stripe_list(conf, conf->temp_inactive_list);
-- 
2.51.0



