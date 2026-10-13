Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6F74F85BC;
	Tue, 13 Oct 2026 12:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894349; cv=none; b=jiXX2uawbZuN2I/cDODMIyJt9KEoaAF9rwDkLpU/UVSJD6jjMrAlzWRPJF6xFEtdZLTYc+2YQvTYzK+L7wUhp65gNqEzuMqa/PV2D6Sdbb96MsjYhxdKEr9t0YvUW3bwG8cP62FX+mWojZ5D0zd9EMUvzulU7L8ow3mTk2qehg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894349; c=relaxed/simple;
	bh=YfyQ21YZyZvA+v+Yh3uI0TihaJ8TYkGb45b67OeCcYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0qkeU/MoD4Gr6an+lyRLHontBk+kkdli72dJ4At5EHWNnMiP4XgvnpILzaYEKK0G4Xdf1Oo+jIHNZ7elg5XUhrzWyjemxbzaHxJvqO6mW/s/giVN1G8tG9VVacP0flTER4YsWdb2RlNRVGnHse/qljm1PXkApFzGQ/ujXZqM88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fA+3drEd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fA+3drEd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B071F000FF;
	Tue, 13 Oct 2026 12:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894347;
	bh=MGqq+GgDWenOijVRSb6f6bTpxfvaKR4rD5dabfn9myc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fA+3drEdF9qQLkEhAbPCc1+RyOJ4//QDk1bKfPC++DUIl9pnLDL1WR0zaz65/b1Zx
	 iiG1WK1ScLXK3vlKN/UMo9MADpQfxWmxAauds6P7bVf0Oxr0hjAmtfA1TknN2QquBO
	 iwToeoR2G6TD+ayxGU2bPj7YhEoo2KR0wJTfzhm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 528/621] smb/server: fix tree connection leak in smb2_tree_connect()
Date: Tue, 13 Oct 2026 13:38:43 +0200
Message-ID: <20261013112933.350929408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Ze Tan <tanze@kylinos.cn>

[ Upstream commit 39f2032096715daae5f6fd0f587ca7a474b019df ]

See the procedure below:

  smb2_tree_connect
    ksmbd_tree_conn_connect
      xa_store(&sess->tree_conns, tree_conn->id, tree_conn)
      ksmbd_counter_inc(KSMBD_COUNTER_TREE_CONNS)
      ksmbd_share_tree_conn_inc(sc)
    ksmbd_iov_pin_rsp // fail
    status.ret = KSMBD_TREE_CONN_STATUS_NOMEM
    // do not disconnect tree_conn

Disconnect the new tree connection if ksmbd_iov_pin_rsp() fails.

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Signed-off-by: Ze Tan <tanze@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index bbbdc117fc112..e73edf006df72 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2066,8 +2066,16 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
 
 	rc = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_tree_connect_rsp));
-	if (rc)
+	if (rc) {
+		if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
+			down_write(&sess->tree_conns_lock);
+			status.tree_conn->t_state = TREE_DISCONNECTED;
+			up_write(&sess->tree_conns_lock);
+			ksmbd_tree_conn_disconnect(sess, status.tree_conn);
+			status.tree_conn = NULL;
+		}
 		status.ret = KSMBD_TREE_CONN_STATUS_NOMEM;
+	}
 
 	if (!IS_ERR(treename))
 		kfree(treename);
-- 
2.53.0



