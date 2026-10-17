Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351243A9879;
	Sat, 17 Oct 2026 17:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259499; cv=none; b=YfMhqRdHXoDumONXDZbBRb7hveMHsYGWYp9kWlICaEEPII6FkMF/ROuGk4PYMJR5y1xJhUxWJXQzxMPR3H76iJJ7RndOzW5kByeYGzbLskHOWYGxWjjV9IJZSWxDDo6pX5HUiU/3rxdr6QPL3Uy2DpmuIMPjeCnWc/n696oVN3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259499; c=relaxed/simple;
	bh=xkXCa0zrAovTTZr53Sfr8lcK9PKp7uLLQsUYD7C+PAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NhYR1aSPoN9QvJ9kPxsQySFuaMGlVEiZOO+Yp6UPRh9ZFAXjQFPeYBDGRCuVHrDobdJ4nG9HhGkgu5l8ooWfbNW7S87ID+Bfk+jEi50+y+gTvsHh48YdA6L1n/j0TjsMlwvoL/N/XLzTR/eH+NpnOlhkCD2xlhZoi7zR4hlhUAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuwKDeHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuwKDeHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF261F000C4;
	Sat, 17 Oct 2026 17:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259497;
	bh=PHHZMMmz6U0Rfelpkt1dUGqW+iYQQ3DD7O3Z8yBMy2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kuwKDeHoaUYtX5Q87klDrKe6av2g52nl1SoQ8ZHYzG400heNcbhPh+lZ7OA+cY7oU
	 TivyY7gZpDPV1kluk+j1I2KFpJljhtR3i4pfKhv1ELqmQoOXwuivbDQefipGqpGAsE
	 p1WFyoi1ZGo0/6a+pCj4v9vi0fOdyMqccnnwhdZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1193/1674] selftests: tls: add test with a partially invalid iov
Date: Sat, 17 Oct 2026 17:57:45 +0200
Message-ID: <20261017160501.763849142@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit dc54b813df63020e946ccdef35b64d4fa99fd622 ]

Make sure that we don't return more bytes than we actually received if
the userspace buffer was bogus. We expect to receive at least the rest
of rec1, and possibly some of rec2 (currently, we don't, but that
would be ok).

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/720e61b3d3eab40af198a58ce2cd1ee019f0ceb1.1711120964.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1c8629651cb5 ("tls: rx: restore msg_iter before TLS 1.3 optimistic retry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 34 +++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index bc36c91c4480f..a79270970ade6 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -1570,6 +1570,40 @@ TEST_F(tls, getsockopt)
 	EXPECT_EQ(errno, EINVAL);
 }
 
+TEST_F(tls, recv_efault)
+{
+	char *rec1 = "1111111111";
+	char *rec2 = "2222222222";
+	struct msghdr hdr = {};
+	struct iovec iov[2];
+	char recv_mem[12];
+	int ret;
+
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
+	EXPECT_EQ(send(self->fd, rec1, 10, 0), 10);
+	EXPECT_EQ(send(self->fd, rec2, 10, 0), 10);
+
+	iov[0].iov_base = recv_mem;
+	iov[0].iov_len = sizeof(recv_mem);
+	iov[1].iov_base = NULL; /* broken iov to make process_rx_list fail */
+	iov[1].iov_len = 1;
+
+	hdr.msg_iovlen = 2;
+	hdr.msg_iov = iov;
+
+	EXPECT_EQ(recv(self->cfd, recv_mem, 1, 0), 1);
+	EXPECT_EQ(recv_mem[0], rec1[0]);
+
+	ret = recvmsg(self->cfd, &hdr, 0);
+	EXPECT_LE(ret, sizeof(recv_mem));
+	EXPECT_GE(ret, 9);
+	EXPECT_EQ(memcmp(rec1, recv_mem, 9), 0);
+	if (ret > 9)
+		EXPECT_EQ(memcmp(rec2, recv_mem + 9, ret - 9), 0);
+}
+
 FIXTURE(tls_err)
 {
 	int fd, cfd;
-- 
2.53.0



