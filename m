Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CDE43043D7;
	Sat, 25 Oct 2025 16:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408842; cv=none; b=jmaHzuJHCdvRaU7OoFl5C0rHmNygUQznacFcIYF9MXXxrmEZjYMZg45tcGQJ83h3lzE3vc74mkSb6ibF8WKoENHYV8+/oSjX5tPdeYHGpPIFz8jVQQIYEeHWcLMJm1KsBO1pY+BJphrODyIYo2ZcRHmYYP3ScvRRwTTHzS01xnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408842; c=relaxed/simple;
	bh=IgmH45LL+d82P6e6wIvlesGK2AuuKkSZcgJBaHhKPoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P/H/03LXwEELSCmBJyQjcJpO2HtHsBXR1tck2uge4dooTKRNZ0Dhl3RvPDnAnHcGaMRxh29drXTsaJntYqzX1msNZ7Q0AKsTPpvGC8DgwRjTFhAnAf3n/hthWT48E9w49F8LeYwG00Y+6HfXRXX0sEIKNPuuj3WYXxEBoJd5M6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UGkkhijI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UGkkhijI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB51CC4CEFB;
	Sat, 25 Oct 2025 16:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408842;
	bh=IgmH45LL+d82P6e6wIvlesGK2AuuKkSZcgJBaHhKPoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGkkhijIxhVtQfEbIu5+dxRfxV0Iv+Rx3ZJfwmqVI6uNpYpazHSb/QVMOqiRImKpH
	 LIeqrP+uwqv9w6Qprgd6xk7au69VfyMjfsDhywR1gupRcdpxhuQpzFwiih1LQD6tQK
	 FSPsl/gNMzLLhTQ8E/io4EDW+qcpHuLJnkllGdGNiuRM6bulUwfZZQiWPmIqjnyWlw
	 xYAgIP8DufNcuAt5dXbj5ggtz0tnQ/p830MNAnTEWX/w5B2N0IIgE3KJZmp9HXnDhk
	 6r3bQsDtp/TyRxBlb2IsixlOG5OGfOKreBLs+5iD4IklgcuNtl5jocgNk8eOhVyp9Y
	 J/utLUzAMTzkQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	dsahern@kernel.org,
	chuck.lever@oracle.com,
	matttbe@kernel.org,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] netlink: specs: fou: change local-v6/peer-v6 check
Date: Sat, 25 Oct 2025 11:55:26 -0400
Message-ID: <20251025160905.3857885-95-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit 9f9581ba74a931843c6d807ecfeaff9fb8c1b731 ]

While updating the binary min-len implementation, I noticed that
the only user, should AFAICT be using exact-len instead.

In net/ipv4/fou_core.c FOU_ATTR_LOCAL_V6 and FOU_ATTR_PEER_V6
are only used for singular IPv6 addresses, and there are AFAICT
no known implementations trying to send more, it therefore
appears safe to change it to an exact-len policy.

This patch therefore changes the local-v6/peer-v6 attributes to
use an exact-len check, instead of a min-len check.

Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Link: https://patch.msgid.link/20250902154640.759815-2-ast@fiberby.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The fou netlink spec and generated policy now enforce
  exact 16‑byte lengths for IPv6 address attributes instead of allowing
  any payload ≥16 bytes.
  - Documentation change: `Documentation/netlink/specs/fou.yaml:55` and
    `Documentation/netlink/specs/fou.yaml:63` switch `checks` from `min-
    len: 16` to `exact-len: 16`.
  - Generated policy change: `net/ipv4/fou_nl.c:21` and
    `net/ipv4/fou_nl.c:23` switch from a plain length to
    `NLA_POLICY_EXACT_LEN(16)` for `FOU_ATTR_LOCAL_V6` and
    `FOU_ATTR_PEER_V6`.

