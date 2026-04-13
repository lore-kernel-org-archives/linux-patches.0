Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4F4D24DCF6;
	Mon, 13 Apr 2026 16:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097024; cv=none; b=m49ERXV9uAPaDVSOX8KR4z00Qwqy46XRTajupDybWvpRWu8+LOF9ipZfiuB+zPidrgl5JtFq6KoelcCFhYDnFSOpYL2UQjBC9cHDZe8BjrlLVR5/vI7I8IcjUKwdcY70EWPsZHxLmrH6S+Tou8B6DKdsKWdgVbnvx3h3chfL4Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097024; c=relaxed/simple;
	bh=vrSxbbOkSLbkvp8aqDKdP3NGo4c9b3lekBT8+GfSZDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qf2pYmEKBDZ1CZUmSLYBpN2kAZcmAgtFs+h2BFam6/L9B6PHVQJGtcMyPLj4E+/Orlvejyh1pee7Wb2o7Dp0/AjYv4dxqohKv1aINIc7GjTmOY1Cn9Gag9k0bOaoVyYNZQibwH5h3+LNhQyz5zEqf1mikEvb7s5QYAX+AF9Ur9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAjQY97x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAjQY97x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAD9C2BCAF;
	Mon, 13 Apr 2026 16:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097023;
	bh=vrSxbbOkSLbkvp8aqDKdP3NGo4c9b3lekBT8+GfSZDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAjQY97xbaxJjJmp606fyHqn+BOoh2EZ2/hVM0YI99OvHOrg9RiT+fazQtrgf/ytM
	 AqXf7QW4ost5jz4dnljchr2HxVYDO/N1F22z7itL9UPqSgNRmIPA8XYpVussS/5/XW
	 2e7zfA/ad5pv2NVozCn07RsCn9wz8Db1OnwTyvqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/55] Revert "mptcp: add needs_id for netlink appending addr"
Date: Mon, 13 Apr 2026 18:01:07 +0200
Message-ID: <20260413155726.073759223@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
References: <20260413155724.820472494@linuxfoundation.org>
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
[ applied changes to net/mptcp/pm_netlink.c instead of renamed net/mptcp/pm_kernel.c ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   24 +++++-------------------
 1 file changed, 5 insertions(+), 19 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1080,7 +1080,7 @@ static void __mptcp_pm_release_addr_entr
 
 static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 					     struct mptcp_pm_addr_entry *entry,
-					     bool needs_id, bool replace)
+					     bool replace)
 {
 	struct mptcp_pm_addr_entry *cur, *del_entry = NULL;
 	unsigned int addr_max;
@@ -1133,7 +1133,7 @@ static int mptcp_pm_nl_append_new_local_
 		}
 	}
 
-	if (!entry->addr.id && needs_id) {
+	if (!entry->addr.id) {
 find_next:
 		entry->addr.id = find_next_zero_bit(pernet->id_bitmap,
 						    MPTCP_PM_MAX_ADDR_ID + 1,
@@ -1144,7 +1144,7 @@ find_next:
 		}
 	}
 
-	if (!entry->addr.id && needs_id)
+	if (!entry->addr.id)
 		goto out;
 
 	__set_bit(entry->addr.id, pernet->id_bitmap);
@@ -1271,7 +1271,7 @@ int mptcp_pm_nl_get_local_id(struct mptc
 	entry->ifindex = 0;
 	entry->flags = MPTCP_PM_ADDR_FLAG_IMPLICIT;
 	entry->lsk = NULL;
-	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry, true, false);
+	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry, false);
 	if (ret < 0)
 		kfree(entry);
 
@@ -1513,18 +1513,6 @@ next:
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
@@ -1566,9 +1554,7 @@ static int mptcp_nl_cmd_add_addr(struct
 			goto out_free;
 		}
 	}
-	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry,
-						!mptcp_pm_has_addr_attr_id(attr, info),
-						true);
+	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry, true);
 	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "too many addresses or duplicate one");
 		goto out_free;


