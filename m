Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2EF31987B;
	Sat, 25 Oct 2025 16:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409603; cv=none; b=KBWsH8aVpbYNOx3utMbREoLNT3meej7TjBrULGe4Pezi80djy+oXrVkzsiMgpWM6VyL8SiC7j7kgMvsiiD4BJqsxftcjmKr5TVWKvFpSu5nUEEDR2D8d50fnES3KuHwFtW8h14lcyQ12wC3yVz45GKwBY1s8miVkXtRcj9cMGU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409603; c=relaxed/simple;
	bh=Co6LODMIPKqq/FmAJ6hbmCocTUL3+OWhgxA5iKpY8Sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WDxnLgIaI0uVW3qU8UdXBzRlDX1/oQjvCrjr0jjdX8nvNjAxSpL1DSvX3KrhbD9hKjCXdGlRKVs2nYHlsIb1pjFxSHXGD8TRfNDtzhIgosvlWGm98pGVs054Gy7k2AAgJYsg19LZp36Rn1a565Eoa6YsLyDSvP3CXHhrbK7720o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rDxHK4fA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rDxHK4fA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597BFC4CEF5;
	Sat, 25 Oct 2025 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409603;
	bh=Co6LODMIPKqq/FmAJ6hbmCocTUL3+OWhgxA5iKpY8Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDxHK4fAhKBpjVqUeYVtw8eIEe72hhpC4fqpxfUC3zASM0Dvsex+6sYL8jMe8Aun6
	 eO6GNOYJQmhdmsYQdLTPxzVYVFQrbbXtChTBSC9CVPkR0B38aZKEPPfNWlvjfUxpmu
	 C3nPlWkdeNZAb9x+wXWuXKXgfmOchCzoXxmzrUKejIf61qpJks/wB9IuKDv+sH5m+l
	 RooAL5KGNayq8Z+o/i3EqzGLfkJ+ZqkwlDRM3fn81wn86h3eGdGnNHuAMA6wy7s1uL
	 t2VDOP6MNX6VNLMsEvQFSU1gJ8yvLcCdTn7CzOHvHvcvgByLcUOqtk4Qk4W1b2sAw7
	 KIrlFoNq/FO2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] bridge: Redirect to backup port when port is administratively down
Date: Sat, 25 Oct 2025 12:00:18 -0400
Message-ID: <20251025160905.3857885-387-sashal@kernel.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 3d05b24429e1de7a17c8fdccb04a04dbc8ad297b ]

If a backup port is configured for a bridge port, the bridge will
redirect known unicast traffic towards the backup port when the primary
port is administratively up but without a carrier. This is useful, for
example, in MLAG configurations where a system is connected to two
switches and there is a peer link between both switches. The peer link
serves as the backup port in case one of the switches loses its
connection to the multi-homed system.

In order to avoid flooding when the primary port loses its carrier, the
bridge does not flush dynamic FDB entries pointing to the port upon STP
disablement, if the port has a backup port.

The above means that known unicast traffic destined to the primary port
will be blackholed when the port is put administratively down, until the
FDB entries pointing to it are aged-out.

Given that the current behavior is quite weird and unlikely to be
depended on by anyone, amend the bridge to redirect to the backup port
also when the primary port is administratively down and not only when it
does not have a carrier.

The change is motivated by a report from a user who expected traffic to
be redirected to the backup port when the primary port was put
administratively down while debugging a network issue.

Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250812080213.325298-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Prevents known-unicast blackholing when a bridge port with a
    configured backup is put administratively down. Today, with a backup
    port configured, FDB entries are intentionally not flushed on STP
    disable (net/bridge/br_stp_if.c:116), so known unicast continues to
    target the primary port. However, br_forward() only redirects to the
    backup when the primary has no carrier, not when it’s
    administratively down, so traffic can be dropped until FDB aging.
  - The patch extends the existing redirection criterion to cover both
    “no carrier” and “admin down,” aligning behavior with user
    expectations in MLAG-like deployments and eliminating a surprising
    failure mode.

- Why it’s a stable-worthy bugfix
  - User-visible impact: Traffic blackhole in a common operational
    scenario (admin down during maintenance/debug), even though a backup
    port is configured and FDB entries are retained specifically to
    allow continued forwarding.
  - Small, contained change: One condition widened in a single function;
    no API/ABI or architectural changes.
  - Consistent with existing semantics: It broadens an already-
    established fast-failover behavior (originally for link/carrier
    loss) to the equivalent “port down” state, which is operationally
    the same intent.
  - Maintainer acks: Reviewed-by and Acked-by from bridge maintainers;
    Signed-off by net maintainer.

- Code reference and rationale
  - Current redirection only when carrier is down:
    - net/bridge/br_forward.c:151
      if (rcu_access_pointer(to->backup_port) &&
      !netif_carrier_ok(to->dev)) { ... }
  - Patch adds admin-down to the same decision, effectively:
    - net/bridge/br_forward.c:151
      if (rcu_access_pointer(to->backup_port) &&
      (!netif_carrier_ok(to->dev) || !netif_running(to->dev))) { ... }
    - This ensures redirection also when `!netif_running()`
      (administratively down).
  - The reason blackholing occurs without this patch:
    - On STP port disable, FDB entries are not flushed if a backup port
      is configured:
      - net/bridge/br_stp_if.c:116
        if (!rcu_access_pointer(p->backup_port))
        br_fdb_delete_by_port(br, p, 0, 0);
    - This optimization (commit 8dc350202d32, “optimize backup_port fdb
      convergence”) intentionally keeps FDB entries to enable seamless
      redirection, but br_forward() fails to redirect when the port is
      admin down, causing drops.

- Risk assessment
  - Minimal regression risk: Checks only `netif_running(to->dev)` in a
    path that already conditionally redirects; `should_deliver()` still
    gates actual forwarding on the backup port’s state and policy.
  - No new features, no data structure changes, no timing-sensitive
    logic added.
  - Behavior remains unchanged unless a backup port is configured, and
    then only in the admin-down case, which is the intended failover
    scenario.

- Backport considerations
  - Applicable to stable series that include backup port support and the
    FDB-retention optimization (e.g., post-2018/2019 kernels). It will
    not apply to trees that predate `backup_port`.
  - The change is a clean one-liner in `br_forward()`; no dependencies
    beyond existing `netif_running()` and `netif_carrier_ok()`.

Conclusion: This is a clear bugfix to prevent data-plane blackholes in a
supported configuration with minimal risk. It should be backported to
stable kernels that have bridge backup-port support.

 net/bridge/br_forward.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 29097e984b4f7..870bdf2e082c4 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -148,7 +148,8 @@ void br_forward(const struct net_bridge_port *to,
 		goto out;
 
 	/* redirect to backup link if the destination port is down */
-	if (rcu_access_pointer(to->backup_port) && !netif_carrier_ok(to->dev)) {
+	if (rcu_access_pointer(to->backup_port) &&
+	    (!netif_carrier_ok(to->dev) || !netif_running(to->dev))) {
 		struct net_bridge_port *backup_port;
 
 		backup_port = rcu_dereference(to->backup_port);
-- 
2.51.0

