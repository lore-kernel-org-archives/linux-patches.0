Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD343B42CB;
	Tue, 21 Jul 2026 22:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672001; cv=none; b=FHin0r5K9BvNIL0rL5BN/ScRZQOjz7oqm8Jjqc2bzUztlqBB9uftjsgPu8UpR6VA3U80+eYYScKXtVgDaoFbYRiItocxQKmPMIvgGqd2hfiOWPG/3Hje7zvnWrxD47W5VGkOTjON2A/8iLUbCBco8mUjHH1VRCnSPVyIjYjzyt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672001; c=relaxed/simple;
	bh=ZBLiroSfsuU+DTCo52+3+9a0Bf65gYTp0d0T79jeDtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lEdQE/IWEm3VKC5RXUXe6ZrAbNB3epR65WHll6twNu9Esl5gX+Wv2VFGDTGK7oN5q+Q6Rxxi/3qoiilqFSAfdtMKQeQlI0oVCEjMQUcfQuzA2jCRdxcQBxosoIbEtzX5jioMqjYknpq5rz+EH2Fwq7vq2jdXZ3Ynvh6j8LWmkqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEw6LeD4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEw6LeD4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8111F000E9;
	Tue, 21 Jul 2026 22:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672000;
	bh=ZszhS6BYykfmpS6OMLQHWM3UBSDTTLii/KCvCaAvaUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEw6LeD4w6FonVqxox+a2P3dGYuACLHfTBT2pwMlljgSH9N+U1AGYIHtbgA4t1jxd
	 WKgDZaezQ5qMaZ3RWHT8imy+SJgsqI7tmWVmYZ9MUekaFIMhYuasPM3XG18pSGbzeu
	 +5aitm2rqhkBlOf17asGQPxs3mLk1IQt/HyKo2PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avinash Duduskar <avinash.duduskar@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 460/843] bpf: zero-initialize the fib lookup flow struct
Date: Tue, 21 Jul 2026 17:21:35 +0200
Message-ID: <20260721152416.379427194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aee29ec9824425..72807bea81ec53 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5588,7 +5588,7 @@ static int bpf_ipv4_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
 	struct neighbour *neigh;
 	struct net_device *dev;
 	struct fib_result res;
-	struct flowi4 fl4;
+	struct flowi4 fl4 = {};
 	u32 mtu = 0;
 	int err;
 
@@ -5725,7 +5725,7 @@ static int bpf_ipv6_fib_lookup(struct net *net, struct bpf_fib_lookup *params,
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



