Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0949306D2A;
	Sat, 25 Oct 2025 16:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409768; cv=none; b=Sky++BxxQw5V6FY1KEHBydXO6l0x1RS4vrNuYhhwJjSNOOnCqZAVQs7PKPEU9lhuALlx2kd1HGjqj+maJG2YniKOwMJlVQ0yFucMBje9olJXxBRTIy2uow4k6AlPrjaJpByRpbu3cEql8RQyY4BJW1gtqG3a4/2GhVVh/+r8j6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409768; c=relaxed/simple;
	bh=yg3XI9YzjlpQi6prDmKnR1os5FFYDrA0vGFt3yZ4Prk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TjSJ54ykNP/Qk/H//w5dlf7d//e2FhupbJX0DSpXCepkE8J6TaqY7kwwfawJ7AbYgcuNGKprhkZUlbbZdGczr6L2D042KzWIsKMEj0s0Q82WBRtwXzjdXp268OqJ68QMg//z2U6Q2B/W5yZPXHeCjhgZmYjXA3SVLdr6Iwl73jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fj7sT2G9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fj7sT2G9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D4BC4CEFB;
	Sat, 25 Oct 2025 16:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409767;
	bh=yg3XI9YzjlpQi6prDmKnR1os5FFYDrA0vGFt3yZ4Prk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fj7sT2G9ekuZgrPA3SxvuS5nogT0yqkCmmH6d51JMexI6va4l5ukIZ7tthPuDlgF6
	 2P+9Zz/L+U7oAef3RQDCSC0ngmr/cCw16Y1/n+n2gVgOz3M0zY/OMlRw8wVloF9T/F
	 f4QhEHQHGo4ZyNFALtM4lrUaeoVt3zfEygV0f1qCY6ynMwSFhh5pFNI4JvRb0a4oOB
	 /2KDPQa16tQMJPJCLkrQ6+kiHQqf7VEtWnghf5eBeyqH0EWckyhDcjMOwK2aMNZ2xz
	 VI2Cx6XK2HodPbRDI6n8NRDD+pGIhJKVVhKuZWRQomAEURmB9JSsfy5zrol65je+/M
	 5e7+4Ern6mg6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] inet_diag: annotate data-races in inet_diag_bc_sk()
Date: Sat, 25 Oct 2025 12:01:27 -0400
Message-ID: <20251025160905.3857885-456-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

Explanation

- Fixes unlocked read races: inet_diag_bc_sk() runs without the socket
  lock; the patch snapshots fields using READ_ONCE() to avoid data races
  and torn/unstable reads when populating the filter entry used by the
  bytecode engine.
  - Snapshots `sk_family`: `net/ipv4/inet_diag.c:603` (`entry.family =
    READ_ONCE(sk->sk_family);`)
  - Snapshots ports and ifindex: `net/ipv4/inet_diag.c:605`
    (`entry.sport = READ_ONCE(inet->inet_num);`),
    `net/ipv4/inet_diag.c:606` (`entry.dport =
    ntohs(READ_ONCE(inet->inet_dport));`), `net/ipv4/inet_diag.c:607`
    (`entry.ifindex = READ_ONCE(sk->sk_bound_dev_if);`)
  - Snapshots userlocks and mark: `net/ipv4/inet_diag.c:609`
    (`entry.userlocks = sk_fullsock(sk) ? READ_ONCE(sk->sk_userlocks) :
    0;`), `net/ipv4/inet_diag.c:612` (`entry.mark =
    READ_ONCE(sk->sk_mark);`)
  - Adds harmless const-correctness for `inet`:
    `net/ipv4/inet_diag.c:597` (`const struct inet_sock *inet =
    inet_sk(sk);`)

- Consistent family/address decision: entry_fill_addrs() now branches on
  the single, snapshotted family stored in entry, rather than re-reading
  the socket family, removing a possible inconsistency window between
  family read and address selection.
  - Uses `entry->family` instead of `sk->sk_family`:
    `net/ipv4/inet_diag.c:583` (`if (entry->family == AF_INET6) { ...
    }`)

- Impact and correctness:
  - inet_diag_bc_sk() collects a snapshot which the bytecode interpreter
    compares against filters. Without READ_ONCE(), unlocked reads may be
    optimized into multiple loads or observe mixed values, causing
    spurious filter mismatches (missing or extra sockets in diagnostics)
    or KCSAN data-race reports.
  - No behavioral change beyond stabilizing a read snapshot; avoids
    inconsistencies and better documents concurrency expectations.

- Small, contained change:
  - Single file (`net/ipv4/inet_diag.c`) and localized to entry
    construction in inet_diag_bc_sk() and to a helper branch condition.
  - No API/ABI changes; only read-side annotations and a trivial const
    qualifier.

- Low regression risk:
  - READ_ONCE() is a read-only annotation; it neither introduces
    ordering constraints beyond the atomic access nor changes control
    flow.
  - entry_fill_addrs() uses the already-read family for a consistent
    decision, which is strictly safer than re-reading an unlocked field.

- Broad but safe applicability:
  - inet_diag_bc_sk() is called across protocols (e.g.,
    `net/ipv4/udp_diag.c:16`, `net/ipv4/tcp_diag.c:366`,
    `net/ipv4/raw_diag.c:131`, `net/mptcp/mptcp_diag.c:20`). All benefit
    from a consistent snapshot without requiring additional locking.

- Stable criteria assessment:
  - Fixes a real bug class (lockless data races/inconsistent reads)
    affecting user-visible diagnostics correctness, especially under
    concurrent socket mutations.
  - Minimal, non-architectural change with negligible risk.
  - No new features or behavior changes beyond stabilizing reads.
  - While there’s no explicit “Cc: stable” tag, the change aligns with
    typical stable backports that annotate/fix data races in widely used
    subsystems.

Conclusion: This is a low-risk correctness fix to avoid unlocked read
races in inet_diag filtering and should be backported to stable trees.

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

