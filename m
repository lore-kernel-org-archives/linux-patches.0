Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055518;
	b=oyqJq914TiXOVmKvny3mYuzhrdyPxDDEvAVWbgl6+OWr725rWodg9jB1KbydoIYG6qbS
	 arHHQdd9oxjRZe62eIcCINGv+rwYJPbUnRJmkzaX50HTBFhSMK9aMoXe5Q1k7NGnPR5n7
	 CDInosUylzZ5bgPyglvXTyZBpBUJUQl9YgLwmqOnW1R6Qm9wm1c3bL+MAZlxzEN9LnQIV
	 Oec/lfv4kZhnqrIKaFsz909Fkx/bBVxN+PV1SoCR+3yD0ENCYkGZCjIy84Q54rmvv7s+r
	 pBZnY6yAcF+K7BLLuG5IgpsEvCF8e97G7V86vO77/9DKDHiKUpsa3wF0smg6tD/1j+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lbVvtXpX6AVr+zYvNUmnGZOr+BlDHLghDlQbCqxTe+s=;
	b=2Xl1SO3BWIyxtuScfPMe9Xh1iSPDfl97cY9bSSrCM+fRcxJoQwgViRSX+QQ6Qof7ZYDw
	 /6X2OBA63RpHHI5q/qpZWebz/Ltb+j9bMG278ZhB/oOZCM8+G1HwPO0ziINGZGF49gfEk
	 96XYt79Hxaq3+NOOcUqqkEBXDoaXLf/W3rUm3p8TrIEF1XiU0yUTFUMRd8EDo5O29M9+R
	 x1LPFfQXvlmBoRJrC1cwdYdOZGzx3Hb5hg+ds5JLWxdXwZzxePy7WmiOqLwuCYA3tGCI2
	 EOOT0fFY3pL2BmIDMdh10Of5I/Zwli8rIn+JMqZqwta4FVvRy9mtQE5sUrVr2VuW6Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K6/kLyfn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68440606A31C;
	Thu, 19 Nov 2026 02:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6/kLyfn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEFE1F000C4;
	Thu, 19 Nov 2026 02:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055518;
	bh=lbVvtXpX6AVr+zYvNUmnGZOr+BlDHLghDlQbCqxTe+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6/kLyfnRCwCzRAJQSTuCn3G9zefhHkHq6esOXEpUR7atgD4DCLutOSYUB2A/DkW7
	 vK346Tf7qY5pUI+6Lo4zIXMQFCCvjZuG+taFy7SEhYF1vyvDa4ARrKDhvlJH8j71dD
	 qRftce3tJ+PzVB3svqt9VlBWpnMOB4bTy1VE5DFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1660/2214] IB/isert: Dont share drop_cmd_list across concurrent connection teardowns
Date: Wed, 18 Nov 2026 15:55:36 +0100
Message-ID: <20261118150118.277043206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6325d1f65b369..eb4b21ba79b7c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2589,7 +2589,7 @@ static void
 isert_put_unsol_pending_cmds(struct iscsi_conn *conn)
 {
 	struct iscsit_cmd *cmd, *tmp;
-	static LIST_HEAD(drop_cmd_list);
+	LIST_HEAD(drop_cmd_list);
 
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, tmp, &conn->conn_cmd_list, i_conn_node) {
-- 
2.53.0



