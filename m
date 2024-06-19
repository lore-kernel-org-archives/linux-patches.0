Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F69AD58;
	Wed, 19 Jun 2024 13:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802981; cv=none; b=gKwkfjcqqSf/3TKb2qvuEH5kgHnPmPWseJRP6lQ2UJFI3ZcUO8a9aBqD/46M4YzwT3n1X0fCv475ZG4r2EsNF4yl6hnRuNHtv4XA9HeWBwtj+43NXBkG608HCC9q91ClpBOJ6yGDdpTl6MeY3zVFd77s2LatVT6sdZ1UBou8hfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802981; c=relaxed/simple;
	bh=VtUebr6zfl7MWB8+2pZb1gP972zDsxwft05DhJqJRj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HO0/mC39Hyr5EYznFKcF5D90QRpwH3nJnNez6FBCtpee9wLcS7WgTLqriIEZTNgXgrTLy8k2XEOFw+GTaYwMgwogXbz3JQHhhOEQVATIVeBOOjJ/kkRUDp0VEoQcTBJaJQMZ3lKUVsI2UQhnFBRmD8M8ch+cpSo2O7enAdqqTo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S6KXEyfO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S6KXEyfO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C25FC2BBFC;
	Wed, 19 Jun 2024 13:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802980;
	bh=VtUebr6zfl7MWB8+2pZb1gP972zDsxwft05DhJqJRj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6KXEyfO9XJN2qFBZ+wSv72T3Bq+LqDY9/pu4Q76QLDo0fVuh3upD+UYxoMU1uI8f
	 Xkt+fBWIMoMBRCKIz3Wy9kBx9A+LLhfzFyx4QSnv0Qx5+evuWYrcCDu8ck6KETY8LA
	 IMjrNKJyqwC65l2iMaXiXmYnNhK7yWVvOB2yNpqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Shi <sl1589472800@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.9 081/281] io_uring: fix cancellation overwriting req->flags
Date: Wed, 19 Jun 2024 14:54:00 +0200
Message-ID: <20240619125612.959202138@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit f4a1254f2a076afb0edd473589bf40f9b4d36b41 upstream.

Only the current owner of a request is allowed to write into req->flags.
Hence, the cancellation path should never touch it. Add a new field
instead of the flag, move it into the 3rd cache line because it should
always be initialised. poll_refs can move further as polling is an
involved process anyway.

It's a minimal patch, in the future we can and should find a better
place for it and remove now unused REQ_F_CANCEL_SEQ.

Fixes: 521223d7c229f ("io_uring/cancel: don't default to setting req->work.cancel_seq")
Cc: stable@vger.kernel.org
Reported-by: Li Shi <sl1589472800@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/6827b129f8f0ad76fa9d1f0a773de938b240ffab.1718323430.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/io_uring_types.h |    3 ++-
 io_uring/cancel.h              |    4 ++--
 io_uring/io_uring.c            |    1 +
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -653,7 +653,7 @@ struct io_kiocb {
 	struct io_rsrc_node		*rsrc_node;
 
 	atomic_t			refs;
-	atomic_t			poll_refs;
+	bool				cancel_seq_set;
 	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
@@ -662,6 +662,7 @@ struct io_kiocb {
 	/* opcode allocated if it needs to store data for async defer */
 	void				*async_data;
 	/* linked requests, IFF REQ_F_HARDLINK or REQ_F_LINK are set */
+	atomic_t			poll_refs;
 	struct io_kiocb			*link;
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -27,10 +27,10 @@ bool io_cancel_req_match(struct io_kiocb
 
 static inline bool io_cancel_match_sequence(struct io_kiocb *req, int sequence)
 {
-	if ((req->flags & REQ_F_CANCEL_SEQ) && sequence == req->work.cancel_seq)
+	if (req->cancel_seq_set && sequence == req->work.cancel_seq)
 		return true;
 
-	req->flags |= REQ_F_CANCEL_SEQ;
+	req->cancel_seq_set = true;
 	req->work.cancel_seq = sequence;
 	return false;
 }
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2211,6 +2211,7 @@ static int io_init_req(struct io_ring_ct
 	req->file = NULL;
 	req->rsrc_node = NULL;
 	req->task = current;
+	req->cancel_seq_set = false;
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;