- Why it matters: Fou only ever uses a single IPv6 address for these
  attributes; there is no valid case for longer payloads. The parser
  reads exactly one IPv6 address with `nla_get_in6_addr()`:
  - Read paths: `net/ipv4/fou_core.c:716` (LOCAL_V6) and
    `net/ipv4/fou_core.c:722` (PEER_V6) copy exactly 16 bytes.
  - Reply paths also emit exactly 16 bytes with `nla_put_in6_addr()`
    (`net/ipv4/fou_core.c:801`, `net/ipv4/fou_core.c:805`), confirming
    the intent is a fixed-size IPv6 address.

- Bug fixed: With a min-length check, malformed attributes longer than
  16 bytes are accepted and silently truncated by `nla_get_in6_addr()`.
  This change correctly rejects such input at policy time, aligning
  validation with actual usage and preventing garbage/trailing data from
  slipping through.

- Scope and risk:
  - Small and contained: Only touches fou’s netlink policy and its spec;
    no broader architectural or behavioral changes.
  - ABI correctness: Tightens validation to the actual fixed-size ABI
    already assumed by the code and reply side.
  - Compatibility: Legitimate userspace already sends 16‑byte IPv6
    addresses; the commit message notes no known implementations rely on
    larger lengths. Any breakage would only affect incorrect/malformed
    senders, which is desired.
  - Consistency: Matches common practice elsewhere for IPv6 attributes
    (e.g., other generated policies using `NLA_POLICY_EXACT_LEN(16)`).

- Stable backport criteria:
  - Fixes a real validation/robustness bug that could affect users
    (acceptance of malformed attributes).
  - Minimal risk of regression and no architectural changes.
  - Confined to a specific subsystem (fou netlink family).
  - Clear, small change with direct correspondence between spec and
    code.

Given the above, this is a low-risk, correctness/robustness fix that
should be backported.

 Documentation/netlink/specs/fou.yaml | 4 ++--
 net/ipv4/fou_nl.c                    | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/netlink/specs/fou.yaml b/Documentation/netlink/specs/fou.yaml
index 57735726262ec..8e7974ec453fc 100644
--- a/Documentation/netlink/specs/fou.yaml
+++ b/Documentation/netlink/specs/fou.yaml
@@ -52,7 +52,7 @@ attribute-sets:
         name: local-v6
         type: binary
         checks:
-          min-len: 16
+          exact-len: 16
       -
         name: peer-v4
         type: u32
@@ -60,7 +60,7 @@ attribute-sets:
         name: peer-v6
         type: binary
         checks:
-          min-len: 16
+          exact-len: 16
       -
         name: peer-port
         type: u16
diff --git a/net/ipv4/fou_nl.c b/net/ipv4/fou_nl.c
index 3d9614609b2d3..506260b4a4dc2 100644
--- a/net/ipv4/fou_nl.c
+++ b/net/ipv4/fou_nl.c
@@ -18,9 +18,9 @@ const struct nla_policy fou_nl_policy[FOU_ATTR_IFINDEX + 1] = {
 	[FOU_ATTR_TYPE] = { .type = NLA_U8, },
 	[FOU_ATTR_REMCSUM_NOPARTIAL] = { .type = NLA_FLAG, },
 	[FOU_ATTR_LOCAL_V4] = { .type = NLA_U32, },
-	[FOU_ATTR_LOCAL_V6] = { .len = 16, },
+	[FOU_ATTR_LOCAL_V6] = NLA_POLICY_EXACT_LEN(16),
 	[FOU_ATTR_PEER_V4] = { .type = NLA_U32, },
-	[FOU_ATTR_PEER_V6] = { .len = 16, },
+	[FOU_ATTR_PEER_V6] = NLA_POLICY_EXACT_LEN(16),
 	[FOU_ATTR_PEER_PORT] = { .type = NLA_BE16, },
 	[FOU_ATTR_IFINDEX] = { .type = NLA_S32, },
 };
-- 
2.51.0

