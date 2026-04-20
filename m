Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A42844DB68;
	Mon, 20 Apr 2026 13:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691832; cv=none; b=Mw8OAU8kZcrRFJr9mL3b86Z8KsABGpKrfd7WzaPlM4P0vYbzTVh9IuNE5vx5VEmTzH40aRrFhWkdUWjpeUHhj3a2DAHixSwo7XUNCZkqX2gjr9YcRcqQOCvILmlRzQSIngwJFrUzAJrrAQF4h60Ke3iPrPP8LDTPxmipU0IeOKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691832; c=relaxed/simple;
	bh=QWqzlxLEdJC2C6QA8VUWn4kJuHJ0GHoc5SSo2zvPuJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EA65TS7pddc8C5M56RGHWtE1WIKXIQXWZIN61lg72dX4kyk5ETYCW62txEKWY+J2kOGy7BCqqnOj3S6a4KW2KLVvNab7vaBpOvPV/7HlnT4bDgFdGq0XErG5En3Wy8oPtWEuXdFEecBb6IHuWWiqXHUeRCrqWrQWDiEiA2MOoeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNsexIpZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNsexIpZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7D2C19425;
	Mon, 20 Apr 2026 13:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691832;
	bh=QWqzlxLEdJC2C6QA8VUWn4kJuHJ0GHoc5SSo2zvPuJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNsexIpZc2LeIf8+q6jkkNxFVIB1zuf6LjQWPJ69w+ZrRIBTVYwRQ78Sq8Gjez5xH
	 fLhT+cqA2eBeyY+ryRWJeE/M4TSIj5T8XzkgbvK59MLmmYDInFcLZ3wPtsUk6FEn5R
	 nBEJ4gm4okjtR+BmpI8x3JDoqly1JY3gH87QWufSe7FQki1FxRDAmv49Aiupew3VNy
	 nYK2SqUukvp2fn9QF2FeiKv1eHNXRe2sueloz0QcB52Wnv6ug5lhTrA+jm6QnqBY6E
	 ZhB8yNHzxbudeXiZrc4nxz7uroOLgDgDdQzJVfRuUrk0UxFNDLxnLr0tbMEF55xPPQ
	 RjWTDQL6HkHsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Wesley Atwell <atwellwea@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ncardwell@google.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] tcp: use WRITE_ONCE() for tsoffset in tcp_v6_connect()
Date: Mon, 20 Apr 2026 09:20:15 -0400
Message-ID: <20260420132314.1023554-221-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wesley Atwell <atwellwea@gmail.com>

[ Upstream commit dc9902bbd480aae510b885b67cd30cd04cfce3a8 ]

Commit dd23c9f1e8d5 ("tcp: annotate data-races around tp->tsoffset")
updated do_tcp_getsockopt() to read tp->tsoffset with READ_ONCE()
for TCP_TIMESTAMP because another CPU may change it concurrently.

tcp_v6_connect() still stores tp->tsoffset with a plain write. That
store runs under lock_sock() via inet_stream_connect(), but the socket
lock does not serialize a concurrent getsockopt(TCP_TIMESTAMP) from
another task sharing the socket.

Use WRITE_ONCE() for the tcp_v6_connect() store so the connect-time
writer matches the lockless TCP_TIMESTAMP reader. This also makes the
IPv6 path consistent with tcp_v4_connect().

Signed-off-by: Wesley Atwell <atwellwea@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Link: https://patch.msgid.link/20260310012604.145661-1-atwellwea@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I now have all the information needed for a comprehensive analysis. Let
me compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- **Subsystem**: `tcp` (networking, IPv6 TCP stack)
- **Action verb**: "use" - specifically requesting `WRITE_ONCE()`
  annotation
- **Summary**: Adds `WRITE_ONCE()` for `tp->tsoffset` in
  `tcp_v6_connect()` to fix a data race with concurrent
  `getsockopt(TCP_TIMESTAMP)`.

**Step 1.2: Tags**
- **Reviewed-by**: Eric Dumazet (Google networking maintainer, and
  importantly the AUTHOR of the original annotation commit
  dd23c9f1e8d5c)
