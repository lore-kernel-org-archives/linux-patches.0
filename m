Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5971C5F26;
	Wed, 19 Mar 2025 14:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395066; cv=none; b=A6f/pOU0xY6JbuDaUFwbRMFcaItQTfpD2OuBkrccYlQyrjklyewS1lYvarBHacViypUttxigEoz4YXc8s8FeITBsN/vBhFUJc6Uz1Ng6C6sS+P47f+pWQNOLdGOs/55GG7i2wL1ZIZ5zyUHQWKjK88OnRcrMfKEMqivXlvhr3hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395066; c=relaxed/simple;
	bh=LtI97epBYjFykA8TJYPpF5C1UlBUM6EGgrUjoAIRBu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7p+YfqyXESr7f3WerkD2su9TojZ5loG5y5oWMA9+0azQz9BoK86WrFHD25V3Rc4GujnBMzVL9sgfzxiecump1px9N3a5b68ie9esKBYgXVg4SYQdNk0q/fYa74kWo25vNOmOkOq8XS80n7AzTQQ0UXqgTJGGSg+4hVDfHWpdoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCE8xjJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCE8xjJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F071BC4CEE4;
	Wed, 19 Mar 2025 14:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395066;
	bh=LtI97epBYjFykA8TJYPpF5C1UlBUM6EGgrUjoAIRBu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCE8xjJtYMLuKhddXifM79NM3a3Iocsog2caLPvHqR4IfXBrnTN9mrGAsEoED6BC3
	 xzcr1LOcuZFEdU+wEJPE4eIWO6gmIoaWVMWVOVzCdiykt4i8FswB9y8ETz5CB+NWDF
	 9zncbC6U284nSlPSOdUtBE+dkystMRuPRi3jmXNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <mrpre@163.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/231] selftests/bpf: Fix invalid flag of recv()
Date: Wed, 19 Mar 2025 07:29:55 -0700
Message-ID: <20250319143029.356084427@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <mrpre@163.com>

[ Upstream commit a0c11149509aa905aeec10cf9998091443472b0b ]

SOCK_NONBLOCK flag is only effective during socket creation, not during
recv. Use MSG_DONTWAIT instead.

Signed-off-by: Jiayuan Chen <mrpre@163.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://patch.msgid.link/20250122100917.49845-5-mrpre@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sockmap_basic.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
index 82bfb266741cf..fb08c565d6aad 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -492,8 +492,8 @@ static void test_sockmap_skb_verdict_shutdown(void)
 	if (!ASSERT_EQ(err, 1, "epoll_wait(fd)"))
 		goto out_close;
 
-	n = recv(c1, &b, 1, SOCK_NONBLOCK);
-	ASSERT_EQ(n, 0, "recv_timeout(fin)");
+	n = recv(c1, &b, 1, MSG_DONTWAIT);
+	ASSERT_EQ(n, 0, "recv(fin)");
 out_close:
 	close(c1);
 	close(p1);
@@ -546,7 +546,7 @@ static void test_sockmap_skb_verdict_fionread(bool pass_prog)
 	ASSERT_EQ(avail, expected, "ioctl(FIONREAD)");
 	/* On DROP test there will be no data to read */
 	if (pass_prog) {
-		recvd = recv_timeout(c1, &buf, sizeof(buf), SOCK_NONBLOCK, IO_TIMEOUT_SEC);
+		recvd = recv_timeout(c1, &buf, sizeof(buf), MSG_DONTWAIT, IO_TIMEOUT_SEC);
 		ASSERT_EQ(recvd, sizeof(buf), "recv_timeout(c0)");
 	}
 
-- 
2.39.5



