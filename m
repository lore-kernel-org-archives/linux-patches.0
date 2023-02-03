Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724D21FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:28:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC878C433EF;
	Fri,  3 Feb 2023 10:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420114;
	bh=NuBiGS8R60NjYxqjfUa/4a3Psxr8CNyMrkwqFlgeYNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPNM8IaWmewCcqru7oEN5wiEeZeoVgPSE8KviQpjkxMndXgOnwNV3ntT/HY5glBqy
	 KajUG6MBHrD9GAbIeak57i50IdkWOHmkdG04YmBfMlOujVi6qwkYTkv1MB8Mg4loOg
	 U3vgCej0PwzZXmTyuEOtSM2NT4xBctNgU587T/Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 084/134] netlink: prevent potential spectre v1 gadgets
Date: Fri,  3 Feb 2023 11:13:09 +0100
Message-Id: <20230203101027.639294733@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
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
index 0d84f79cb4b5..b5ce5e46c06e 100644
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
@@ -169,6 +170,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	if (type <= 0 || type > maxtype)
 		return 0;
 
+	type = array_index_nospec(type, maxtype + 1);
 	pt = &policy[type];
 
 	BUG_ON(pt->type > NLA_TYPE_MAX);
@@ -377,6 +379,7 @@ static int __nla_validate_parse(const struct nlattr *head, int len, int maxtype,
 			}
 			continue;
 		}
+		type = array_index_nospec(type, maxtype + 1);
 		if (policy) {
 			int err = validate_nla(nla, maxtype, policy,
 					       validate, extack);
-- 
2.39.0



