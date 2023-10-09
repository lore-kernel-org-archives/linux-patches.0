Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 447161A5A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6gElAGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEABAC433C7;
	Mon,  9 Oct 2023 13:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857811;
	bh=SoMPrE/sujzynQqyrN4ugL5vfzIU06k6kuLbHsnDEFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6gElAGCqsQ9edH4zGv6zVXCDXx/OikYAT67yjEQZKq5FZCgp87bfENVkklYdMRMB
	 R7PHWc3hytmRrI4Lx0ZuwoK5tTPbPkQ6HILdtODP+06w8C021aX/jfyQleBGIB1uYY
	 R69Gt0OKG/b4noP4ztSPThXc0M1ZL/LPAiiNwnAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rife <jrife@google.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 137/162] smb: use kernel_connect() and kernel_bind()
Date: Mon,  9 Oct 2023 15:01:58 +0200
Message-ID: <20231009130126.690857507@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
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

From: Jordan Rife <jrife@google.com>

commit cedc019b9f260facfadd20c6c490e403abf292e3 upstream.

Recent changes to kernel_connect() and kernel_bind() ensure that
callers are insulated from changes to the address parameter made by BPF
SOCK_ADDR hooks. This patch wraps direct calls to ops->connect() and
ops->bind() with kernel_connect() and kernel_bind() to ensure that SMB
mounts do not see their mount address overwritten in such cases.

Link: https://lore.kernel.org/netdev/9944248dba1bce861375fcce9de663934d933ba9.camel@redhat.com/
Cc: <stable@vger.kernel.org> # 6.0+
Signed-off-by: Jordan Rife <jrife@google.com>
Acked-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2901,9 +2901,9 @@ bind_socket(struct TCP_Server_Info *serv
 	if (server->srcaddr.ss_family != AF_UNSPEC) {
 		/* Bind to the specified local IP address */
 		struct socket *socket = server->ssocket;
-		rc = socket->ops->bind(socket,
-				       (struct sockaddr *) &server->srcaddr,
-				       sizeof(server->srcaddr));
+		rc = kernel_bind(socket,
+				 (struct sockaddr *) &server->srcaddr,
+				 sizeof(server->srcaddr));
 		if (rc < 0) {
 			struct sockaddr_in *saddr4;
 			struct sockaddr_in6 *saddr6;
@@ -3050,8 +3050,8 @@ generic_ip_connect(struct TCP_Server_Inf
 		 socket->sk->sk_sndbuf,
 		 socket->sk->sk_rcvbuf, socket->sk->sk_rcvtimeo);
 
-	rc = socket->ops->connect(socket, saddr, slen,
-				  server->noblockcnt ? O_NONBLOCK : 0);
+	rc = kernel_connect(socket, saddr, slen,
+			    server->noblockcnt ? O_NONBLOCK : 0);
 	/*
 	 * When mounting SMB root file systems, we do not want to block in
 	 * connect. Otherwise bail out and then let cifs_reconnect() perform


