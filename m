Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D440D1E9913;
	Wed, 15 Jan 2025 10:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937907; cv=none; b=RK6m38A7GK/2TcY66/IZLihuWxqPIOfI/npRGE23w9QKmpr+dyYQvSZW6fb9p+G8ZXaD4m1C6gSrUIAzlRzthh1xr7Xph9GB2o0ZEYTN2okt7lAxCMJalfn+P87geTR5j5MgSp7KaCj3OAe4uUejZyZr3SwY3U/dq0s6yudOuCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937907; c=relaxed/simple;
	bh=zb+Rf8iozRvD2P10y+17+qOVpczg2bTjGSsix/OQvi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xubo3k4P3AAjxqacEfH3AG01SNTM+mszfWXVNsxQZdAb1XdI964UqqBu1Dp3JW1UDgUjnbrWGuSzBn+cZsyVl4vtOhfmUwgf1HN3647F5wSvyjvHaj4mM8+mziq6l0/ZYjl3lkcMGwx9Wktb9tBDA43U9IEGCs4DwbkORmh0qns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOPxzHWN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOPxzHWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49119C4CEDF;
	Wed, 15 Jan 2025 10:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937907;
	bh=zb+Rf8iozRvD2P10y+17+qOVpczg2bTjGSsix/OQvi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iOPxzHWNUpzotu21YkEJ4nJ7SLwXscgYoEP2O87szHZd2z1ZcoRnYVmGZPUZ1n99k
	 e28x0lS86yqPLsogc9RA2iVFwxMDvKWpdeZruqKdbL754FpQXucs/rWfS0wsLcWuy7
	 e0ewVYcjwdv114cAzQp76edNCu5BrTAjbuTxy9sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Duan <dzq.aishenghu0@gmail.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/189] tcp/dccp: allow a connection when sk_max_ack_backlog is zero
Date: Wed, 15 Jan 2025 11:35:22 +0100
Message-ID: <20250115103607.402974373@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zhongqiu Duan <dzq.aishenghu0@gmail.com>

[ Upstream commit 3479c7549fb1dfa7a1db4efb7347c7b8ef50de4b ]

If the backlog of listen() is set to zero, sk_acceptq_is_full() allows
one connection to be made, but inet_csk_reqsk_queue_is_full() does not.
When the net.ipv4.tcp_syncookies is zero, inet_csk_reqsk_queue_is_full()
will cause an immediate drop before the sk_acceptq_is_full() check in
tcp_conn_request(), resulting in no connection can be made.

This patch tries to keep consistent with 64a146513f8f ("[NET]: Revert
incorrect accept queue backlog changes.").

Link: https://lore.kernel.org/netdev/20250102080258.53858-1-kuniyu@amazon.com/
Fixes: ef547f2ac16b ("tcp: remove max_qlen_log")
Signed-off-by: Zhongqiu Duan <dzq.aishenghu0@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250102171426.915276-1-dzq.aishenghu0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_connection_sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index c0deaafebfdc..4bd93571e6c1 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -281,7 +281,7 @@ static inline int inet_csk_reqsk_queue_len(const struct sock *sk)
 
 static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
 {
-	return inet_csk_reqsk_queue_len(sk) >= READ_ONCE(sk->sk_max_ack_backlog);
+	return inet_csk_reqsk_queue_len(sk) > READ_ONCE(sk->sk_max_ack_backlog);
 }
 
 bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
-- 
2.39.5



