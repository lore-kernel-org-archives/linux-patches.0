Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048868;
	b=QlzMAeSf3zlq9DgNbu2MQl9n1tH25qyyc0kfUkmVT+QDi9+I9FJGr6BxmVELjgWCGqfd
	 qk/RRGiocZkw4TIj9C2edHMQFE7rnfa3o3yKA3OGUJqG1Wfh8AbKUYpe2uMqkoID8IoJw
	 WQsw/B+qCeOsVzEk76hlV2frMQjNip7QcSLDj7p0nxqTbhaKgYUBaReIxhaAPWkpaDhtg
	 Jap5+yrkHKjeerLqkO7SExnV3TVvAtDgwZqU16l34y+IBSRfdveuLe1REHz0rqS+9KlgF
	 qlW2oLd8OcthME1Aj7heD2SN90RK/J89N8Cy5WXq9hRJ44/3N1BYPXDSHA2QRtvi8Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v0rhIBE3WmTY/O/9ToaHq5tKpgy/W38TfkBmrxgBbQ8=;
	b=IvtTQGVX8TB76544I+zGGbs+6jd7+v702z9muxVvwTMNvIRcnoIfG32fXGxCxMTGFZKi
	 5y4KRibFJ5tROYqBwi1Jz/nXoy7WdVNuQQiC5r5gOZeunbZY119dF6Hgk12X1mQ3+t+p+
	 EBYomsA6zzKL5AKw9tfV3q8l+seUueXlC1NXgQh2AwoAhrUfg0uw/s4OTlJ+51MNFLr6g
	 FyyRR1GJZI/DfxxlzaKG4phPJZnCMtarOqZTSKdpitCmyo+QzNL6qo17ioZWPHMs6Lo8h
	 6q9kSrXHiPG59ztQ/lJqTQ4/aSc1hCtfPUW3XKbC96U7QB7gESsOzdSzziu2TLIhYqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rtZrBj6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D53606A32A;
	Thu, 19 Nov 2026 00:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rtZrBj6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E471A1F000C4;
	Thu, 19 Nov 2026 00:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048868;
	bh=v0rhIBE3WmTY/O/9ToaHq5tKpgy/W38TfkBmrxgBbQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rtZrBj6g6O0EPmFDb01YgSAidP1cdOlpnuREVrWEGROUwRrAGxk2Zwp4SGrVvw+iV
	 jKAPEW/USNCv8TcBGV0gQTSeS6A/fCZe/hEa2W9jdZRnp3TBNZyCawInY0DluLqDCS
	 +lK3Li+KxCIF0r1cUPvWhG3FbxuJ3fKRjnqky8rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2121/2857] IB/isert: Dont share drop_cmd_list across concurrent connection teardowns
Date: Wed, 18 Nov 2026 15:52:35 +0100
Message-ID: <20261118150317.772057085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2e474a5d30ff5..a9cde4db403ba 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2590,7 +2590,7 @@ static void
 isert_put_unsol_pending_cmds(struct iscsit_conn *conn)
 {
 	struct iscsit_cmd *cmd, *tmp;
-	static LIST_HEAD(drop_cmd_list);
+	LIST_HEAD(drop_cmd_list);
 
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, tmp, &conn->conn_cmd_list, i_conn_node) {
-- 
2.53.0



