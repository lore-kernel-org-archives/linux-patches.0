Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CED22397BF;
	Tue, 15 Jul 2025 13:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587815; cv=none; b=X3bOVucqY6JE9eRCJAkDzPYq+2VXpyJsP9KFTv5e/ff6iSL+C6Qx2TTTFIaQw5+GXFTt53tpAPWkJR+KN9iczQ1PIYzZvUdjcohPnCyoTXyHPLmDShvTeXHBeYPELK3TAfJ5e5XQDVLF00x5PMGJDA9D41nbJbpcMiLrpDX758c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587815; c=relaxed/simple;
	bh=jf/utHT9qhOjqJitvg1ws9asGMTmINU2Jt6d08bT/bQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiuOhqbI559bCcTxFKKmXksbSVciaZ1zDEj2fa/GqKECTSBWDJUzpaNrHNh16zaaplCm8cFhLtfqc4vmcXCzyQkojnEyY9MBooCS0AK0QZGB94a/8KudwUwmWIjXmLgG3EU7Apad9D4GkMyVufjytyufu+oTuMbK1znBmfO3ezg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAfRy5NX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAfRy5NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C9CCC4CEE3;
	Tue, 15 Jul 2025 13:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587814;
	bh=jf/utHT9qhOjqJitvg1ws9asGMTmINU2Jt6d08bT/bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAfRy5NX0W6ziqrjBky+ie8cOojHMt/qbcbFGpRsOg3uVrDD6IEY0Ddimxk2yKmWF
	 gqDCyXKNGAKW3FYut33TJ8383A2dOpZMt6WY0oGqrQpiFO8j26AgQSYXdmOg6H8aC8
	 DoEN5xq1OSWeggHf3khOw9BWOLDPdhjH2WO6YO4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Maximilian Heyne <mheyne@amazon.de>
Subject: [PATCH 5.10 153/208] fs/proc: do_task_stat: use __for_each_thread()
Date: Tue, 15 Jul 2025 15:14:22 +0200
Message-ID: <20250715130817.039390912@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit 7904e53ed5a20fc678c01d5d1b07ec486425bb6a upstream.

do/while_each_thread should be avoided when possible.

Link: https://lkml.kernel.org/r/20230909164501.GA11581@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 7601df8031fd ("fs/proc: do_task_stat: use sig->stats_lock to gather the threads/children stats")
Cc: stable@vger.kernel.org
[ mheyne: adjusted context ]
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/array.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -512,18 +512,18 @@ static int do_task_stat(struct seq_file
 		cgtime = sig->cgtime;
 
 		if (whole) {
-			struct task_struct *t = task;
+			struct task_struct *t;
 
 			min_flt = sig->min_flt;
 			maj_flt = sig->maj_flt;
 			gtime = sig->gtime;
 
 			rcu_read_lock();
-			do {
+			__for_each_thread(sig, t) {
 				min_flt += t->min_flt;
 				maj_flt += t->maj_flt;
 				gtime += task_gtime(t);
-			} while_each_thread(task, t);
+			}
 			rcu_read_unlock();
 
 			thread_group_cputime_adjusted(task, &utime, &stime);


