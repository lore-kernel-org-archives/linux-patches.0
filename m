Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEF735C681;
	Thu, 20 Aug 2026 17:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247508; cv=none; b=EHBUdsgdDnGdwOvDCwttypJCBTySFtm8zSejPCryLtRYt4Ktd9hpUHV/balcqUQh6INIPTeUYgKI9d6OzZLb4NlKWQokgetxBY7RdeO4v0MdV2y4+VjUakWXNlzY99rME7fvWIykf8WRTRzbKCx3nXE/s0tct3UXrNxWYizpa5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247508; c=relaxed/simple;
	bh=OBT/eGbC77+lQXwLgtMykB3laRBlvPTXve/1VhCnFx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fK4g4lijCCc77wEVllAZ4mqdtdjuQ68VuT0xPCz3BwPqVx4g2/QgHG9qNO+47pAK2nVFjV6LmWuzHbSXJbHPXqDrFg9dYGdWveNDM9w4xZE6zKGOH9bNBvCSIHj1qBtGvxqzeqVZiHz5rqiPEPszhhTbxF5dKyOgwsnly78HRXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLsMmENC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLsMmENC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F3061F000E9;
	Thu, 20 Aug 2026 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247507;
	bh=hi6fPKBPKv1QpLfVODg+PdC5CtBrW+yZvsMMzrcCvOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WLsMmENCtDv90NADXGCEWrKHH8CzJ3I6pkaZkta+xvdRGHqye/1EH6OkQV0bYyAHN
	 Z9flWrKGmo8QH3lz8bo3HQiMH4DXbnua1oCq620sha5rIKpZOSeTZ2EuI5Vfpqhsl4
	 Eav+CZfvSoziYhlnkGBHlr7JON6wMMOTYJEmOzPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/166] selftests: tls: add test with a partially invalid iov
Date: Thu, 20 Aug 2026 16:55:28 +0200
Message-ID: <20260820145213.220157156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/tls.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

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


