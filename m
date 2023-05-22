Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60C7171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53657C433EF;
	Mon, 22 May 2023 19:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783351;
	bh=fUMsZtzfRXUxjlokN++TSoC4gwEIqN84MyNdwjFLexk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1MFwpzQvzxWqDVbedNoW0YKS+OTCuNffUWE9mg67p6emfSyWF0iBIcs+jThtWLqhp
	 2/Luvyp1WKEXf1y70pHvi+5a29v8jYqElzPSnZCR5rku2dKdA6ULEUBcpfxSFMh9R3
	 I2EYgtVIivxNEx+ma8R2iDuah1ohCkcUNKRgW1Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	syzbot <syzkaller@googlegroups.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/292] net: annotate sk->sk_err write from do_recvmmsg()
Date: Mon, 22 May 2023 20:06:13 +0100
Message-Id: <20230522190406.298927887@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
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
index 577079a8935fa..c2e0a22f16d9b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2890,7 +2890,7 @@ static int do_recvmmsg(int fd, struct mmsghdr __user *mmsg,
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



