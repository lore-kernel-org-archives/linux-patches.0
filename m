Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3587E248BAA;
	Wed, 15 Jan 2025 11:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938911; cv=none; b=nK8r7z52NGaNu7YIB7i43n44uDuS0LVLGkKP5m3s3NINmM3R5HtdrIuvKKWNDHSa5Grw1ZrSwpS5mf6PHEktHGlhXICm5OOPJIwSzhPgJgt8Ykyt+pUyF8MxZKcDmFxf2styba/XcCcji54RqNGWaFW1B8SfL8e7bEWzTj4rRQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938911; c=relaxed/simple;
	bh=ZIQ914tPHX8a/N7IEEzvWB83KymVitnH5peL5w0MFWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfHqLcVLF724UFxRgz6tLnzaRjB++IEUCBLEqU07vnTiTfFuhvG4stWg71rROAU8+KC5rGojQkXwBB6wGKz0qJ1FbeajEPJ/QWMnbTqtREHkpIYAfXTl0mts9vaaiGlb3bnKgAqRkqbR+Cl0wfsUzbiyikmV9jYRrvKtvDaY5Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEofZ1a4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEofZ1a4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F62C4CEDF;
	Wed, 15 Jan 2025 11:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938910;
	bh=ZIQ914tPHX8a/N7IEEzvWB83KymVitnH5peL5w0MFWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WEofZ1a4palVmwRechfGbxvRCTzTxwvic5QvldHoX154OEXVjRWJZ5FPUVTS0h9OW
	 1p2xPQQ7p7Aqh8IQCubS9cBcChHSKvpHIkfnv7yWSFdc4cC/W2yTH9HLfPgcol6JZe
	 YPQM8QR8n7P46J6s99rjNeei1dPgbDveWtFpd85E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 114/129] io_uring/eventfd: ensure io_eventfd_signal() defers another RCU period
Date: Wed, 15 Jan 2025 11:38:09 +0100
Message-ID: <20250115103558.890279317@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit c9a40292a44e78f71258b8522655bffaf5753bdb upstream.

io_eventfd_do_signal() is invoked from an RCU callback, but when
dropping the reference to the io_ev_fd, it calls io_eventfd_free()
directly if the refcount drops to zero. This isn't correct, as any
potential freeing of the io_ev_fd should be deferred another RCU grace
period.

Just call io_eventfd_put() rather than open-code the dec-and-test and
free, which will correctly defer it another RCU grace period.

Fixes: 21a091b970cd ("io_uring: signal registered eventfd to process deferred task work")
Reported-by: Jann Horn <jannh@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -537,6 +537,13 @@ static __cold void io_queue_deferred(str
 	}
 }
 
+static void io_eventfd_free(struct rcu_head *rcu)
+{
+	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
+
+	eventfd_ctx_put(ev_fd->cq_ev_fd);
+	kfree(ev_fd);
+}
 
 static void io_eventfd_ops(struct rcu_head *rcu)
 {
@@ -550,10 +557,8 @@ static void io_eventfd_ops(struct rcu_he
 	 * ordering in a race but if references are 0 we know we have to free
 	 * it regardless.
 	 */
-	if (atomic_dec_and_test(&ev_fd->refs)) {
-		eventfd_ctx_put(ev_fd->cq_ev_fd);
-		kfree(ev_fd);
-	}
+	if (atomic_dec_and_test(&ev_fd->refs))
+		call_rcu(&ev_fd->rcu, io_eventfd_free);
 }
 
 static void io_eventfd_signal(struct io_ring_ctx *ctx)


