Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C5C1FB44
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E096C433C7;
	Tue,  1 Aug 2023 09:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883457;
	bh=35cMFGabREQ4T4IAtyZmgoIJIpDzH/Mk/P73GWERMN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dLME0MY1JoMkAQ5sTjoiK/C2emMsYsN9Zzp3w6OnAjX942b8V0pC4z2usUrhaprqK
	 Cl1YXw1pZUhpppzecpxYgfXaR34vBTYWR0/hfPlDc6E4VjP3iI+R2NS4AbEyIG5E9D
	 toW/Fp0QDYy9YYKMeMk0Z5pTX35ruD4YxiuZoTN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 223/239] mptcp: more accurate NL event generation
Date: Tue,  1 Aug 2023 11:21:27 +0200
Message-ID: <20230801091933.979481409@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
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

commit 21d9b73a7d5241905367098d260a3c68b811da32 upstream.

Currently the mptcp code generate a "new listener" event even
if the actual listen() syscall fails. Address the issue moving
the event generation call under the successful branch.

Cc: stable@vger.kernel.org
Fixes: f8c9dfbd875b ("mptcp: add pm listener events")
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20230725-send-net-20230725-v1-2-6f60fe7137a9@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3717,10 +3717,9 @@ static int mptcp_listen(struct socket *s
 	if (!err) {
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 		mptcp_copy_inaddrs(sk, ssock->sk);
+		mptcp_event_pm_listener(ssock->sk, MPTCP_EVENT_LISTENER_CREATED);
 	}
 
-	mptcp_event_pm_listener(ssock->sk, MPTCP_EVENT_LISTENER_CREATED);
-
 unlock:
 	release_sock(sk);
 	return err;


