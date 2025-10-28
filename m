Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0181E2E717C;
	Tue, 28 Oct 2025 12:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761655705; cv=none; b=s1C4LdafB30uHiJ3FmMI99A1kRLEX4Wxx67d/2iZIMH9Ei84AtKxeaY4kgBYDsjouio1fJBrZkL4WN+VzCOZFh1/4t4RDUMZpk9g2Dj6wl6BNMsGuk74IOQBdW7DOuLbajvn2VRCrsV7hiBJCO/K4OOcHg/OTDA5AyD4Mo3VSOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761655705; c=relaxed/simple;
	bh=YCzRRoz5aZYCOi7lIEk6gX0/S8WoNE5OPMWRNwiA+Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LmchVqJxjns+naeS5Ecmnw4NSRVBD22m3F2SwI2+LVHCQH+kDgqsLXWOZOpjv0WiYWk8bCUW5wvhoZnb8qfsOh7BKqMM4WJ4QnQgndNVFB6RI9DBjGwUeLHBJWoyK4fqah4rdB5Ax34JxxfyNr6llrjqoeucvQftcPJqDjtRFtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/AMKh89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/AMKh89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806B7C4CEE7;
	Tue, 28 Oct 2025 12:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761655704;
	bh=YCzRRoz5aZYCOi7lIEk6gX0/S8WoNE5OPMWRNwiA+Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/AMKh89lJNdJIaH11wb/ovw4zDIqaXhLTvQZ91l92i6yuM6zv6T7PuJWjKu10UAR
	 pByDAoyCy+koG9CtR4DHRKLPj+N9nl/LY+HuAHt2rSmic9PPZLIrivvL1wmt0aOh8x
	 B7Fxlo2h0Ltd69N4/blwfIVD2j4TL6BWxauuiSfEoLiv4FFq4FVMzLeqXVB4vZ9jeO
	 CSUeo34UcgV+aVOHDej6lDwvxnh0OAZuuncBnWgBonOjjHSZAygd/Ddy2MifzUTRLB
	 8Vnd80IzAUl+7o5GS8FiK2DFSSevrl7SnTxSYluKshrc/8F9aw300Pzn57hGGVrIBk
	 8G8rQZcV8TQTQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ralf Lici <ralf@mandelbit.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antonio Quartulli <antonio@openvpn.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	sdf@fomichev.me,
	hare@suse.de,
	ebiggers@google.com,
	alexandre.f.demers@gmail.com,
	will@kernel.org,
	mhal@rbox.co,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.1] net: datagram: introduce datagram_poll_queue for custom receive queues
Date: Tue, 28 Oct 2025 08:48:04 -0400
Message-ID: <20251028124815.1058740-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028124815.1058740-1-sashal@kernel.org>
References: <20251028124815.1058740-1-sashal@kernel.org>
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

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit f6ceec6434b5efff62cecbaa2ff74fc29b96c0c6 ]

Some protocols using TCP encapsulation (e.g., espintcp, openvpn) deliver
userspace-bound packets through a custom skb queue rather than the
standard sk_receive_queue.

Introduce datagram_poll_queue that accepts an explicit receive queue,
and convert datagram_poll into a wrapper around datagram_poll_queue.
This allows protocols with custom skb queues to reuse the core polling
logic without relying on sk_receive_queue.

Cc: Sabrina Dubroca <sd@queasysnail.net>
Cc: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Antonio Quartulli <antonio@openvpn.net>
Link: https://patch.msgid.link/20251021100942.195010-2-ralf@mandelbit.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## BACKPORT RECOMMENDATION: YES

## EXTENSIVE ANALYSIS

### 1. COMMIT CONTEXT AND PURPOSE

This commit introduces `datagram_poll_queue()`, a new polling function
that accepts an explicit receive queue parameter, and refactors the
existing `datagram_poll()` to be a thin wrapper around it. The commit is
**part of a bug fix series** titled "fix poll behaviour for TCP-based
tunnel protocols" (merge commit df890ceeb2e51).

### 2. TOOLS AND METHODOLOGY USED

**Git analysis tools used:**
- `git log --grep` to trace the patch series and related commits
- `git show` to examine commit messages and Fixes tags
- `git tag --contains` to determine kernel version introduction
- `git diff` to analyze code changes

**Code analysis tools used:**
- `Grep` with pattern matching to find all users of `datagram_poll`
  (found 26 protocol implementations)
- `Read` to examine the espintcp implementation showing the bug
- Manual code review of the changes

