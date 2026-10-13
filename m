Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE1D4F93A8;
	Tue, 13 Oct 2026 12:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893840; cv=none; b=PC7YEUsAGmDk9rvG+3oEBhjgddh6WzBFDvPDtiEGckcdeFsRAXpROYjJbKAysTXORW9TbprPQZtJDoy7Ivj54b7+oMX8u2baBsJfDxG/QA/ZVGymzUmJtZ3SRjwq7I0L52gaJoipOVth44imiZh9UQapIK2774kJ0T0/FO4c7R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893840; c=relaxed/simple;
	bh=CiG1Jgdv/GbMpeBMZ+kBzBKxBZ/Ms2Tx2QBkQNO/W14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UbAxwCuuhrEi5szscQzsSyChGPw0TNNs+/gdQJToMz00YYj1OQk7asLyWh6uE9Ojt190ejzJrTetmxTEUtWyiMxXQVP5eeDbBfttk0VRA1g06vc9QHW+zTKILZcVlOpUwkoZVRlT3R44eFfwAJ8IrxhMS+ajHAGPhEjsJfAwvpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s52jI6Mw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s52jI6Mw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEEFD1F000FF;
	Tue, 13 Oct 2026 12:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893839;
	bh=NURsNRIvXRsuGKoDww61mLFcHou3LiXjGuyP3zaHKHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s52jI6MwvdRuEhsLbR2cRf/AKDiEjwade7PxDR6ep4ZCFfsmuHYFblZrZz3INgpqh
	 iMxcgAionyCPrlcI6o1xq74ZSiTCQ4pf1Ir319qCa0wPKAZf6hgBiKo+atkSFHzQAi
	 GAj4SAiREZmnaU3Xy5NOz7VEnDka75rf35cyJ3TY=
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
Subject: [PATCH 6.18 361/621] bpf: Check sk_state before sk_protocol in bpf_tcp_*_syncookie
Date: Tue, 13 Oct 2026 13:35:56 +0200
Message-ID: <20261013112929.415223887@linuxfoundation.org>
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
index 308b86abe4608..6926903163592 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7541,7 +7541,7 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 		return -EINVAL;
 
 	/* sk_listener() allows TCP_NEW_SYN_RECV, which makes no sense here. */
-	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
+	if (sk->sk_state != TCP_LISTEN || sk->sk_protocol != IPPROTO_TCP)
 		return -EINVAL;
 
 	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies))
@@ -7614,7 +7614,7 @@ BPF_CALL_5(bpf_tcp_gen_syncookie, struct sock *, sk, void *, iph, u32, iph_len,
 	if (unlikely(!sk || th_len < sizeof(*th) || th_len != th->doff * 4))
 		return -EINVAL;
 
-	if (sk->sk_protocol != IPPROTO_TCP || sk->sk_state != TCP_LISTEN)
+	if (sk->sk_state != TCP_LISTEN || sk->sk_protocol != IPPROTO_TCP)
 		return -EINVAL;
 
 	if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_syncookies))
-- 
2.53.0



