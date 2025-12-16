Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B066346FD0;
	Tue, 16 Dec 2025 11:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886337; cv=none; b=Iwedra5By5PbQI3FAmv0rmTTZPVPDcfv6ZVems/5QKJ5n+LPM89j1wrE9kD1pOT+sL3s3asPWBGntj4hPp6BEn4iuKzQbCGE9X4kZoYCgN/jx5qIKhLwjSyGQJdMhR90jAJO7f6jn4SyZvNfYQsFx//eA6u3q53oArueHgkgSk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886337; c=relaxed/simple;
	bh=OFmttU2Q0RD2tw/XfESS4NI08AijQJtU2Fdw40kdx3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYzxIBs0byeNcrdOUkQYrwFvsZo5kOZC0b6SbJfQ59PkUJpTH0gPz3Lib5Vd2Ti1uDxD/l3xFPt+aC+cyk7t5C8hkvcg9/7x0iHuLSumQo5UVggwuoEg0rqYl5/U063mHSL1Zty2B/tyovoMmJwuLjLfC5WiUyMfQMYYWcH8QPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6uNQY5j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6uNQY5j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD888C4CEF5;
	Tue, 16 Dec 2025 11:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886337;
	bh=OFmttU2Q0RD2tw/XfESS4NI08AijQJtU2Fdw40kdx3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6uNQY5j4sKDUO5WzhK8IfPoRU2UKQKSDMqNjRKN1+//J7mb0cn6zaWZZ9KbAhjZ4
	 iW/3PqP0m66EpPQnHfRqY3pLUSb/upncDdpfQFNeqC+zUqJXU8PSDdcTCQsgesGZy9
	 hes9tuOeI+CYXJTJSw65qGHj9VnHGQUip/i9cv74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 407/507] md/raid5: fix IO hang when array is broken with IO inflight
Date: Tue, 16 Dec 2025 12:14:08 +0100
Message-ID: <20251216111400.208928503@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 771ac1cbab995..8f45de227f1c4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4938,7 +4938,8 @@ static void handle_stripe(struct stripe_head *sh)
 		goto finish;
 
 	if (s.handle_bad_blocks ||
-	    test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags)) {
+	    (md_is_rdwr(conf->mddev) &&
+	     test_bit(MD_SB_CHANGE_PENDING, &conf->mddev->sb_flags))) {
 		set_bit(STRIPE_HANDLE, &sh->state);
 		goto finish;
 	}
@@ -6753,7 +6754,8 @@ static void raid5d(struct md_thread *thread)
 		int batch_size, released;
 		unsigned int offset;
 
-		if (test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
+		if (md_is_rdwr(mddev) &&
+		    test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
 			break;
 
 		released = release_stripe_list(conf, conf->temp_inactive_list);
-- 
2.51.0



