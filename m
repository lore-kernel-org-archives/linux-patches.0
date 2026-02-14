Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E586325F994;
	Sat, 14 Feb 2026 21:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104338; cv=none; b=KED4N0+jtxTNeKfCXEtbuA+vPTGheDc22k3PvFypcO0XOwh5p4ylHncxdH52z07x6RKjffC4XAcvvDcRzumWIWz3bVGfzrRiXCcpq3H/klqdPDfMhraZb2SKI/8PUhb8FEMuB6ijUFFHOX+n5djBYhKZMRw0TkjVRRmqv3DjJl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104338; c=relaxed/simple;
	bh=qtxYZTGJQeqK8Nfdp0BEb53NOaoUaaE1kwfFFdgXlJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pcA68Zlo0H0gRNHgQbjNYvaH/GcG8CLL+OKFKj14YjDV1TiPwEszAcJLSdPmCbUMomMLRzQH1O8pjnlJHHTEjPPG3nmikdaaDwrIVc1SRDZmRKEnwkytB6OsY0MEb4XRDIFY+3w5uXoSyA6cyzNqMCnYfjSw+A3fh7mfJsDypok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hsEjmgC3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hsEjmgC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9652C16AAE;
	Sat, 14 Feb 2026 21:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104337;
	bh=qtxYZTGJQeqK8Nfdp0BEb53NOaoUaaE1kwfFFdgXlJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsEjmgC3nPqbk1ZUyXAiPSi+a0ASUpCGL/BIBmb/koMlB+HXKAKeFnEKhdEyRnjW+
	 a2CzO+88cD5fnL9vwLviZmXY0JXTwoo141dcs+Vtmn/fQUHIchAjqUhYpMrNLdatb6
	 PJ6W9iZP7w0tO88JEqC1tIla8pE/Br3l9eZSYpXZ9DsDIHWghn3QqGZpn2WjnDILaj
	 wB6wlGUFeBJuAPeTXEB1N55lu7PSFCx9/8stvAeDxOGCQRP9YAwbUistsM3wsWM2BQ
	 Uev/xbSCv+JFv+LdQWOsJjYgLwnCSZMPvQeXIr73qKohjVgrMcxmoPBEDZ24TIQSSF
	 KtKruH7QFg4VA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	pabeni@redhat.com,
	aleksander.lobakin@intel.com,
	willemb@google.com,
	mheib@redhat.com,
	alice@isovalent.com,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-6.1] gro: change the BUG_ON() in gro_pull_from_frag0()
Date: Sat, 14 Feb 2026 16:22:50 -0500
Message-ID: <20260214212452.782265-25-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cbe41362be2c27e0237a94a404ae413cec9c2ad9 ]

Replace the BUG_ON() which never fired with a DEBUG_NET_WARN_ON_ONCE()

$ scripts/bloat-o-meter -t vmlinux.1 vmlinux.2
add/remove: 2/2 grow/shrink: 1/1 up/down: 370/-254 (116)
Function                                     old     new   delta
gro_try_pull_from_frag0                        -     196    +196
napi_gro_frags                               771     929    +158
__pfx_gro_try_pull_from_frag0                  -      16     +16
__pfx_gro_pull_from_frag0                     16       -     -16
dev_gro_receive                             1514    1464     -50
gro_pull_from_frag0                          188       -    -188
Total: Before=22565899, After=22566015, chg +0.00%

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260122045720.1221017-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of: "gro: change the BUG_ON() in gro_pull_from_frag0()"

### 1. COMMIT MESSAGE ANALYSIS

The commit replaces a `BUG_ON()` with `DEBUG_NET_WARN_ON_ONCE()` in the
GRO (Generic Receive Offload) network path. The author is Eric Dumazet,
a top Google network stack developer and prolific stable contributor.
The commit message notes this BUG_ON() "never fired" and includes bloat-
o-meter output showing minor code size changes.

There are no "Fixes:" tags or "Cc: stable" tags, which is expected for
commits under review.

### 2. CODE CHANGE ANALYSIS

The change is a single-line replacement:

```c
- BUG_ON(skb->end - skb->tail < grow);
+ DEBUG_NET_WARN_ON_ONCE(skb->end - skb->tail < grow);
```

**What this does:**
- `BUG_ON()` crashes the entire kernel (panic) if the condition is true.
  This is a hard crash that takes down the whole system.
