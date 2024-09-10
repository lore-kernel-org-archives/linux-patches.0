Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7763188A28;
	Tue, 10 Sep 2024 10:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963555; cv=none; b=KBtkPNhnImTK4QSpgGA78DsGEHWD8s5izLdnSzL83tVxX8ErKBCXNcDemlz1BS3mQLOhv9scmcjQBVQjxHDgF6PEhIxx8sCqBWOQXqprkwZGVE5WQjENjxfQ7XdhqLq5KH/3U9GpC+zh7ZApNcBZn7nGg55BlWiyy7z7Hk6veck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963555; c=relaxed/simple;
	bh=W4mH0/9x87S5i+UINUxDXEjQ5wEfIvzbcSTZhn4iK7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pa8gOIoJGhN8fUFTQYNEaH68wzq6nrb0BAMSsTezu6dQXHBadeJiWJ4ud5v5cB8yR4/rcOK8Y5Ef3FuVW0LG8I4DMraScYYZgZpXe8A/ohkjyVvwlt2a7cDMjtPDQQqzQrLursa4C33Hvnxx01bSiSjA7iYFnWyrq7gixigIuRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtzvD05j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtzvD05j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3261AC4CEC3;
	Tue, 10 Sep 2024 10:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963555;
	bh=W4mH0/9x87S5i+UINUxDXEjQ5wEfIvzbcSTZhn4iK7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtzvD05jqo6wfssECQLP/EFwztU1lC1rw/r5eM0irV7yw0Rcahwqky1oNCCVqQdlX
	 x/b+2YjVGZyRGwU+IdGr8MY9OL5MU02yLIWCfJD0bWvPFjvCHVebikJLFmD/Ur7gwd
	 VK/bGPkdsyo61rzjEbkbVoKYCy+VNhcBuJUBIkE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 098/214] mptcp: pm: ADD_ADDR 0 is not a new address
Date: Tue, 10 Sep 2024 11:32:00 +0200
Message-ID: <20240910092602.794936322@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

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
[ Conflicts in pm.c, due to commit 4d25247d3ae4 ("mptcp: bypass
  in-kernel PM restrictions for non-kernel PMs"), which is not in this
  version, and changes the context. The same fix can be applied here by
  adding the new check at the same place. Note that addresses_equal()
  has been used instead of mptcp_addresses_equal(), renamed in commit
  4638de5aefe5 ("mptcp: handle local addrs announced by userspace PMs"),
  not in this version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c         |    4 +++-
 net/mptcp/pm_netlink.c |    9 +++++++++
 net/mptcp/protocol.h   |    2 ++
 3 files changed, 14 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -189,7 +189,9 @@ void mptcp_pm_add_addr_received(struct m
 
 	spin_lock_bh(&pm->lock);
 
-	if (!READ_ONCE(pm->accept_addr)) {
+	/* id0 should not have a different address */
+	if ((addr->id == 0 && !mptcp_pm_nl_is_init_remote_addr(msk, addr)) ||
+	    (addr->id > 0 && !READ_ONCE(pm->accept_addr))) {
 		mptcp_pm_announce_addr(msk, addr, true);
 		mptcp_pm_add_addr_send_ack(msk);
 	} else if (mptcp_pm_schedule_work(msk, MPTCP_PM_ADD_ADDR_RECEIVED)) {
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -669,6 +669,15 @@ add_addr_echo:
 	mptcp_pm_nl_addr_send_ack(msk);
 }
 
+bool mptcp_pm_nl_is_init_remote_addr(struct mptcp_sock *msk,
+				     const struct mptcp_addr_info *remote)
+{
+	struct mptcp_addr_info mpc_remote;
+
+	remote_address((struct sock_common *)msk, &mpc_remote);
+	return addresses_equal(&mpc_remote, remote, remote->port);
+}
+
 void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -742,6 +742,8 @@ void mptcp_pm_add_addr_received(struct m
 void mptcp_pm_add_addr_echoed(struct mptcp_sock *msk,
 			      const struct mptcp_addr_info *addr);
 void mptcp_pm_add_addr_send_ack(struct mptcp_sock *msk);
+bool mptcp_pm_nl_is_init_remote_addr(struct mptcp_sock *msk,
+				     const struct mptcp_addr_info *remote);
 void mptcp_pm_nl_addr_send_ack(struct mptcp_sock *msk);
 void mptcp_pm_rm_addr_received(struct mptcp_sock *msk,
 			       const struct mptcp_rm_list *rm_list);


