Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296F02BD012;
	Wed,  4 Feb 2026 15:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219131; cv=none; b=Go7uTb+J5S/ksczlcCXrS19vKAQ63lGjo8upey8GyWqrBn9igiG4ydy/ey4wCXoZTJaJD+rQwmfe3FmG+mA4xqKYPrcDC/fFoWvm+7s7pIw9BorxsTPZwGy1Fvr0lf2//udlQlgoaZGDEWXX1ZAaNgN1/Of3Jo/za3mb+zaoQXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219131; c=relaxed/simple;
	bh=iWya0oychxCZJCBPR3bkhKQcZAPvtANoywQxiLw0Hvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGcmtD3m2yMDNyEV3r70t2OIC1pIdWMzJiP2IrZYdIfuNK49R+9M6FWPRyzqEn3rJukMriIfJLil9A5lkag+LBGKjhczlYDblVntsLsWgAxCd7eiMfE7jya0AeQ275m5uXOh1AC4vdiyQMB3ZpV5xnImVPHMLZi2VsLrlXBmA48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PbPbWVSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PbPbWVSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53850C4CEF7;
	Wed,  4 Feb 2026 15:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219130;
	bh=iWya0oychxCZJCBPR3bkhKQcZAPvtANoywQxiLw0Hvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PbPbWVSSowzLCvwq8qIbYxvjQkdheybir0M7rEkIFb1VQyYDA/F0E9OJSWcWAbWif
	 b83xw/XMe/jL4DpXYft6RLgWs3D+/gLozn0d2fR9dCOQvNyOpLPe45/nSJXxe6pArq
	 9m9L9xGuQ/2l0Rh3Y/PjiDXV5r6xjwrhxT+tLNvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laveesh Bansal <laveeshb@laveeshbansal.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.18 059/122] writeback: fix 100% CPU usage when dirtytime_expire_interval is 0
Date: Wed,  4 Feb 2026 15:40:41 +0100
Message-ID: <20260204143853.979717049@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laveesh Bansal <laveeshb@laveeshbansal.com>

commit 543467d6fe97e27e22a26e367fda972dbefebbff upstream.

When vm.dirtytime_expire_seconds is set to 0, wakeup_dirtytime_writeback()
schedules delayed work with a delay of 0, causing immediate execution.
The function then reschedules itself with 0 delay again, creating an
infinite busy loop that causes 100% kworker CPU usage.

Fix by:
- Only scheduling delayed work in wakeup_dirtytime_writeback() when
  dirtytime_expire_interval is non-zero
- Cancelling the delayed work in dirtytime_interval_handler() when
  the interval is set to 0
- Adding a guard in start_dirtytime_writeback() for defensive coding

Tested by booting kernel in QEMU with virtme-ng:
- Before fix: kworker CPU spikes to ~73%
- After fix: CPU remains at normal levels
- Setting interval back to non-zero correctly resumes writeback

Fixes: a2f4870697a5 ("fs: make sure the timestamps for lazytime inodes eventually get written")
Cc: stable@vger.kernel.org
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220227
Signed-off-by: Laveesh Bansal <laveeshb@laveeshbansal.com>
Link: https://patch.msgid.link/20260106145059.543282-2-laveeshb@laveeshbansal.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2471,7 +2471,8 @@ static void wakeup_dirtytime_writeback(s
 				wb_wakeup(wb);
 	}
 	rcu_read_unlock();
-	schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
+	if (dirtytime_expire_interval)
+		schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
 }
 
 static int dirtytime_interval_handler(const struct ctl_table *table, int write,
@@ -2480,8 +2481,12 @@ static int dirtytime_interval_handler(co
 	int ret;
 
 	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-	if (ret == 0 && write)
-		mod_delayed_work(system_percpu_wq, &dirtytime_work, 0);
+	if (ret == 0 && write) {
+		if (dirtytime_expire_interval)
+			mod_delayed_work(system_percpu_wq, &dirtytime_work, 0);
+		else
+			cancel_delayed_work_sync(&dirtytime_work);
+	}
 	return ret;
 }
 
@@ -2498,7 +2503,8 @@ static const struct ctl_table vm_fs_writ
 
 static int __init start_dirtytime_writeback(void)
 {
-	schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
+	if (dirtytime_expire_interval)
+		schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
 	register_sysctl_init("vm", vm_fs_writeback_table);
 	return 0;
 }


