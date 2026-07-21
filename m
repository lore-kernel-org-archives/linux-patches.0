Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D4C415F2D;
	Tue, 21 Jul 2026 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657743; cv=none; b=mnSHbmwZZBkkhZ22J3RoS8SCkUuLZYKJfs8VOZ9DD2QEnzYJxRoBubH1KoR+eT8Z0yuTnSxlp4OHcqzyC7ZuJ03YVN26uASr3wvxRrapChJvWML72YKtuz4Xji2ylOGiMOe1TgtncK5ykowuWu/KHVgmI/TuP/RhIx28nfM8rfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657743; c=relaxed/simple;
	bh=4iYnhRdth8VneRg1Bad5ZIGEZ/yWhuQlKLWx41wMGek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dsE3mod9V4gign5sL/v3R3+jOgrQX0w2jhEWIwg7zK9zGXUcPTcaEeQVFvSpAFLGQXVESJ24Nc1HA3yTO1lfFbZsrMdhO/A5IzoIV4ersPQ2CoffKYSZsHxI0/4keamXwpIGbB42vWbPTjw2KQVVfMbzzAayHUrfyRC4hmYKZ6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsZfKMuP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsZfKMuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D944B1F000E9;
	Tue, 21 Jul 2026 18:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657741;
	bh=zevscH2RnGN+RLPhjbO/1kD8VRW8BDZuri8mYrZ2p1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsZfKMuPiCQac92YXqhBrnBddZkvcah1/Xr4mSA1EWypF3uAfgrQcIArZzdZfkOHL
	 IZU6YEjpEMmTIHKh3Y9lJS0TNxi3hkWAJIzaUv2DTa5JLwkuSlTV5WkTVkkbCw1faE
	 nxlvFb785IE5EYamIAdKzMdydXaKcOmw42zrZOrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avinash Duduskar <avinash.duduskar@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0878/1611] bpf: zero-initialize the fib lookup flow struct
Date: Tue, 21 Jul 2026 17:16:34 +0200
Message-ID: <20260721152535.138917138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avinash Duduskar <avinash.duduskar@gmail.com>

[ Upstream commit 0dfcb68a6a5ac517b22dff6a1f01cb4f126dfc57 ]

bpf_ipv4_fib_lookup() and bpf_ipv6_fib_lookup() build the flow key on
the stack with a bare "struct flowi4 fl4;" / "struct flowi6 fl6;" and
fill it field by field, but never set flowi4_l3mdev / flowi6_l3mdev.

On the non-DIRECT path the lookup goes through the fib rules whenever the
netns has custom rules, which a VRF installs:

	bpf_ipv4_fib_lookup() -> fib_lookup() -> __fib_lookup()
	  -> l3mdev_update_flow()   reads !fl->flowi_l3mdev
	  -> fib_rules_lookup() -> fib_rule_match()
	       -> l3mdev_fib_rule_match()   uses fl->flowi_l3mdev

l3mdev_update_flow() resolves the l3mdev master from the ingress device
only while the field is still zero. Left at a nonzero stack value the
resolution is skipped, and l3mdev_fib_rule_match() then tests that value
as an ifindex, so the VRF master is not resolved and the rule fails to
match: an ingress enslaved to a VRF can fail to select its table. FIB
rules matching on an L3 master device (l3mdev_fib_rule_iif_match()/
_oif_match()) read the same value, so an "ip rule iif/oif <vrf>"
mismatches the same way.

Zero-initialize the whole flow struct rather than adding one more
field assignment, so any flowi field added later is covered too.
ip_route_input_slow() likewise zeroes the field before its input lookup.

CONFIG_INIT_STACK_ALL_ZERO masks this by default, but it depends on
compiler support (CC_HAS_AUTO_VAR_INIT_ZERO), so INIT_STACK_NONE builds,
including older toolchains that fall back to it, are exposed. Built with
INIT_STACK_ALL_PATTERN, a plain bpf_fib_lookup (no VLAN, no DIRECT) over a
VRF slave whose destination is routed only in the VRF table returns
BPF_FIB_LKUP_RET_NOT_FWDED, and resolves with this patch. On the default
config the lookup succeeds either way, so ordinary testing does not catch
the bug.

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Signed-off-by: Avinash Duduskar <avinash.duduskar@gmail.com>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Link: https://lore.kernel.org/r/20260617224719.1428599-1-avinash.duduskar@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index e91659caea0f8a..a3e6cd9c4a78bc 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6076,7 +6076,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	struct neighbour *neigh;
 	struct net_device *dev;
 	struct fib_result res;
-	struct flowi4 fl4;
+	struct flowi4 fl4 = {};
 	u32 mtu = 0;
 	int err;
 
@@ -6216,7 +6216,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	struct neighbour *neigh;
 	struct net_device *dev;
 	struct inet6_dev *idev;
-	struct flowi6 fl6;
+	struct flowi6 fl6 = {};
 	int strict = 0;
 	int oif, err;
 	u32 mtu = 0;
-- 
2.53.0



