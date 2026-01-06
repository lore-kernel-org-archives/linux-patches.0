Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011B23559C4;
	Tue,  6 Jan 2026 17:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720585; cv=none; b=eIuTcxQZRuP2Un7Y+FO4YRv2Zv4NRtb38X2wflBaggb99Xe6NsIv5Z2TlSrxyLAHn7ZbrlgKWBdOZHEG1SiDdQTSTG0bTcuf0k8r/b173/Epv2//UDRMSo9zgd+n/57igmLF36vA12ACUfj0FvaQ6cKJCIyLAqyquknQaP7+3MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720585; c=relaxed/simple;
	bh=BuvwAA0T77KmQe3hb+BphT5HkREvCxelp+59VmPilKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCQDxjhgXQasKZzvo6i4T8C4P++r1vuwpsUdzRi1H5i+HB2qLb6jM4KYIs2MciaOZsyKMAgeuKHUipvA96o8Kku65xHXosnH2MhnSBy7/u6MyWUi726Q0JYGW9h8fMuHTo/cVYwDtr7VXLzTW3z3/xb9xVoPOBiT3PXXuP1eE1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaRrQkcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaRrQkcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6F1C116C6;
	Tue,  6 Jan 2026 17:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720584;
	bh=BuvwAA0T77KmQe3hb+BphT5HkREvCxelp+59VmPilKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaRrQkcQfgFa46TJrQhMqwYykxYc/57VoDX1qHtPkYcLcwBHdX6xFAg6nLwdXd1my
	 Vb+Kg7Wm3A7SoST6rkHNKtcAcI+GZeJTbF4ArfJPBeZIaA+cxvDRO3KmNh40CyiQCC
	 dmRri7cXFd81pn7BwcEKq5MuVLDHGeZpY2f1LxE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 249/567] io_uring/poll: correctly handle io_poll_add() return value on update
Date: Tue,  6 Jan 2026 18:00:31 +0100
Message-ID: <20260106170500.526604146@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 	preq->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(preq);
 out:


