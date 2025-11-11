Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1C92D879A;
	Tue, 11 Nov 2025 01:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823581; cv=none; b=FbcpYzACBc7rwC7YL+fw6V7pIJD8vCREVuLapL1ljZhaQ8X+kHFwqWiuYgqHxbk/pitacvvR8Va6WmyCLYLljidHMrvleT5QLBhMpk7JYo2bXcfvIACu/O/zMnbbU/i+h9yX95pqH672kwD2ErTL4ZUAfTmlKGgyuZK/UkDiO8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823581; c=relaxed/simple;
	bh=0h1pEephsztK766OuMmNuHRMr5veDpn7kS38SJICkI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5hdtcaeQeK8dgnNrLDIQbLP5Me6+Eo5ccKDwVwqVwxFrP+P/8wQ0ncVSyDntyLao5EbL1AlceGq17e3jq/XeACak1t7OQLPsEHblRtjFk9MTurhslB6X4C/P5jxei3bhyFacF78vvPIchFKURTLrlYIl2gdqj6dq8W9xxaDPGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BK9VCTN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BK9VCTN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB1CC113D0;
	Tue, 11 Nov 2025 01:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823581;
	bh=0h1pEephsztK766OuMmNuHRMr5veDpn7kS38SJICkI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BK9VCTN+73xgJIuokJfD4QQRh99U3KKSr5gb0vMlRPAQ1uH9UMQxAUrDwti4LBu/q
	 nZnZjrlNiFJ99f1IWaKU6XCa8T5UpqllHAGBoE1VAzs8P50coBtUDYDPalrb3G1LSI
	 9TKsG5RpixO5TzCGuACJHrsD3o6K6vVNZykG8YX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 274/565] inet_diag: annotate data-races in inet_diag_bc_sk()
Date: Tue, 11 Nov 2025 09:42:10 +0900
Message-ID: <20251111004533.048153516@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 67639309163d0..f2de2f2962595 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -783,7 +783,7 @@ static void entry_fill_addrs(struct inet_diag_entry *entry,
 			     const struct sock *sk)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	if (sk->sk_family == AF_INET6) {
+	if (entry->family == AF_INET6) {
 		entry->saddr = sk->sk_v6_rcv_saddr.s6_addr32;
 		entry->daddr = sk->sk_v6_daddr.s6_addr32;
 	} else
@@ -796,18 +796,18 @@ static void entry_fill_addrs(struct inet_diag_entry *entry,
 
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



