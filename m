Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F6F2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2EC5C433EF;
	Wed, 12 Apr 2023 08:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289285;
	bh=5N4H+5eKSih01MbLMFxyPjTFXYyj/Rub4l0/ypcZUWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CB5/OA0E7Vys3dFIMMRgRY2+ft3xdYKy3LMTLsrw3pByZ1TFKJvVZuRW9TOFI+/cc
	 1cSKwXUp8K7Kpnl4gpYRlxqw2HYKzHk5aVbgHR7Zuv6B6RBev/4EEkWB6Y65IU5AHG
	 mF0Vv6/0AzmL4mRhFTCxPc8FTuEUfdotmn5D9pRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Andrea Righi <andrea.righi@canonical.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 023/173] l2tp: generate correct module alias strings
Date: Wed, 12 Apr 2023 10:32:29 +0200
Message-Id: <20230412082839.033276886@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrea Righi <andrea.righi@canonical.com>

[ Upstream commit 154e07c164859fc90bf4e8143f2f6c1af9f3a35e ]

Commit 65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h") moved the
definition of IPPROTO_L2TP from a define to an enum, but since
__stringify doesn't work properly with enums, we ended up breaking the
modalias strings for the l2tp modules:

 $ modinfo l2tp_ip l2tp_ip6 | grep alias
 alias:          net-pf-2-proto-IPPROTO_L2TP
 alias:          net-pf-2-proto-2-type-IPPROTO_L2TP
 alias:          net-pf-10-proto-IPPROTO_L2TP
 alias:          net-pf-10-proto-2-type-IPPROTO_L2TP

Use the resolved number directly in MODULE_ALIAS_*() macros (as we
already do with SOCK_DGRAM) to fix the alias strings:

$ modinfo l2tp_ip l2tp_ip6 | grep alias
alias:          net-pf-2-proto-115
alias:          net-pf-2-proto-115-type-2
alias:          net-pf-10-proto-115
alias:          net-pf-10-proto-115-type-2

Moreover, fix the ordering of the parameters passed to
MODULE_ALIAS_NET_PF_PROTO_TYPE() by switching proto and type.

Fixes: 65b32f801bfb ("uapi: move IPPROTO_L2TP to in.h")
Link: https://lore.kernel.org/lkml/ZCQt7hmodtUaBlCP@righiandr-XPS-13-7390
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Tested-by:  Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_ip.c  | 8 ++++----
 net/l2tp/l2tp_ip6.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 4db5a554bdbd9..41a74fc84ca13 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -677,8 +677,8 @@ MODULE_AUTHOR("James Chapman <jchapman@katalix.com>");
 MODULE_DESCRIPTION("L2TP over IP");
 MODULE_VERSION("1.0");
 
-/* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn't like
- * enums
+/* Use the values of SOCK_DGRAM (2) as type and IPPROTO_L2TP (115) as protocol,
+ * because __stringify doesn't like enums
  */
-MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 2, IPPROTO_L2TP);
-MODULE_ALIAS_NET_PF_PROTO(PF_INET, IPPROTO_L2TP);
+MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET, 115, 2);
+MODULE_ALIAS_NET_PF_PROTO(PF_INET, 115);
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 2478aa60145fb..5137ea1861ce2 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -806,8 +806,8 @@ MODULE_AUTHOR("Chris Elston <celston@katalix.com>");
 MODULE_DESCRIPTION("L2TP IP encapsulation for IPv6");
 MODULE_VERSION("1.0");
 
-/* Use the value of SOCK_DGRAM (2) directory, because __stringify doesn't like
- * enums
+/* Use the values of SOCK_DGRAM (2) as type and IPPROTO_L2TP (115) as protocol,
+ * because __stringify doesn't like enums
  */
-MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 2, IPPROTO_L2TP);
-MODULE_ALIAS_NET_PF_PROTO(PF_INET6, IPPROTO_L2TP);
+MODULE_ALIAS_NET_PF_PROTO_TYPE(PF_INET6, 115, 2);
+MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 115);
-- 
2.39.2



