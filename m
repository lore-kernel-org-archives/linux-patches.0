Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475FE143C4E;
	Wed, 19 Jun 2024 13:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802854; cv=none; b=K3+iQ+EPLG6wo7o7GpBu7HMMS4yXPvZa7D3fFsEPafdt6w6EjCx+WvfJrFT7Ih8/yS2bc6inv0q4wBXSSe1jDTLCE2lAuH6FaLy0RFMSbp2u5Uymww0FODSjKaEuZws5bo2b8DN1aJegdlsUQ3rO5ByqGzkPCwGYGkM3t+RanNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802854; c=relaxed/simple;
	bh=3kSbawVpyxy0W4Pki1KvsRRbHGcx5naTvwYqLrbSXnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shcxV9oV9FUR4TYMPg8h28fMjDEzrK5cP1Z9tFIxVOXymvPz57gkw/KsZd5JYAMHOcqIoXjC6b9zFx6Rld0naafF8RB+E4WwsjA0+gHdM2B4OX4AP2YugrSCkJ9OeodQUtagUSzl/XDiPCYlyoWe4rtT+q64oi76W4ncMZQgQLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M708LpsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M708LpsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC88C2BBFC;
	Wed, 19 Jun 2024 13:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802854;
	bh=3kSbawVpyxy0W4Pki1KvsRRbHGcx5naTvwYqLrbSXnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M708LpsWku3fqHJhVBZ1YW8HaTApysJ5OnQ4Hss0QhlcbMLhvFCZBgpRxcX1TyTzI
	 A4rfDqMJuV98+BuJ5In9GZh7eOKqxsfxty4YlAHc1VOBm3DAnwi8DlHI8cHeMdk25s
	 cu/uzbvoR6RwY0+YT2m7WVrysNOYJlhoLk+/Ur6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 069/281] af_unix: Use skb_queue_len_lockless() in sk_diag_show_rqlen().
Date: Wed, 19 Jun 2024 14:53:48 +0200
Message-ID: <20240619125612.499408078@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 5d915e584d8408211d4567c22685aae8820bfc55 ]

We can dump the socket queue length via UNIX_DIAG by specifying
UDIAG_SHOW_RQLEN.

If sk->sk_state is TCP_LISTEN, we return the recv queue length,
but here we do not hold recvq lock.

Let's use skb_queue_len_lockless() in sk_diag_show_rqlen().

Fixes: c9da99e6475f ("unix_diag: Fixup RQLEN extension report")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/diag.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/unix/diag.c b/net/unix/diag.c
index 116cf508aea4a..321336f91a0af 100644
--- a/net/unix/diag.c
+++ b/net/unix/diag.c
@@ -104,7 +104,7 @@ static int sk_diag_show_rqlen(struct sock *sk, struct sk_buff *nlskb)
 	struct unix_diag_rqlen rql;
 
 	if (READ_ONCE(sk->sk_state) == TCP_LISTEN) {
-		rql.udiag_rqueue = sk->sk_receive_queue.qlen;
+		rql.udiag_rqueue = skb_queue_len_lockless(&sk->sk_receive_queue);
 		rql.udiag_wqueue = sk->sk_max_ack_backlog;
 	} else {
 		rql.udiag_rqueue = (u32) unix_inq_len(sk);
-- 
2.43.0



