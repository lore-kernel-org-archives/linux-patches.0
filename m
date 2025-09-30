Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671AB30597A;
	Tue, 30 Sep 2025 15:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244822; cv=none; b=PlcFhxTzvfCftO3B6tA9e4V1dTCr4mAEFHTcMmeG2zxT45sRsPqwlWixPeK77s+bjW/rUFryzqM4V+d418wXO8EKD5e/V7ipEBBUfw9vlg9Xu6am1eK4PgUyLM++TtfhBEjmXCPLNwgicnUGNk4hjiYeX4P+xLC4LVywzCrOs3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244822; c=relaxed/simple;
	bh=0BFoZnQIkeeq00+Hkrr16pacwT5bs7cKpItliJhnKUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZXdifgEeI45qCSVFjHVTHjn46e53EW+VoEDG6sX/kSXYaiKo5PiET3ZzMsKu7skpoy7fB6BZb5+ds8sB9v3B3fhBGFHubBAYt1+LKZQN7pdY+wV9wGP4uoSKYDwrnRYqhzCo/ZVBBfgd0HtgICWqKp7bGwy+f8hXh/5lQj/CF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrQxDY1P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrQxDY1P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E06C4CEF0;
	Tue, 30 Sep 2025 15:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244822;
	bh=0BFoZnQIkeeq00+Hkrr16pacwT5bs7cKpItliJhnKUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrQxDY1PCgoYUAM1p+pvMwTm8/wIH4GweAeTsyGonTPUYnGJk/GeGN8dx+1hvn9Ih
	 OUF2MmB1WwoeTg1cwojWF4kJ8iEBq+64N/04CBfIruuUB8ro9akGbw4lAUOyTGykMo
	 KG1LPLxRTgCE7G91HhJIaBiSUe30N0wikMqAEIo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+80cb3cc5c14fad191a10@syzkaller.appspotmail.com,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 093/143] futex: Use correct exit on failure from futex_hash_allocate_default()
Date: Tue, 30 Sep 2025 16:46:57 +0200
Message-ID: <20250930143834.934720951@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 4ec3c15462b9f44562f45723a92e2807746ba7d1 ]

copy_process() uses the wrong error exit path from futex_hash_allocate_default().
After exiting from futex_hash_allocate_default(), neither tasklist_lock
nor siglock has been acquired. The exit label bad_fork_core_free unlocks
both of these locks which is wrong.

The next exit label, bad_fork_cancel_cgroup, is the correct exit.
sched_cgroup_fork() did not allocate any resources that need to freed.

Use bad_fork_cancel_cgroup on error exit from futex_hash_allocate_default().

Fixes: 7c4f75a21f636 ("futex: Allow automatic allocation of process wide futex hash")
Reported-by: syzbot+80cb3cc5c14fad191a10@syzkaller.appspotmail.com
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Closes: https://lore.kernel.org/all/68cb1cbd.050a0220.2ff435.0599.GAE@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1ee8eb11f38ba..0cbc174da76ac 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2289,7 +2289,7 @@ __latent_entropy struct task_struct *copy_process(
 	if (need_futex_hash_allocate_default(clone_flags)) {
 		retval = futex_hash_allocate_default();
 		if (retval)
-			goto bad_fork_core_free;
+			goto bad_fork_cancel_cgroup;
 		/*
 		 * If we fail beyond this point we don't free the allocated
 		 * futex hash map. We assume that another thread will be created
-- 
2.51.0



