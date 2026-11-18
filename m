Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024772;
	b=p4agcMAJ7ckhLLYRwjVVCJGaedogNY7GMOFgJ5IvEy7xrbm49bnpyzdbXBNPRAtLrWuT
	 LucCdvopDY1uiIb6kYw15t5WCYaA92UWAKgcKTlfCxL837Rh1yiOLVaAy4T4rtolBKKY9
	 t39JtxN1M9yH7VCTvmWznLKK3rg3k/q2/OlgMbJe+LMXBFZDWEpjYWu3LiZgFw7J+il10
	 Ljt3Fbe1FznGENIFdvVMxB1bACWHe9tiszFbf05kHeuee+ZPy6XN/HACKnCerZ/8nsCJ2
	 8Q9ZcpUPxHLfT/jQp0qRW5XtX5072qBqeOsnUW8efk1MALPWQCju/nxuQ1LrRYGViZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=is8Kp2a93R51fb+AR1dT0Q7GfrbNt83tiXGe7qbekIA=;
	b=rIlNE0G9Hbdw+bNZuv9GaJ0OJHHQZEdMO101gTscnCHWFvXzH97HK408sQDOqDJXRMZK
	 ED4VOKjkLFIFRJ8N+GwxxcaYlp9hY5GsKckOHspNCzJRIaeOYWwinjJzPIxgZR02RyFKN
	 31vVttAXLEb02fofLLvME1JLaTmK19glibKOw0t0UMN5Mo2g6HmVjuD682IPTJu95nAJL
	 /b7z6X6u8OZlYEDVcKZZzM8+6JFaujMB4T4smQy5FAQ5keDbTWxaKuqKcNSdayLGtcOdG
	 AXJARlBQFZe/HyxUukVSmTY2STOgLMEdO+B2jpmpra/gki+CGeXodhLnJS9Xie/ypBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GRNHigkH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98676606A338;
	Wed, 18 Nov 2026 17:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GRNHigkH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88EE1F000C6;
	Wed, 18 Nov 2026 17:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024772;
	bh=is8Kp2a93R51fb+AR1dT0Q7GfrbNt83tiXGe7qbekIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GRNHigkHgj//x8Z10qw8Gafv6TH1FRI12lrD40AV/pWlroLTTB/2UC4KwM9iW3UA3
	 L7j3+pl9NOd3aR0spk2MzMnuUS6MEjKE4/9DIv4d1eZ88syjRH9chNPytyH34FXIgv
	 A49gU5qEvOwMY1WmBSJTImQCkq7dHxh7QsvKt/f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0844/2151] IB/isert: Dont share drop_cmd_list across concurrent connection teardowns
Date: Wed, 18 Nov 2026 15:42:59 +0100
Message-ID: <20261118150153.002365419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b3fc753982a38..e3ff99c75b308 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2586,7 +2586,7 @@ static void
 isert_put_unsol_pending_cmds(struct iscsit_conn *conn)
 {
 	struct iscsit_cmd *cmd, *tmp;
-	static LIST_HEAD(drop_cmd_list);
+	LIST_HEAD(drop_cmd_list);
 
 	spin_lock_bh(&conn->cmd_lock);
 	list_for_each_entry_safe(cmd, tmp, &conn->conn_cmd_list, i_conn_node) {
-- 
2.53.0



