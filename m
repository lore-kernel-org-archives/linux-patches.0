Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BA31C28E;
	Tue, 11 Nov 2025 01:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823940; cv=none; b=YxfZgMhvnb3xfYzXM376D+ihxhTiWiW/onWU2TFx6scjoLHD/0uvXS3CF/Kb1uX7b1DQURag2NRvHRIVKDhodGfBrSgpaYaHz0cSRdPtjiU7UrgEhFjyADRGjUo9JycSlduIsci4rn6z3SI74PqDaR5EsiRN71BPsTxk+1E1KaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823940; c=relaxed/simple;
	bh=GsNmxQDIMQfQBqBrcY/fqQffMKJbBIgKhxanv5Aldjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSJTddhsDoj6N8OmbL3l5yyVGGX3iBf21xabqJMi+USZdkpc7WNO2QW+vluftQKN0Wzduvut7r0K1yvnddVkoUCmRy2RJ2z9/P5BD/CfKTPy2RoiLTNQvDNSB8qGJp+os15GnLZx+2UENs/RISJiq3/kXXdnkSC0feHX95zIsTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIr+DwDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIr+DwDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D85CC16AAE;
	Tue, 11 Nov 2025 01:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823940;
	bh=GsNmxQDIMQfQBqBrcY/fqQffMKJbBIgKhxanv5Aldjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIr+DwDfTjJMebyxp7lOBHzmh06kq/7Ysd+sS5+4jvx7YbBcHm4hpcnDjMp8n8YUo
	 I9hmEeLBsidqmkPWblaYRu9VGHx+Lsg/fVLzdBhqIeBLiJ+z20ZTOKoSVcUW76TXuc
	 vpo9Jgt/axXxHmt7dXe+IXcPEi6mgGQVk2XR/ut4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 401/849] inet_diag: annotate data-races in inet_diag_bc_sk()
Date: Tue, 11 Nov 2025 09:39:31 +0900
Message-ID: <20251111004546.133828259@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4fd84a0aaf2ba125b441aa09d415022385e66bf2 ]

inet_diag_bc_sk() runs with an unlocked socket,
annotate potential races with READ_ONCE().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250828102738.2065992-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_diag.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 2fa53b16fe778..238b2a4a6cf43 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -785,7 +785,7 @@ static void entry_fill_addrs(struct inet_diag_entry *entry,
 			     const struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	if (sk->sk_family == AF_INET6) {
+	if (entry->family == AF_INET6) {
 		entry->saddr = sk->sk_v6_rcv_saddr.s6_addr32;
 		entry->daddr = sk->sk_v6_daddr.s6_addr32;
 	} else
@@ -798,18 +798,18 @@ static void entry_fill_addrs(struct inet_diag_entry *entry,
 
 int inet_diag_bc_sk(const struct nlattr *bc, struct sock *sk)
 {
-	struct inet_sock *inet = inet_sk(sk);
+	const struct inet_sock *inet = inet_sk(sk);
 	struct inet_diag_entry entry;
 
 	if (!bc)
 		return 1;
 
-	entry.family = sk->sk_family;
+	entry.family = READ_ONCE(sk->sk_family);
 	entry_fill_addrs(&entry, sk);
-	entry.sport = inet->inet_num;
-	entry.dport = ntohs(inet->inet_dport);
-	entry.ifindex = sk->sk_bound_dev_if;
-	entry.userlocks = sk_fullsock(sk) ? sk->sk_userlocks : 0;
+	entry.sport = READ_ONCE(inet->inet_num);
+	entry.dport = ntohs(READ_ONCE(inet->inet_dport));
+	entry.ifindex = READ_ONCE(sk->sk_bound_dev_if);
+	entry.userlocks = sk_fullsock(sk) ? READ_ONCE(sk->sk_userlocks) : 0;
 	if (sk_fullsock(sk))
 		entry.mark = READ_ONCE(sk->sk_mark);
 	else if (sk->sk_state == TCP_NEW_SYN_RECV)
-- 
2.51.0



