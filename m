Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192BE328B58;
	Fri,  9 Jan 2026 12:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960672; cv=none; b=n4LX0kjM7VhfUbMDLXJn7ZNJMlotBopvMcTrkzSMSq0gLYqi6oUeIXJCxmDCTKhZP22AhGIa3S3ZocASytpKX7BhCfBes8QdozChxOi/ZJQSoIgXC79Ll/oA8GcI/wImLWVTkq8nhS10RaDgblQSebnDLGF+tOeTk8rn+gH5W3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960672; c=relaxed/simple;
	bh=QgaKnZh6dZq4AyO1/ORB4y7OTo9N+uOLjZcOMaAVpVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZiLfVfft5emQCOr3YYTD8EFGaC0VZ7jp/RXsDedEX/8T4fF6+WHxEqoqIsyluWRoBNzrPrh4QYT6IKMvH5N+LcZ+ceBra2Gh2xA0jGq8nCf15tqD2HsU+TFDdzCtIRqUbP1Eb9bXJPtO/mfm94an8qlGnnDhjBtvkWJ7PedWoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmumS1Qc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmumS1Qc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99655C4CEF1;
	Fri,  9 Jan 2026 12:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960672;
	bh=QgaKnZh6dZq4AyO1/ORB4y7OTo9N+uOLjZcOMaAVpVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmumS1QcIwqcJXTGClrrQNs333+VBqbgUrFvxhM/P3M3IVP/mcVuHfs1O5sUm2fVr
	 JEQVsbwOW6XQIxKoajCUrdlxKiMkdvP1NzW2alr2rySQX1BaxPAapyXnI9cAakumpD
	 9RvxPLf2uHeyBp9U4JqGsl3/vyjuJidpzVQjZJsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 484/737] io_uring/poll: correctly handle io_poll_add() return value on update
Date: Fri,  9 Jan 2026 12:40:23 +0100
Message-ID: <20260109112152.192860006@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

Commit 84230ad2d2afbf0c44c32967e525c0ad92e26b4e upstream.

When the core of io_uring was updated to handle completions
consistently and with fixed return codes, the POLL_REMOVE opcode
with updates got slightly broken. If a POLL_ADD is pending and
then POLL_REMOVE is used to update the events of that request, if that
update causes the POLL_ADD to now trigger, then that completion is lost
and a CQE is never posted.

Additionally, ensure that if an update does cause an existing POLL_ADD
to complete, that the completion value isn't always overwritten with
-ECANCELED. For that case, whatever io_poll_add() set the value to
should just be retained.

Cc: stable@vger.kernel.org
Fixes: 97b388d70b53 ("io_uring: handle completions in the core")
Reported-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
Tested-by: syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/poll.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -1024,12 +1024,17 @@ found:
 
 		ret2 = io_poll_add(preq, issue_flags & ~IO_URING_F_UNLOCKED);
 		/* successfully updated, don't complete poll request */
-		if (!ret2 || ret2 == -EIOCBQUEUED)
+		if (ret2 == IOU_ISSUE_SKIP_COMPLETE)
 			goto out;
+		/* request completed as part of the update, complete it */
+		else if (ret2 == IOU_OK)
+			goto complete;
 	}
 
-	req_set_fail(preq);
 	io_req_set_res(preq, -ECANCELED, 0);
+complete:
+	if (preq->cqe.res < 0)
+		req_set_fail(preq);
 	preq->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(preq);
 out:


