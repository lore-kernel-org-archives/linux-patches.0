Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5D418657
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50387C433C9;
	Wed, 20 Sep 2023 11:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210727;
	bh=xQ9AZf6CUzJdyRdvYiqz1Np6h3B86zObEvjBIAsSnDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=clH8c8DLQ28+Lu9wkclSx73k2m5jH+C0D+iDpEOqh2q1saoqEmAEDqmBdFDhTz1cm
	 0SQAsWawX9lc9H4b2nkPvN4uurgKVtvBy1qmFEmWm393oA3tl6S/oDFV0ZuUpr1ndP
	 uvi74HxRwxGFYbU+QF1kYFKBKAEJj58qKhnKPFRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Ingo Molnar <mingo@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 157/211] panic: Reenable preemption in WARN slowpath
Date: Wed, 20 Sep 2023 13:30:01 +0200
Message-ID: <20230920112850.747491772@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit cccd32816506cbac3a4c65d9dff51b3125ef1a03 ]

Commit:

  5a5d7e9badd2 ("cpuidle: lib/bug: Disable rcu_is_watching() during WARN/BUG")

amended warn_slowpath_fmt() to disable preemption until the WARN splat
has been emitted.

However the commit neglected to reenable preemption in the !fmt codepath,
i.e. when a WARN splat is emitted without additional format string.

One consequence is that users may see more splats than intended.  E.g. a
WARN splat emitted in a work item results in at least two extra splats:

  BUG: workqueue leaked lock or atomic
  (emitted by process_one_work())

  BUG: scheduling while atomic
  (emitted by worker_thread() -> schedule())

Ironically the point of the commit was to *avoid* extra splats. ;)

Fix it.

Fixes: 5a5d7e9badd2 ("cpuidle: lib/bug: Disable rcu_is_watching() during WARN/BUG")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Paul E. McKenney <paulmck@kernel.org>
Link: https://lore.kernel.org/r/3ec48fde01e4ee6505f77908ba351bad200ae3d1.1694763684.git.lukas@wunner.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/panic.c b/kernel/panic.c
index 10effe40a3fa6..ea1c5fcb2d191 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -697,6 +697,7 @@ void warn_slowpath_fmt(const char *file, int line, unsigned taint,
 	if (!fmt) {
 		__warn(file, line, __builtin_return_address(0), taint,
 		       NULL, NULL);
+		warn_rcu_exit(rcu);
 		return;
 	}
 
-- 
2.40.1



