Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B113C3905F8;
	Sat, 12 Sep 2026 07:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196690; cv=none; b=ES473mG8Cc6yJ6pUvQoXvOWlh5x0PWYDyOWWkRh7ee5rX1G0HK20JjLpUn3A7sjeMw6cO6nucVsRF9m8ql2X9ioafUVwZU+O/bzjwM0KVaSIM4Zh+ZwAT4xbvSNAi3x4o2MPNW/G8pIcNg6dmLVCvhkkg67Mssq423JaTVP/JKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196690; c=relaxed/simple;
	bh=PUjMINphXDA0KaEmGKaCmd50e4dLpG6tGqfsoRsWk/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ98IwCkbxApJxwMwoXWN+SkFlzv9GaWKfucYamu6MNk7GM4MKNolqkMcvJpUyPyzn/vMEOG/DJ62b2ePC+9EAPVNNvSXF+5t+/ot3mJCuHJXT1jKavryzc1VE+5FQO1e7dbFIP5ot8oQF0M4L3L4oVFZVwTJsQblRTSITkavqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G7mtrMDM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G7mtrMDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC271F000FF;
	Sat, 12 Sep 2026 07:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196689;
	bh=orAYvAPm4nAD691awkKbt+TZO8ROnBnH9Vot5uJGwwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7mtrMDMC6ghqS9nHsxX0JF46icwGFi5qxtP8Jlhk+IxLWUZstGLV8W6o7h6OUVmy
	 F7tYnW4Me19SdfH7cNFHVcEQcjC0HDzmyj2aEVRYFRzxUSrrzjvvUGP2siFdaQ+EX5
	 gfUlJXZaP+KrulLV5qwHP589lvSbXRrXh+5suXq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0018/1815] smb/server: fix tree connection leak in smb2_tree_connect()
Date: Sat, 12 Sep 2026 08:29:28 +0200
Message-ID: <20260912065649.435896664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: b5ec6c462aab ("ksmbd: fix tree connection use-after-free in smb2_tree_connect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2330,8 +2330,16 @@ out_err1:
 		rsp->ShareFlags |= cpu_to_le32(SMB2_SHAREFLAG_COMPRESS_DATA);
 
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