**Findings:**
- Found the commit is patch 2 of a 4-patch series (Link:
  20251021100942.195010-2-ralf@mandelbit.com)
- Identified two follow-up commits that **depend on this
  infrastructure**:
  - **commit 0fc3e32c2c069**: espintcp fix with `Fixes: e27cca96cd68`
  - **commit efd729408bc7d**: ovpn fix with `Fixes: 11851cbd60ea`

### 3. BUG IMPACT ANALYSIS

**The bug being fixed:**

From the merge commit message: *"Protocols like [espintcp and ovpn]
decapsulate packets received over TCP and deliver userspace-bound data
through a separate skb queue, not the standard sk_receive_queue.
Previously, both relied on datagram_poll(), which would signal readiness
based on non-userspace packets, **leading to misleading poll results and
unnecessary recv attempts in userspace**."*

**User-visible impact:**
1. Userspace calls `poll()` to check for data availability
2. `poll()` incorrectly signals `EPOLLIN` when sk_receive_queue contains
   non-userspace packets
3. Userspace attempts `recv()` but no actual data is available
4. This causes unnecessary system calls and incorrect application
   behavior

**Affected protocols and kernel versions:**
- **espintcp**: Introduced in v5.6 (2020) → **Bug affects stable kernels
  v5.6+**
- **ovpn**: Introduced in v6.16 (2025) → Only affects very recent
  kernels

### 4. CODE CHANGE ANALYSIS

**Specific changes in net/core/datagram.c:**
- Renamed `datagram_poll()` to `datagram_poll_queue()` with new
  parameter `struct sk_buff_head *rcv_queue`
- Changed line 960 from:
  ```c
  if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
  ```
  to:
  ```c
  if (!skb_queue_empty_lockless(rcv_queue))
  ```
- Created new `datagram_poll()` as a 3-line wrapper:
  ```c
  __poll_t datagram_poll(struct file *file, struct socket *sock,
  poll_table *wait)
  {
  return datagram_poll_queue(file, sock, wait,
  &sock->sk->sk_receive_queue);
  }
  ```
- Added `EXPORT_SYMBOL(datagram_poll_queue)` for module use

**Changes in include/linux/skbuff.h:**
- Added function declaration for `datagram_poll_queue()`

**Total scope:** 47 lines changed (37 insertions, 10 deletions)

### 5. RISK ASSESSMENT

**Why this is low risk:**

1. **Pure refactoring**: The commit extracts existing logic into a new
   function without changing behavior for existing users
2. **Backward compatibility**: All 26 existing users of
   `datagram_poll()` get identical behavior (wrapper calls new function
   with sk_receive_queue)
3. **No architectural changes**: No changes to data structures or
   locking
4. **Self-contained**: Changes isolated to datagram.c and its header
5. **Well-tested path**: The polling logic itself is unchanged, just
   parameterized

**Verification from current code (net/xfrm/espintcp.c:555-566):**
The current buggy espintcp_poll() implementation shows the problem:
```c
__poll_t mask = datagram_poll(file, sock, wait);  // Checks wrong queue!
struct espintcp_ctx *ctx = espintcp_getctx(sk);
if (!skb_queue_empty(&ctx->ike_queue))            // Then manually
checks right queue
    mask |= EPOLLIN | EPOLLRDNORM;
```

This can produce false positives when sk_receive_queue has packets but
ike_queue doesn't.

### 6. STABLE TREE COMPLIANCE ANALYSIS

**Does it meet stable kernel criteria?**

✅ **Required for bug fix**: This is infrastructure needed for fixes with
explicit "Fixes:" tags
✅ **Doesn't introduce new features**: Exports an API but doesn't change
user-facing behavior
✅ **Obviously correct**: Simple refactoring to parameterize existing
code
✅ **Important**: Fixes user-visible poll() misbehavior in espintcp
(exists since v5.6)
✅ **Self-contained**: Minimal, isolated change
✅ **No side effects**: Existing behavior preserved for all current users

**Stable backport strategy:**
- For kernels v5.6 - v6.15: Backport this commit + espintcp fix (commit
  0fc3e32c2c069)
- For kernels v6.16+: Backport this commit + both fixes (espintcp and
  ovpn)

### 7. DEPENDENCY CHAIN

**Critical finding:** The follow-up commits CANNOT be applied without
this infrastructure commit. The espintcp fix calls
`datagram_poll_queue()` which doesn't exist in stable kernels.
Therefore, to backport the bug fix, this commit must also be backported.

