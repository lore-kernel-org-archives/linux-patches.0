Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B9929B795;
	Sat, 17 Oct 2026 16:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254753; cv=none; b=iWJBVD6cLh/zoo/TQYed3iyYX4+X9rsYEIIoK5qI4Y7K1UyvCs+wOiXUu8LbbkafCnsSIujlwlajS8xesIKBHWwt1raHbULRfz7UPwzv7y2Y0zLSkafTvhfu9APTtkIlYYtGm2luNVanZQn8LgTppNE3fhbul0MdUEI30QpI07w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254753; c=relaxed/simple;
	bh=sv9R7MPBFcD/yUI8JDXI4ru2Ja5tG7dqd4LhKRHSmbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ewraytczAUQL8RzNINr5z4ZxKG8QXIODhilCAGhxn3X7fXrY7tDkQMw9/DSqb9b0ST3QmPmUgtgqSeMbUzyt92iVndzdHRF9G7zpmop3j6K1ipBBoyJSEUUtBOiPLT8xxAK5N7SHWxkZJfaRLNyWjWBtDlu6kRcXnTglAhTl8v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCN6MynS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCN6MynS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4D81F000C4;
	Sat, 17 Oct 2026 16:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254752;
	bh=nr5rVzBoOvBZYok7eshT9E6QqKrHMMPBUz9FJnPgIdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCN6MynS+/lGINA5FWau4njkzI+3G6YZ1wdOQYU4W9/He1Wz0L3SSK2+KH8s5qkO0
	 mIJSHNVWeVNPNb1xlwaccLA789iSHVulwB8GjkSBeQNtFQIQK0jTV9wfwxved5a6qQ
	 wM3qvzpwrS/bpZXIh87vF5nCCRQHckk70P+125bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxiao Xu <rakukuip@gmail.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 549/869] bpf: Check sk_state before sk_protocol in bpf_tcp_*_syncookie
Date: Sat, 17 Oct 2026 17:56:30 +0200
Message-ID: <20261017160051.165796939@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Luxiao Xu <rakukuip@gmail.com>

[ Upstream commit 31a420a822ff92e2090bd5d65efe8e34e2d6d9b8 ]

bpf_tcp_gen_syncookie and bpf_tcp_check_syncookie accept a socket pointer
'sk' with argument type ARG_PTR_TO_BTF_ID_SOCK_COMMON. However, they access
sk->sk_protocol without validating whether 'sk' represents a full socket.

Fix this issue by checking sk->sk_state != TCP_LISTEN before inspecting
sk->sk_protocol in both bpf_tcp_gen_syncookie and bpf_tcp_check_syncookie.
Since mini-sockets are never in the TCP_LISTEN state, the condition
short-circuits and prevents dereferencing fullsock-specific fields.

Fixes: 399040847084 ("bpf: add helper to check for a valid SYN cookie")
Fixes: 70d66244317e ("bpf: add bpf_tcp_gen_syncookie helper")
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Luxiao Xu <rakukuip@gmail.com>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://lore.kernel.org/bpf/6218aa3534d0d2d3f448fde70a8dc2769d7a8201.1785823138.git.rakukuip@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index a680cf27ad820..ce290de4b1652 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7475,7 +7475,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 		return -EINVAL;
 
 	/* sk_listener() allows TCP_NEW_SYN_RECV, which makes no sense here. */
-	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
+	if (sk->sk_state != TCP_LISTEN || sk->sk_protocol != IPPROTO_TCP)
 		return -EINVAL;
 
 	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies))
@@ -7548,7 +7548,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	if (unlikely(!sk || th_len < sizeof(*th) || th_len != th->doff * 4))
 		return -EINVAL;
 
-	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
+	if (sk->sk_state != TCP_LISTEN || sk->sk_protocol != IPPROTO_TCP)
 		return -EINVAL;
 
 	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies))
-- 
2.53.0



