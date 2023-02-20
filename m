Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CB463B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58BCC433EF;
	Mon, 20 Feb 2023 13:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901476;
	bh=M5TyjJgO94QADkNo/updKqfNf+Z9O1PEHDp9P6Wgc6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VRWuECaaO7o0M4M3QA0kOKObBte45NPdkyekXgu0sujS5iMsfAfNFYqkfTQJs8q5k
	 U57Ckxxtioyl5l2QcnfLbxuy18Q55w7lCxtu8D+DQ0WMRkm8JpD9l2vAcQLNCUsacZ
	 wQQ3oDQahsOjw9xEFmFTC2azr0hnDOzdsF0w78mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/118] mptcp: fix locking for in-kernel listener creation
Date: Mon, 20 Feb 2023 14:35:20 +0100
Message-Id: <20230220133600.576591331@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit ad2171009d968104ccda9dc517f5a3ba891515db ]

For consistency, in mptcp_pm_nl_create_listen_socket(), we need to
call the __mptcp_nmpc_socket() under the msk socket lock.

Note that as a side effect, mptcp_subflow_create_socket() needs a
'nested' lockdep annotation, as it will acquire the subflow (kernel)
socket lock under the in-kernel listener msk socket lock.

The current lack of locking is almost harmless, because the relevant
socket is not exposed to the user space, but in future we will add
more complexity to the mentioned helper, let's play safe.

Fixes: 1729cf186d8a ("mptcp: create the listening socket for new port")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 10 ++++++----
 net/mptcp/subflow.c    |  2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index fdf2ee29f7623..5e38a0abbabae 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -992,8 +992,8 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 {
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
-	struct mptcp_sock *msk;
 	struct socket *ssock;
+	struct sock *newsk;
 	int backlog = 1024;
 	int err;
 
@@ -1002,11 +1002,13 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	if (err)
 		return err;
 
-	msk = mptcp_sk(entry->lsk->sk);
-	if (!msk)
+	newsk = entry->lsk->sk;
+	if (!newsk)
 		return -EINVAL;
 
-	ssock = __mptcp_nmpc_socket(msk);
+	lock_sock(newsk);
+	ssock = __mptcp_nmpc_socket(mptcp_sk(newsk));
+	release_sock(newsk);
 	if (!ssock)
 		return -EINVAL;
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 929b0ee8b3d5f..c4971bc42f60f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1631,7 +1631,7 @@ int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
 	if (err)
 		return err;
 
-	lock_sock(sf->sk);
+	lock_sock_nested(sf->sk, SINGLE_DEPTH_NESTING);
 
 	/* the newly created socket has to be in the same cgroup as its parent */
 	mptcp_attach_cgroup(sk, sf->sk);
-- 
2.39.0



