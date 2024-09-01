Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C3318661C;
	Sun,  1 Sep 2024 16:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209179; cv=none; b=gHmonp/B7AnPYqtJa+w+mgWgvdR0NwMb4V9P+3g+OwagOKzvfjv97eXWWgaJ3BtcD60A2VrQUfre5cb+WCYLPzxIpbefi/NxkC3khjsXeJn8lGsPI5SlmxwDVV2yd/ht4petmW2EUDE6gyz9Dd0a+1IRy/EtTOOj8MbjxI4GRc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209179; c=relaxed/simple;
	bh=zsWwLBcJLWUj6AiJq5u4Mcr0CtNXcZRV7LVdHSMZi6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/WJc0c3Lls3SNVZFiOmH4orHKHeSonEIxhpn9tOG8FYVQfacMCaByM1WoOArqmk0r44F5tpFVjl8mkWbm2Vr0+mYx8lbSDmmpyHVosqtC0CwmHvSMcqxqOFyiP+xRT3efcdT1x/2mindfD/vpND7MrdqEgZyjEhVGv/63QS+6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9KfFaz5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9KfFaz5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F6AC4CEC3;
	Sun,  1 Sep 2024 16:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209178;
	bh=zsWwLBcJLWUj6AiJq5u4Mcr0CtNXcZRV7LVdHSMZi6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9KfFaz51lNh6H5EcUanBg3yJ9ZYtZRUq7eIu+qHke7jAjGJMSTYxoLhFb+5pWidf
	 3mEENmV4n7XZUAukj2RYpNu9Lof0Q2XexobiTvx41nl+Tsf8jWwQjL/Y9ygcFul60V
	 VtZbECP6+oIlnP2GG9zVrOuaM/ZO03PXcNbwxvMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 17/71] mptcp: pm: ADD_ADDR 0 is not a new address
Date: Sun,  1 Sep 2024 18:17:22 +0200
Message-ID: <20240901160802.540076601@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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
@@ -235,7 +235,9 @@ void mptcp_pm_add_addr_received(const st
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
@@ -739,6 +739,15 @@ static void mptcp_pm_nl_add_addr_receive
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
@@ -802,6 +802,8 @@ void mptcp_pm_add_addr_received(const st
 void mptcp_pm_add_addr_echoed(struct mptcp_sock *msk,
 			      const struct mptcp_addr_info *addr);
 void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk);
+bool mptcp_pm_nl_is_init_remote_addr(struct mptcp_sock *msk,
+				     const struct mptcp_addr_info *remote);
 void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk);
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
 			       const struct mptcp_rm_list *rm_list);


