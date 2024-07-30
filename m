Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3CD1C2324;
	Tue, 30 Jul 2024 16:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355232; cv=none; b=LAe98kbfqGyCL2r4ZrSO6/X/jS8dPn5ZEEgFyUS8Ei/mh2IfXzqh6FFq9nToxG51VjBksZ4ciUuXx630hl5GcVoz88QPFIgWbBNTKun4ZwdioyE2l5im2o7txWasZFx0cF7Zk0uAP7a3fRS0CzuDeFI0VMJe9x6+5yJgQBO8alo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355232; c=relaxed/simple;
	bh=3/F8P7hLPWkhl6tgX1PKq7keR+6dy9M5yXSggO1LEXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rld3v+Y3a8rkUqe9oUrKYNhF82RzS/yroBdjKmZ9oSqprgHvWbfAwRJgXkPGNNpvQwL774dEDm7eR8ik1eYnjy5syTVDroRuAuzcc7df67yp5UVtFiyMgcyJYEUispY7TiZxpZHMbnh2Vop5T9SzeweX9iv9bTnGLOL32puI+Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuZxdUf8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuZxdUf8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D72EC4AF0C;
	Tue, 30 Jul 2024 16:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355232;
	bh=3/F8P7hLPWkhl6tgX1PKq7keR+6dy9M5yXSggO1LEXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuZxdUf847CqMn+BtKV8RY7f5BLqbeewJxqjPRxuVJxRq7KVVrbvFvDb4Hlf+fAwP
	 RteBuEePDTdazT5p7egt/nzPBHOT6k5L71L3TFp6cak+5F5iuI4NoUiEPAEDIfiUm9
	 CbciwRzpuh8y8OiCRLA9nptMzi3Kb3pMLYBqeTm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Kusiak <mateusz.kusiak@linux.intel.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/568] md: Dont wait for MD_RECOVERY_NEEDED for HOT_REMOVE_DISK ioctl
Date: Tue, 30 Jul 2024 17:42:08 +0200
Message-ID: <20240730151640.661304354@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit a1fd37f97808db4fa1bf55da0275790c42521e45 ]

Commit 90f5f7ad4f38 ("md: Wait for md_check_recovery before attempting
device removal.") explained in the commit message that failed device
must be reomoved from the personality first by md_check_recovery(),
before it can be removed from the array. That's the reason the commit
add the code to wait for MD_RECOVERY_NEEDED.

However, this is not the case now, because remove_and_add_spares() is
called directly from hot_remove_disk() from ioctl path, hence failed
device(marked faulty) can be removed from the personality by ioctl.

On the other hand, the commit introduced a performance problem that
if MD_RECOVERY_NEEDED is set and the array is not running, ioctl will
wait for 5s before it can return failure to user.

Since the waiting is not needed now, fix the problem by removing the
waiting.

Fixes: 90f5f7ad4f38 ("md: Wait for md_check_recovery before attempting device removal.")
Reported-by: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>
Closes: https://lore.kernel.org/all/814ff6ee-47a2-4ba0-963e-cf256ee4ecfa@linux.intel.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240627112321.3044744-1-yukuai1@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ba732b1d00b5b..b5dea664f946d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7684,12 +7684,6 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 	}
 
-	if (cmd == HOT_REMOVE_DISK)
-		/* need to ensure recovery thread has run */
-		wait_event_interruptible_timeout(mddev->sb_wait,
-						 !test_bit(MD_RECOVERY_NEEDED,
-							   &mddev->recovery),
-						 msecs_to_jiffies(5000));
 	if (cmd == STOP_ARRAY || cmd == STOP_ARRAY_RO) {
 		/* Need to flush page cache, and ensure no-one else opens
 		 * and writes
-- 
2.43.0



