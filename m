Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E7D2D8763;
	Wed,  4 Feb 2026 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218862; cv=none; b=QGwaY6RFa18NN8qa/8hkcce8zN4nE9ywu1XiIzH64xjYJPRmw7mAGkDGtyZdIvexth8lHIdux1fvS4TX3hORUUUtWUD3S1fDATdclxsX+DYX+uPnbF7ZVhwSypSLnv608+KnjCZRASV2eOfwgkuKYSOj2qEMrXuLhgGOh+hNiII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218862; c=relaxed/simple;
	bh=lLrjddHA8qlz9Z90jfTL1IMboGlktBwtqXVishvi1kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dpnZEJzxd7mlxQVvaPz+f+6N+e0wX5EHBlwTQlUipi8GH9jNiFkcl0hiNY+9tyTG77FKtNY0YTC9paRhUEFTmiG9+PalRpeOfaGiaDxASA9JNDXURJb0S/ZDtkGBynkAIA3qe8TNBUoNHL6v9mlMnJAOL92EdJhy2+7DgAW/p1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rt34cigK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rt34cigK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C3DC4CEF7;
	Wed,  4 Feb 2026 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218862;
	bh=lLrjddHA8qlz9Z90jfTL1IMboGlktBwtqXVishvi1kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rt34cigK1w1SZolf4pdGmMUmjt3nW/awEH7Wx73hXehZhTDhw+70dp3w80bsyAjLP
	 ZSkdo24Eem6PEIueLPImjW3bxTT9KFuuCfQ2Q1jKCrcvbpsCwELR14c5YAVa9VMztj
	 Gasc1wKoF5An/OZ5XyWSx4q+vJU7pJUk5I+LyiT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laveesh Bansal <laveeshb@laveeshbansal.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 82/87] writeback: fix 100% CPU usage when dirtytime_expire_interval is 0
Date: Wed,  4 Feb 2026 15:41:20 +0100
Message-ID: <20260204143849.877167770@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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
@@ -2418,12 +2418,14 @@ static void wakeup_dirtytime_writeback(s
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
@@ -2434,8 +2436,12 @@ int dirtytime_interval_handler(const str
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
 


