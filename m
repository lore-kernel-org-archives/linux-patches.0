Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D4411C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C51CC4AF5D;
	Mon, 28 Aug 2023 10:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219742;
	bh=G+qQRIo5PraD246KRHspIgKYearCsJLtZB7cW5OPw58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5XLit/fn105wmjEzODpzaqmQVVP7S/ERm+u4kbzSjtVPYNh4tdzxOezrQhm3mnRd
	 RAVGgpbTHQsLcmT7NRMmOHrsivGPXRuGAKYoW4GYkrlyuuo4y5YvRRASs5DDnQG7tS
	 VbpXX/eXwM1gQyAqSIzXAsnd4F6VcCU6ckgPrRIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florent Fourcot <florent.fourcot@wifirst.fr>,
	Brian Baboch <brian.baboch@wifirst.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 38/84] rtnetlink: return ENODEV when ifname does not exist and group is given
Date: Mon, 28 Aug 2023 12:13:55 +0200
Message-ID: <20230828101150.555934278@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florent Fourcot <florent.fourcot@wifirst.fr>

[ Upstream commit ef2a7c9065cea4e3fbc0390e82d05141abbccd7f ]

When the interface does not exist, and a group is given, the given
parameters are being set to all interfaces of the given group. The given
IFNAME/ALT_IF_NAME are being ignored in that case.

That can be dangerous since a typo (or a deleted interface) can produce
weird side effects for caller:

Case 1:

 IFLA_IFNAME=valid_interface
 IFLA_GROUP=1
 MTU=1234

Case 1 will update MTU and group of the given interface "valid_interface".

Case 2:

 IFLA_IFNAME=doesnotexist
 IFLA_GROUP=1
 MTU=1234

Case 2 will update MTU of all interfaces in group 1. IFLA_IFNAME is
ignored in this case

This behaviour is not consistent and dangerous. In order to fix this issue,
we now return ENODEV when the given IFNAME does not exist.

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 30188bd7838c ("rtnetlink: Reject negative ifindexes in RTM_NEWLINK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index cee86a2b3a036..ffa97613314ff 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3272,6 +3272,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct ifinfomsg *ifm;
 	char ifname[IFNAMSIZ];
 	struct nlattr **data;
+	bool link_specified;
 	int err;
 
 #ifdef CONFIG_MODULES
@@ -3292,12 +3293,16 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		ifname[0] = '\0';
 
 	ifm = nlmsg_data(nlh);
-	if (ifm->ifi_index > 0)
+	if (ifm->ifi_index > 0) {
+		link_specified = true;
 		dev = __dev_get_by_index(net, ifm->ifi_index);
-	else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME])
+	} else if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME]) {
+		link_specified = true;
 		dev = rtnl_dev_get(net, NULL, tb[IFLA_ALT_IFNAME], ifname);
-	else
+	} else {
+		link_specified = false;
 		dev = NULL;
+	}
 
 	master_dev = NULL;
 	m_ops = NULL;
@@ -3400,7 +3405,12 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	if (!(nlh->nlmsg_flags & NLM_F_CREATE)) {
-		if (ifm->ifi_index == 0 && tb[IFLA_GROUP])
+		/* No dev found and NLM_F_CREATE not set. Requested dev does not exist,
+		 * or it's for a group
+		*/
+		if (link_specified)
+			return -ENODEV;
+		if (tb[IFLA_GROUP])
 			return rtnl_group_changelink(skb, net,
 						nla_get_u32(tb[IFLA_GROUP]),
 						ifm, extack, tb);
-- 
2.40.1



