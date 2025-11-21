Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69636264612;
	Fri, 21 Nov 2025 13:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731284; cv=none; b=nHqX/R8CuUHie9uJP32YTpdvsqGE21v7b7dtYO9Mx0LjfGOhoRGM68dOvkIobRLF0ZIjJ40+UY71Pyo1tD97YJMSDLDlxo69htHDDD+snoSLzfjuOCG9te+wWUWope3u7ERbwkGtYVBPpscRgjmW+jMiLeCgLs3A+vqANUyhhWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731284; c=relaxed/simple;
	bh=FYLN6Xl3Evm9od3e874g4J82eZZI5seGOtA6DisBIZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYkz5K0iUI1EgoWUBKeEiJkibxWOnlUdl5kBxxa5KBJnSDaV6zV4iErwZ/22Dv45AcZ3v5U27ptUi30iXV+g4jScW/Sim+b5lAfnW2qlZZYo2VNE+rLK03Ukb+oAWYebua/kABvIAVdA6UOBhcj8Jr4zBuJtmZhs1DFFIL8r6l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEhUF0/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEhUF0/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FA9C4CEF1;
	Fri, 21 Nov 2025 13:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731284;
	bh=FYLN6Xl3Evm9od3e874g4J82eZZI5seGOtA6DisBIZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lEhUF0/aW3QIuGJp72yqYyjeH5QeweSlLxscNzKG1E/WuSFsoTIC7SQhSabG/IjHp
	 na8XV2lWslSwET4EIzW1ntueqUANUqB3szTM26q7mGXaGxaffxch58MmivXRK/wUT8
	 R7EKJo5R/OisnxwZJBcgOGksawr9fCWOmADWkIyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9c47ad18f978d4394986@syzkaller.appspotmail.com,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Eslam Khafagy <eslam.medhat1993@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 121/247] posix-timers: Plug potential memory leak in do_timer_create()
Date: Fri, 21 Nov 2025 14:11:08 +0100
Message-ID: <20251121130158.927339722@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eslam Khafagy <eslam.medhat1993@gmail.com>

[ Upstream commit e0fd4d42e27f761e9cc82801b3f183e658dc749d ]

When posix timer creation is set to allocate a given timer ID and the
access to the user space value faults, the function terminates without
freeing the already allocated posix timer structure.

Move the allocation after the user space access to cure that.

[ tglx: Massaged change log ]

Fixes: ec2d0c04624b3 ("posix-timers: Provide a mechanism to allocate a given timer ID")
Reported-by: syzbot+9c47ad18f978d4394986@syzkaller.appspotmail.com
Suggested-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Eslam Khafagy <eslam.medhat1993@gmail.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://patch.msgid.link/20251114122739.994326-1-eslam.medhat1993@gmail.com
Closes: https://lore.kernel.org/all/69155df4.a70a0220.3124cb.0017.GAE@google.com/T/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-timers.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 8b582174b1f94..42db8396f1999 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -476,12 +476,6 @@ static int do_timer_create(clockid_t which_clock, struct sigevent *event,
 	if (!kc->timer_create)
 		return -EOPNOTSUPP;
 
-	new_timer = alloc_posix_timer();
-	if (unlikely(!new_timer))
-		return -EAGAIN;
-
-	spin_lock_init(&new_timer->it_lock);
-
 	/* Special case for CRIU to restore timers with a given timer ID. */
 	if (unlikely(current->signal->timer_create_restore_ids)) {
 		if (copy_from_user(&req_id, created_timer_id, sizeof(req_id)))
@@ -491,6 +485,12 @@ static int do_timer_create(clockid_t which_clock, struct sigevent *event,
 			return -EINVAL;
 	}
 
+	new_timer = alloc_posix_timer();
+	if (unlikely(!new_timer))
+		return -EAGAIN;
+
+	spin_lock_init(&new_timer->it_lock);
+
 	/*
 	 * Add the timer to the hash table. The timer is not yet valid
 	 * after insertion, but has a unique ID allocated.
-- 
2.51.0



