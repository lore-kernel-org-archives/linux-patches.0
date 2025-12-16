Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A3233B966;
	Tue, 16 Dec 2025 11:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884720; cv=none; b=uopB2oF3VAgW2AAJPIosA6DX7HzlPNpJvK2jGHco8+WS0UVaQGauDR3oXnriYdsrEGKi3zkG48szyROHOWCgkVW0Wp/pjTLaGQqtvywoInadm8Y2IB8tRq1j59nTlW2MtUH1MJNO3fWltl4ByLuTOpOQLnzvnRxsj8FMxdpRHP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884720; c=relaxed/simple;
	bh=aI35feNjIjT/zOF1PWU/fn4W1bDmhw5vNFWxaK/SNvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QgekrSEzIcHWs7dZuDSKls4wj1P2W4GWTqdinErq/ywXR6WPJS+xB845X7aKPyRC4eIcmy4JJ4WFglZxvl8G5+7pPoItiJ8ZlgxvqADH2VesjcffW7dgWkZR4eHgtf3SxHl+yU7AM6JjsTJACNUxxGHo+OxrCz9a3Mf/2fhbBQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EETS0gas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EETS0gas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE92FC4CEF1;
	Tue, 16 Dec 2025 11:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884720;
	bh=aI35feNjIjT/zOF1PWU/fn4W1bDmhw5vNFWxaK/SNvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EETS0gasEj9M8fyJsMWpmEnp6NagkybQ//2hFGvnt25rmu/Vk8K90/RYmy8wnPTTU
	 mTwuN7k8VjPRMeATgutjUVbkMEC5VAmptnrpn6oXwRgF8c81tfTzAdvyU78dkgufbg
	 WT+L6ueAI8Ipapu0HCUHtGpUkca/V8YurWFtXQko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 277/354] md/raid5: fix IO hang when array is broken with IO inflight
Date: Tue, 16 Dec 2025 12:14:04 +0100
Message-ID: <20251216111330.951594646@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index 4fae8ade24090..8e5ccca3b68b8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4947,7 +4947,8 @@ static void handle_stripe(struct stripe_head *sh)
 		goto finish;
 
 	if (s.handle_bad_blocks ||
-	    test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
+	    (md_is_rdwr(conf->mddev) &&
+	     test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags))) {
 		set_bit(STRIPE_HANDLE, &sh->state);
 		goto finish;
 	}
@@ -6763,7 +6764,8 @@ static void raid5d(struct md_thread *thread)
 		int batch_size, released;
 		unsigned int offset;
 
-		if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
+		if (md_is_rdwr(mddev) &&
+		    test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
 			break;
 
 		released = release_stripe_list(conf, conf->temp_inactive_list);
-- 
2.51.0



