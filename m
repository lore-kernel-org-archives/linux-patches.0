Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C763229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E209C433EF;
	Mon, 30 Jan 2023 14:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088812;
	bh=PFOJyNlO27zwD8Dhh897/TgQLDx19LJZwmGVrRH31PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gf3w7FfImLsi0lb6hI22fTOPvrQSRsb2iSbqHDk33P0W9BVvg+3r/F2kImaQNAu3u
	 +TnvNcxwqE1skBjjsGhKBDL2dkeVw12VgkyqOI+KR8S0IiOrQHABHTrwhvhytchb4h
	 oayBIiNnweSMnndOReymWt6t8/eTrMQBjPKid8KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 116/143] netlink: prevent potential spectre v1 gadgets
Date: Mon, 30 Jan 2023 14:52:53 +0100
Message-Id: <20230130134311.646505641@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f0950402e8c76e7dcb08563f1b4e8000fbc62455 ]

Most netlink attributes are parsed and validated from
__nla_validate_parse() or validate_nla()

    u16 type = nla_type(nla);

    if (type == 0 || type > maxtype) {
        /* error or continue */
    }

@type is then used as an array index and can be used
as a Spectre v1 gadget.

array_index_nospec() can be used to prevent leaking
content of kernel memory to malicious users.

This should take care of vast majority of netlink uses,
but an audit is needed to take care of others where
validation is not yet centralized in core netlink functions.

Fixes: bfa83a9e03cf ("[NETLINK]: Type-safe netlink messages/attributes interface")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230119110150.2678537-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/nlattr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index fe60f9ae9db1..aa8fc4371e93 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/jiffies.h>
+#include <linux/nospec.h>
 #include <linux/skbuff.h>
 #include <linux/string.h>
 #include <linux/types.h>
@@ -369,6 +370,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	if (type <= 0 || type > maxtype)
 		return 0;
 
+	type = array_index_nospec(type, maxtype + 1);
 	pt = &policy[type];
 
 	BUG_ON(pt->type > NLA_TYPE_MAX);
@@ -584,6 +586,7 @@ static int __nla_validate_parse(const struct nlattr *head, int len, int maxtype,
 			}
 			continue;
 		}
+		type = array_index_nospec(type, maxtype + 1);
 		if (policy) {
 			int err = validate_nla(nla, maxtype, policy,
 					       validate, extack, depth);
-- 
2.39.0



