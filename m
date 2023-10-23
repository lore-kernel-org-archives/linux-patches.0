Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4471429B
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKd3zQ1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDE0C433C7;
	Mon, 23 Oct 2023 11:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059904;
	bh=7M8uAlThECaYBR+d6vHUSZAYKiNLs1FYSS6uVmODoKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JKd3zQ1TT3Ef/fxeH2Sr4UGJaJSl6m5ZQsYVoQP5R30DvWv1voYLE+GV6z52QahV+
	 BggOvUn7DFXsuS6exSkak6ZLLU5JJ6O3zn3KGJhiOqF8G3B7Vv9zck3ltOFwD73ZOz
	 3lSrjWpzvDnO34dqMd4oyPwOv3qYj3Oxtjh2nk9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rife <jrife@google.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 65/98] libceph: use kernel_connect()
Date: Mon, 23 Oct 2023 12:56:54 +0200
Message-ID: <20231023104815.888497086@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104813.580375891@linuxfoundation.org>
References: <20231023104813.580375891@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jordan Rife <jrife@google.com>

[ Upstream commit 7563cf17dce0a875ba3d872acdc63a78ea344019 ]

Direct calls to ops->connect() can overwrite the address parameter when
used in conjunction with BPF SOCK_ADDR hooks. Recent changes to
kernel_connect() ensure that callers are insulated from such side
effects. This patch wraps the direct call to ops->connect() with
kernel_connect() to prevent unexpected changes to the address passed to
ceph_tcp_connect().

This change was originally part of a larger patch targeting the net tree
addressing all instances of unprotected calls to ops->connect()
throughout the kernel, but this change was split up into several patches
targeting various trees.

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/20230821100007.559638-1-jrife@google.com/
Link: https://lore.kernel.org/netdev/9944248dba1bce861375fcce9de663934d933ba9.camel@redhat.com/
Fixes: d74bad4e74ee ("bpf: Hooks for sys_connect")
Signed-off-by: Jordan Rife <jrife@google.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/messenger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index 53ab8fc713a3e..7fd18e10755ec 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -487,8 +487,8 @@ static int ceph_tcp_connect(struct ceph_connection *con)
 	dout("connect %s\n", ceph_pr_addr(&con->peer_addr.in_addr));
 
 	con_sock_state_connecting(con);
-	ret = sock->ops->connect(sock, (struct sockaddr *)&ss, sizeof(ss),
-				 O_NONBLOCK);
+	ret = kernel_connect(sock, (struct sockaddr *)&ss, sizeof(ss),
+			     O_NONBLOCK);
 	if (ret == -EINPROGRESS) {
 		dout("connect %s EINPROGRESS sk_state = %u\n",
 		     ceph_pr_addr(&con->peer_addr.in_addr),
-- 
2.40.1



