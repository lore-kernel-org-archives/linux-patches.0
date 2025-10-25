Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851473074A4;
	Sat, 25 Oct 2025 16:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409391; cv=none; b=F4abrpOjdBgXpMbeeUHHc7nsHAF/qEtKvPQ1K82MmzOxq4PXbpuR5FW6VJn2hL6YwyUAABGJxZr1OyRg32zB0eXINlAKFBxQcB0RjVuLSJlKVwc6PivlxqHkmgxkW9nfHzsJCDPwsZmHpj9utNnIbyLC7CTutollc+LndA/PRUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409391; c=relaxed/simple;
	bh=Eo1dzXjyZ4j2Et5f+6SWckQLSKp7VD275jrVBd3zdBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oGD656SvChlO+IrwM9B00ZUX4mS4kVjOqfi0y9wQIJFpjERYC+I69tRrhf3NpX4kkenWoTnJA4yKGbiZNMeUpWnmCI7qkxg/0OxnkF0nYk2uNFp6Xh1MrgUCASpO9107Y1NHJk+QHh1DJEbuylOefAI3vASgVT/nlKdY3KGOIqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frffo4kX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frffo4kX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 688C6C4CEF5;
	Sat, 25 Oct 2025 16:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409391;
	bh=Eo1dzXjyZ4j2Et5f+6SWckQLSKp7VD275jrVBd3zdBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=frffo4kXwWag4ETZ9TXSEotj3lsFEDbXpX5gJHQA21QB8nhRclU6JfojSsHH2Ic3L
	 pIQ6p/AxwJRpj4WtfKlu//J19qjKYoJM2r7Ji4ejKJ1Dcb9ClHnKdy1qtjKHfEqIlT
	 D4LeCWypXqrj0k0zMJqstGU3tjv5Gb7ixMz9T40mvO+YKjNVDbrEDC3/ID4z+yJtF2
	 CmrYIC4lquUe9agsIl4tMXGpm5T0tcnVYIzyQsKe2lNlwEPTsx+uaRaXhaxDPD1eYz
	 bN79Y+jvXhCV7Vog3KGv+xVF4F0OjyOraSXpHEhbwhgw3iQ0hN2SrEYedCBoGytz1p
	 K0MksCbe9Y2Ag==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ncardwell@google.com,
	davem@davemloft.net,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] tcp: use dst_dev_rcu() in tcp_fastopen_active_disable_ofo_check()
Date: Sat, 25 Oct 2025 11:58:54 -0400
Message-ID: <20251025160905.3857885-303-sashal@kernel.org>
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

[ Upstream commit b62a59c18b692f892dcb8109c1c2e653b2abc95c ]

Use RCU to avoid a pair of atomic operations and a potential
UAF on dst_dev()->flags.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Explanation and rationale
- What it fixes
  - Eliminates a race that can lead to a use-after-free when reading
    `dev->flags` from a `dst_entry` without RCU protection. The pre-
    change pattern `sk_dst_get()` → `dst_dev()` → `dev->flags` →
    `dst_release()` can observe a freed `struct net_device` and
    dereference `dev->flags`, risking UAF.
  - The change uses RCU to safely dereference the route device and avoid
    the refcount pair on `dst` (performance benefit is secondary to
    correctness).

- Code specifics
  - Affected function: `net/ipv4/tcp_fastopen.c:559`
    (tcp_fastopen_active_disable_ofo_check)
  - Before (conceptually): `dst = sk_dst_get(sk); dev = dst ?
    dst_dev(dst) : NULL; if (!(dev && (dev->flags & IFF_LOOPBACK)))
    atomic_set(..., 0); dst_release(dst);`
    - Problem: `dev->flags` is read without RCU or a device reference;
      `struct net_device` is RCU-freed, so this can race and UAF.
  - After:
    - `rcu_read_lock();`
    - `dst = __sk_dst_get(sk);` (RCU-protected view of
      `sk->sk_dst_cache`; `include/net/sock.h:2142`)
    - `dev = dst ? dst_dev_rcu(dst) : NULL;` (RCU-safe deref of device;
      `include/net/dst.h:574`)
    - `if (!(dev && (dev->flags & IFF_LOOPBACK)))
      atomic_set(&sock_net(sk)->ipv4.tfo_active_disable_times, 0);`
    - `rcu_read_unlock();`
    - See current code at `net/ipv4/tcp_fastopen.c:581` for the RCU
      pattern.
  - The function is invoked in normal teardown paths, so it can be hit
    in practice:
    - `net/ipv4/tcp_ipv4.c:2570`
    - `net/ipv4/tcp.c:3382`

- Scope and risk
  - Small, contained change in a single function, no ABI changes, no
    architectural refactors.
  - Only affects active TCP Fast Open logic when clearing the global
    backoff counter on non-loopback devices.
  - Behavior is unchanged except making the device lookup and flag read
    concurrency-safe and cheaper (no `dst` refcount inc/dec).
  - Reading `IFF_LOOPBACK` under RCU is safe; the bit is effectively
    stable for the loopback device, and RCU guarantees pointer lifetime
    during the check.

- Stable backport fit
  - Fixes a real concurrency/UAF bug that can crash the kernel; it’s not
    a feature change.
  - Minimal risk of regression and confined to TCP/TFO.
  - Uses widely available helpers:
    - `__sk_dst_get()` at `include/net/sock.h:2142`
    - `dst_dev_rcu()` at `include/net/dst.h:574`
  - If an older stable branch lacked `dst_dev_rcu()`, the change is
    trivially adaptable using `rcu_dereference(dst->dev)` under
    `rcu_read_lock()`. But in maintained series this helper is already
    present in the networking core.

- Why it matters
  - Even if exploitation is unlikely (requires racing TFO teardown with
    route/device changes), it’s a correctness and reliability fix in a
    core network path and should be in stable trees.

Conclusion
- This is a clear bug fix for a potential UAF with a minimal, localized
  RCU conversion. It aligns with stable criteria and should be
  backported.

 net/ipv4/tcp_fastopen.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index f1884f0c9e523..7d945a527daf0 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -576,11 +576,12 @@ void tcp_fastopen_active_disable_ofo_check(struct sock *sk)
 		}
 	} else if (tp->syn_fastopen_ch &&
 		   atomic_read(&sock_net(sk)->ipv4.tfo_active_disable_times)) {
-		dst = sk_dst_get(sk);
-		dev = dst ? dst_dev(dst) : NULL;
+		rcu_read_lock();
+		dst = __sk_dst_get(sk);
+		dev = dst ? dst_dev_rcu(dst) : NULL;
 		if (!(dev && (dev->flags & IFF_LOOPBACK)))
 			atomic_set(&sock_net(sk)->ipv4.tfo_active_disable_times, 0);
-		dst_release(dst);
+		rcu_read_unlock();
 	}
 }
 
-- 
2.51.0

