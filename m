Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7175F2E63E
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkUhqQbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD583C433C8;
	Mon,  9 Oct 2023 13:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858189;
	bh=DEvGiYJO7PIaJreIYPPEd9D5xAYjXiPxk8UbMoCab1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkUhqQbisa7pB+qWCp+YSyiwcxTVQrBtmLaI5M96OU2gnHiYQEMm563OEqSUbrRej
	 fV3qJz3dQFevOfHyWTE6LW+IGFOdz1VUWEHTlaCgo00ZSeYTlHEyCsTW+2MhZ/42tu
	 0+jWvfS3knj291VQUKTPguIKAH26W0qjA3awz0RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 017/131] selftests: tls: swap the TX and RX sockets in some tests
Date: Mon,  9 Oct 2023 15:00:57 +0200
Message-ID: <20231009130116.844804796@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 032e08e8ce016..837206dbe5d6e 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -311,11 +311,11 @@ TEST_F(tls, sendmsg_large)
 
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
@@ -344,9 +344,9 @@ TEST_F(tls, sendmsg_multiple)
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



