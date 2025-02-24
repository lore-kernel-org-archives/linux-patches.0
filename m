Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57993245037;
	Mon, 24 Feb 2025 14:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408240; cv=none; b=tqZ4jPymHrYqjl7Td0rXzYl3thW0CdmgHPELroXtZQosQmWNuO03OroHoSxlhYaObFFshWRwek/EmHgUx0hA9/GhpxJymiaGyCQ9cHmWkHv4s3/vbknOL0YJPiWsaz1iaxcl2PVjuDC3KOxdNnCcJtUs3xYVMFrPAsvXTRDq1c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408240; c=relaxed/simple;
	bh=S2AbNmFA9AtI22adQ/Xebu1QO75TFISrm+t7MbGUtbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8qDs3NQWHHcflNPux4rR/WDZnllImuO7bpx6otKv/1wYiI2Sbyu2Uudh9D4IDzI7Gmq1/ZeZGhwW1bJ9CmsxxAfa84saMz/X8ut57nsVHKrk0KyMsUX6KoyjhtRWj/0OaeEPCb3uYncMKKvhjfc3qJS59XbBZJC+tU7/Ty+Tlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ithIhLO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ithIhLO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88587C4CEE6;
	Mon, 24 Feb 2025 14:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408240;
	bh=S2AbNmFA9AtI22adQ/Xebu1QO75TFISrm+t7MbGUtbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ithIhLO3/C6uUdYtxxPQ9vN0cg4h1N/oIZCTSGX28oaG7F7RuQPydSfqKFUa82SwD
	 LbJSX5Z5ha2uMYiRdHrAmmasMiT3s8KW6ChUodDIUtoNFAC8Fzxw8kFp4W3b0/A0FG
	 5irOwMqPzG+8OuDLVC4/MnrWhJwYvG2gY679Ww4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.6 133/140] md: fix missing flush of sync_work
Date: Mon, 24 Feb 2025 15:35:32 +0100
Message-ID: <20250224142608.234915384@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yu Kuai <yukuai3@huawei.com>

commit f2d87a759f6841a132e845e2fafdad37385ddd30 upstream.

Commit ac619781967b ("md: use separate work_struct for md_start_sync()")
use a new sync_work to replace del_work, however, stop_sync_thread() and
__md_stop_writes() was trying to wait for sync_thread to be done, hence
they should switch to use sync_work as well.

Noted that md_start_sync() from sync_work will grab 'reconfig_mutex',
hence other contex can't held the same lock to flush work, and this will
be fixed in later patches.

Fixes: ac619781967b ("md: use separate work_struct for md_start_sync()")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Acked-by: Xiao Ni <xni@redhat.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20231205094215.1824240-2-yukuai1@huaweicloud.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4836,7 +4836,7 @@ static void stop_sync_thread(struct mdde
 		return;
 	}
 
-	if (work_pending(&mddev->del_work))
+	if (work_pending(&mddev->sync_work))
 		flush_workqueue(md_misc_wq);
 
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
@@ -6293,7 +6293,7 @@ static void md_clean(struct mddev *mddev
 static void __md_stop_writes(struct mddev *mddev)
 {
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	if (work_pending(&mddev->del_work))
+	if (work_pending(&mddev->sync_work))
 		flush_workqueue(md_misc_wq);
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);


