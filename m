Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E0315CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596A1C433C1;
	Tue,  8 Nov 2022 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916870;
	bh=+A9R9iXaj0tnMppuYoK6/HVugyLmetw5AC7z/3p0AMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzfOoRq+uBVbXYZ5CCSHDzT8t+TscIK7YfNWCVwSTu9dVbCIzr+vHYlv7rYZr0pnC
	 s4V3trGkRbuVFmJhaARbQNS/tg0LKTFhvnIi3VOnBt08HEzNt4NB73H48zQAs3RXV5
	 EXTpHf9vkS/75JYcCP0ZnobJhfiRVWM6kC7oNL/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Stefan Metzmacher <metze@samba.org>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.0 160/197] net: also flag accepted sockets supporting msghdr originated zerocopy
Date: Tue,  8 Nov 2022 14:39:58 +0100
Message-Id: <20221108133402.210696893@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stefan Metzmacher <metze@samba.org>

commit 71b7786ea478f3c4611deff4d2b9676b0c17c56b upstream.

Without this only the client initiated tcp sockets have SOCK_SUPPORT_ZC.
The listening socket on the server also has it, but the accepted
connections didn't, which meant IORING_OP_SEND[MSG]_ZC will always
fails with -EOPNOTSUPP.

Fixes: e993ffe3da4b ("net: flag sockets supporting msghdr originated zerocopy")
Cc: <stable@vger.kernel.org> # 6.0
CC: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/io-uring/20221024141503.22b4e251@kernel.org/T/#m38aa19b0b825758fb97860a38ad13122051f9dda
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/af_inet.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -748,6 +748,8 @@ int inet_accept(struct socket *sock, str
 		  (TCPF_ESTABLISHED | TCPF_SYN_RECV |
 		  TCPF_CLOSE_WAIT | TCPF_CLOSE)));
 
+	if (test_bit(SOCK_SUPPORT_ZC, &sock->flags))
+		set_bit(SOCK_SUPPORT_ZC, &newsock->flags);
 	sock_graft(sk2, newsock);
 
 	newsock->state = SS_CONNECTED;