From commit 0fc3e32c2c069 (espintcp fix):
```c
- __poll_t mask = datagram_poll(file, sock, wait);
- if (!skb_queue_empty(&ctx->ike_queue))
- mask |= EPOLLIN | EPOLLRDNORM;
- return mask;
+       return datagram_poll_queue(file, sock, wait, &ctx->ike_queue);
```

### 8. CONCLUSION

**BACKPORT STATUS: YES**

**Rationale:**
1. This commit is **mandatory infrastructure** for backporting bug fixes
   that have explicit "Fixes:" tags
2. The bug affects espintcp in stable kernels since v5.6 (2020), making
   it a long-standing issue
3. The change is **minimal, safe, and obviously correct** - a textbook
   refactoring
4. It follows stable kernel rules: enables a bug fix without introducing
   new user-facing features
5. Zero risk to existing users - all 26 current datagram_poll() users
   get identical behavior
6. The follow-up bug fixes cannot be applied without this infrastructure

**Backport as part of the series:** This commit + commit 0fc3e32c2c069
(espintcp fix) should be backported together to stable kernels v5.6+.

 include/linux/skbuff.h |  3 +++
 net/core/datagram.c    | 44 ++++++++++++++++++++++++++++++++----------
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fa633657e4c06..ad66110b43cca 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4157,6 +4157,9 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk,
 				    struct sk_buff_head *sk_queue,
 				    unsigned int flags, int *off, int *err);
 struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned int flags, int *err);
+__poll_t datagram_poll_queue(struct file *file, struct socket *sock,
+			     struct poll_table_struct *wait,
+			     struct sk_buff_head *rcv_queue);
 __poll_t datagram_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait);
 int skb_copy_datagram_iter(const struct sk_buff *from, int offset,
diff --git a/net/core/datagram.c b/net/core/datagram.c
index f474b9b120f98..8b328879f8d25 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -920,21 +920,22 @@ int skb_copy_and_csum_datagram_msg(struct sk_buff *skb,
 EXPORT_SYMBOL(skb_copy_and_csum_datagram_msg);
 
 /**
- * 	datagram_poll - generic datagram poll
+ *	datagram_poll_queue - same as datagram_poll, but on a specific receive
+ *		queue
  *	@file: file struct
  *	@sock: socket
  *	@wait: poll table
+ *	@rcv_queue: receive queue to poll
  *
- *	Datagram poll: Again totally generic. This also handles
- *	sequenced packet sockets providing the socket receive queue
- *	is only ever holding data ready to receive.
+ *	Performs polling on the given receive queue, handling shutdown, error,
+ *	and connection state. This is useful for protocols that deliver
+ *	userspace-bound packets through a custom queue instead of
+ *	sk->sk_receive_queue.
  *
- *	Note: when you *don't* use this routine for this protocol,
- *	and you use a different write policy from sock_writeable()
- *	then please supply your own write_space callback.
+ *	Return: poll bitmask indicating the socket's current state
  */
-__poll_t datagram_poll(struct file *file, struct socket *sock,
-			   poll_table *wait)
+__poll_t datagram_poll_queue(struct file *file, struct socket *sock,
+			     poll_table *wait, struct sk_buff_head *rcv_queue)
 {
 	struct sock *sk = sock->sk;
 	__poll_t mask;
@@ -956,7 +957,7 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
 		mask |= EPOLLHUP;
 
 	/* readable? */
-	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(rcv_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
@@ -978,4 +979,27 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
 
 	return mask;
 }
+EXPORT_SYMBOL(datagram_poll_queue);
+
+/**
+ *	datagram_poll - generic datagram poll
+ *	@file: file struct
+ *	@sock: socket
+ *	@wait: poll table
+ *
+ *	Datagram poll: Again totally generic. This also handles
+ *	sequenced packet sockets providing the socket receive queue
+ *	is only ever holding data ready to receive.
+ *
+ *	Note: when you *don't* use this routine for this protocol,
+ *	and you use a different write policy from sock_writeable()
+ *	then please supply your own write_space callback.
+ *
+ *	Return: poll bitmask indicating the socket's current state
+ */
+__poll_t datagram_poll(struct file *file, struct socket *sock, poll_table *wait)
+{
+	return datagram_poll_queue(file, sock, wait,
+				   &sock->sk->sk_receive_queue);
+}
 EXPORT_SYMBOL(datagram_poll);
-- 
2.51.0

