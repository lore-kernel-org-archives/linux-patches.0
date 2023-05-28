Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A30611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:23:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3606C433EF;
	Sun, 28 May 2023 19:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301786;
	bh=Z1Dlaqgi3TMUtUU+JEDf+mlbr97O5lEGjzYo7sxrgwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XNQYeF/0vsxyhuv9RzaE843RwXQtSiMuEm+4dJuGV5vbLpyAppTnqC3GeJXNVvVI0
	 zi7Tt7MSjQhxqVFJvh6xIca1tPGwMLPZqPzZ4lccyThLBXbw31nKmN1d3Tdy9/Y8u0
	 N3vNsaf9FZWGdjPw15aO70HmnVMlVHe50vu/HRXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/161] net: annotate sk->sk_err write from do_recvmmsg()
Date: Sun, 28 May 2023 20:08:52 +0100
Message-Id: <20230528190837.357675644@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190837.051205996@linuxfoundation.org>
References: <20230528190837.051205996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e05a5f510f26607616fecdd4ac136310c8bea56b ]

do_recvmmsg() can write to sk->sk_err from multiple threads.

As said before, many other points reading or writing sk_err
need annotations.

Fixes: 34b88a68f26a ("net: Fix use after free in the recvmmsg exit path")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 02feaf5bd84a3..9dd4c7ce8343a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2723,7 +2723,7 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
 		 * error to return on the next call or if the
 		 * app asks about it using getsockopt(SO_ERROR).
 		 */
-		sock->sk->sk_err = -err;
+		WRITE_ONCE(sock->sk->sk_err, -err);
 	}
 out_put:
 	fput_light(sock->file, fput_needed);
-- 
2.39.2



