Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600671A6803;
	Tue, 16 Jun 2026 17:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630335; cv=none; b=Tcoc2ATTVmsqAs9gDYcU1b4g2e6v8DjrDbrC6ph6/mqYdrEcFIaVKwMWi/qxqpaLRB7PLxSQZIDdIOReh3IyxKikBVBd7GKiijV5SglTEN1t96WKb9TKufztsG7h60l1mxh09E/hH2Y60h0BoOVOr/nCuhTe3TZsm5RNrZmGq8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630335; c=relaxed/simple;
	bh=Kzvr8KTL9CMhHgItvXHbWZIGQat9GJwqd4lCqyoxzYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHDHHpY5N/rsvjcA4xz6+9aNfJ64tuIVFE6YKYMAmsGkomCHjS4u4KggHrt7RIV9EE6GI0q9rwsjhU+9y9l2/Hg/dDCIclMWIIzFVG1Q+UHaw7oBrj91XywHwip+Y/Re9ZArLD9ozwl4TKJAZbycGQc8/7dql/OMTgS9rT2ftEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYxeCm/g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYxeCm/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201011F000E9;
	Tue, 16 Jun 2026 17:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630334;
	bh=57xOUkaiAJBphBk5yAGPdPETYsuugszPvFXmmOLsRGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYxeCm/g7fuFAj5MHToUEX5mL6oEQvUiMknxqXsbd11cNa6gORFYLRz6uHXBDHwTd
	 vJCHqv7dUnmQ/J2hAyV1H0Mjf0Mt+3N2YxVUjZ1JUjoBV6s8uYO0VW+FvqAO/0/F24
	 sgwl6etD+U8oVrAkBdLWc1pMwi37DToBkJsTs2N0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 447/452] mptcp: add-addr: always drop other suboptions
Date: Tue, 16 Jun 2026 20:31:14 +0530
Message-ID: <20260616145140.000489081@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

[ Upstream commit bd34fa0257261b76964df1c98f44b3cb4ee14620 ]

When an ADD_ADDR needs to be sent, it could be prepared if there is
enough remaining space and even if the packet is not a pure ACK. But it
would be dropped soon after.

Indeed, in mptcp_pm_add_addr_signal(), there is enough space to fit a
DSS of 20 octets and an ADD_ADDR echo containing an IPv4 address on 8
octets for example. In this case, the packet would be prepared, the
MPTCP_ADD_ADDR_ECHO bit would be removed from pm->addr_signal, but the
option would be silently dropped in mptcp_established_options_add_addr()
not to override DSS info in the union from 'struct mptcp_out_options',
and also because mptcp_write_options() will enforce mutually exclusion
with DSS.

Instead, don't even try to send an ADD_ADDR if it is not a pure ACK.
Retry for each new packet until a pure-ACK is emitted. That's fine to do
that, because each time an ADD_ADDR (echo) is scheduled, a pure ACK is
queued.

This also simplifies the code, and the skb checks can be done earlier,
before the lock.

Note: also, since commit 6d0060f600ad ("mptcp: Write MPTCP DSS headers
to outgoing data packets"), opts->ahmac would not have been set to 0
when other suboptions were not dropped, and when sending an ADD_ADDR
echo. That would have resulted in sending an ADD_ADDR using garbage
info, where there was not enough space, instead of an echo one without
the ADD_ADDR HMAC.

Fixes: 1bff1e43a30e ("mptcp: optimize out option generation")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260602-net-mptcp-misc-fixes-7-1-rc7-v2-11-856831229976@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c  |   30 +++++++-----------------------
 net/mptcp/pm.c       |   15 ++++-----------
 net/mptcp/protocol.h |    7 +++----
 3 files changed, 14 insertions(+), 38 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -662,7 +662,6 @@ static bool mptcp_established_options_ad
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
-	bool drop_other_suboptions = false;
 	unsigned int opt_size = *size;
 	struct mptcp_addr_info addr;
 	bool echo;
@@ -673,36 +672,20 @@ static bool mptcp_established_options_ad
 	 */
 	if (!mptcp_pm_should_add_signal(msk) ||
 	    (opts->suboptions & (OPTION_MPTCP_MPJ_ACK | OPTION_MPTCP_MPC_ACK)) ||
-	    !mptcp_pm_add_addr_signal(msk, skb, opt_size, remaining, &addr,
-		    &echo, &drop_other_suboptions))
+	    !skb || !skb_is_tcp_pure_ack(skb) ||
+	    !mptcp_pm_add_addr_signal(msk, opt_size, remaining, &addr, &echo))
 		return false;
 