- **Reviewed-by**: Jiayuan Chen
- **Link**:
  https://patch.msgid.link/20260310012604.145661-1-atwellwea@gmail.com
- **Signed-off-by**: Jakub Kicinski (net maintainer)
- No Fixes: tag, no Cc: stable tag (expected for manual review)

Record: Notably reviewed by Eric Dumazet who authored the original
tsoffset annotation commit. Strong quality signal.

**Step 1.3: Body Text Analysis**
The commit explains:
1. dd23c9f1e8d5c added `READ_ONCE()` to `do_tcp_getsockopt()` for
   `TCP_TIMESTAMP` and `WRITE_ONCE()` to `tcp_v4_connect()`
2. `tcp_v6_connect()` was missed - it still uses a plain write for
   `tp->tsoffset`
3. `tcp_v6_connect()` runs under `lock_sock()`, but
   `getsockopt(TCP_TIMESTAMP)` doesn't hold the socket lock when reading
   `tsoffset`
4. This creates a data race between the writer (connect) and the
   lockless reader (getsockopt)

Record: Bug is a data race in `tp->tsoffset` store in IPv6 connect path.
The IPv4 path was correctly annotated but IPv6 was missed. This is a gap
in the original fix dd23c9f1e8d5c.

**Step 1.4: Hidden Bug Fix?**
This is explicitly described as completing a data race annotation that
was missed. It IS a bug fix (data race fix).

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- **Files**: 1 file changed (`net/ipv6/tcp_ipv6.c`)
- **Change**: 1 line modified (-1/+1)
- **Function**: `tcp_v6_connect()`
- **Scope**: Single-file, single-line, surgical fix

**Step 2.2: Code Flow Change**

Before:

```328:328:net/ipv6/tcp_ipv6.c
                tp->tsoffset = st.ts_off;
```

After (from the diff):
```c
                WRITE_ONCE(tp->tsoffset, st.ts_off);
```

The only change is wrapping a plain C store in `WRITE_ONCE()`, which
prevents store tearing and acts as a compiler barrier. The actual value
stored is identical.

**Step 2.3: Bug Mechanism**
Category: **Data race (KCSAN-class)**. The concurrent reader
(`do_tcp_getsockopt()` at line 4721 in `tcp.c`) uses `READ_ONCE()` but
the writer in IPv6 doesn't use `WRITE_ONCE()`, violating the kernel's
data race annotation convention. Under the C memory model, a plain write
concurrent with a `READ_ONCE` constitutes undefined behavior.

**Step 2.4: Fix Quality**
- Obviously correct: Yes. Trivially so. WRITE_ONCE wrapping a store is
  mechanically correct.
- Minimal/surgical: Yes. One line.
- Regression risk: Zero. WRITE_ONCE cannot change functional behavior.
- Consistent with existing pattern: IPv4 path already uses `WRITE_ONCE`
  since dd23c9f1e8d5c.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The blame shows line 328 (`tp->tsoffset = st.ts_off;`) was introduced by
commit `165573e41f2f66` (Eric Dumazet, 2026-03-02, "tcp: secure_seq: add
back ports to TS offset"). However, the underlying issue (plain write
without WRITE_ONCE) existed BEFORE this refactoring — the original
annotation commit dd23c9f1e8d5c (v6.5-rc3, July 2023) already missed the
IPv6 path.

