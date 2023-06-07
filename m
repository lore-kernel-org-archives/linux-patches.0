Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F3819E48
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D5EC433D2;
	Wed,  7 Jun 2023 20:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170458;
	bh=lnMvFK+IgG7kW/4N7QTOPdVCRZ0LMdjguCkn2RcxIpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1281o+SXNPMi3xK1+UNZx7hdUU0IkQCQ1sY8ZhfHWKQlsGlQgRTw0+VW00mwGDpj6
	 Upfy1F2w0dEuXzdPHZ2wYoVArO9gm3A4e6LIU6OLhiV7aRHShWXIQ8mRyNPUWTRlNH
	 0EjBBIDWdLr9amvMqMjLTPtWmb4qU/82SsHxk0Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/225] mptcp: avoid unneeded __mptcp_nmpc_socket() usage
Date: Wed,  7 Jun 2023 22:14:06 +0200
Message-ID: <20230607200916.092815780@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
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

[ Upstream commit 617612316953093bc859890e405e1b550c27d840 ]

In a few spots, the mptcp code invokes the __mptcp_nmpc_socket() helper
multiple times under the same socket lock scope. Additionally, in such
places, the socket status ensures that there is no MP capable handshake
running.

Under the above condition we can replace the later __mptcp_nmpc_socket()
helper invocation with direct access to the msk->subflow pointer and
better document such access is not supposed to fail with WARN().

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5b825727d087 ("mptcp: add annotations around msk->subflow accesses")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ea46a5cb1c30f..fecee0a850d65 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3172,7 +3172,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	struct socket *listener;
 	struct sock *newsk;
 
-	listener = __mptcp_nmpc_socket(msk);
+	listener = msk->subflow;
 	if (WARN_ON_ONCE(!listener)) {
 		*err = -EINVAL;
 		return NULL;
@@ -3398,7 +3398,7 @@ static int mptcp_get_port(struct sock *sk, unsigned short snum)
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct socket *ssock;
 
-	ssock = __mptcp_nmpc_socket(msk);
+	ssock = msk->subflow;
 	pr_debug("msk=%p, subflow=%p", msk, ssock);
 	if (WARN_ON_ONCE(!ssock))
 		return -EINVAL;
@@ -3746,7 +3746,10 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 
 	pr_debug("msk=%p", msk);
 
-	ssock = __mptcp_nmpc_socket(msk);
+	/* buggy applications can call accept on socket states other then LISTEN
+	 * but no need to allocate the first subflow just to error out.
+	 */
+	ssock = msk->subflow;
 	if (!ssock)
 		return -EINVAL;
 
-- 
2.39.2



