Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3BB30C371;
	Mon, 13 Apr 2026 16:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098531; cv=none; b=l6hoZ+k4pbeR1MGK0aaYdCCGKHONEumtjdflRHsKjb6oH+wFR/xx4IgPZkqea/EZ9E9TmXGgAxHWpbcEXYOzr4BWTqmweY89Ggn0gTwRqeBozCUWlCa2aSH4avbbFjPKtF7TDd+2uSaLEvdNdTqhAH4g/eldapFRDIdmkpc7jDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098531; c=relaxed/simple;
	bh=pSpHiebUu3bUEaY72l/GWi0P7sXe4IbT9Z30oJ8oiPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uO55z0EspnDY7sJ2DBBG3Qkdh686sG6aNSp6sc6cAULdt37h/V7HLuq4nwr5OBGnmG1XVzwXx3umlfWzSJpiSWVslBcIGF3UjHU4ul+SXZZblAigvb3LEiWGgn73eRXFVUA8Yt8ccLBHA2BMB3+0/+mCcqN2ma2ZR4l5RByGSBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xb6bTPqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xb6bTPqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32651C2BCAF;
	Mon, 13 Apr 2026 16:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098530;
	bh=pSpHiebUu3bUEaY72l/GWi0P7sXe4IbT9Z30oJ8oiPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xb6bTPqtULWIpqz+Wxt2ICOM6kzRpcLI3HEd0sVH8rfEuctKZX026goiMR6O+eAYE
	 vu7F3HPI9yDwj+KZ8HctRsX7VCYsDKN+KEVBkL7OnqeY0lmKcnjNfOoEAMfdXCn5Gk
	 Q966te7H4L8/9yL6B1EhNWY7DkDiJFbC8GVq8Tg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 543/570] Revert "mptcp: add needs_id for netlink appending addr"
Date: Mon, 13 Apr 2026 18:01:14 +0200
Message-ID: <20260413155850.786692199@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

[ Upstream commit 8e2760eaab778494fc1fa257031e0e1799647f46 ]

This commit was originally adding the ability to add MPTCP endpoints
with ID 0 by accident. The in-kernel PM, handling MPTCP endpoints at the
net namespace level, is not supposed to handle endpoints with such ID,
because this ID 0 is reserved to the initial subflow, as mentioned in
the MPTCPv1 protocol [1], a per-connection setting.

Note that 'ip mptcp endpoint add id 0' stops early with an error, but
other tools might still request the in-kernel PM to create MPTCP
endpoints with this restricted ID 0.

In other words, it was wrong to call the mptcp_pm_has_addr_attr_id
helper to check whether the address ID attribute is set: if it was set
to 0, a new MPTCP endpoint would be created with ID 0, which is not
expected, and might cause various issues later.

Fixes: 584f38942626 ("mptcp: add needs_id for netlink appending addr")
Cc: stable@vger.kernel.org
Link: https://datatracker.ietf.org/doc/html/rfc8684#section-3.2-9 [1]
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260407-net-mptcp-revert-pm-needs-id-v2-1-7a25cbc324f8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted changes from pm_kernel.c to pm_netlink.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -972,8 +972,7 @@ static bool address_use_port(struct mptc
 }
 
 static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
-					     struct mptcp_pm_addr_entry *entry,
-					     bool needs_id)
+					     struct mptcp_pm_addr_entry *entry)
 {
 	struct mptcp_pm_addr_entry *cur;
 	unsigned int addr_max;
@@ -1000,7 +999,7 @@ static int mptcp_pm_nl_append_new_local_
 			goto out;
 	}
 
-	if (!entry->addr.id && needs_id) {
+	if (!entry->addr.id) {
 find_next:
 		entry->addr.id = find_next_zero_bit(pernet->id_bitmap,
 						    MAX_ADDR_ID + 1,
@@ -1011,7 +1010,7 @@ find_next:
 		}
 	}
 
-	if (!entry->addr.id && needs_id)
+	if (!entry->addr.id)
 		goto out;
 
 	__set_bit(entry->addr.id, pernet->id_bitmap);
@@ -1152,7 +1151,7 @@ int mptcp_pm_nl_get_local_id(struct mptc
 	entry->ifindex = 0;
 	entry->flags = 0;
 	entry->lsk = NULL;
-	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry, true);
+	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
 	if (ret < 0)
 		kfree(entry);
 
@@ -1374,18 +1373,6 @@ next:
 	return 0;
 }
 
-static bool mptcp_pm_has_addr_attr_id(const struct nlattr *attr,
-				      struct genl_info *info)
-{
-	struct nlattr *tb[MPTCP_PM_ADDR_ATTR_MAX + 1];
-
-	if (!nla_parse_nested_deprecated(tb, MPTCP_PM_ADDR_ATTR_MAX, attr,
-					 mptcp_pm_addr_policy, info->extack) &&
-	    tb[MPTCP_PM_ADDR_ATTR_ID])
-		return true;
-	return false;
-}
-
 static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
@@ -1412,8 +1399,7 @@ static int mptcp_nl_cmd_add_addr(struct
 			return ret;
 		}
 	}
-	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry,
-						!mptcp_pm_has_addr_attr_id(attr, info));
+	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
 	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "too many addresses or duplicate one");
 		if (entry->lsk)


