Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C63E2C21E3;
	Tue, 12 Aug 2025 18:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024986; cv=none; b=KXIR/LwsIE4jJrKkOBodE3yhZ+xcj4Z2AglwGsCnOeK969NHcVdKwB+YtU+hrOIWf1DpnaXLEYIsyKPhtVM0GLdn2iWLYBVqCCMmL+W9W+mzSYjtis9TYKqF1lviFceNaKmHS3mwX2YB8fegI+TnVGVntUPNtUGpmM3QYh074k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024986; c=relaxed/simple;
	bh=hXjHoQxGbSiBpSLwsfhV7WiHQmiWkmT8QgiWhUgLmLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kamKV5CaazqjZ2nE5nf9MaZmmX+28sKUTgthS3kSZ2KOA8zkzE0GiN6WE3VVKK5xSDbruyMosY+Fsg5nivvAp3d5P/j2zMr7b3McEz4pIKHxH2/ct27/mUDzUifbu+2VSr15wpNuPGLh7P8YrNV0l3xwWePXNB8npqSp/nYMjsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVLSQzFA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVLSQzFA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FCDC4CEF0;
	Tue, 12 Aug 2025 18:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024984;
	bh=hXjHoQxGbSiBpSLwsfhV7WiHQmiWkmT8QgiWhUgLmLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QVLSQzFA1S2hCzgGvaB1WqvPEIxj17G70uqkpnJiheFExQEqsr7jHFEO208nXV6vC
	 GkGv5CUSf2JCLKfDddRK08nXGIecluMZQTCQaNQtumm7KNMstE5JnFNT4jY8N6WXVi
	 mzvfzCeF+N/cZrBwAh5ZERSbhsIJNsCwZ29nsipM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 536/627] md: make rdev_addable usable for rcu mode
Date: Tue, 12 Aug 2025 19:33:51 +0200
Message-ID: <20250812173452.303557152@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huawei.com>

[ Upstream commit 13017b427118f4311471ee47df74872372ca8482 ]

Our testcase trigger panic:

BUG: kernel NULL pointer dereference, address: 00000000000000e0
...
Oops: Oops: 0000 [#1] SMP NOPTI
CPU: 2 UID: 0 PID: 85 Comm: kworker/2:1 Not tainted 6.16.0+ #94
PREEMPT(none)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.16.1-2.fc37 04/01/2014
Workqueue: md_misc md_start_sync
RIP: 0010:rdev_addable+0x4d/0xf0
...
Call Trace:
 <TASK>
 md_start_sync+0x329/0x480
 process_one_work+0x226/0x6d0
 worker_thread+0x19e/0x340
 kthread+0x10f/0x250
 ret_from_fork+0x14d/0x180
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Modules linked in: raid10
CR2: 00000000000000e0
---[ end trace 0000000000000000 ]---
RIP: 0010:rdev_addable+0x4d/0xf0

md_spares_need_change in md_start_sync will call rdev_addable which
protected by rcu_read_lock/rcu_read_unlock. This rcu context will help
protect rdev won't be released, but rdev->mddev will be set to NULL
before we call synchronize_rcu in md_kick_rdev_from_array. Fix this by
using READ_ONCE and check does rdev->mddev still alive.

Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
Fixes: 570b9147deb6 ("md: use RCU lock to protect traversal in md_spares_need_change()")
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Link: https://lore.kernel.org/linux-raid/20250731114530.776670-1-yangerkun@huawei.com
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e78c42c381db..10670c62b09e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9418,6 +9418,12 @@ static bool rdev_is_spare(struct md_rdev *rdev)
 
 static bool rdev_addable(struct md_rdev *rdev)
 {
+	struct mddev *mddev;
+
+	mddev = READ_ONCE(rdev->mddev);
+	if (!mddev)
+		return false;
+
 	/* rdev is already used, don't add it again. */
 	if (test_bit(Candidate, &rdev->flags) || rdev->raid_disk >= 0 ||
 	    test_bit(Faulty, &rdev->flags))
@@ -9428,7 +9434,7 @@ static bool rdev_addable(struct md_rdev *rdev)
 		return true;
 
 	/* Allow to add if array is read-write. */
-	if (md_is_rdwr(rdev->mddev))
+	if (md_is_rdwr(mddev))
 		return true;
 
 	/*
-- 
2.39.5



