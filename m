Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25BC1D555
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE63C433C7;
	Wed,  4 Oct 2023 18:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443121;
	bh=bPekx4cBz4l7uClHdjhNj4bVm4QVytLnS3jRnjiTyFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uw4Nw32M7sa/HBC+G+6CulSaU8Sh/wDXtCOqXelqnWOlv/Ei5H/OCoS2srjYFAId8
	 Pysy0Wna6HgkTp+xm7YEex4Npwpd/esh8C04GkKCwY0RYT33T4QPbkh1EDQoXE+i/2
	 /Q41uN71CqAKdfW1YiB7cfqjE9yQCIp3KyQzBGWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/259] selftests: tls: swap the TX and RX sockets in some tests
Date: Wed,  4 Oct 2023 19:53:37 +0200
Message-ID: <20231004175219.465027134@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit c326ca98446e0ae4fee43a40acf79412b74cfedb ]

tls.sendmsg_large and tls.sendmsg_multiple are trying to send through
the self->cfd socket (only configured with TLS_RX) and to receive through
the self->fd socket (only configured with TLS_TX), so they're not using
kTLS at all. Swap the sockets.

Fixes: 7f657d5bf507 ("selftests: tls: add selftests for TLS sockets")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index c0ad8385441f2..5b80fb155d549 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -551,11 +551,11 @@ TEST_F(tls, sendmsg_large)
 
 		msg.msg_iov = &vec;
 		msg.msg_iovlen = 1;
-		EXPECT_EQ(sendmsg(self->cfd, &msg, 0), send_len);
+		EXPECT_EQ(sendmsg(self->fd, &msg, 0), send_len);
 	}
 
 	while (recvs++ < sends) {
-		EXPECT_NE(recv(self->fd, mem, send_len, 0), -1);
+		EXPECT_NE(recv(self->cfd, mem, send_len, 0), -1);
 	}
 
 	free(mem);
@@ -584,9 +584,9 @@ TEST_F(tls, sendmsg_multiple)
 	msg.msg_iov = vec;
 	msg.msg_iovlen = iov_len;
 
-	EXPECT_EQ(sendmsg(self->cfd, &msg, 0), total_len);
+	EXPECT_EQ(sendmsg(self->fd, &msg, 0), total_len);
 	buf = malloc(total_len);
-	EXPECT_NE(recv(self->fd, buf, total_len, 0), -1);
+	EXPECT_NE(recv(self->cfd, buf, total_len, 0), -1);
 	for (i = 0; i < iov_len; i++) {
 		EXPECT_EQ(memcmp(test_strs[i], buf + len_cmp,
 				 strlen(test_strs[i])),
-- 
2.40.1



