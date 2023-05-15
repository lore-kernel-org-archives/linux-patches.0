Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA19FBF6
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C33C433EF;
	Mon, 15 May 2023 17:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173394;
	bh=5Xz6DNewh+6cg6nd7xwBDceSdpGCKhYyujgZh2gky+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5eKbaJ2gGkGRDQJxokRWjz2UvqN/Jhz/F2p2v37kdvIuoD4D67AekM55rWcDXUhC
	 enZWgLnkFXVN7F0w4WLSw6/IBs+6NA5nmq97D9FD+b5gFmbIgBbDFC1RE6AWR2X4kv
	 XNDoaKh+LWR0mYL9oPMq5N5JZDV/bw/dHDBUatwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/282] scm: fix MSG_CTRUNC setting condition for SO_PASSSEC
Date: Mon, 15 May 2023 18:27:39 +0200
Message-Id: <20230515161724.668578859@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

[ Upstream commit a02d83f9947d8f71904eda4de046630c3eb6802c ]

Currently, kernel would set MSG_CTRUNC flag if msg_control buffer
wasn't provided and SO_PASSCRED was set or if there was pending SCM_RIGHTS.

For some reason we have no corresponding check for SO_PASSSEC.

In the recvmsg(2) doc we have:
       MSG_CTRUNC
              indicates that some control data was discarded due to lack
              of space in the buffer for ancillary data.

So, we need to set MSG_CTRUNC flag for all types of SCM.

This change can break applications those don't check MSG_CTRUNC flag.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

v2:
- commit message was rewritten according to Eric's suggestion
Acked-by: Paul Moore <paul@paul-moore.com>

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/scm.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/net/scm.h b/include/net/scm.h
index 1ce365f4c2560..585adc1346bd0 100644
--- a/include/net/scm.h
+++ b/include/net/scm.h
@@ -105,16 +105,27 @@ static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct sc
 		}
 	}
 }
+
+static inline bool scm_has_secdata(struct socket *sock)
+{
+	return test_bit(SOCK_PASSSEC, &sock->flags);
+}
 #else
 static inline void scm_passec(struct socket *sock, struct msghdr *msg, struct scm_cookie *scm)
 { }
+
+static inline bool scm_has_secdata(struct socket *sock)
+{
+	return false;
+}
 #endif /* CONFIG_SECURITY_NETWORK */
 
 static __inline__ void scm_recv(struct socket *sock, struct msghdr *msg,
 				struct scm_cookie *scm, int flags)
 {
 	if (!msg->msg_control) {
-		if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp)
+		if (test_bit(SOCK_PASSCRED, &sock->flags) || scm->fp ||
+		    scm_has_secdata(sock))
 			msg->msg_flags |= MSG_CTRUNC;
 		scm_destroy(scm);
 		return;
-- 
2.39.2



