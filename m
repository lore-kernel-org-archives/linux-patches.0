Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23D711193;
	Mon,  4 Mar 2024 21:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588690; cv=none; b=Hl900s3ajPIdzCvurfGf3Cu1oFOZhapp16Mke3OKG8oBOKGbSDw+4C6J7xhaTLLNbSlLKKEM9IdpAxhjKtLx+mZL5/fPKCqxFtuvsQaNqD0I9vBMp2kq2G9LuZBRhPkAxgPZLRf04VZWMG9fNqoieysN5gvDhQJi3buQdwcUZxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588690; c=relaxed/simple;
	bh=xNqjunxuknNlgL2R0jKRLQ+xlXpampVRalacxBuvlUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1JgbQwMTq3b2PGST8fWwR+Lj6QRglgDj80h7f4DRxxF54gzvhIEtKEbMYYu8zl46XpiQz2+jislY8Kx+vyGsz+PuIxUFvvCGKa4JZOkdXnxuOWKepJXZoEiTLjxqtI11T9JyDa6eB8rulb/ZMefV+YOuyrFavSVSdJCVmio+go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EAFca2/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EAFca2/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2FDC433F1;
	Mon,  4 Mar 2024 21:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588690;
	bh=xNqjunxuknNlgL2R0jKRLQ+xlXpampVRalacxBuvlUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAFca2/gx/tC2akskAYku3KxGfkXnZlvCeHyOciEUBM2u9n+C8+xa+Ft7lhPgfMf0
	 AJ6A/oA+c3A4ZgUOa9ovfu9Aj/F5GU99Sucfu3nNv3d+f6EU4uBP6O5Vreai4VciEK
	 qyE8tf/iln8p1A84PbNM+0cX2T8BVSqYer79zh88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/215] rtnetlink: fix error logic of IFLA_BRIDGE_FLAGS writing back
Date: Mon,  4 Mar 2024 21:22:02 +0000
Message-ID: <20240304211558.853871242@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 743ad091fb46e622f1b690385bb15e3cd3daf874 ]

In the commit d73ef2d69c0d ("rtnetlink: let rtnl_bridge_setlink checks
IFLA_BRIDGE_MODE length"), an adjustment was made to the old loop logic
in the function `rtnl_bridge_setlink` to enable the loop to also check
the length of the IFLA_BRIDGE_MODE attribute. However, this adjustment
removed the `break` statement and led to an error logic of the flags
writing back at the end of this function.

if (have_flags)
    memcpy(nla_data(attr), &flags, sizeof(flags));
    // attr should point to IFLA_BRIDGE_FLAGS NLA !!!

Before the mentioned commit, the `attr` is granted to be IFLA_BRIDGE_FLAGS.
However, this is not necessarily true fow now as the updated loop will let
the attr point to the last NLA, even an invalid NLA which could cause
overflow writes.

This patch introduces a new variable `br_flag` to save the NLA pointer
that points to IFLA_BRIDGE_FLAGS and uses it to resolve the mentioned
error logic.

Fixes: d73ef2d69c0d ("rtnetlink: let rtnl_bridge_setlink checks IFLA_BRIDGE_MODE length")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20240227121128.608110-1-linma@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 7cf1e42d7f93b..ac379e4590f8d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5026,10 +5026,9 @@ static int rtnl_bridge_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	struct net *net = sock_net(skb->sk);
 	struct ifinfomsg *ifm;
 	struct net_device *dev;
-	struct nlattr *br_spec, *attr = NULL;
+	struct nlattr *br_spec, *attr, *br_flags_attr = NULL;
 	int rem, err = -EOPNOTSUPP;
 	u16 flags = 0;
-	bool have_flags = false;
 
 	if (nlmsg_len(nlh) < sizeof(*ifm))
 		return -EINVAL;
@@ -5047,11 +5046,11 @@ static int rtnl_bridge_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	br_spec = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), IFLA_AF_SPEC);
 	if (br_spec) {
 		nla_for_each_nested(attr, br_spec, rem) {
-			if (nla_type(attr) == IFLA_BRIDGE_FLAGS && !have_flags) {
+			if (nla_type(attr) == IFLA_BRIDGE_FLAGS && !br_flags_attr) {
 				if (nla_len(attr) < sizeof(flags))
 					return -EINVAL;
 
-				have_flags = true;
+				br_flags_attr = attr;
 				flags = nla_get_u16(attr);
 			}
 
@@ -5095,8 +5094,8 @@ static int rtnl_bridge_setlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 	}
 
-	if (have_flags)
-		memcpy(nla_data(attr), &flags, sizeof(flags));
+	if (br_flags_attr)
+		memcpy(nla_data(br_flags_attr), &flags, sizeof(flags));
 out:
 	return err;
 }
-- 
2.43.0



