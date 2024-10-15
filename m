Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA0E1C07C4;
	Tue, 15 Oct 2024 12:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728996960; cv=none; b=MeQXPl2A5VULrbL9mCXtHj7GWHGXilt2bAoOBuMyKoSNvUU1tIZ2p70q+WJGmn6v6zrX6vL2kDhqlRX/nLc/3GwRPgBG4krljLAF1F+e1wT/teJjOc+PtqZPKwFOR0U28R7Z+HkH4AxwVB6xOOBWbi2sO7sbett8nMKdc0cfg6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728996960; c=relaxed/simple;
	bh=fE2bZ0w2Y4HDHT2KRv33fVjgIeYa30C6g+8VokE+piE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuoTq7RbMr4CDdQPlxoYVge9uTTj7Fy9Vnr6GwAJzATUTYq6aHTTn8R+V3oeDUl8+VeKcEEhVKc7yNTpU5B35JxPFv4RhylKkMgRuKXtyXtAU+m3SlN305W7YaowToKnlMGC8RmaXguWBDGVeiJIXv/grHJpmG+yeQj6JH6YnHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2NsnQBpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2NsnQBpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D9BC4CEC6;
	Tue, 15 Oct 2024 12:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728996960;
	bh=fE2bZ0w2Y4HDHT2KRv33fVjgIeYa30C6g+8VokE+piE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2NsnQBprOyBgajcWKkBIYuoGNxk+9QDKtB7zcPoBEc7GPyl5xAjNE8uPA+XvLxbHU
	 KsosKGuVzUk+SdrlFBLi77TJ52q0fXkguEk8CKY5fy3XN68KZGYyQXSM8pEez7Urit
	 dmQFjqZnByKGQ3hZytGRGPXA+pwlC5Z5LJVLM/Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Caratti <dcaratti@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 5.10 049/518] mptcp: validate id when stopping the ADD_ADDR retransmit timer
Date: Tue, 15 Oct 2024 14:39:13 +0200
Message-ID: <20241015123918.903472360@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

From: Davide Caratti <dcaratti@redhat.com>

commit d58300c3185b78ab910092488126b97f0abe3ae2 upstream.

when Linux receives an echo-ed ADD_ADDR, it checks the IP address against
the list of "announced" addresses. In case of a positive match, the timer
that handles retransmissions is stopped regardless of the 'Address Id' in
the received packet: this behaviour does not comply with RFC8684 3.4.1.

Fix it by validating the 'Address Id' in received echo-ed ADD_ADDRs.
Tested using packetdrill, with the following captured output:

 unpatched kernel:

 Out <...> Flags [.], ack 1, win 256, options [mptcp add-addr v1 id 1 198.51.100.2 hmac 0xfd2e62517888fe29,mptcp dss ack 3007449509], length 0
 In  <...> Flags [.], ack 1, win 257, options [mptcp add-addr v1-echo id 1 1.2.3.4,mptcp dss ack 3013740213], length 0
 Out <...> Flags [.], ack 1, win 256, options [mptcp add-addr v1 id 1 198.51.100.2 hmac 0xfd2e62517888fe29,mptcp dss ack 3007449509], length 0
 In  <...> Flags [.], ack 1, win 257, options [mptcp add-addr v1-echo id 90 198.51.100.2,mptcp dss ack 3013740213], length 0
        ^^^ retransmission is stopped here, but 'Address Id' is 90

 patched kernel:

 Out <...> Flags [.], ack 1, win 256, options [mptcp add-addr v1 id 1 198.51.100.2 hmac 0x1cf372d59e05f4b8,mptcp dss ack 3007449509], length 0
 In  <...> Flags [.], ack 1, win 257, options [mptcp add-addr v1-echo id 1 1.2.3.4,mptcp dss ack 1672384568], length 0
 Out <...> Flags [.], ack 1, win 256, options [mptcp add-addr v1 id 1 198.51.100.2 hmac 0x1cf372d59e05f4b8,mptcp dss ack 3007449509], length 0
 In  <...> Flags [.], ack 1, win 257, options [mptcp add-addr v1-echo id 90 198.51.100.2,mptcp dss ack 1672384568], length 0
 Out <...> Flags [.], ack 1, win 256, options [mptcp add-addr v1 id 1 198.51.100.2 hmac 0x1cf372d59e05f4b8,mptcp dss ack 3007449509], length 0
 In  <...> Flags [.], ack 1, win 257, options [mptcp add-addr v1-echo id 1 198.51.100.2,mptcp dss ack 1672384568], length 0
        ^^^ retransmission is stopped here, only when both 'Address Id' and 'IP Address' match

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: b4cd80b03389 ("mptcp: pm: Fix uaf in __timer_delete_sync")
[ Conflicts in options.c, because some features are missing in this
  version, e.g. commit 557963c383e8 ("mptcp: move to next addr when
  subflow creation fail") and commit f7dafee18538 ("mptcp: use
  mptcp_addr_info in mptcp_options_received"). ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c    |    2 +-
 net/mptcp/pm_netlink.c |    8 ++++----
 net/mptcp/protocol.h   |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -915,7 +915,7 @@ void mptcp_incoming_options(struct sock
 			mptcp_pm_add_addr_received(msk, &addr);
 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ADDADDR);
 		} else {
-			mptcp_pm_del_add_timer(msk, &addr);
+			mptcp_pm_del_add_timer(msk, &addr, true);
 			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_ECHOADD);
 		}
 		mp_opt.add_addr = 0;
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -249,18 +249,18 @@ out:
 
 struct mptcp_pm_add_entry *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
-		       struct mptcp_addr_info *addr)
+		       struct mptcp_addr_info *addr, bool check_id)
 {
 	struct mptcp_pm_add_entry *entry;
 	struct sock *sk = (struct sock *)msk;
 
 	spin_lock_bh(&msk->pm.lock);
 	entry = mptcp_lookup_anno_list_by_saddr(msk, addr);
-	if (entry)
+	if (entry && (!check_id || entry->addr.id == addr->id))
 		entry->retrans_times = ADD_ADDR_RETRANS_MAX;
 	spin_unlock_bh(&msk->pm.lock);
 
-	if (entry)
+	if (entry && (!check_id || entry->addr.id == addr->id))
 		sk_stop_timer_sync(sk, &entry->add_timer);
 
 	return entry;
@@ -764,7 +764,7 @@ static bool remove_anno_list_by_saddr(st
 {
 	struct mptcp_pm_add_entry *entry;
 
-	entry = mptcp_pm_del_add_timer(msk, addr);
+	entry = mptcp_pm_del_add_timer(msk, addr, false);
 	if (entry) {
 		list_del(&entry->list);
 		kfree(entry);
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -450,7 +450,7 @@ void mptcp_pm_rm_addr_received(struct mp
 void mptcp_pm_free_anno_list(struct mptcp_sock *msk);
 struct mptcp_pm_add_entry *
 mptcp_pm_del_add_timer(struct mptcp_sock *msk,
-		       struct mptcp_addr_info *addr);
+		       struct mptcp_addr_info *addr, bool check_id);
 struct mptcp_pm_add_entry *
 mptcp_lookup_anno_list_by_saddr(struct mptcp_sock *msk,
 				struct mptcp_addr_info *addr);


