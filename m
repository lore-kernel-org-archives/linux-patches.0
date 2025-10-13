Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA94A307AF5;
	Mon, 13 Oct 2025 15:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368627; cv=none; b=hgeXjbZP5JbDcjkrhUDohNiXlw6OOlAMCQ9pWcBG3k8ciBFkxLdqJdMr9sR8tOvuXw96zAs3l5owvrw46sXcSGYB/C6DAn38nw3c1WZ0Qfm0hP2Trn3HsDJ/Y7qN3LDsBdnazApZ/bgSCODbcdraA5vqEjL3yI5Few/77D8hRpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368627; c=relaxed/simple;
	bh=6znLhvq8TCo6NQ7VrSGWVTKkX4dMPFFlDvz9AlAzqNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTEriLMabGxPX0NHCTh6ZBF8YN0rhIcBcTPBw/w3Cyp2jwEQHd+B0++cCuiqZgHYqV552f5haVlN8T+lGLB90yanTOwPcLFKrdVux9uXZVexC6fBE2q30utTMUgxlmx+aD3FD7MIEL9y1H0wzB+z83zgFVSysysQaw4QnmVW7R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uivy4isq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uivy4isq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C56C4CEE7;
	Mon, 13 Oct 2025 15:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368626;
	bh=6znLhvq8TCo6NQ7VrSGWVTKkX4dMPFFlDvz9AlAzqNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uivy4isqt2rsZ0GeMQF9YALEkNb6njxOPuU+oD7z19ZGStym+nsoVPadTtgbifqqR
	 R6cTRHHsY8VlgQeL7N3MiG/1j0S3SwbOW/4PGlTfB9MXfY+dqmbVurNYicmbrEi0iw
	 GI0Pm6dqnHFO3YA0/EDIhNEhH60YoBrFFc3hvmAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 227/262] io_uring/waitid: always prune wait queue entry in io_waitid_wait()
Date: Mon, 13 Oct 2025 16:46:09 +0200
Message-ID: <20251013144334.418120151@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

commit 2f8229d53d984c6a05b71ac9e9583d4354e3b91f upstream.

For a successful return, always remove our entry from the wait queue
entry list. Previously this was skipped if a cancelation was in
progress, but this can race with another invocation of the wait queue
entry callback.

Cc: stable@vger.kernel.org
Fixes: f31ecf671ddc ("io_uring: add IORING_OP_WAITID support")
Reported-by: syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com
Tested-by: syzbot+b9e83021d9c642a33d8c@syzkaller.appspotmail.com
Link: https://lore.kernel.org/io-uring/68e5195e.050a0220.256323.001f.GAE@google.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/waitid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -272,13 +272,14 @@ static int io_waitid_wait(struct wait_qu
 	if (!pid_child_should_wake(wo, p))
 		return 0;
 
+	list_del_init(&wait->entry);
+
 	/* cancel is in progress */
 	if (atomic_fetch_inc(&iw->refs) & IO_WAITID_REF_MASK)
 		return 1;
 
 	req->io_task_work.func = io_waitid_cb;
 	io_req_task_work_add(req);
-	list_del_init(&wait->entry);
 	return 1;
 }
 


