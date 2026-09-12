Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844C52C21F7;
	Sat, 12 Sep 2026 08:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200350; cv=none; b=TkBdSQB+eyykDRdPoDYTXUhkcbymMpirJLXQNso2didMWFbeqCTLiBQ2AW4NFeDXg4Fd0MVUpGAZOqciTZ7KiO+1eJ2wvp4MZlg2VLz2rCkO8C94e1MD9GZ2pfB/FLzkgJ5Ro3nCZI0FxgZ/WNGa+VQB1U+BgpqlVyRpq0R2lwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200350; c=relaxed/simple;
	bh=WTVQdLSHX2TGrrl/yXxx2YqzNoHTEEVkllE+rJTHls8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYvQS39uo0qDTUvM29u13QOwmSJuk6DXq55qH0GBpvFZuGZdKHBXxc7dIVtaLpsp5USb5kOMCgw1J+SQMBEcDnxHXoPtxCvJO9eZgpYRZPYNplDKSqIcF753m85gliKfaRCUzEQ1eNLAcEB9nXJuh7+CVuBIGIz22Zog5JmTjD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTwP0mF3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTwP0mF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879311F0089A;
	Sat, 12 Sep 2026 08:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200349;
	bh=fO0kjGaxj1R22C6zDeugtbJfHQe8UII6hsnNBri+fNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wTwP0mF3etgoETE0dVtp9vddl2dstqD1vOSaA3OM0WdZDiqGWsNnn98cOAhGOhywv
	 vSud58v25CIW5n459+DewYqNzFKQc9EnWXpPZDS1uICGUhLvO1vFGOR2Od7H+5WjD7
	 LPkUT9p7NNJ8rH4uwez4soacNbKy6DZWqRzSKwxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
	Yu Kuai <yukuai@fygo.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0770/1815] md: recheck spare changes before starting sync
Date: Sat, 12 Sep 2026 08:42:00 +0200
Message-ID: <20260912065706.983879391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

[ Upstream commit c7d34d17ea43ebc86b45d439ebb435e11ca44bca ]

remove_spares() and remove_and_add_spares() modify the array's rdev
configuration. These operations are only safe after the array has been
suspended.

md_start_sync() checks whether spare configuration changes are needed
before taking reconfig_mutex. However, the rdev state can change before
the mutex is acquired, so the initial check can become stale. In that
case, md_choose_sync_action() may remove or replace rdevs while normal
I/O is still accessing them.

The race can occur as follows:

raid10d          Worker                      Normal IO
____________     _______________________     ______________________

                                             raid10_write_request()
                                             wait_blocked_dev()
set Blocked
set Faulty
                                             Skip Faulty rdev
                                             rrdev->nr_pending++
                                             .repl_bio = bio
                 removeable_rdev = false     .
                 array not suspended         .
lock mddev                                   goto err_handle
                 lock mddev (wait)
                 .
update sb        .
clear Blocked    .
                 .
unlock mddev     .
                 lock mddev (acquires)
                 remove_spares()
                 removeable_rdev = true

                 raid10_remove_disk()
                 rdev = replacement
                 replacement = NULL
                                             rdev_dec_pending(NULL)
                 unlock mddev                (NULL)->nr_pending--

In this case, rdev_dec_pending() is called with a NULL pointer,
resulting in a NULL pointer dereference when attempting to decrement
nr_pending.

Fix this by suspending the array when spare configuration changes are
needed, including for non-read-write arrays, and checking again after
taking reconfig_mutex. If the array was not already suspended and a
change is now needed, release the mutex, suspend the array, and
reacquire the mutex before continuing.

Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need reconfiguration")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260628142420.1051027-1-abd.masalkhi@gmail.com?part=3
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Reviewed-by: Yu Kuai <yukuai@fygo.io>
Link: https://patch.msgid.link/20260708112003.474537-1-abd.masalkhi@gmail.com
Signed-off-by: Yu Kuai <yukuai@fygo.io>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/md.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f5cba883856ae..2a25996fe1555 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10186,13 +10186,25 @@ static void md_start_sync(struct work_struct *ws)
 	 * If reshape is still in progress, spares won't be added or removed
 	 * from conf until reshape is done.
 	 */
-	if (mddev->reshape_position == MaxSector &&
+	if ((mddev->reshape_position == MaxSector || !md_is_rdwr(mddev)) &&
 	    md_spares_need_change(mddev)) {
 		suspend = true;
 		mddev_suspend(mddev, false);
 	}
 
 	mddev_lock_nointr(mddev);
+
+	/*
+	 * The spare configuration can change before reconfig_mutex is acquired.
+	 * Recheck while holding the lock and suspend if needed.
+	 */
+	if (!suspend && (mddev->reshape_position == MaxSector || !md_is_rdwr(mddev)) &&
+	    md_spares_need_change(mddev)) {
+		mddev_unlock(mddev);
+		mddev_suspend_and_lock_nointr(mddev);
+		suspend = true;
+	}
+
 	if (!md_is_rdwr(mddev)) {
 		/*
 		 * On a read-only array we can:
-- 
2.53.0



