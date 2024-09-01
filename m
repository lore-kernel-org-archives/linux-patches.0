Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0904814290C;
	Sun,  1 Sep 2024 16:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207929; cv=none; b=t53QvEtSvOCV21Ig2p5RgTDufA+pzhaO3yXA5CeC1m8lEv2Lo0q+OTNzbH8UvfB3eY5Z54h0q1eis+XBrWJjzjsS3ga4Evn1UiRXp8Hd621tn5l5Jz8eA/BA+0iPsOOqP337RxoFy4FPjficAezt4EZ+HYWCFA/2tFUGm2AHzxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207929; c=relaxed/simple;
	bh=2Z+2r9mx5Wa4qrqQzOaf2SomOJ+os7WddaXt0H7MuQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tSvB1dD+764pGAXu5Q/RlS4PT68kphyQpd3CJAhQBLWtwu+x+g0Ltb3L28eCNnICKnEr8M+VSbbKfPkYwXH8EPyf52r4zHrphi6+Yr46Ln8I6D5p+k8y9MSIW34JXbhNhi736l1EnynsgWxqihqv1P+mH/vk4MDBThe8Bu9ZaT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QeJVmbat; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QeJVmbat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AD0C4CEC3;
	Sun,  1 Sep 2024 16:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207928;
	bh=2Z+2r9mx5Wa4qrqQzOaf2SomOJ+os7WddaXt0H7MuQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QeJVmbatl6AuPX78bEPazDR5ePVoR7zA3QgjEzq/GKoW35mIMkYBqwMD9HgKlYbFM
	 vBwK6vgDytRdcqeTLn7JxPR6iriuR+gzsS5EnoW8wAC2egfJCQn41Ds8mC2Wpidt6p
	 mkB6N0EY2Qb3Mdai1FaRDnFNJaq7LQ+SQUURwow8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 20/93] mptcp: pm: ADD_ADDR 0 is not a new address
Date: Sun,  1 Sep 2024 18:16:07 +0200
Message-ID: <20240901160808.121477060@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 57f86203b41c98b322119dfdbb1ec54ce5e3369b upstream.

The ADD_ADDR 0 with the address from the initial subflow should not be
considered as a new address: this is not something new. If the host
receives it, it simply means that the address is available again.

When receiving an ADD_ADDR for the ID 0, the PM already doesn't consider
it as new by not incrementing the 'add_addr_accepted' counter. But the
'accept_addr' might not be set if the limit has already been reached:
this can be bypassed in this case. But before, it is important to check
that this ADD_ADDR for the ID 0 is for the same address as the initial
subflow. If not, it is not something that should happen, and the
ADD_ADDR can be ignored.

Note that if an ADD_ADDR is received while there is already a subflow
opened using the same address, this ADD_ADDR is ignored as well. It
means that if multiple ADD_ADDR for ID 0 are received, there will not be
any duplicated subflows created by the client.

Fixes: d0876b2284cf ("mptcp: add the incoming RM_ADDR support")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c         |    4 +++-
 net/mptcp/pm_netlink.c |    9 +++++++++
 net/mptcp/protocol.h   |    2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -227,7 +227,9 @@ void mptcp_pm_add_addr_received(const st
 		} else {
 			__MPTCP_INC_STATS(sock_net((struct sock *)msk), MPTCP_MIB_ADDADDRDROP);
 		}
-	} else if (!READ_ONCE(pm->accept_addr)) {
+	/* id0 should not have a different address */
+	} else if ((addr->id == 0 && !mptcp_pm_nl_is_init_remote_addr(msk, addr)) ||
+		   (addr->id > 0 && !READ_ONCE(pm->accept_addr))) {
 		mptcp_pm_announce_addr(msk, addr, true);
 		mptcp_pm_add_addr_send_ack(msk);
 	} else if (mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED)) {
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -768,6 +768,15 @@ static void mptcp_pm_nl_add_addr_receive
 	}
 }
 
+bool mptcp_pm_nl_is_init_remote_addr(struct mptcp_sock *msk,
+				     const struct mptcp_addr_info *remote)
+{
+	struct mptcp_addr_info mpc_remote;
+
+	remote_address((struct sock_common *)msk, &mpc_remote);
+	return mptcp_addresses_equal(&mpc_remote, remote, remote->port);
+}
+
 void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -907,6 +907,8 @@ void mptcp_pm_add_addr_received(const st
 void mptcp_pm_add_addr_echoed(struct mptcp_sock *msk,
 			      const struct mptcp_addr_info *addr);
 void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk);
+bool mptcp_pm_nl_is_init_remote_addr(struct mptcp_sock *msk,
+				     const struct mptcp_addr_info *remote);
 void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk);
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
 			       const struct mptcp_rm_list *rm_list);


