Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BD91A38CF;
	Tue, 30 Jul 2024 16:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355206; cv=none; b=Z+0JN5aJED6LOt4fABT2w7DLSYIkYABdCvfHOSZ3Ldg0iKtoSkae03SH3UjCnCJc/sx1LTFxcGu3eJuH8plVBjn/EHCXGN8E/c4uM+muVgurS9LW30dADZpK3IxHK5eFeTBhl8aZbbn6AWyIfNQIVp6cJEWfQv4c28LKyjBb7ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355206; c=relaxed/simple;
	bh=3OXJbIy8+WRGibA1YqmaRbsCWUabRLof9cwCMbkXvRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ThZy/qG2DqW810CzVme8tpTIhxZDKEIzag6MJkBWMnkBLsL+NMVn7oTxDc9/cMUJG1pdyFTH1ignOuECzA2UZQBEEagi5z15inQxGVCw9re4mBgWC9wXMfknBf81qRwbZsKgzwSxUfuMxMGMvCPb4dRA3uP+KJGMfRjSg0A9ebA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEVbktQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEVbktQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E36C32782;
	Tue, 30 Jul 2024 16:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355205;
	bh=3OXJbIy8+WRGibA1YqmaRbsCWUabRLof9cwCMbkXvRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MEVbktQ6ik+9RhOf0npV0uaUfuE0JWn+Ll5n2qNZaTbLaRs0USYZE5VF47jfzvT6q
	 DZCLkgjoxrkOtDGtl2AMuzTdEWtORzjzATiEFFhkcTNGA7hW2JnyoYQtUdRYkVWaeK
	 52zwHBYlxVZTsx/+JtKyUitJpG6mqT7wXFfDbcxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Kusiak <mateusz.kusiak@linux.intel.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 029/809] md: Dont wait for MD_RECOVERY_NEEDED for HOT_REMOVE_DISK ioctl
Date: Tue, 30 Jul 2024 17:38:25 +0200
Message-ID: <20240730151725.807475597@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3a02b8903d626..9c5be016e5073 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7746,12 +7746,6 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 		return get_bitmap_file(mddev, argp);
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



