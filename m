Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B585633FE12
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300921; cv=none; b=WbyjRtr4Iid6XhJ+IoMOF7673Y5hmlDvdLxwk1gOeuCrTLd5j27ZVBHu0qQFQAy5HGCNPwaAqEOm0fIEPjEtEjmBXFjfRJWckzsH2o4eQuFLWhdrQyvdYJjslOwo2jAcd9Bmo0ftet7WdZm7QUxDT51ZHY2X4R9EmV6Vw4yg8PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300921; c=relaxed/simple;
	bh=xGS7k8bup1A3BByGv4uqYT1BPnXWLFgBjfkOw8FyJj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOk4slawS62ad0S4NaoxOt3dA+fIxxlhSAisGxuJQTANMs1REZCnmQQaj3q8NcTZRkdo6+3EQPatk2dAyNh4YuddzQDfadJBbB/LCkVKn0rmouVsPyWtOt7uBQDOfZxoXmoeANtBn7M4pHOS2W72mEuEZFC0wG0MGBnjqMVop+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UBm/9Ta2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UBm/9Ta2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2EFC19423;
	Sat, 28 Feb 2026 17:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300921;
	bh=xGS7k8bup1A3BByGv4uqYT1BPnXWLFgBjfkOw8FyJj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBm/9Ta2hGDjKugWE139hQer6n8vnGqa4b20G4/HKhv/C6x5+sPD+iT6zPNaIeABX
	 Xp5z3OQOy/7twVgbDe+GoNE/icF5E7Gn2K5NJ7hjJ5sEp7tQ5p5FkZ+NW4cNJ8LDCY
	 W4MLuBEvNYKhZXrnqy45Xy+Lw1hRBOrM1pZxRdxdbD0oaGEMhdRnJZppyHhRFNLsJy
	 AgoPWAw8FfQf7gTaWghiPx35yegfK/gxUKtTnlRFEpcCGKhcCM3kx3avSf4uVSO8wo
	 X8apM4ur5EgJPTn+bNUx71lrNI95cv33GUY56R2+njxi9mADeMgVfTjV2kVDKu/4YH
	 O3g1VJK5RDqdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 038/752] netfs: when subreq is marked for retry, do not check if it faced an error
Date: Sat, 28 Feb 2026 12:35:49 -0500
Message-ID: <20260228174750.1542406-38-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

[ Upstream commit 82e8885bd7633a36ee9050e6d7f348a4155eed5f ]

The *_subreq_terminated functions today only process the NEED_RETRY
flag when the subreq was successful or failed with EAGAIN error.
However, there could be other retriable errors for network filesystems.

Avoid this by processing the NEED_RETRY irrespective of the error
code faced by the subreq. If it was specifically marked for retry,
the error code must not matter.

Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/read_collect.c  | 10 ++++++++++
 fs/netfs/read_retry.c    |  4 ++--
 fs/netfs/write_collect.c |  8 ++++----
 fs/netfs/write_issue.c   |  1 +
 4 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 7a0ffa675fb17..137f0e28a44c5 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -546,6 +546,15 @@ void netfs_read_subreq_terminated(struct netfs_io_subrequest *subreq)
 		}
 	}
 
+	/* If need retry is set, error should not matter unless we hit too many
+	 * retries. Pause the generation of new subreqs
+	 */
+	if (test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags)) {
+		trace_netfs_rreq(rreq, netfs_rreq_trace_set_pause);
+		set_bit(NETFS_RREQ_PAUSE, &rreq->flags);
+		goto skip_error_checks;
+	}
+
 	if (unlikely(subreq->error < 0)) {
 		trace_netfs_failure(rreq, subreq, subreq->error, netfs_fail_read);
 		if (subreq->source == NETFS_READ_FROM_CACHE) {
@@ -559,6 +568,7 @@ void netfs_read_subreq_terminated(struct netfs_io_subrequest *subreq)
 		set_bit(NETFS_RREQ_PAUSE, &rreq->flags);
 	}
 
+skip_error_checks:
 	trace_netfs_sreq(subreq, netfs_sreq_trace_terminated);
 	netfs_subreq_clear_in_progress(subreq);
 	netfs_put_subrequest(subreq, netfs_sreq_trace_put_terminated);
diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index b99e84a8170af..7793ba5e3e8fc 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -12,6 +12,7 @@
 static void netfs_reissue_read(struct netfs_io_request *rreq,
 			       struct netfs_io_subrequest *subreq)
 {
+	subreq->error = 0;
 	__clear_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
 	__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
 	netfs_stat(&netfs_n_rh_retry_read_subreq);
@@ -242,8 +243,7 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 	subreq = list_next_entry(subreq, rreq_link);
 abandon:
 	list_for_each_entry_from(subreq, &stream->subrequests, rreq_link) {
-		if (!subreq->error &&
-		    !test_bit(NETFS_SREQ_FAILED, &subreq->flags) &&
+		if (!test_bit(NETFS_SREQ_FAILED, &subreq->flags) &&
 		    !test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags))
 			continue;
 		subreq->error = -ENOMEM;
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index cbf3d9194c7bf..61eab34ea67ef 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -492,11 +492,11 @@ void netfs_write_subrequest_terminated(void *_op, ssize_t transferred_or_error)
 
 	if (IS_ERR_VALUE(transferred_or_error)) {
 		subreq->error = transferred_or_error;
-		if (subreq->error == -EAGAIN)
-			set_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
-		else
+		/* if need retry is set, error should not matter */
+		if (!test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags)) {
 			set_bit(NETFS_SREQ_FAILED, &subreq->flags);
-		trace_netfs_failure(wreq, subreq, transferred_or_error, netfs_fail_write);
+			trace_netfs_failure(wreq, subreq, transferred_or_error, netfs_fail_write);
+		}
 
 		switch (subreq->source) {
 		case NETFS_WRITE_TO_CACHE:
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index dd8743bc8d7fe..34894da5a23ec 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -250,6 +250,7 @@ void netfs_reissue_write(struct netfs_io_stream *stream,
 	iov_iter_truncate(&subreq->io_iter, size);
 
 	subreq->retry_count++;
+	subreq->error = 0;
 	__clear_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
 	__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
 	netfs_stat(&netfs_n_wh_retry_write_subreq);
-- 
2.51.0

