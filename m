Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247631DC998;
	Tue, 27 May 2025 17:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367561; cv=none; b=HfcQLBYR/wv0JWLGrgeXlkdgjpvrca4Xo8pa0Mo8s0oIdvKnELa5/WZF3i4d58yR3GqMlqS1+f4lxDmGYhESayU3Ffvn6/5auPK2M2XhgVo+kg5WvvN/v9xFZ8go2GcAfeUE7J4f93WjvvAX6M6gA9EAXLILxpNwizdamHeMUfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367561; c=relaxed/simple;
	bh=l05VTLVb16kcMlH3U1va6KkMNJ2Z0U2UO4V3CTDbGsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hmp6r6tLVY5I6KNQi9vZFpuU3NrjOaVIlsUxe5c99PnISL54A76VDOLwMRsH6B37ClJ55Sxoprq58lSF0S/D4TORn6nte7M/bc6EUt0r3UPY3Eh+tsqNwBrUsUDOM6X5CqTrJ/iR71p7Qe6HAEYka0zDhxPl9A7KzakShRPkIeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qeHU/Wvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qeHU/Wvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DEB0C4CEEA;
	Tue, 27 May 2025 17:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367561;
	bh=l05VTLVb16kcMlH3U1va6KkMNJ2Z0U2UO4V3CTDbGsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qeHU/Wvf19Ak182bZB8VoUtUuZrcwbdR0uSjInLYlp9npHgJgZpG4wiNxf5wog/iJ
	 z2ATIV/1/BheqJvQ06o51P31x9tUvGntwWILrhZkqtRgDmnSpLW/W//WaGlUyCA6aT
	 PW0+UIDWBgvrMfoCHlJqWtMDLS0AEBXjt6RTp9PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Segall <bsegall@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 427/783] posix-timers: Invoke cond_resched() during exit_itimers()
Date: Tue, 27 May 2025 18:23:44 +0200
Message-ID: <20250527162530.510788632@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Segall <bsegall@google.com>

[ Upstream commit f99c5bb396b8d1424ed229d1ffa6f596e3b9c36b ]

exit_itimers() loops through every timer in the process to delete it.  This
requires taking the system-wide hash_lock for each of these timers, and
contends with other processes trying to create or delete timers.

When a process creates hundreds of thousands of timers, and then exits
while other processes contend with it, this can trigger softlockups on
CONFIG_PREEMPT=n.

Add a cond_resched() invocation into the loop to allow the system to make
progress.

Signed-off-by: Ben Segall <bsegall@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/xm2634gg2n23.fsf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/posix-timers.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 15ed343693101..43b08a04898a8 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1107,8 +1107,10 @@ void exit_itimers(struct task_struct *tsk)
 	spin_unlock_irq(&tsk->sighand->siglock);
 
 	/* The timers are not longer accessible via tsk::signal */
-	while (!hlist_empty(&timers))
+	while (!hlist_empty(&timers)) {
 		itimer_delete(hlist_entry(timers.first, struct k_itimer, list));
+		cond_resched();
+	}
 
 	/*
 	 * There should be no timers on the ignored list. itimer_delete() has
-- 
2.39.5



