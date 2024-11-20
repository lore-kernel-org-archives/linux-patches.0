Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A7E433B3;
	Wed, 20 Nov 2024 13:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107615; cv=none; b=Syg8NtAtngXkyk/5bUgjx3Whw4UFiPQoM6pHH2UDB0sjAvUsizpwWoNMDvxjnYL7+Ro+QR/COKwStBtJgXyNwMtEU5G49zSqgIwOzQgEp5uSyTZ1YKTvi0upvwXlFn+HH6eE/ZNWmqsCq2utJEBdce7B4+DdldJm9xWA1eXrM+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107615; c=relaxed/simple;
	bh=FqBkPN7zbp2qD9F+4jcfr0dpPp1BxUN33x48EiASgc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adsYBxEwr+1C92LNQPeRNbkTAIDvztiM4I7xZw2avht/16NMS1fpYR5Caq3+L6zBeqwyzdtoEB63dkKVYLwLKX+QwXRImlQRXZiVE1zcjGgVCQSUQDV+yTZTV0atAw3/Zb+ko223FxmmI0D0Bqw/b5Ot9byv10ybz5ibPvFO9x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CngvgN07; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CngvgN07"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C446CC4CECD;
	Wed, 20 Nov 2024 13:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107614;
	bh=FqBkPN7zbp2qD9F+4jcfr0dpPp1BxUN33x48EiASgc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CngvgN07OUIVAPeFmOwtSwvQ/IBxOkrrtnGCo3xXlYg2/V2E1TeozzP9X6dB0ye/m
	 FaRKd10IxC8Dlph4TBOab1PfyKwsjIMWc0Ub+S7YC5BODXVAhxSuJUYuU4X7W1NcCv
	 ruo6YR7pJgdLGePs954NCMMNp8gvonx80oiqKcoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 67/82] mptcp: add userspace_pm_lookup_addr_by_id helper
Date: Wed, 20 Nov 2024 13:57:17 +0100
Message-ID: <20241120125631.121854330@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 06afe09091ee69dc7ab058b4be9917ae59cc81e5 upstream.

Corresponding __lookup_addr_by_id() helper in the in-kernel netlink PM,
this patch adds a new helper mptcp_userspace_pm_lookup_addr_by_id() to
lookup the address entry with the given id on the userspace pm local
address list.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f642c5c4d528 ("mptcp: hold pm lock when deleting entry")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -107,19 +107,26 @@ static int mptcp_userspace_pm_delete_loc
 	return -EINVAL;
 }
 
+static struct mptcp_pm_addr_entry *
+mptcp_userspace_pm_lookup_addr_by_id(struct mptcp_sock *msk, unsigned int id)
+{
+	struct mptcp_pm_addr_entry *entry;
+
+	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
+		if (entry->addr.id == id)
+			return entry;
+	}
+	return NULL;
+}
+
 int mptcp_userspace_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk,
 						   unsigned int id,
 						   u8 *flags, int *ifindex)
 {
-	struct mptcp_pm_addr_entry *entry, *match = NULL;
+	struct mptcp_pm_addr_entry *match;
 
 	spin_lock_bh(&msk->pm.lock);
-	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
-		if (id == entry->addr.id) {
-			match = entry;
-			break;
-		}
-	}
+	match = mptcp_userspace_pm_lookup_addr_by_id(msk, id);
 	spin_unlock_bh(&msk->pm.lock);
 	if (match) {
 		*flags = match->flags;
@@ -280,7 +287,7 @@ int mptcp_nl_cmd_remove(struct sk_buff *
 {
 	struct nlattr *token = info->attrs[MPTCP_PM_ATTR_TOKEN];
 	struct nlattr *id = info->attrs[MPTCP_PM_ATTR_LOC_ID];
-	struct mptcp_pm_addr_entry *match = NULL;
+	struct mptcp_pm_addr_entry *match;
 	struct mptcp_pm_addr_entry *entry;
 	struct mptcp_sock *msk;
 	LIST_HEAD(free_list);
@@ -317,13 +324,7 @@ int mptcp_nl_cmd_remove(struct sk_buff *
 
 	lock_sock(sk);
 
-	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
-		if (entry->addr.id == id_val) {
-			match = entry;
-			break;
-		}
-	}
-
+	match = mptcp_userspace_pm_lookup_addr_by_id(msk, id_val);
 	if (!match) {
 		GENL_SET_ERR_MSG(info, "address with specified id not found");
 		release_sock(sk);


