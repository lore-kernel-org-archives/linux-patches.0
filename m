Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E26E13B2BE;
	Tue, 27 Feb 2024 13:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041077; cv=none; b=o831mEJFPgu3b0Z+214wBpI6Xzx0i+Y0o02z/QjvEP6/G/G37zY4yNfypgkwLDYW3d1/Km2sZmc9PqTe40SkNUr+5sOjuw/JhGE7RQLaagO4L59TCvsVZpoN0t3W+D41EFyCj3GtaLUxUDtP5t+zHDeJdIShd+p1SaKTueyU7Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041077; c=relaxed/simple;
	bh=Md70SJTfexR/nrH7e4ICaW4dx1gOAYyz3u591CcO+TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCC4O0OaU6QsNnOgfcvqnXIsuf4NlrTeCriA8Aa6U27Jd9U6hlIP1urjLwh2Z6iBZy2S4P653mYo/oU7++NGWwzTvsXc8rvpzhkEeoGJqAUxeG79ve7HQaRbkF6CANdZPe2+oJp5Eh6O65Ogz7h4S0bTu66nJ0rNcRphC8qnM0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPBEEu+l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPBEEu+l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0CA4C43394;
	Tue, 27 Feb 2024 13:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041077;
	bh=Md70SJTfexR/nrH7e4ICaW4dx1gOAYyz3u591CcO+TI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPBEEu+lSJfyigi98a3rN9ZxZu0jxxNGhAXTUdy8iAZzvMtMFNBIaDnlEUSoz1IsU
	 QAwHjNMZa4lyr9Y3gt5BYsg1vwCJFf3F1a/3FxpfX8JBj0PILZstWYsiHoHCDtMYAc
	 Sk6Hl9Ar2gEFAgGnfovG0OcVmWl1XDNjvx2OXVUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.7 182/334] md: Dont ignore suspended array in md_check_recovery()
Date: Tue, 27 Feb 2024 14:20:40 +0100
Message-ID: <20240227131636.493979195@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

commit 1baae052cccd08daf9a9d64c3f959d8cdb689757 upstream.

mddev_suspend() never stop sync_thread, hence it doesn't make sense to
ignore suspended array in md_check_recovery(), which might cause
sync_thread can't be unregistered.

After commit f52f5c71f3d4 ("md: fix stopping sync thread"), following
hang can be triggered by test shell/integrity-caching.sh:

1) suspend the array:
raid_postsuspend
 mddev_suspend

2) stop the array:
raid_dtr
 md_stop
  __md_stop_writes
   stop_sync_thread
    set_bit(MD_RECOVERY_INTR, &mddev->recovery);
    md_wakeup_thread_directly(mddev->sync_thread);
    wait_event(..., !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))

3) sync thread done:
md_do_sync
 set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 md_wakeup_thread(mddev->thread);

4) daemon thread can't unregister sync thread:
md_check_recovery
 if (mddev->suspended)
   return; -> return directly
 md_read_sync_thread
 clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 -> MD_RECOVERY_RUNNING can't be cleared, hence step 2 hang;

This problem is not just related to dm-raid, fix it by ignoring
suspended array in md_check_recovery(). And follow up patches will
improve dm-raid better to frozen sync thread during suspend.

Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Closes: https://lore.kernel.org/all/8fb335e-6d2c-dbb5-d7-ded8db5145a@redhat.com/
Fixes: 68866e425be2 ("MD: no sync IO while suspended")
Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240201092559.910982-2-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9519,9 +9519,6 @@ not_running:
  */
 void md_check_recovery(struct mddev *mddev)
 {
-	if (READ_ONCE(mddev->suspended))
-		return;
-
 	if (mddev->bitmap)
 		md_bitmap_daemon_work(mddev);
 


