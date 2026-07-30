Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355D24483A6;
	Thu, 30 Jul 2026 16:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428184; cv=none; b=YnFyEjWXd5YFgJqQlhg8Kopo8s7m4MdpJMXzpZPDw5RXhfg/d4L99LSuzvDWQEcYuXeHxxy2XAtW/h5/3+sB3iybIi+OGoPHkyfT/v4m0X8dy7x/sEvRZ1KhdHTL5zWfQIM2zfRR4STc4FEyv0cC2ojyu+eluf9GFERP3C4L2aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428184; c=relaxed/simple;
	bh=mdLFj88sljBOszw54U2ExY30kw2SwKXFaM6emQdGA7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEeMLP1vuX3yMsndbwCP/Zg9JcE7RilOSgHcKKCMgw9Pg9y2JjLGdSyiSM++9uZTGZ5bHAF1n0MrAe8PIw+nW3VkAFzPxIJZUjkOOYld2cOpCHKNb/bVIsuFSD7+IGNGyheRVsk593uAALySc6POzE75Dg/Ga0W7vCrXBsUawYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZiADO/T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZiADO/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5DF1F00A3E;
	Thu, 30 Jul 2026 16:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428170;
	bh=BkBiIE5tcLRek82UwN1yOl+2FczbaSucYjsR6q8Esn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZiADO/T/SFiwqtk7sbIUzPINHEbsGoHbR/ypBoe5Dm/qARkGrVgDoY2Slhwb0PNM
	 AywTSi/um17imvqbYIq57ULrodz0jZbrEJcMPjWsvA0tPfufoPdGmDFTsfGuXl/x8k
	 oGuKOWrSkVZuNP04+QFhT/M6xjk6s3ImDTDRjMus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 429/484] taskstats: fill_stats_for_tgid: use for_each_thread()
Date: Thu, 30 Jul 2026 16:15:26 +0200
Message-ID: <20260730141432.799909025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -233,9 +233,8 @@ static int fill_stats_for_tgid(pid_t tgi
 	else
 		memset(stats, 0, sizeof(*stats));
 
-	tsk = first;
 	start_time = ktime_get_ns();
-	do {
+	for_each_thread(first, tsk) {
 		if (tsk->exit_state)
 			continue;
 		/*
@@ -258,7 +257,7 @@ static int fill_stats_for_tgid(pid_t tgi
 
 		stats->nvcsw += tsk->nvcsw;
 		stats->nivcsw += tsk->nivcsw;
-	} while_each_thread(first, tsk);
+	}
 
 	unlock_task_sighand(first, &flags);
 	rc = 0;


