Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9D836405A;
	Wed, 20 May 2026 16:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294388; cv=none; b=m699jPXVafWcneeEhg1F2RDoduct2DLpPf9j9ZZzBxw1TkvoKKOnwFQdbKMRkZBzpsfJ1Vg2OhNrBuN0YE9yHMGofzVCV4A/slIgdN7gFh0nbcZgqFK8WychjqtXkLCCGhSswoB6CyTBhx5epZstsXotDSM4yCg6584BnVB4z54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294388; c=relaxed/simple;
	bh=EC2olcZ9oZT3bsHpUV49uhzEf6MUA8aZayVO4Zx4w8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBItpLc31oChEn6zz3Er7eWAUnnLCnkEwsyyAioj7ZdzmZnBc8VGlY1QuQq3HL/JPfC6YL2E+UwOnFLyPCUNg1jKMRspIJ4mY2gOR9MH6x+tQ0o38vuaHJwpchO1x5BIThwzEaMaBYxnGIUyZLgBpduzXg7t5n5sng9FZMMCJeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANVh6kcW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANVh6kcW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767FD1F000E9;
	Wed, 20 May 2026 16:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294387;
	bh=tydZZzxgknKEnhdIjZHTXHM1M/0wYW4G6J79TzjQfBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANVh6kcWf0zDBFzP3FOa2yrvCif4KDeF6hNFpu1kvpwU+zMoCZmSLctDOaZsTwjOd
	 vkR7EkFCQg+KRc1TlP47d5Q7IrBq40msQjN1aob3SL+qukyyk3qmgDia9TEC8+ZSPh
	 pesFCogqGH5LAzxafwI9ef26AAi3kfLXe/hsFlKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai@fnnas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0020/1146] md: wake raid456 reshape waiters before suspend
Date: Wed, 20 May 2026 18:04:30 +0200
Message-ID: <20260520162148.844582839@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Yu Kuai <yukuai@fnnas.com>

[ Upstream commit cf86bb53b9c92354904a328e947a05ffbfdd1840 ]

During raid456 reshape, direct IO across the reshape position can sleep
in raid5_make_request() waiting for reshape progress while still
holding an active_io reference. If userspace then freezes reshape and
writes md/suspend_lo or md/suspend_hi, mddev_suspend() kills active_io
and waits for all in-flight IO to drain.

This can deadlock: the IO needs reshape progress to continue, but the
reshape thread is already frozen, so the active_io reference is never
dropped and suspend never completes.

raid5_prepare_suspend() already wakes wait_for_reshape for dm-raid. Do
the same for normal md suspend when reshape is already interrupted, so
waiting raid456 IO can abort, drop its reference, and let suspend
finish.

The mdadm test tests/25raid456-reshape-deadlock reproduces the hang.

Fixes: 714d20150ed8 ("md: add new helpers to suspend/resume array")
Link: https://lore.kernel.org/linux-raid/20260327140729.2030564-1-yukuai@fnnas.com/
Signed-off-by: Yu Kuai <yukuai@fnnas.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 159af8d7ccf0b..9c552904a5ddc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -488,6 +488,17 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
 	}
 
 	percpu_ref_kill(&mddev->active_io);
+
+	/*
+	 * RAID456 IO can sleep in wait_for_reshape while still holding an
+	 * active_io reference. If reshape is already interrupted or frozen,
+	 * wake those waiters so they can abort and drop the reference instead
+	 * of deadlocking suspend.
+	 */
+	if (mddev->pers && mddev->pers->prepare_suspend &&
+	    reshape_interrupted(mddev))
+		mddev->pers->prepare_suspend(mddev);
+
 	if (interruptible)
 		err = wait_event_interruptible(mddev->sb_wait,
 				percpu_ref_is_zero(&mddev->active_io));
-- 
2.53.0



