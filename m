Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C9615AF;
	Sat, 13 Jan 2024 09:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GTWE2I1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E25CFC433C7;
	Sat, 13 Jan 2024 09:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139856;
	bh=LO2SPxaeU9tC3ZXBbAr3yWZaUnB1c5akIm39WpwgYqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GTWE2I1Ok5lNSGbMvxadgEBdYedvxcomib9176ZKT3AdYUOqZuSUIXB2GWLFhhNLw
	 17sBFOuxj57lfjqdsndBih+lVCyyNB1K9SlZc3F4qqHAxm6P2g8KI6ckWHq6kUwmnS
	 beYHviJ20mb1Z0bMRteRkfMgmuQMKiRrqgODoaP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/43] net: Save and restore msg_namelen in sock_sendmsg
Date: Sat, 13 Jan 2024 10:49:54 +0100
Message-ID: <20240113094207.400481348@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.930684111@linuxfoundation.org>
References: <20240113094206.930684111@linuxfoundation.org>
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

From: Marc Dionne <marc.dionne@auristor.com>

[ Upstream commit 01b2885d9415152bcb12ff1f7788f500a74ea0ed ]

Commit 86a7e0b69bd5 ("net: prevent rewrite of msg_name in
sock_sendmsg()") made sock_sendmsg save the incoming msg_name pointer
and restore it before returning, to insulate the caller against
msg_name being changed by the called code.  If the address length
was also changed however, we may return with an inconsistent structure
where the length doesn't match the address, and attempts to reuse it may
lead to lost packets.

For example, a kernel that doesn't have commit 1c5950fc6fe9 ("udp6: fix
potential access to stale information") will replace a v4 mapped address
with its ipv4 equivalent, and shorten namelen accordingly from 28 to 16.
If the caller attempts to reuse the resulting msg structure, it will have
the original ipv6 (v4 mapped) address but an incorrect v4 length.

Fixes: 86a7e0b69bd5 ("net: prevent rewrite of msg_name in sock_sendmsg()")
Signed-off-by: Marc Dionne <marc.dionne@auristor.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/socket.c b/net/socket.c
index 36e38ee434ea1..2a48aa89c035b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -675,6 +675,7 @@ int sock_sendmsg(struct socket *sock, struct msghdr *msg)
 {
 	struct sockaddr_storage *save_addr = (struct sockaddr_storage *)msg->msg_name;
 	struct sockaddr_storage address;
+	int save_len = msg->msg_namelen;
 	int ret;
 
 	if (msg->msg_name) {
@@ -684,6 +685,7 @@ int sock_sendmsg(struct socket *sock, struct msghdr *msg)
 
 	ret = __sock_sendmsg(sock, msg);
 	msg->msg_name = save_addr;
+	msg->msg_namelen = save_len;
 
 	return ret;
 }
-- 
2.43.0



