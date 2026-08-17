Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63E93DD851;
	Mon, 17 Aug 2026 15:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979305; cv=none; b=VQHxm0VNhbMqGlxv4y0iE6ysRT+n1m4AMS1NwSQZbtzqKXfidunkoqk3NJSjmfbOl4QFSHylIkCQL838UsLkCl7hkNjTSyLm9jmJXfFi9jYuF/VFk3id57xsxQBbAJHoK9Hd9l7qXXTII2e6c47acUAZv4k8lLCt+mWvzKgNWB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979305; c=relaxed/simple;
	bh=5vZMmJOITbk+M+qFeA7f5W2ASgHwdSlu4EEsHolNpRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2AMGQ+Xl5ytiwTMMTF9aGudyhWrIZsLpKeqm/iVxoP38KcSK5N+bwW2hxummra7lsKce/MF9EdBKZAk60+YnOk1Fm7AMxxGJsX/joVT9TAn5OH1NFgt2P6GZ+q1JtEyv5W7Hw9N0e4LUYfcb1zVQpvhsFX6byYM7w35dDLuumU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VxcWgvBP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VxcWgvBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4451F000E9;
	Mon, 17 Aug 2026 15:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979303;
	bh=CAK4kDDkzzJiQc9yXTa1i3mqnqwO7iQ+8Z6XkSk4bks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VxcWgvBPsufX0OjoXuKb7KvU5wqs8TevSsEllDWzGBCreCQoiL95kyyO0VMOb2xgl
	 +t1IaDvMzi+iTIt2m7UJlyCIktqylXuu1/k0puzUC4b232Hehvt5Y1ME4Y9nAObR1f
	 NdK3dFZ5lPt9cKiru8YSJENO3B6agYmNPMyOJGPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 152/609] tipc: fix u16 MTU truncation in media and bearer MTU validation
Date: Mon, 17 Aug 2026 15:27:28 +0200
Message-ID: <20260817132549.097005035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <blbllhy@gmail.com>

[ Upstream commit 9f29cd8a8e7901a2617c8064ce9f50fc67b97cb8 ]

Both TIPC_NL_MEDIA_SET and TIPC_NL_BEARER_SET accept user-supplied
MTU values but only enforce a minimum bound, not a maximum. When a user
sets the MTU to a value exceeding U16_MAX (65535), it passes validation
but is silently truncated when assigned to u16 fields l->mtu and
l->advertised_mtu in tipc_link_create(). Values like 65536 (0x10000)
truncate to 0, causing a division by zero in tipc_link_set_queue_limits()
which computes TIPC_MAX_PUBL / (l->mtu / ITEM_SIZE). Other overflowing
values (e.g. 65537-131071) produce small incorrect MTU values, resulting
in link malfunction behaviors.

Crash stack (triggered as unprivileged user via user namespace):

  tipc_link_set_queue_limits  net/tipc/link.c:2531
  tipc_link_create            net/tipc/link.c:520
  tipc_node_check_dest        net/tipc/node.c:1279
  tipc_disc_rcv               net/tipc/discover.c:252
  tipc_rcv                    net/tipc/node.c:2129
  tipc_udp_recv               net/tipc/udp_media.c:392

Two independent paths lack the upper bound check:
1. tipc_udp_mtu_bad() -- called from __tipc_nl_media_set() (MEDIA_SET)
2. inline check in __tipc_nl_bearer_set() at bearer.c:1160 (BEARER_SET)

Fix both by rejecting MTU values above U16_MAX.

Fixes: 901271e0403a ("tipc: implement configuration of UDP media MTU")
Reported-by: AutonomousCodeSecurity@microsoft.com
Closes: https://lore.kernel.org/all/CAB8m9WgETt0AjmFwE=F-CKjGXsK6_WDv0=kbYRcC8-noo+amnA@mail.gmail.com
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Signed-off-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260714041541.307702-1-blbllhy@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/tipc/netlink.c
+++ b/net/tipc/netlink.c
@@ -113,12 +113,16 @@ const struct nla_policy tipc_nl_node_pol
 };
 
 /* Properties valid for media, bearer and link */
+static struct netlink_range_validation tipc_nl_mtu_range = {
+	.max = U16_MAX,
+};
+
 const struct nla_policy tipc_nl_prop_policy[TIPC_NLA_PROP_MAX + 1] = {
 	[TIPC_NLA_PROP_UNSPEC]		= { .type = NLA_UNSPEC },
 	[TIPC_NLA_PROP_PRIO]		= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_TOL]		= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_WIN]		= { .type = NLA_U32 },
-	[TIPC_NLA_PROP_MTU]		= { .type = NLA_U32 },
+	[TIPC_NLA_PROP_MTU]		= NLA_POLICY_FULL_RANGE(NLA_U32, &tipc_nl_mtu_range),
 	[TIPC_NLA_PROP_BROADCAST]	= { .type = NLA_U32 },
 	[TIPC_NLA_PROP_BROADCAST_RATIO]	= { .type = NLA_U32 }
 };


