Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F01255F52;
	Mon, 17 Aug 2026 15:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978842; cv=none; b=daxtIRbfWLoSBBBtiuPfEW5WYcMKz/n3aK/h9AFdzxMHBqDKxTclWPxj8Vey1CExwTmMLCjMAgMia3sN9XdX5oStRzCQOtPeD0+fahdpmr/CpNHtiX8YDsLeNsnplLlrHgQcDZW0Z/nCCWkar0s60NuY64LdzpjBjzGiW5e4BF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978842; c=relaxed/simple;
	bh=3IEBDUmBI24m6s41P4+IsLs717nJD7pXVtQKkwOfEg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fV2mWKGgM+fVqxEvv1jPVa5zdvQ651Zms+zgBripAJnRjj35KdOG/9idyH/BKczD8EXYs3U8kE4AQd36hboq7ssWsBQENTHnXnUPkx9SVx7znp1ad/GWLYxgqMGXT3rttQvULKumVo3sPQ58iAejqXna25ewzH3lGQuSiz0aC7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BG6O8TQj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BG6O8TQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28291F000E9;
	Mon, 17 Aug 2026 15:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978841;
	bh=jaAulx/yTDRXPxaF7RyB6MuRNkMBUgGCXkLQEJs4esQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BG6O8TQjnFcQFvvrLFhOo+1L0AVwrhIujgzRrOiZzqS9J/xljOBZfOi9B2oWN1Q7B
	 Mj7NzJ0HSQglt+/Rns4byhFgE3+yo5ey5+WnAQAN/NFPVshRhdUn+mkOOS1bnnkgTv
	 6+dDpidd4/q6isH6oysSP+jPzfUGlH0ctCSIysSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Ushakov <sysroot314@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Jay Wang <wanjay@amazon.com>
Subject: [PATCH 6.1 002/609] af_unix: Set gc_in_progress to true in unix_gc().
Date: Mon, 17 Aug 2026 15:24:58 +0200
Message-ID: <20260817132543.167861128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit d82ba05263c69fa2437fe93e4e561cc40f4c03af ]

Igor Ushakov reported that unix_gc() could run with gc_in_progress
being false if the work is scheduled while running:

  Thread 1         Thread 2                     Thread 3
  --------         --------                     --------
                   unix_schedule_gc()           unix_schedule_gc()
                   `- if (!gc_in_progress)      `- if (!gc_in_progress)
                      |- gc_in_progress = true     |
                      `- queue_work()              |
  unix_gc() <----------------/                     |
  |                                                |- gc_in_progress = true
  ...                                              `- queue_work()
  |                                                       |
  `- gc_in_progress = false                               |
                                                          |
  unix_gc() <---------------------------------------------'
  |
  ... /* gc_in_progress == false */
  |
  `- gc_in_progress = false

unix_peek_fpl() relies on gc_in_progress not to confuse GC
by MSG_PEEK.

Let's set gc_in_progress to true in unix_gc().

Fixes: 8b90a9f819dc ("af_unix: Run GC on only one CPU.")
Reported-by: Igor Ushakov <sysroot314@gmail.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260501073945.1884564-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Add setting gc_in_progress in __unix_gc(). Keep the existing
  set in unix_gc() for wait_for_unix_gc() over-limit throttling. ]
Signed-off-by: Igor Ushakov <sysroot314@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Jay Wang <wanjay@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 66fd606c43f45d..38c8cae1316716 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -560,6 +560,8 @@ static void __unix_gc(struct work_struct *work)
 	struct sk_buff_head hitlist;
 	struct sk_buff *skb;
 
+	WRITE_ONCE(gc_in_progress, true);
+
 	spin_lock(&unix_gc_lock);
 
 	if (!unix_graph_maybe_cyclic) {
-- 
2.53.0



