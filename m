Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF733783B2;
	Mon,  9 Feb 2026 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647812; cv=none; b=igmxRyrTcORAIWO8ayY+LhldEWpaerRqw6jiSLiQsFw75N7u/P0/IWoiqXPyhIUK5W9CdJcymCSTOmlmE6p8VuGREJ3HiPqsuS0fJa1zaZJynuEQaZmf221pKUTl8P8SGwSSefc6I+Rs2puopG4olYDtpHW722GOtgzwnNpUvOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647812; c=relaxed/simple;
	bh=pJdxpqBRndfnNuOv4cLi+PszT7zVivMYfCWdKvcarJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtsDiOAZUVX64vW5Dea+hFhAwNiParpWXoVoJst4AzB6CoWA4TOY1m5l0Me/bG2l0FWYhvpQ/EVjXUghI6YroHr9USzuHZ76KHNe0v07oRnPTFtNBUHNqWx5O3Iz4j7Zjv+fqcoyYgvAQINxy4V677HanEmO6G1vBfevTSUYxeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXZaFxqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXZaFxqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03DBC116C6;
	Mon,  9 Feb 2026 14:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647812;
	bh=pJdxpqBRndfnNuOv4cLi+PszT7zVivMYfCWdKvcarJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXZaFxqk5pISo0fAqWmn4Ser2jE3T3b6ErIHlpT5jSCsQYijIZc7BrQ4cnxhfZp7f
	 4G2/OIsWKblYLRMOWNlAWtKqYVxVSLZ6E7OOLv0v/Es+RShkP/9P/FP2Q+Qud1+UQe
	 o8KmoiSQkOrZRellei8RVlRkkL0tLyGAA5Ayrw0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FengWei Shih <dannyshih@synology.com>,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/113] md: suspend array while updating raid_disks via sysfs
Date: Mon,  9 Feb 2026 15:23:05 +0100
Message-ID: <20260209142311.506203693@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
References: <20260209142310.204833231@linuxfoundation.org>
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

From: FengWei Shih <dannyshih@synology.com>

[ Upstream commit 2cc583653bbe050bacd1cadcc9776d39bf449740 ]

In raid1_reshape(), freeze_array() is called before modifying the r1bio
memory pool (conf->r1bio_pool) and conf->raid_disks, and
unfreeze_array() is called after the update is completed.

However, freeze_array() only waits until nr_sync_pending and
(nr_pending - nr_queued) of all buckets reaches zero. When an I/O error
occurs, nr_queued is increased and the corresponding r1bio is queued to
either retry_list or bio_end_io_list. As a result, freeze_array() may
unblock before these r1bios are released.

This can lead to a situation where conf->raid_disks and the mempool have
already been updated while queued r1bios, allocated with the old
raid_disks value, are later released. Consequently, free_r1bio() may
access memory out of bounds in put_all_bios() and release r1bios of the
wrong size to the new mempool, potentially causing issues with the
mempool as well.

Since only normal I/O might increase nr_queued while an I/O error occurs,
suspending the array avoids this issue.

Note: Updating raid_disks via ioctl SET_ARRAY_INFO already suspends
the array. Therefore, we suspend the array when updating raid_disks
via sysfs to avoid this issue too.

Signed-off-by: FengWei Shih <dannyshih@synology.com>
Link: https://lore.kernel.org/linux-raid/20251226101816.4506-1-dannyshih@synology.com
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 26056d53f40c9..526390acd39e0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4175,7 +4175,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	if (err < 0)
 		return err;
 
-	err = mddev_lock(mddev);
+	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
 	if (mddev->pers)
@@ -4200,7 +4200,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
 	} else
 		mddev->raid_disks = n;
 out_unlock:
-	mddev_unlock(mddev);
+	mddev_unlock_and_resume(mddev);
 	return err ? err : len;
 }
 static struct md_sysfs_entry md_raid_disks =
-- 
2.51.0



