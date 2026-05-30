Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A064D2690D5;
	Sat, 30 May 2026 17:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160915; cv=none; b=QjUe/1Y8fyhw8nTmoNTJ7W395e4lOoMby3qYp61lPMgMShq3dMSiyt1EI74HNO55fbTtnSPB7QVk0B+4rL3dccFlw8kx+vBK68nO5KHiFKhg2JXguj7os+o6f9S+2krBki7fHOTJ6dQdKTNOZ6wRZdeFKZcqfWOwh/FkDt8FcCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160915; c=relaxed/simple;
	bh=aAVQZRJlLp3WwnvQB9gzkchHiQqBWXxpc3/rOxQfvLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gm6Jfb2yzn+9HdekG/U3ETxTCfxzK3XnR2fAqDqC+I4QcYLwAlMhg1ciaIXOUnpLOATSLxe6NXPGbr7pdaxfQZYnBt8ckZRLy7r0qXsNaDY5/QLq42qJh8XPgGGEWvlLF5lwnsNjRqWzJR+g9jcobtJwuTdMMM7jhmjcqLZDT5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q10zZ1V2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q10zZ1V2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8281F00893;
	Sat, 30 May 2026 17:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160914;
	bh=SHNxMTEoJqD+UndCZRF6lg9qrHVW+K8y7QDKhQBLUXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q10zZ1V2oLPnigG/BdMYxdE64zKOLWjW+1Hn8EgPql+K42ekKE87ZtRPlPjVZKe9E
	 Iy+Bea5mjjDM5doIHF5A9UhUXGS9drLktwrq4iwfCd/Z3qo8hqH7zc8IrW7z7XF2+7
	 pza0g6JRctv/H+zzVchewc5ZGJkfkUV/ErEoOy7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 442/969] hrtimer: Avoid pointless reprogramming in __hrtimer_start_range_ns()
Date: Sat, 30 May 2026 17:59:26 +0200
Message-ID: <20260530160312.478735896@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit d19ff16c11db38f3ee179d72751fb9b340174330 ]

Much like hrtimer_reprogram(), skip programming if the cpu_base is running
the hrtimer interrupt.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Juri Lelli <juri.lelli@redhat.com>
Reviewed-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260224163429.069535561@kernel.org
Stable-dep-of: f2e388a019e4 ("hrtimer: Reduce trace noise in hrtimer_start()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/hrtimer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 062dda96e2706..2d8c7b735baeb 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1284,6 +1284,14 @@ static int __hrtimer_start_range_ns(struct hrtimer *timer, ktime_t tim,
 	}
 
 	first = enqueue_hrtimer(timer, new_base, mode);
+
+	/*
+	 * If the hrtimer interrupt is running, then it will reevaluate the
+	 * clock bases and reprogram the clock event device.
+	 */
+	if (new_base->cpu_base->in_hrtirq)
+		return false;
+
 	if (!force_local) {
 		/*
 		 * If the current CPU base is online, then the timer is
-- 
2.53.0