**Step 3.2: Fixes Tag Follow-up**
The commit references dd23c9f1e8d5c ("tcp: annotate data-races around
tp->tsoffset"). Verified:
- dd23c9f1e8d5c only modified `net/ipv4/tcp.c` and `net/ipv4/tcp_ipv4.c`
  — it did NOT touch `net/ipv6/tcp_ipv6.c`
- It added `WRITE_ONCE()` to `tcp_v4_connect()` and
  `do_tcp_setsockopt()`, and `READ_ONCE()` to `do_tcp_getsockopt()`
- The IPv6 writer was missed entirely

dd23c9f1e8d5c is in mainline since v6.5-rc3, and was backported to
stable trees (6.1.y, 6.4.y, etc.).

**Step 3.3: File History**
Recent changes to `tcp_ipv6.c` include the `165573e41f2f66` refactoring
(March 2026). For stable trees older than this, the code around the
tsoffset assignment looks different (uses `secure_tcpv6_ts_off()`
directly), but the fix is trivially adaptable.

**Step 3.4: Author**
Wesley Atwell is not the subsystem maintainer but the patch was reviewed
by Eric Dumazet (Google TCP maintainer) who wrote the original
annotation commit. Applied by Jakub Kicinski (net maintainer).

**Step 3.5: Dependencies**
The recent refactoring `165573e41f2f66` changes the code shape in the
diff. In older stable trees (pre-7.0), the backport would need trivial
adaptation: wrapping `secure_tcpv6_ts_off(...)` in `WRITE_ONCE()`
instead of `st.ts_off`. The fix is logically independent.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1**: b4 dig found the submission at
https://patch.msgid.link/20260324221326.1395799-3-atwellwea@gmail.com
(v2 or later revision). Lore.kernel.org is behind anti-bot protection,
so direct access was blocked.

**Step 4.2**: Review from Eric Dumazet is the strongest possible signal
for this subsystem.

**Step 4.3-4.5**: No syzbot report (this is a code-inspection-found data
race). No specific bug report — found by reading the code and noticing
the IPv6 path was missed.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions Modified**: `tcp_v6_connect()`

**Step 5.2: Race Partners**
- Writer: `tcp_v6_connect()` → stores `tp->tsoffset` (under
  `lock_sock()` via `inet_stream_connect()`)
- Reader: `do_tcp_getsockopt()` at line 4721 → reads `tp->tsoffset` with
  `READ_ONCE()` — verified NO lock_sock() is held for `TCP_TIMESTAMP`
- Other writers: `do_tcp_setsockopt()` (already uses `WRITE_ONCE()`,
  line 4178), `tcp_v4_connect()` (already uses `WRITE_ONCE()`, line 336)

The race is real and verified: `getsockopt(TCP_TIMESTAMP)` can run
concurrently with `connect()` from another thread sharing the socket.

**Step 5.3: Other tsoffset accessors**
- `tcp_output.c` line 995: plain read of `tp->tsoffset` — but this runs
  in the data path under the socket lock, so no data race with connect
- `tcp_input.c` lines 4680, 4712, 6884: plain reads — also under socket
  lock
- `tcp_minisocks.c` line 350, 643: assignments during socket
  creation/accept — not concurrent

Record: The data race is specifically between
`getsockopt(TCP_TIMESTAMP)` lockless reader and `tcp_v6_connect()`
writer.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code in Stable?**
- The original annotation commit dd23c9f1e8d5c is in v6.5-rc3, so it was
  backported to stable trees 6.1.y, 6.4.y, 6.5.y, 6.6.y, etc.
- In ALL those trees, the IPv6 path was NOT annotated (because
  dd23c9f1e8d5c never touched `tcp_ipv6.c`)
- The bug exists in every stable tree that has dd23c9f1e8d5c

**Step 6.2: Backport Complications**
Minor: In stable trees without `165573e41f2f66` (which is a very recent
March 2026 change), the line looks different. The fix would need trivial
adaptation to wrap `secure_tcpv6_ts_off(...)` instead of `st.ts_off`.
This is a straightforward mechanical change.

**Step 6.3**: No other fix for this specific IPv6 data race was found.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1**: TCP networking subsystem — **CORE** criticality. Every
system uses TCP.

**Step 7.2**: Active subsystem with frequent commits.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**: All users using IPv6 TCP connections where
`getsockopt(TCP_TIMESTAMP)` is called concurrently with `connect()`.

**Step 8.2: Trigger**: A multi-threaded application where one thread
calls `connect()` on an IPv6 TCP socket while another calls
`getsockopt(TCP_TIMESTAMP)`. The race window exists but the practical
trigger is uncommon.

**Step 8.3: Severity**: MEDIUM. A torn read of `tsoffset` would yield an
incorrect timestamp value from `getsockopt()`. However, under the C
memory model this is undefined behavior, and KCSAN would flag it as a
data race.

**Step 8.4: Risk-Benefit**
- **Benefit**: Completes the data race annotation intended by
  dd23c9f1e8d5c. Fixes UB. Consistent with IPv4 path. Extremely
  important for KCSAN-clean kernels.
- **Risk**: Zero. `WRITE_ONCE()` is a transparent compiler annotation
  that cannot introduce regressions.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**
FOR backporting:
- Fixes a real data race (UB under C memory model)
- Completes a fix that was already backported (dd23c9f1e8d5c) but missed
  the IPv6 path
- One-line change, zero regression risk
- Reviewed by Eric Dumazet (author of the original annotation, TCP
  maintainer)
- Makes IPv6 consistent with IPv4
- Core networking subsystem

AGAINST backporting:
- Practical impact is low (torn read returns slightly wrong timestamp)
- Minor adaptation needed for older stable trees (trivial)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? **YES** — trivially correct one-line
   WRITE_ONCE wrapping
2. Fixes a real bug? **YES** — data race (undefined behavior per C
   memory model)
3. Important issue? **MEDIUM** — data race, potential KCSAN splat;
   completes an incomplete prior fix
4. Small and contained? **YES** — 1 line, 1 file
5. No new features or APIs? **Correct** — no new features
6. Can apply to stable trees? **YES** — with trivial adaptation for
   older trees

**Step 9.3: Exception Categories**: Not an exception category, but a
standard bug fix.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Eric Dumazet and Jiayuan Chen, Link
  to submission, SOB from Jakub Kicinski
- [Phase 2] Diff: single line change `tp->tsoffset = st.ts_off` →
  `WRITE_ONCE(tp->tsoffset, st.ts_off)` in `tcp_v6_connect()`
- [Phase 3] git show dd23c9f1e8d5c: confirmed it only modified
  `net/ipv4/tcp.c` and `net/ipv4/tcp_ipv4.c`, NOT `net/ipv6/tcp_ipv6.c`
- [Phase 3] git blame: line 328 from `165573e41f2f66` (2026-03-02) but
  the missing annotation predates that refactoring
- [Phase 3] Verified dd23c9f1e8d5c is in v6.5-rc3 via `git describe
  --contains`
- [Phase 5] Verified `do_tcp_getsockopt()` at line 4510-4721 does NOT
  hold `lock_sock()` for `TCP_TIMESTAMP` case — confirmed lockless
  READ_ONCE reader
- [Phase 5] Verified `tcp_v4_connect()` at line 336 already has
  `WRITE_ONCE(tp->tsoffset, ...)` — IPv4 was fixed, IPv6 wasn't
- [Phase 5] Verified all other `tp->tsoffset` writers already use
  WRITE_ONCE (lines 336, 4178 in ipv4/)
- [Phase 6] dd23c9f1e8d5c was in v6.5-rc3, so present in all active
  stable trees (6.1.y through 6.12.y)
- [Phase 6] Backport needs trivial adaptation for pre-165573e41f2f66
  trees (wrap `secure_tcpv6_ts_off()` instead of `st.ts_off`)

This is a minimal, obviously correct, zero-risk fix that completes a
data race annotation already present in stable trees. The fix was
reviewed by the original annotation author (Eric Dumazet). It brings the
IPv6 path in line with the already-annotated IPv4 path.

**YES**

 net/ipv6/tcp_ipv6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index bb09d5ccf5990..ba7cd7d3d4da0 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -325,7 +325,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr_unsized *uaddr,
 						 inet->inet_dport);
 		if (!tp->write_seq)
 			WRITE_ONCE(tp->write_seq, st.seq);
-		tp->tsoffset = st.ts_off;
+		WRITE_ONCE(tp->tsoffset, st.ts_off);
 	}
 
 	if (tcp_fastopen_defer_connect(sk, &err))
-- 
2.53.0

