Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234F61A00F5;
	Thu, 15 Aug 2024 14:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730713; cv=none; b=dmfF6c9HdW8pNzmqLmaUMQPqY+LYfrMDDPTmGpGYtfRliJOiz2o9dXhubH7eS/GHb6wtKZrZCP7MSemCcjiOfsF/NnJUG6YT4hUgVwiidFkwf/8CBAC4mLf8Owlpef0GFFa1rBvoJYE2TD+HOt4S0ibTSSdC9Rhbc/A1ZeOj3+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730713; c=relaxed/simple;
	bh=fsy3qJFMATI9LqKH4/i1OFCurY/A3Nb2Ngi2uSeK5Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oj9IEzOpSsFaDUIPuJIR4vaeL4S7fwpr0ujv6RV/tftRyEKdHJXSKB6+lU+T8q/eOp1ifUCPNGLhoFxQGfYuoMqwo9yzHOE1QSZq000iliJg/ByboYJHLuv93DwrFUf2xDC4wKwsi6MXqtWIU0jS6M/Fl+wOOWfd2Gr3RpNM9Wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=agP4OXU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="agP4OXU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706C4C4AF0C;
	Thu, 15 Aug 2024 14:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730713;
	bh=fsy3qJFMATI9LqKH4/i1OFCurY/A3Nb2Ngi2uSeK5Yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=agP4OXU6rzURubm4QrB6nJ+0TR0Yr9QuQhCUomFlayg9YnBNhXK4TS3buQl5skK9H
	 48QGWBUGEt5tH2Onj1Kw2kTZ322xNvmAQeceoc6t93eQU4WGh7Tt+7uRRQ7o8ZS5PW
	 gG8utg6L65UMQjQqMu+KbUuebDHjnxq8r3ik2KFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@suse.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.1 01/38] mptcp: pass addr to mptcp_pm_alloc_anno_list
Date: Thu, 15 Aug 2024 15:25:35 +0200
Message-ID: <20240815131833.005686056@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@suse.com>

commit 528cb5f2a1e859522f36f091f29f5c81ec6d4a4c upstream.

Pass addr parameter to mptcp_pm_alloc_anno_list() instead of entry. We
can reduce the scope, e.g. in mptcp_pm_alloc_anno_list(), we only access
"entry->addr", we can then restrict to the pointer to "addr" then.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c95eb32ced82 ("mptcp: pm: reduce indentation blocks")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c   |    8 ++++----
 net/mptcp/pm_userspace.c |    2 +-
 net/mptcp/protocol.h     |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -352,7 +352,7 @@ mptcp_pm_del_add_timer(struct mptcp_sock
 }
 
 bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
-			      const struct mptcp_pm_addr_entry *entry)
+			      const struct mptcp_addr_info *addr)
 {
 	struct mptcp_pm_add_entry *add_entry = NULL;
 	struct sock *sk = (struct sock *)msk;
@@ -360,7 +360,7 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 
 	lockdep_assert_held(&msk->pm.lock);
 
-	add_entry = mptcp_lookup_anno_list_by_saddr(msk, &entry->addr);
+	add_entry = mptcp_lookup_anno_list_by_saddr(msk, addr);
 
 	if (add_entry) {
 		if (mptcp_pm_is_kernel(msk))
@@ -377,7 +377,7 @@ bool mptcp_pm_alloc_anno_list(struct mpt
 
 	list_add(&add_entry->list, &msk->pm.anno_list);
 
-	add_entry->addr = entry->addr;
+	add_entry->addr = *addr;
 	add_entry->sock = msk;
 	add_entry->retrans_times = 0;
 
@@ -580,7 +580,7 @@ static void mptcp_pm_create_subflow_or_s
 			return;
 
 		if (local) {
-			if (mptcp_pm_alloc_anno_list(msk, local)) {
+			if (mptcp_pm_alloc_anno_list(msk, &local->addr)) {
 				__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
 				msk->pm.add_addr_signaled++;
 				mptcp_pm_announce_addr(msk, &local->addr, false);
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -225,7 +225,7 @@ int mptcp_nl_cmd_announce(struct sk_buff
 	lock_sock((struct sock *)msk);
 	spin_lock_bh(&msk->pm.lock);
 
-	if (mptcp_pm_alloc_anno_list(msk, &addr_val)) {
+	if (mptcp_pm_alloc_anno_list(msk, &addr_val.addr)) {
 		msk->pm.add_addr_signaled++;
 		mptcp_pm_announce_addr(msk, &addr_val.addr, false);
 		mptcp_pm_nl_addr_send_ack(msk);
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -812,7 +812,7 @@ int mptcp_pm_nl_mp_prio_send_ack(struct
 				 struct mptcp_addr_info *rem,
 				 u8 bkup);
 bool mptcp_pm_alloc_anno_list(struct mptcp_sock *msk,
-			      const struct mptcp_pm_addr_entry *entry);
+			      const struct mptcp_addr_info *addr);
 void mptcp_pm_free_anno_list(struct mptcp_sock *msk);
 bool mptcp_pm_sport_in_anno_list(struct mptcp_sock *msk, const struct sock *sk);
 struct mptcp_pm_add_entry *