- `DEBUG_NET_WARN_ON_ONCE()` only prints a warning (and only once), and
  only when `CONFIG_DEBUG_NET` is enabled. In production kernels without
  `CONFIG_DEBUG_NET`, this becomes a no-op.

**The critical difference:** After the change, if the condition
triggers, the code continues to execute `memcpy()` and subsequent
operations with potentially bad parameters. However, the BUG_ON was
described as having "never fired," meaning this condition is believed to
be unreachable in practice.

### 3. CLASSIFICATION

This is a **BUG_ON to WARN conversion** — a common pattern in the
kernel. The kernel community has a strong policy of removing BUG_ON()
calls from non-fatal paths because:
- A BUG_ON() in the network receive path means a single malformed packet
  (or driver bug) can crash the entire system
- A WARN is preferred because it allows the system to continue operating
  and reports the issue for debugging
- BUG_ON() in hot paths is considered a denial-of-service risk

This is categorized as a **robustness/stability improvement** — it
prevents a kernel panic in a hot network path. While the condition
reportedly never fires, if it ever did (e.g., due to a driver bug,
memory corruption, or edge case), the old code would crash the kernel,
while the new code allows survival.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 1 line (single token replacement)
- **Files changed:** 1 (`net/core/gro.c`)
- **Subsystem:** Core networking (GRO) — very hot path, affects every
  system doing network I/O
- **Risk:** Very low. Replacing BUG_ON with a warning is strictly less
  dangerous — in the worst case, if the condition fires, instead of a
  guaranteed crash, we get either a warning (debug builds) or continued
  execution (production builds). The continued execution after the
  condition could theoretically cause memory corruption, but it was
  already protected by the fact that `gro_try_pull_from_frag0()`
  validates the grow parameter.

### 5. USER IMPACT

- **Who is affected:** Every Linux system using network GRO (virtually
  all networked systems)
- **Severity if bug triggers:** Without this fix, a BUG_ON in the
  network receive path means a kernel panic — complete system crash.
  With this fix, the system survives.
- **Real-world scenario:** If a NIC driver has a bug that causes an
  unexpected skb layout, or if there's memory corruption, the BUG_ON
  would crash the system. The WARN allows the system to continue and the
  issue to be diagnosed.

### 6. STABILITY INDICATORS

- Author: Eric Dumazet (Google, top networking maintainer) — extremely
  trustworthy
- Reviewed/accepted by: Jakub Kicinski (net maintainer)
- Pattern: BUG_ON → WARN conversions are well-established stable
  material

### 7. DEPENDENCY CHECK

This is a self-contained one-line change. `DEBUG_NET_WARN_ON_ONCE` has
been available in the kernel for several versions. No dependencies on
other commits.

### 8. PRECEDENT

BUG_ON to WARN conversions in hot paths are regularly backported to
stable trees, especially in networking code. The kernel community
considers BUG_ON() in non-fatal paths to be a bug in itself — it's an
overreaction that turns a recoverable situation into a system crash.

### VERDICT

**Pros:**
- Prevents kernel panic in core networking hot path
- Tiny, surgical, one-line change
- Zero risk of regression (strictly less dangerous behavior)
- Author and reviewer are top-tier networking maintainers
- Self-contained, no dependencies
- Well-established pattern (BUG_ON → WARN)

**Cons:**
- The BUG_ON "never fired" — the condition may be unreachable in
  practice
- After conversion, if condition fires in production (non-debug) kernel,
  the code continues with potentially invalid state (though this is
  better than crashing)
- Could be classified as "cleanup" rather than "bug fix"

The change converts a potential denial-of-service (kernel panic via
BUG_ON in network receive path) into a survivable warning. While the
condition reportedly never fires, BUG_ON in hot network paths is itself
considered a bug because it's an unnecessary crash risk. The fix is
minimal, safe, and improves system robustness.

**YES**

 net/core/gro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index 482fa7d7f5981..ef61695fbdbb6 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -417,7 +417,7 @@ static void gro_pull_from_frag0(struct sk_buff *skb, int grow)
 {
 	struct skb_shared_info *pinfo = skb_shinfo(skb);
 
-	BUG_ON(skb->end - skb->tail < grow);
+	DEBUG_NET_WARN_ON_ONCE(skb->end - skb->tail < grow);
 
 	memcpy(skb_tail_pointer(skb), NAPI_GRO_CB(skb)->frag0, grow);
 
-- 
2.51.0

