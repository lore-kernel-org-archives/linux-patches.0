Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2721738DC46;
	Thu, 30 Jul 2026 16:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427614; cv=none; b=VGlUUje8y2L7VF8filH2URrF2kElIBDWZaKCsiExZlWPHFrFZWzJi5PShlXfHrvlQ2tkloS1avN0PUl+yO/QrCJ3mPwewP4oFEDGR5DPSgmWZIHQdjrZDc8S5o3XqmKPbrLzVySs2xcE7c2Tpl1XOe76rtzs16rjGmis7rcKsVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427614; c=relaxed/simple;
	bh=xUZuSHErJIUJndr37h2BSNzwqDmrZOiuFQ88KJ0Ca7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uza1w3iybSRUzN2ymcfzJ3LNJlU+hFUpSd0wk68t7lyphIFDtrDrt0ge+W1n/Ol/wfFHkCvG9byRpuDT+3wE5rbupZbyt4P+PYcqeDcyrzjo0xdh+mDG5b3uqPi0J6B82mdTafB53mqZJhAQ+vNf/Mco3ZQ2OHCF5JLghJH8oyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZXSZeeU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZXSZeeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897BD1F000E9;
	Thu, 30 Jul 2026 16:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427613;
	bh=/J8WszbVeYZyAZytSBqfx9Q3lC1QXdYgJ8DYsMdap/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZXSZeeUrkJ9W23/QcWXGa8o68mAtg3U78Wi+6fieOi6zT58SzSgPc1MqG+2a32yj
	 jLUc0plK/6vXxaG0T2Q7lIy/38qnBgeCTTN5b0Z03Nvjj6eAyEuS5sXE+zuYVJmKSl
	 6yEXofWEkA3k0vtIQ+oz3IvdJznt+P/0Jp3ndjug=
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
Subject: [PATCH 6.6 187/484] tipc: fix u16 MTU truncation in media and bearer MTU validation
Date: Thu, 30 Jul 2026 16:11:24 +0200
Message-ID: <20260730141427.529150322@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


