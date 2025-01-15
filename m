Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCAC18952C;
	Wed, 15 Jan 2025 10:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938364; cv=none; b=Ep8H4NtBhRZIMmG0UN4qanCqZLvsd7DitO3wXRonth8LzXtwXJOhiwDnavJYCT7iDUdS5c1dvHJn+neIn+WsSEZpOIwyj2ekRLmhJ519qICZsKlsv0s63+vqintc3IXEf8e6c9+qvNKVcIiTEf8Szns7MxMohqzObz6p5lmX2gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938364; c=relaxed/simple;
	bh=aHmkFufDi4+cTlXDxPmXv0EqpHDTtiu+ELaoBVNZN+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9aBOxZVlYoBwDTGEZhC0ti2J38zBURMnLSZkQxyO72KHUPhbBxWTHbGrfSaumKB+WC+kGIPRO7EwImOW+UsJkNyV63mL9tZEWAifGmviIJMj8rOOrujq0dF1YlAHt1+aozmcorPc3Y1VM8gB+dboizhOaNyAeZTCybTqjjgeGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c4rim9mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c4rim9mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2198C4CEDF;
	Wed, 15 Jan 2025 10:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938364;
	bh=aHmkFufDi4+cTlXDxPmXv0EqpHDTtiu+ELaoBVNZN+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c4rim9mbnr+Y0lKOh+x3F9tmQ8PM2VCrq987enZ3MA+YuQvaXQQrwvB+aBR1U9knY
	 2Bd/jbSGiysG+5ANL1UhAf0jC4SWZauPnB6HPAjzAUEURb/oIqgguoVF1U83V4dAwh
	 5JEDBpzCP81RcfdaHl/ccTHD2+6BbiCHviWj2ZTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 129/189] io_uring/sqpoll: zero sqd->thread on tctx errors
Date: Wed, 15 Jan 2025 11:37:05 +0100
Message-ID: <20250115103611.594834904@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 4b7cfa8b6c28a9fa22b86894166a1a34f6d630ba upstream.

Syzkeller reports:

BUG: KASAN: slab-use-after-free in thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
Read of size 8 at addr ffff88803578c510 by task syz.2.3223/27552
 Call Trace:
  <TASK>
  ...
  kasan_report+0x143/0x180 mm/kasan/report.c:602
  thread_group_cputime+0x409/0x700 kernel/sched/cputime.c:341
  thread_group_cputime_adjusted+0xa6/0x340 kernel/sched/cputime.c:639
  getrusage+0x1000/0x1340 kernel/sys.c:1863
  io_uring_show_fdinfo+0xdfe/0x1770 io_uring/fdinfo.c:197
  seq_show+0x608/0x770 fs/proc/fd.c:68
  ...

That's due to sqd->task not being cleared properly in cases where
SQPOLL task tctx setup fails, which can essentially only happen with
fault injection to insert allocation errors.

Cc: stable@vger.kernel.org
Fixes: 1251d2025c3e1 ("io_uring/sqpoll: early exit thread if task_context wasn't allocated")
Reported-by: syzbot+3d92cfcfa84070b0a470@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/efc7ec7010784463b2e7466d7b5c02c2cb381635.1736519461.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -275,8 +275,12 @@ static int io_sq_thread(void *data)
 	DEFINE_WAIT(wait);
 
 	/* offload context creation failed, just exit */
-	if (!current->io_uring)
+	if (!current->io_uring) {
+		mutex_lock(&sqd->lock);
+		sqd->thread = NULL;
+		mutex_unlock(&sqd->lock);
 		goto err_out;
+	}
 
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);


