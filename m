Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF81144376;
	Thu, 15 Aug 2024 14:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730918; cv=none; b=nLk6/8/5Z276UgChLhSkflzN6kLMmqfZ35983kxZ7JpHLEHTk6PRIhktQX40dzpo/hK88eSTsdgCVm74URXppTRDNXDt3duC1btg1a2RM8FQVApJxndCxgmmFVNpRi6Kgk3OJMGbM/u48ENuLzJWtBLsWDGJC1wK4O67oYAffH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730918; c=relaxed/simple;
	bh=0xztK/nEU/ElkM7fNf+kM+qcLhQyezcZMu2eURSdnW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jkaVtFsSWFVAEpZvrcQRj2GRivNc66r+yBn0ldj5qskNhzvjoP/se/vF+glOAimjpz+ybvqGkwrLSBRjqoT4zyXMTZ033YH5z2tmEsFj+1FYY3crFpTUzX2FRG5+aUH3ihnpSLzBxp7GdwS+VWXHPuETAL/QkBzxSwB/Fha3gPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpbaLm4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpbaLm4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E180C32786;
	Thu, 15 Aug 2024 14:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730917;
	bh=0xztK/nEU/ElkM7fNf+kM+qcLhQyezcZMu2eURSdnW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpbaLm4ZpDaKCQn0ZrnJvOLEaP3AIB6l/oQf60VC+rSg2NHbfa6q8xTfmB59iliwM
	 vWDghFpsvlvFV0FKndQO8k0F5sgup38OyLH6q/tgKyu3TAhpTfTWOBFUi1vSY+Mo/r
	 DuugJpP4DOi3+hjczRhk0YhkcpW+rJtCP92WXHWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Fastabend <john.fastabend@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 34/67] net: tls, add test to capture error on large splice
Date: Thu, 15 Aug 2024 15:25:48 +0200
Message-ID: <20240815131839.633419779@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Fastabend <john.fastabend@gmail.com>

[ Upstream commit 034ea1305e659ddae44c19ba8449166fec318e2d ]

syzbot found an error with how splice() is handled with a msg greater
than 32. This was fixed in previous patch, but lets add a test for
it to ensure it continues to work.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index ad993ab3ac181..bc36c91c4480f 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -707,6 +707,20 @@ TEST_F(tls, splice_from_pipe)
 	EXPECT_EQ(memcmp(mem_send, mem_recv, send_len), 0);
 }
 
+TEST_F(tls, splice_more)
+{
+	unsigned int f = SPLICE_F_NONBLOCK | SPLICE_F_MORE | SPLICE_F_GIFT;
+	int send_len = TLS_PAYLOAD_MAX_LEN;
+	char mem_send[TLS_PAYLOAD_MAX_LEN];
+	int i, send_pipe = 1;
+	int p[2];
+
+	ASSERT_GE(pipe(p), 0);
+	EXPECT_GE(write(p[1], mem_send, send_len), 0);
+	for (i = 0; i < 32; i++)
+		EXPECT_EQ(splice(p[0], NULL, self->fd, NULL, send_pipe, f), 1);
+}
+
 TEST_F(tls, splice_from_pipe2)
 {
 	int send_len = 16000;
-- 
2.43.0



