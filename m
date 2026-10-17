Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66253890F8;
	Sat, 17 Oct 2026 18:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260788; cv=none; b=uD8ng7pqo6uPcm0rxn5i192dTJTpr00aJQMFOqeqC2OIdRUsTAKdOceVt4UfgiTzhSW3r8Bf02xywy2+Ue9HTpCwtqDG3Uo0oRCzm9II+0C0FXfm+wX+L69AXkqZBqAoEujgnipi55dDmyUeBk2SN2dclo+JaPIlNuwjzOuUpIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260788; c=relaxed/simple;
	bh=xVVE/1mXMO9tNp+arT9MRR1QeJaJEaLfqDuNnbvi1RU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwYlJIEXI83rlIQYyhuI7RIqHeIgYDIs0TLYxvscqEok7QGOZ8BYB0pqCLRf3fDliygbkIol/tfGjru/G+lu93flqNGB5+bQMkdhWHnvNzDXVY6/kLrP6fMQESSzVjNdeUSFPXksqMqDlvomxxoNh8WySRgkNWhxtcYBlodJe+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydEH3n/x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydEH3n/x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100CD1F000C4;
	Sat, 17 Oct 2026 18:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260787;
	bh=rPh+Av/BJ77ok8w85gJQ3949ZwoU8nxmFY4n3L9NZEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ydEH3n/xzIwfXdW9efqRk1oeaVTHg+q9JxF/duQp/PWWE4tPK70Y9sJWQGyCrutEn
	 C0uK87LTCEDRm35HdcuP6iX34eYdNL+05N7q2Urknz5m0BdAniq77jqEX4fnD8val+
	 FAf6wGQt8KPnn+VV0H0p8TIN/+J2xH0O/27wUm5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Tan <tanze@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1659/1674] smb/server: fix tree connection leak in smb2_tree_connect()
Date: Sat, 17 Oct 2026 18:05:31 +0200
Message-ID: <20261017160513.653934945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/smb/server/smb2pdu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 7e1a6f8e49131..f2b9e4d9cbd02 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2071,8 +2071,13 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	rsp->ShareFlags = SMB2_SHAREFLAG_MANUAL_CACHING;
 
 	rc = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_tree_connect_rsp));
-	if (rc)
+	if (rc) {
+		if (status.ret == KSMBD_TREE_CONN_STATUS_OK) {
+			ksmbd_tree_conn_disconnect(sess, status.tree_conn);
+			status.tree_conn = NULL;
+		}
 		status.ret = KSMBD_TREE_CONN_STATUS_NOMEM;
+	}
 
 	if (!IS_ERR(treename))
 		kfree(treename);
-- 
2.53.0



