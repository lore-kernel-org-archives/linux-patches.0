Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060980;
	b=Rj6eIlgN/lptX4LIW4J0wAAQbFTGYKh1BnfAPwE+U1akapkM5Pv1KrfthC8uYvTczNIb
	 CPnZsmA09fsaTQWWyGQfyGgrDd8JoIuYAi6tzezwAmuOlqFDQf+vfneefiEt9Glz51oxn
	 QxWEyfw4Cu571EJTf9yH0uMaxpZm3KZTdY9oDyyOmjkZEvmd9DD3DHzFdxXn4T64nIdfm
	 lnX8qVY0TvR8pY4xYNTUe+76+mdwjW6VPE3yNQShYbW3gSb7KW3tfCuEGnuzu3NjkpWj8
	 8HbYJt6CSbnBS6alhctdXKOHwO0CFKl0I+bKSDTNEWxoAUDW+v2WXKOkTgIGNCeiRfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4//owhSGWV76gBln3P7FMoTFOh5ruo8kJWpsSveD/ZQ=;
	b=pEw4xfbF6ehsvM0b6KXBXDSee+iOT9K6HhXJKUfvYOXHYxAZKyNe3Rt93K8ou0I12l6M
	 PPFRO9+PkW1Wk94GVEDDG7n6HLbhlSLa6fPNkfa4XzXnOlMOKKvc0mTmYmxRpkEb6WgdB
	 4ninIWUMVzf5hG5IJmM/cgwvPhh6qQD8boZOPqBgRrOGSwEqdzOdsWQ31agZfeQfph1UC
	 smEqQTXpdagIZ0LrxPZ4HWB0AQ6TN/PVzOGu6XGABtBEfuuO8BLII1TfEnzRXppyAaQGI
	 SRk+KhiTgbrGmRikuc8aHywd5uOgG9kRsyNNd3rW3by44uQS+npFw8HSYB9qyBVnOuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2azZhuP0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FA0606A32C;
	Thu, 19 Nov 2026 04:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2azZhuP0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A373B1F000C5;
	Thu, 19 Nov 2026 04:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060980;
	bh=4//owhSGWV76gBln3P7FMoTFOh5ruo8kJWpsSveD/ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2azZhuP0RsuSXq7eHtXrDAqTjzPg0NLxyu6t7MGqSzWGUZNac8PY6I6rgkH3Go2jQ
	 t+LQvMH8TD5dsk7ILZ1F9i4QXKzu6KhbkvFGdWrSJAzgWqe6zN6snPkRQXfvICCOZM
	 YtymIhFSnqnfZEitVigOsVC+i2O9JSWSDdRM8BjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1393/1848] IB/isert: Dont share drop_cmd_list across concurrent connection teardowns
Date: Wed, 18 Nov 2026 15:57:11 +0100
Message-ID: <20261118150017.787975469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit d30e9b1bc47bd9be4b2fc97b0e4074bc02c4203a ]

isert_put_unsol_pending_cmds() declares drop_cmd_list as a static
LIST_HEAD, so the list is shared across all invocations of the function.
It is called from isert_wait_conn(), the per-connection .iscsit_wait_conn
transport callback, which runs independently for each connection during
teardown.

conn->cmd_lock only protects each connection's own conn_cmd_list, not the
shared drop_cmd_list.  If two connections tear down at the same time, both
threads list_move_tail() commands into the same drop_cmd_list without any
mutual exclusion, and then both iterate and list_del/put it concurrently.
This corrupts the linked list and can double-free iscsit_cmd structures.

Make drop_cmd_list a stack-local list, matching the pattern already used
in isert_free_np().

Fixes: 3e03c4b01da3 ("iser-target: Put the reference on commands waiting for unsol data")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Link: https://patch.msgid.link/20260921031100.2199-1-lirongqing@baidu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index b7efdc63f4a72..3c04da84e3ffb 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2579,7 +2579,7 @@ static void
 isert_put_unsol_pending_cmds(struct iscsi_conn *conn)
 {
 	struct iscsit_cmd *cmd, *tmp;
-	static LIST_HEAD(drop_cmd_list);
+	LIST_HEAD(drop_cmd_list);
 
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, tmp, &conn->conn_cmd_list, i_conn_node) {
-- 
2.53.0



