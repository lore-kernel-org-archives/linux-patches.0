Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9477868F;
	Mon,  4 Mar 2024 21:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589330; cv=none; b=UXqfFOdAMXR44fhM9siDuV35Lr2iF6v4Z+eBSuE3FJSArmj8ZqQUMP0B9vY4o58gJhcZIqs4lm0LLaza97L6E1FnfezdGx3Ft664+Wm6Jy+cSJBt6quGT3tIXoHvD2c9Aa8RQK0SU9okZuQj4iyKBSJRuXSWfbncD8tE5xPk7UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589330; c=relaxed/simple;
	bh=xgKjUuQw3NyKjVwRDM/8OC1NnKa+89BTVsEGoT3xz6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVMcdew/kt7e0aLDCxOtHidB+GwU5lZ1D2OjxrCYI5cOXXICasGuPrYk0F04eR6satJjrbxNOggK+FONbLJcjFVgfuS7+rtficKIRMqczybJA+Yu8Qkqd0qswmJyKPpcYVSZadZ2Ss6R4Ygcx4u1IJ7PWkfyQGFyVfEj9YV3efk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqD0vHKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqD0vHKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B9EC433C7;
	Mon,  4 Mar 2024 21:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589329;
	bh=xgKjUuQw3NyKjVwRDM/8OC1NnKa+89BTVsEGoT3xz6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wqD0vHKppzWQzmQTbfafkfZFpTxR6BGW3dtBYW92JfL7zGO6GABoavwSvB7FCbUiu
	 s412Cp600bRM2TibCO/jQ6G2qokuCkO/qmEZj3lXLi4zpI1ojgqvKEWLwERbcXnFdO
	 QzHaVFYrfbBJfJA/VwoZ0FdqI/Co3Kct3/E1pVwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 67/84] mptcp: add needs_id for netlink appending addr
Date: Mon,  4 Mar 2024 21:24:40 +0000
Message-ID: <20240304211544.631172024@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 584f3894262634596532cf43a5e782e34a0ce374 upstream.

Just the same as userspace PM, a new parameter needs_id is added for
in-kernel PM mptcp_pm_nl_append_new_local_addr() too.

Add a new helper mptcp_pm_has_addr_attr_id() to check whether an address
ID is set from PM or not.

In mptcp_pm_nl_get_local_id(), needs_id is always true, but in
mptcp_pm_nl_add_addr_doit(), pass mptcp_pm_has_addr_attr_id() to
needs_it.

Fixes: efd5a4c04e18 ("mptcp: add the address ID assignment bitmap")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -823,7 +823,8 @@ static bool address_use_port(struct mptc
 }
 
 static int mptcp_pm_nl_append_new_local_addr(struct pm_nl_pernet *pernet,
-					     struct mptcp_pm_addr_entry *entry)
+					     struct mptcp_pm_addr_entry *entry,
+					     bool needs_id)
 {
 	struct mptcp_pm_addr_entry *cur;
 	unsigned int addr_max;
@@ -850,7 +851,7 @@ static int mptcp_pm_nl_append_new_local_
 			goto out;
 	}
 
-	if (!entry->addr.id) {
+	if (!entry->addr.id && needs_id) {
 find_next:
 		entry->addr.id = find_next_zero_bit(pernet->id_bitmap,
 						    MAX_ADDR_ID + 1,
@@ -861,7 +862,7 @@ find_next:
 		}
 	}
 
-	if (!entry->addr.id)
+	if (!entry->addr.id && needs_id)
 		goto out;
 
 	__set_bit(entry->addr.id, pernet->id_bitmap);
@@ -1001,7 +1002,7 @@ int mptcp_pm_nl_get_local_id(struct mptc
 	entry->ifindex = 0;
 	entry->flags = 0;
 	entry->lsk = NULL;
-	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
+	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry, true);
 	if (ret < 0)
 		kfree(entry);
 
@@ -1202,6 +1203,18 @@ next:
 	return 0;
 }
 
+static bool mptcp_pm_has_addr_attr_id(const struct nlattr *attr,
+				      struct genl_info *info)
+{
+	struct nlattr *tb[MPTCP_PM_ADDR_ATTR_MAX + 1];
+
+	if (!nla_parse_nested_deprecated(tb, MPTCP_PM_ADDR_ATTR_MAX, attr,
+					 mptcp_pm_addr_policy, info->extack) &&
+	    tb[MPTCP_PM_ADDR_ATTR_ID])
+		return true;
+	return false;
+}
+
 static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *attr = info->attrs[MPTCP_PM_ATTR_ADDR];
@@ -1228,7 +1241,8 @@ static int mptcp_nl_cmd_add_addr(struct
 			return ret;
 		}
 	}
-	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
+	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry,
+						!mptcp_pm_has_addr_attr_id(attr, info));
 	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "too many addresses or duplicate one");
 		if (entry->lsk)


