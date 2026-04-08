Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C183537FC;
	Wed,  8 Apr 2026 18:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672367; cv=none; b=jtm0zfAn4mZRF4IRvTDIMGqGtDWgGIPR21e+ojEMqE/xjemF7zMNKrWrKg4387LNWISmZySFKMa0+1j785gc2AJNp5oyc4/+PMFZyxnA/vvhdFrFDaoIPhqO/NMnMNQtHFEk8m9sflXj7guZ0JgCIrlM//UmBQRkDGB7QALZ8S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672367; c=relaxed/simple;
	bh=nNBxK1L2Gr58Gf/+nQZ9vdroVaPZp/nV/zy94MGPXB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jTX65HRqR6iQD4hi2Th3k2rknkc6IjCc7SLzfsbk7LSQb9jYcquSXCeZh3Gc6dteuL2PuqnTGwjZ4Jiyj3xbUdu6f7axLT2mkTepFouiHtq75x5q5UWMUQV567kiJm5xDeHgkKDpQL5GX7Cg6R6WL9mvEepfRUm1oCLss+4e+6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTvYyx5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTvYyx5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC599C19421;
	Wed,  8 Apr 2026 18:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672367;
	bh=nNBxK1L2Gr58Gf/+nQZ9vdroVaPZp/nV/zy94MGPXB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTvYyx5egwIEVzD3s11nsrZyRzrWyTfOfcD9XfcNUk3B7T45fnX4igIEZYYAlkRUq
	 fbitp7/sIstZGxerx9mEAr+iLrzLrqS88Y73wu3F+H/P4Q9/xT50WozsY/Jz4sRpPr
	 1wIwPqtyyg4q4H49Eb/PGGw3AFCntQdenDBuCb7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiasong <lixiasong1@huawei.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 291/312] MPTCP: fix lock class name family in pm_nl_create_listen_socket
Date: Wed,  8 Apr 2026 20:03:28 +0200
Message-ID: <20260408175944.631521363@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Li Xiasong <lixiasong1@huawei.com>

commit 7ab4a7c5d969642782b8a5b608da0dd02aa9f229 upstream.

In mptcp_pm_nl_create_listen_socket(), use entry->addr.family
instead of sk->sk_family for lock class setup. The 'sk' parameter
is a netlink socket, not the MPTCP subflow socket being created.

Fixes: cee4034a3db1 ("mptcp: fix lockdep false positive in mptcp_pm_nl_create_listen_socket()")
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260319112159.3118874-1-lixiasong1@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflict in pm_kernel.c, because commit 8617e85e04bd ("mptcp: pm:
  split in-kernel PM specific code") is not in this version, and moves
  code from pm_netlink.c to pm_kernel.c. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1184,7 +1184,7 @@ static struct lock_class_key mptcp_keys[
 static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 					    struct mptcp_pm_addr_entry *entry)
 {
-	bool is_ipv6 = sk->sk_family == AF_INET6;
+	bool is_ipv6 = entry->addr.family == AF_INET6;
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
 	struct socket *ssock;


