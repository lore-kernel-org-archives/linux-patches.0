Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BB255E4C;
	Tue,  9 Jul 2024 11:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524680; cv=none; b=AvKOxkdWLEN6qvMjhREd31KfihOhxG0SWfG1FqSWlSQwx5UDPx1uDJbxAFiVV/3JGHD0nlgAstw+Q6fz4dSGeORXvszXLDA5ZwQc26ZkpxYqKJKoxZAVUZjo7WCFmccLzvTofwQUSuVrhyh4thij2sxxYTSEFcnDYy+u2Q0KWNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524680; c=relaxed/simple;
	bh=X23rKL2FDbx54La/EcfiIB/NMAsoDpj6IF5s5PrpZu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hk2LewaozRR/AgJ9h2LZnOx97HcVzZR2yDjucKVh0qnN0cSzk8RxyndP2Yt9D4XPzI0wZVaMkJNzbHe1EyMS8Um/T3xuAp5Q9yM1Vm5+1dzdQ6pJiaODmHJs6XaszNlDIAtwbmb+jcvhY5q0aVq7LHxl07af+alScI6VzBH1tig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOOyohIG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOOyohIG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0CBC3277B;
	Tue,  9 Jul 2024 11:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524679;
	bh=X23rKL2FDbx54La/EcfiIB/NMAsoDpj6IF5s5PrpZu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOOyohIGF56d9qyvp4OkiN9g3/QbRi9fQZB+gKpXV3pgaFJ1S12iRE4fOBx2gLqh6
	 qpHEVZs9QHSveQ4whLT+KY/Q+NSxCHAeLQR4V4htnNw5jJar2FsPB6/a8Ew/URzmmR
	 xKIKeVx1qf8vH1YaVfBmXgAn5mzO+S1AL2+WsSeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinliang Zheng <alexjlzheng@tencent.com>,
	Michal Hocko <mhocko@suse.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Mateusz Guzik <mjguzik@gmail.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Tycho Andersen <tandersen@netflix.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 065/102] mm: optimize the redundant loop of mm_update_owner_next()
Date: Tue,  9 Jul 2024 13:10:28 +0200
Message-ID: <20240709110653.910214145@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinliang Zheng <alexjlzheng@tencent.com>

commit cf3f9a593dab87a032d2b6a6fb205e7f3de4f0a1 upstream.

When mm_update_owner_next() is racing with swapoff (try_to_unuse()) or
/proc or ptrace or page migration (get_task_mm()), it is impossible to
find an appropriate task_struct in the loop whose mm_struct is the same as
the target mm_struct.

If the above race condition is combined with the stress-ng-zombie and
stress-ng-dup tests, such a long loop can easily cause a Hard Lockup in
write_lock_irq() for tasklist_lock.

Recognize this situation in advance and exit early.

Link: https://lkml.kernel.org/r/20240620122123.3877432-1-alexjlzheng@tencent.com
Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tycho Andersen <tandersen@netflix.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/exit.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -481,6 +481,8 @@ retry:
 	 * Search through everything else, we should not get here often.
 	 */
 	for_each_process(g) {
+		if (atomic_read(&mm->mm_users) <= 1)
+			break;
 		if (g->flags & PF_KTHREAD)
 			continue;
 		for_each_thread(g, c) {


