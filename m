Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E55B46D0BD;
	Thu, 20 Aug 2026 16:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243614; cv=none; b=QTCLAqZeuNxLf0xRaw8Ulv1GvuHILAYEDfWEEuzhBEbHPwgBNTtCrD/zUeZvy8XUpRUWJAD8VANiJNH6q1207wlePfi7ZGQw2HbV6tOb8SUMcsJGmcdZ5adMFVHnp+aCVsQ41AgMG1Y7doQ4/bSffKGb7LcznvOV8zdKiHe99NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243614; c=relaxed/simple;
	bh=gfpZIymO6AyBsuscML4gDKDEfHVjP4vcaVXBzF0dMUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=slFXBqU+8fFe4cqME8P2Fm+z7VR6dib32ajqy5XdGirm1ORmetbH2CgiUK904+cRAqWbach+rKx4oBiEjLaqG4b/rx5mv4AEk8DsgCGriQ0EcJllJ00YnqOZdUjmMMNGAfJ1OgDPzJl7YPtHyqnXa6ThybwZlfnHWioA7Q4poac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMjBva1R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMjBva1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E5E1F000E9;
	Thu, 20 Aug 2026 16:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243613;
	bh=Z3uyNDlKeyFeVSuqR2OLXknkMNlRadkneYz1R/092E8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HMjBva1RZGaA6YxRyHQhdDmp/RpKusr9+1gvzRDA76QZLdGJ7Wkm9n14Dp4Nrro7b
	 Pa6+vxhMl2gHTFKyEtyouW6x/4xUjjzt7G1pmSxFo4b6N7Fur8ZolcHPlWmZmXbkL0
	 6YzJV3sdXhFNlMPkXv3Fd/K5ANwf+m4njVNmyH8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/272] taskstats: fill_stats_for_tgid: use for_each_thread()
Date: Thu, 20 Aug 2026 16:55:02 +0200
Message-ID: <20260820145234.805947368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit ed5378a387fd7c382497f2abcf4605e030b64044 ]

do/while_each_thread should be avoided when possible.

Plus I _think_ this change allows to avoid lock_task_sighand() but I am
not sure, I forgot everything about taskstats.  In any case, this code
does not look right in that the same thread can be accounted twice:
taskstats_exit() can account the exiting thread in signal->stats and drop
->siglock but this thread is still on the thread-group list, so
lock_task_sighand() can't help.

Link: https://lkml.kernel.org/r/20230909214951.GA24274@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: b3e4fbb04220 ("taskstats: retain dead thread stats in TGID queries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/taskstats.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -211,9 +211,8 @@ static int fill_stats_for_tgid(pid_t tgi
 	else
 		memset(stats, 0, sizeof(*stats));
 
-	tsk = first;
 	start_time = ktime_get_ns();
-	do {
+	for_each_thread(first, tsk) {
 		if (tsk->exit_state)
 			continue;
 		/*
@@ -236,7 +235,7 @@ static int fill_stats_for_tgid(pid_t tgi
 
 		stats->nvcsw += tsk->nvcsw;
 		stats->nivcsw += tsk->nivcsw;
-	} while_each_thread(first, tsk);
+	}
 
 	unlock_task_sighand(first, &flags);
 	rc = 0;


