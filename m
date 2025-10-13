Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C90C145B3F;
	Mon, 13 Oct 2025 15:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368581; cv=none; b=uT8peIFYSa/t+Ljwn/XgqW7R5YhxKUf+cYpNf8bcf0v2BzQxy7P64bFdmVz4QqEfOm+jiG3cdlS2Znpi7gMOpEDswePKgCTQ9fDshJsnUhkDrQ2HQA8xZP1FjGGt7hnH4ur6M/QH+rJVLSky92f6veWAT99JmER6//g6oCz1nQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368581; c=relaxed/simple;
	bh=5mIzBpzqu3ZmtHBvvRG5yynm1078mL4kNLqpfiiCLyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0KwIy7qkH6aitlDhqSY7ePjLg4VJWOZdA081ZU8nYe5/juexNvTlLikcSiGWBFRUOdFVbRJ2Jlp8Fl+nDPBVpWtZRNpNRCwxyi77IBsY365dQ7WU2AfegiJtZ9SlY9swfNbbBNzk+XjtlXHUzJM/08lees1AAbD6FDTbHJJwJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehy0FRMr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehy0FRMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E69C4CEE7;
	Mon, 13 Oct 2025 15:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368581;
	bh=5mIzBpzqu3ZmtHBvvRG5yynm1078mL4kNLqpfiiCLyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehy0FRMrfoCXQD2YSSHniIRTC636x1zoWeVzMRIjd+BMylVsHtYL02PG5neat9NrS
	 9szMrzQQa+XBD3WpLKlCjKUPFuucPvVKK3k7L0qfxnO639pmKKEFE2HrYa8FS9cKRL
	 1a6ub1TxFvUocMMvrA2a1RsZhjLWWfTFoJFOdbYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Goldwyn Rodrigues <rgoldwyn@suse.de>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 209/262] ocfs2: fix double free in user_cluster_connect()
Date: Mon, 13 Oct 2025 16:45:51 +0200
Message-ID: <20251013144333.770581622@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 8f45f089337d924db24397f55697cda0e6960516 ]

user_cluster_disconnect() frees "conn->cc_private" which is "lc" but then
the error handling frees "lc" a second time.  Set "lc" to NULL on this
path to avoid a double free.

Link: https://lkml.kernel.org/r/aNKDz_7JF7aycZ0k@stanley.mountain
Fixes: c994c2ebdbbc ("ocfs2: use the new DLM operation callbacks while requesting new lockspace")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/stack_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 77edcd70f72c2..c5236b3ed168f 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -1018,6 +1018,7 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 			printk(KERN_ERR "ocfs2: Could not determine"
 					" locking version\n");
 			user_cluster_disconnect(conn);
+			lc = NULL;
 			goto out;
 		}
 		wait_event(lc->oc_wait, (atomic_read(&lc->oc_this_node) > 0));
-- 
2.51.0