-	/*
-	 * Later on, mptcp_write_options() will enforce mutually exclusion with
-	 * DSS, bail out if such option is set and we can't drop it.
-	 */
-	if (drop_other_suboptions)
-		remaining += opt_size;
-	else if (opts->suboptions & OPTION_MPTCP_DSS)
-		return false;
+	remaining += opt_size;
 
 	len = mptcp_add_addr_len(addr.family, echo, !!addr.port);
 	if (remaining < len)
 		return false;
 
 	*size = len;
-	if (drop_other_suboptions) {
-		pr_debug("drop other suboptions\n");
-		opts->suboptions = 0;
-
-		/* note that e.g. DSS could have written into the memory
-		 * aliased by ahmac, we must reset the field here
-		 * to avoid appending the hmac even for ADD_ADDR echo
-		 * options
-		 */
-		opts->ahmac = 0;
-		*size -= opt_size;
-	}
+	pr_debug("drop other suboptions\n");
+	opts->suboptions = 0;
+	*size -= opt_size;
 	opts->addr = addr;
 	opts->suboptions |= OPTION_MPTCP_ADD_ADDR;
 	if (!echo) {
@@ -712,6 +695,7 @@ static bool mptcp_established_options_ad
 						     &opts->addr);
 	} else {
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ECHOADDTX);
+		opts->ahmac = 0;
 	}
 	pr_debug("addr_id=%d, ahmac=%llu, echo=%d, port=%d\n",
 		 opts->addr.id, opts->ahmac, echo, ntohs(opts->addr.port));
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -330,10 +330,9 @@ void mptcp_pm_mp_fail_received(struct so
 
 /* path manager helpers */
 
-bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, const struct sk_buff *skb,
-			      unsigned int opt_size, unsigned int remaining,
-			      struct mptcp_addr_info *addr, bool *echo,
-			      bool *drop_other_suboptions)
+bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int opt_size,
+			      unsigned int remaining,
+			      struct mptcp_addr_info *addr, bool *echo)
 {
 	bool skip_add_addr = false;
 	int ret = false;
@@ -351,10 +350,7 @@ bool mptcp_pm_add_addr_signal(struct mpt
 	 * plain dup-ack from TCP perspective. The other MPTCP-relevant info,
 	 * if any, will be carried by the 'original' TCP ack
 	 */
-	if (skb && skb_is_tcp_pure_ack(skb)) {
-		remaining += opt_size;
-		*drop_other_suboptions = true;
-	}
+	remaining += opt_size;
 
 	*echo = mptcp_pm_should_add_signal_echo(msk);
 	if (*echo) {
@@ -372,9 +368,6 @@ bool mptcp_pm_add_addr_signal(struct mpt
 	if (remaining < mptcp_add_addr_len(family, *echo, port)) {
 		struct net *net = sock_net((struct sock *)msk);
 
-		if (!*drop_other_suboptions)
-			goto out_unlock;
-
 		if (*echo) {
 			MPTCP_INC_STATS(net, MPTCP_MIB_ECHOADDTXDROP);
 		} else {
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -1042,10 +1042,9 @@ static inline int mptcp_rm_addr_len(cons
 	return TCPOLEN_MPTCP_RM_ADDR_BASE + roundup(rm_list->nr - 1, 4) + 1;
 }
 
-bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, const struct sk_buff *skb,
-			      unsigned int opt_size, unsigned int remaining,
-			      struct mptcp_addr_info *addr, bool *echo,
-			      bool *drop_other_suboptions);
+bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, unsigned int opt_size,
+			      unsigned int remaining,
+			      struct mptcp_addr_info *addr, bool *echo);
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     struct mptcp_rm_list *rm_list);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);


