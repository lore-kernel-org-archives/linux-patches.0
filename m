Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7533325A2C9;
	Mon, 13 Apr 2026 16:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096849; cv=none; b=Yv4zG6Z+H0vG5FHd+zN/ICXUYCpWjWs4XNo5LyVwxVoM6z+mFQDuk34d88tpMWN97IbLnUwtJYJTlD4uwGqpDiHrddhAFYlIGJBR3Z6IJMV9Po4Hq1BSjZ3QEIaG+TurYqssTK0hupulljbEpVIbjOkUnCOvH7zCVMXkJZveuKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096849; c=relaxed/simple;
	bh=ZupzfOC9geJ4hDlKdkOxpXw4bQEMPg4TMPAltIBCvhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3aR53BN4+/f3jLGNNwu72yAUGzU1ngi1o7Ci0b1Ny17ifQyMHvaeykuGkby3te/iffpaCcQjE3KWrAwa8wK6SR72Ho0ZXMfzVJu7/W25rpSLM8Oj2exdIhzXRvzu21XX2zJHhKgu7iA/9ihIoQ4DCg3Y2Jv4DfUqK/tim0L568=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUFDOGXV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUFDOGXV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CBD3C2BCAF;
	Mon, 13 Apr 2026 16:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096849;
	bh=ZupzfOC9geJ4hDlKdkOxpXw4bQEMPg4TMPAltIBCvhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUFDOGXVgeSHMnR1zjYXoqqmofPbABEzoreupXwF/FE+UV3dsNJDYq+plDiEiFCjk
	 TAIQuNQBM8rqrMegUHyg+jjCRucHPzw2+lfFPyfg5YpuCeN0uMSQKHj/S9gimZALqn
	 ZRQ2bb9y6G/S9b1KZE1eTpXUTbo7cemNsSviEp9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 16/50] Revert "mptcp: add needs_id for netlink appending addr"
Date: Mon, 13 Apr 2026 18:00:43 +0200
Message-ID: <20260413155725.117835298@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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
@@ -1079,7 +1079,7 @@ static void __mptcp_pm_release_addr_entr
 
 static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
 					     struct mptcp_pm_addr_entry *entry,
-					     bool needs_id, bool replace)
+					     bool replace)
 {
 	struct mptcp_pm_addr_entry *cur, *del_entry = NULL;
 	unsigned int addr_max;
@@ -1138,7 +1138,7 @@ static int mptcp_pm_nl_append_new_local_
 		}
 	}
 
-	if (!entry->addr.id && needs_id) {
+	if (!entry->addr.id) {
 find_next:
 		entry->addr.id = find_next_zero_bit(pernet->id_bitmap,
 						    MPTCP_PM_MAX_ADDR_ID + 1,
@@ -1149,7 +1149,7 @@ find_next:
 		}
 	}
 
-	if (!entry->addr.id && needs_id)
+	if (!entry->addr.id)
 		goto out;
 
 	__set_bit(entry->addr.id, pernet->id_bitmap);
@@ -1282,7 +1282,7 @@ int mptcp_pm_nl_get_local_id(struct mptc
 	entry->ifindex = 0;
 	entry->flags = MPTCP_PM_ADDR_FLAG_IMPLICIT;
 	entry->lsk = NULL;
-	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry, true, false);
+	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry, false);
 	if (ret < 0)
 		kfree(entry);
 
@@ -1524,18 +1524,6 @@ next:
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
@@ -1577,9 +1565,7 @@ static int mptcp_nl_cmd_add_addr(struct
 			goto out_free;
 		}
 	}
-	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry,
-						!mptcp_pm_has_addr_attr_id(attr, info),
-						true);
+	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry, true);
 	if (ret < 0) {
 		GENL_SET_ERR_MSG_FMT(info, "too many addresses or duplicate one: %d", ret);
 		goto out_free;


