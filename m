Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFDB27B359;
	Wed,  4 Feb 2026 14:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216661; cv=none; b=Q1O8IeNBucLhW939VLCLlay2F57EC0zoxK4uVAk+ncc9xmG1qWikC+0p+ogb1vlWSiulyulcz8qJdNN/FfOMbk4Nv/499Qouwi7mhOfsNzqnDO5X81+AYw223zd5p7xVvP6xOcqAe6J0Snpfl9V9txp/1X/HPAIqpwokgjX/5gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216661; c=relaxed/simple;
	bh=HzeyMSVPZvgwULciV4usITTKn2EtsNmcMsmuRGmP8xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGq6gCcIYTBvJCbpQhaOORm9puAi8LOEXStybjaALMje05aiinbpUym/s93nTykXyiLy9eRofagwJ17qLZdLwXobrR0UVdLrLTPE6SjbjVeEhUEVn3KiuEcq/Ffb7zCHG6XaAbBQPEuaXPn2pYSwAwVWiOQrp0n0gKa34mIeEfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BoXx+HHs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BoXx+HHs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E06BC4CEF7;
	Wed,  4 Feb 2026 14:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216661;
	bh=HzeyMSVPZvgwULciV4usITTKn2EtsNmcMsmuRGmP8xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoXx+HHsB7hDZVEYDbE6EQycmlPkUxlkhmQSwbxVUwEMre54SxVWeFOPL+/5vC3VE
	 k6S9Kp9VoQQV42JJGpK9Kv+i2UmREBePeCX4YZ09IuvAzryJxAyrVv9a1ukxW0qy03
	 SBMkuefJmmtZt+MX04ysvz49MnVbckw4go1GiXeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laveesh Bansal <laveeshb@laveeshbansal.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 155/161] writeback: fix 100% CPU usage when dirtytime_expire_interval is 0
Date: Wed,  4 Feb 2026 15:40:18 +0100
Message-ID: <20260204143857.324065738@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laveesh Bansal <laveeshb@laveeshbansal.com>

[ Upstream commit 543467d6fe97e27e22a26e367fda972dbefebbff ]

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
[ adapted system_percpu_wq to system_wq for the workqueue used in dirtytime_interval_handler() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fs-writeback.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2187,12 +2187,14 @@ static void wakeup_dirtytime_writeback(s
 				wb_wakeup(wb);
 	}
 	rcu_read_unlock();
-	schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
+	if (dirtytime_expire_interval)
+		schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
 }
 
 static int __init start_dirtytime_writeback(void)
 {
-	schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
+	if (dirtytime_expire_interval)
+		schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
 	return 0;
 }
 __initcall(start_dirtytime_writeback);
@@ -2203,8 +2205,12 @@ int dirtytime_interval_handler(struct ct
 	int ret;
 
 	ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-	if (ret == 0 && write)
-		mod_delayed_work(system_wq, &dirtytime_work, 0);
+	if (ret == 0 && write) {
+		if (dirtytime_expire_interval)
+			mod_delayed_work(system_wq, &dirtytime_work, 0);
+		else
+			cancel_delayed_work_sync(&dirtytime_work);
+	}
 	return ret;
 }
 


