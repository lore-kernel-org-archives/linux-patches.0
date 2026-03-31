Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0A130E83A;
	Tue, 31 Mar 2026 17:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976957; cv=none; b=TfzNDC+lODKFnYN8hIenBLpWJ7HV6wwymA5RkEBH8x7Exa+BWAY/YKuAQWeSN87/W4CUdkXHr+4sBfkQvYm9Z0yyKlsgyZbFj2GsnvY2g3e7H6Ke0jEntb7h/y8C8Wyye5kpxX1neDJFUgLxEl6lEurJ7JtVQjtPtSLmq2NYPKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976957; c=relaxed/simple;
	bh=XmBjzkQhZhMVlId5kIVnu0DIZk1WfzPnJ+4vK+SYqjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMBkQZjLWF9Q5KPIHCyGfLlPvT9ignbssmaDR8Haou2VGE9ftCys2U/qnzQnWyDRIRhmPYdCVzeAZ5Pq1d4dD8Oz5KRxFKsGZufUHTa1sOtVyHBqjLgW9yWU7S0jFE7IMYb2Uamhfw0F432+Q/gUEnK4TuhUqwNDzc6XJJyH4cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpBjJhl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpBjJhl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432B3C19423;
	Tue, 31 Mar 2026 17:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976957;
	bh=XmBjzkQhZhMVlId5kIVnu0DIZk1WfzPnJ+4vK+SYqjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpBjJhl4X5oEj3+O6mHnllny1O7MPp7tgMvaIZJb8fKmGD955DejdNqphctis95EB
	 LPPO2Atk7hQiws9zjUWWLCB3aRoLNYDkHKGZVJSk1VOub9tSq7L9KB8vPNc4z+PGEA
	 lxyoe7NKJmg+ZHNvkp5V7Mz3HvNzzcwqG5NvUwA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7227db0fbac9f348dba0@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 293/309] netfs: Fix NULL pointer dereference in netfs_unbuffered_write() on retry
Date: Tue, 31 Mar 2026 18:23:16 +0200
Message-ID: <20260331161804.351278124@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

[ Upstream commit e9075e420a1eb3b52c60f3b95893a55e77419ce8 ]

When a write subrequest is marked NETFS_SREQ_NEED_RETRY, the retry path
in netfs_unbuffered_write() unconditionally calls stream->prepare_write()
without checking if it is NULL.

Filesystems such as 9P do not set the prepare_write operation, so
stream->prepare_write remains NULL. When get_user_pages() fails with
-EFAULT and the subrequest is flagged for retry, this results in a NULL
pointer dereference at fs/netfs/direct_write.c:189.

Fix this by mirroring the pattern already used in write_retry.c: if
stream->prepare_write is NULL, skip renegotiation and directly reissue
the subrequest via netfs_reissue_write(), which handles iterator reset,
IN_PROGRESS flag, stats update and reissue internally.

Fixes: a0b4c7a49137 ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Reported-by: syzbot+7227db0fbac9f348dba0@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=7227db0fbac9f348dba0
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
Link: https://patch.msgid.link/20260307043947.347092-1-kartikey406@gmail.com
Tested-by: syzbot+7227db0fbac9f348dba0@syzkaller.appspotmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/direct_write.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index dd1451bf7543d..4d9760e36c119 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -186,10 +186,18 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 		stream->sreq_max_segs	= INT_MAX;
 
 		netfs_get_subrequest(subreq, netfs_sreq_trace_get_resubmit);
-		stream->prepare_write(subreq);
 
-		__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
-		netfs_stat(&netfs_n_wh_retry_write_subreq);
+		if (stream->prepare_write) {
+			stream->prepare_write(subreq);
+			__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
+			netfs_stat(&netfs_n_wh_retry_write_subreq);
+		} else {
+			struct iov_iter source;
+
+			netfs_reset_iter(subreq);
+			source = subreq->io_iter;
+			netfs_reissue_write(stream, subreq, &source);
+		}
 	}
 
 	netfs_unbuffered_write_done(wreq);
-- 
2.53.0



