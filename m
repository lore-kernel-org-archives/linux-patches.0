Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EBE1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D33C433D2;
	Mon, 20 Mar 2023 15:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325915;
	bh=xiRh6sWfV3prQZpdcS43W6PEq3K7YVCnNLbksEWsJ4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPrldL6CTElnyxJcUmovcCwfh4Ulj1BocjWsrt0h73kFBuKO/LE4eeSXcRFuuhJSO
	 RIF0iRWRod+sj73GN3wyxoBdDWYE/57Xhje5UWZzegcykqeKOZ+FkJwZX3leElZKyS
	 HqFT7Sealv+y1SOBLHJoRmip+ov8iGrzFlniROXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 167/198] mptcp: fix lockdep false positive in mptcp_pm_nl_create_listen_socket()
Date: Mon, 20 Mar 2023 15:55:05 +0100
Message-Id: <20230320145514.536525592@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
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

commit cee4034a3db1d30c3243dd51506a9d4ab1a849fa upstream.

Christoph reports a lockdep splat in the mptcp_subflow_create_socket()
error path, when such function is invoked by
mptcp_pm_nl_create_listen_socket().

Such code path acquires two separates, nested socket lock, with the
internal lock operation lacking the "nested" annotation. Adding that
in sock_release() for mptcp's sake only could be confusing.

Instead just add a new lockclass to the in-kernel msk socket,
re-initializing the lockdep infra after the socket creation.

Fixes: ad2171009d96 ("mptcp: fix locking for in-kernel listener creation")
Cc: stable@vger.kernel.org
Reported-by: Christoph Paasch <cpaasch@apple.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/354
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -987,9 +987,13 @@ out:
 	return ret;
 }
 
+static struct lock_class_key mptcp_slock_keys[2];
+static struct lock_class_key mptcp_keys[2];
+
 static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 					    struct mptcp_pm_addr_entry *entry)
 {
+	bool is_ipv6 = sk->sk_family == AF_INET6;
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
 	struct socket *ssock;
@@ -1006,6 +1010,18 @@ static int mptcp_pm_nl_create_listen_soc
 	if (!newsk)
 		return -EINVAL;
 
+	/* The subflow socket lock is acquired in a nested to the msk one
+	 * in several places, even by the TCP stack, and this msk is a kernel
+	 * socket: lockdep complains. Instead of propagating the _nested
+	 * modifiers in several places, re-init the lock class for the msk
+	 * socket to an mptcp specific one.
+	 */
+	sock_lock_init_class_and_name(newsk,
+				      is_ipv6 ? "mlock-AF_INET6" : "mlock-AF_INET",
+				      &mptcp_slock_keys[is_ipv6],
+				      is_ipv6 ? "msk_lock-AF_INET6" : "msk_lock-AF_INET",
+				      &mptcp_keys[is_ipv6]);
+
 	lock_sock(newsk);
 	ssock = __mptcp_nmpc_socket(mptcp_sk(newsk));
 	release_sock(newsk);


