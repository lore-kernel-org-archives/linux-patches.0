Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB8C1B2194;
	Wed, 19 Mar 2025 14:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394899; cv=none; b=oUTbdWXlhx1YJT3WmKlYIm8CFocEpGNPQQmm8kHlbaPFy05X0pxluOv+yJ2RTaxyAwTdatxqAV/wKISUNXAXayffEAISFc7yMdSLlXUQcMTZPBX7hZ+i66buyuANjUrlvxE5eX3LPq/mdErdnxhd8iOuEEJ+vNvQseRQ/zyt+Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394899; c=relaxed/simple;
	bh=0271ZOHLmoAX0ciPBL4Kknfmm9TuyU9TAjJV7Mf4ywE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EScXggpyHm3sQ/gPf21LS9ToLcj5SpjMZFg7JRGtT17Gjgv1mceaeW6dE5BmqRYzKmZCOgohqr7dllkO1x+rB2IP9tU2ScKPJSBN4niOfbl1k+Hqre+G6z40iotErYOtnCJile88YEoIhGPdAjZB+3xWM8VBBhiK+Qv5oQZlYiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SR4gYx3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SR4gYx3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D467C4CEE4;
	Wed, 19 Mar 2025 14:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394899;
	bh=0271ZOHLmoAX0ciPBL4Kknfmm9TuyU9TAjJV7Mf4ywE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SR4gYx3KRx50DKBCwEDpuqtcOlSRUjwpz8Bp0B4hDdFgG8iEQgCnWMb4nV06Uios5
	 Cc0OE5VH4Iedow5DPixD8FanfIizur7IXyG54arhfHwHDDIDL5lGNao6/aY4Qg39Kb
	 QpBqJ/VWKNR/w8GqhQvtzZ1t7R+2W9jVVbiSvN8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <mrpre@163.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 105/241] selftests/bpf: Fix invalid flag of recv()
Date: Wed, 19 Mar 2025 07:29:35 -0700
Message-ID: <20250319143030.321158436@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 884ad87783d59..0c51b7288978e 100644
--- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
+++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
@@ -522,8 +522,8 @@ static void test_sockmap_skb_verdict_shutdown(void)
 	if (!ASSERT_EQ(err, 1, "epoll_wait(fd)"))
 		goto out_close;
 
-	n = recv(c1, &b, 1, SOCK_NONBLOCK);
-	ASSERT_EQ(n, 0, "recv_timeout(fin)");
+	n = recv(c1, &b, 1, MSG_DONTWAIT);
+	ASSERT_EQ(n, 0, "recv(fin)");
 out_close:
 	close(c1);
 	close(p1);
@@ -628,7 +628,7 @@ static void test_sockmap_skb_verdict_fionread(bool pass_prog)
 	ASSERT_EQ(avail, expected, "ioctl(FIONREAD)");
 	/* On DROP test there will be no data to read */
 	if (pass_prog) {
-		recvd = recv_timeout(c1, &buf, sizeof(buf), SOCK_NONBLOCK, IO_TIMEOUT_SEC);
+		recvd = recv_timeout(c1, &buf, sizeof(buf), MSG_DONTWAIT, IO_TIMEOUT_SEC);
 		ASSERT_EQ(recvd, sizeof(buf), "recv_timeout(c0)");
 	}
 
-- 
2.39.5



