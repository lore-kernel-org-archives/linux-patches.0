Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440B21E515;
	Fri,  9 Jan 2026 12:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962474; cv=none; b=W15KbPf0a15TYQmk55Is+UZGIs0GXYi60Zy3/hb4KYrHSq32wgryxPz1DVot16D/jlYYDAubni5xbmmgxVA31E/8b45eoWIXEEodWZdKe+pSu/d90wnM7147zRSGYI5+4Pclo2wce3ykEkufQy5+Jwh4EYcf441aaIB2+j2GGsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962474; c=relaxed/simple;
	bh=Xuh+uYalqI8mV8T6vcO9rEkqwrIgMwJKBeTSH6bWSmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwPRDnFDZsCLhx73kpE6A+MX+6VoDhHuer7198TzRYcGafdweZAcKEibACwrcbmPwLLmFLbuUNXzUUdmHt8n3swktXpc8r5TeTUBwx7yMMLDPgLom7CnICOi4jgBDt6oEuYTWtnTjMKpKLb7pvSfXuCUGbFQmarnL2mw9WfizrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mR02Md+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mR02Md+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47887C19423;
	Fri,  9 Jan 2026 12:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962473;
	bh=Xuh+uYalqI8mV8T6vcO9rEkqwrIgMwJKBeTSH6bWSmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mR02Md+O62RHawdYwD1/PFuqeP1V+F7LVVi0xZRgq4Eodup3JEzijzurp4nVndweC
	 ISU6K4kU8Yd5cdyaTSp3QYH2kRpw+Q4Kft1I4cNIUOJO0XxYYkXPmhNbfuK2a7lWnh
	 HN5Qcar+Y0pkDKY5bvZkYt8UKHQMBCJdnDgJMft8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 376/634] io_uring/poll: correctly handle io_poll_add() return value on update
Date: Fri,  9 Jan 2026 12:40:54 +0100
Message-ID: <20260109112131.679351598@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
@@ -1038,12 +1038,17 @@ found:
 
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
 	io_req_task_complete(preq, &locked);
 out:
 	io_ring_submit_unlock(ctx, issue_flags);


