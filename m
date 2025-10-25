Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0037B306D58;
	Sat, 25 Oct 2025 16:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408964; cv=none; b=pBQyUjeDSv0nhNBSkMHguDetOrbAAo5tXYd1hHXV1qCLyjCshCYIh7s8mcd3nd6Jc+AMe0TGsGvVNV0W2ip/JkUQ9AMO9LTLgFogDaZ5qyw1O7NJdDCP1HnxnXKwmJWqA6xH63HCm7eZ9+HSypMx+eluAlT8dOVRXQHghP/Pjk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408964; c=relaxed/simple;
	bh=Z0gYjaT/pj2+kw/kJwmeS138tIDeq1u8T5VPhho6WXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EbLhAF+FheJXR9SNI5cn6gbF8Smhp3ZyBA0/WbIcvBMW7n2KBkyNioCVpDDSZ0iIV0Kq4UgkgpysuoayhmyOWxu6GHcfPbBebM7/k4jumHbEqMwvnjertYfP09Ztj3amn+wVu18c33uUUQNRYVM37mKzoaBezEuY2k1yyRQ5aJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UPt3eEkQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UPt3eEkQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B97DC4CEFB;
	Sat, 25 Oct 2025 16:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408963;
	bh=Z0gYjaT/pj2+kw/kJwmeS138tIDeq1u8T5VPhho6WXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPt3eEkQBmGbk+OQfd2k3C4yPVZzX3Ama4LeeNW0nbTFL+T5hk9FsmzfXP+3ruknk
	 SK86pWjMMOhYibxXSBNDxGPL4megVe2jmUeZjHEX9Dfniri+bAjFKhmpYFALYY6V3i
	 wcUSsCmian1kCCfo1fW4bXbbT1qnycWgn27H9Q+GPGtFaiWDca9pqnN1SUfFPfblG9
	 wtk50+HwNie0rLksSHOoiJfacxExtjMtOWXmgocNmM9BAg46XEMDlb/Avp/kSg2r2Y
	 8ArY/CmNzwut6Lp/nA5l7XGYWoDdaZf7fnl1raDHn2BEPLvsv8FCpOH2KVMUr8U5+N
	 4eWH1aQH7MUYg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pabeni@redhat.com,
	willemb@google.com
Subject: [PATCH AUTOSEL 6.17-5.4] net: Call trace_sock_exceed_buf_limit() for memcg failure with SK_MEM_RECV.
Date: Sat, 25 Oct 2025 11:56:25 -0400
Message-ID: <20251025160905.3857885-154-sashal@kernel.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 9d85c565a7b7c78b732393c02bcaa4d5c275fe58 ]

Initially, trace_sock_exceed_buf_limit() was invoked when
__sk_mem_raise_allocated() failed due to the memcg limit or the
global limit.

However, commit d6f19938eb031 ("net: expose sk wmem in
sock_exceed_buf_limit tracepoint") somehow suppressed the event
only when memcg failed to charge for SK_MEM_RECV, although the
memcg failure for SK_MEM_SEND still triggers the event.

Let's restore the event for SK_MEM_RECV.

Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20250815201712.1745332-5-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Restores a missing tracepoint emission when memory cgroup charge
    fails for receive allocations. Today, the tracepoint is not emitted
    for SK_MEM_RECV on memcg charge failure, which breaks observability
    for memory pressure on receive paths.
  - The suppression was introduced by d6f19938eb031 (“net: expose sk
    wmem in sock_exceed_buf_limit tracepoint”), as confirmed by blame on
    the conditional emission at net/core/sock.c:3335-3336.

- Change details
  - Current code (before this patch) only emits the tracepoint if:
    - send path: always, or
    - receive path: only if memcg charge “succeeded” (`charged ==
      true`):
      - net/core/sock.c:3335-3336
        if (kind == SK_MEM_SEND || (kind == SK_MEM_RECV && charged))
        trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
  - The patch makes the emission unconditional in the suppression path:
    - Effectively changes the above to:
      - net/core/sock.c:3336
        trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
  - No other logic or accounting is changed; the uncharge remains
    correctly guarded by `if (memcg && charged)` (net/core/sock.c:3340),
    preserving correct memcg accounting.

- Scope and risk
  - Small, contained one-line change in a well-defined path (the
    suppress_allocation path of __sk_mem_raise_allocated()).
  - Functional impact limited to tracing only; no behavior change in
    networking or memory accounting.
  - Tracepoints are nop when disabled (static branches), so overhead
    impact is negligible; when enabled, this restores expected
    visibility for memcg receive failures.

- Historical/contextual analysis
  - Originally, the tracepoint was intended to fire on allocation
    suppression due to either global or memcg limits.
  - d6f19938eb031 (blame at net/core/sock.c:3335-3336) unintentionally
    gated the SK_MEM_RECV case on `charged`, suppressing the event
    specifically when memcg charge failed (the exact condition users
    need to observe).
  - A related fix, 8542d6fac25c0 (“Fix sock_exceed_buf_limit not being
    triggered in __sk_mem_raise_allocated”), already corrected a
    different regression around default `charged` and uncharge gating,
    and is present in this tree (net/core/sock.c:3340). This new change
    complements that by fixing the SK_MEM_RECV/memcg-fail emission gap.

- Stable backport criteria
  - Important bugfix (restores a lost diagnostic signal used by
    operators for memory pressure analysis and debugging).
  - Minimal and localized change; no ABI/API or architectural changes.
  - No side effects on core data path or memory accounting.
  - Affects a core net tracepoint but only its emission conditions;
    matches original intent and symmetry with SK_MEM_SEND.

- Applicability/dependencies
  - Applies cleanly to trees where the conditional exists (introduced by
    d6f19938eb031). No additional dependencies beyond the already-
    present tracepoint infrastructure.
  - For older stable series also missing 8542d6fac25c0, consider
    backporting that commit as well to avoid other missed events in non-
    memcg scenarios.

Conclusion: Backporting this commit is low risk and restores expected
tracing semantics for a real-world observability regression.

 net/core/sock.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index e21348ead7e76..1382bddcbaff4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3336,8 +3336,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 		}
 	}
 
-	if (kind == SK_MEM_SEND || (kind == SK_MEM_RECV && charged))
-		trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
+	trace_sock_exceed_buf_limit(sk, prot, allocated, kind);
 
 	sk_memory_allocated_sub(sk, amt);
 
-- 
2.51.0

