Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B70343D9E;
	Tue, 26 Aug 2025 13:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214519; cv=none; b=YKwOGgiJ7hXs1cFrkMVxR20ica9Lj5HsD69aSD7jQMXphW+R2JI/JxZWj9GOEt+xyzDqzk000qzyVEFe9MGGsnvqLMqyOOMgBff7pwibUURmaAtdb6IBOH6nl+RZmtQnMnX+CidNsIR+Z5oiWdbY0uIK5WCz6waX7MnA+zLTlTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214519; c=relaxed/simple;
	bh=AYSrZsJHqxZo8Yn9qg/JcPnMMzvp/jgBdnj30NCCeXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuDGvMgGvj8A0/Wjczx73pbrIT8n9/UQPa8GdXppx4UHM5ffftoUmdwpUI7cRZkfx1XwRSICWNfmLr3B7hl/fak+Om/zyEOAakHBfn2C/UYJ1WEzwBKgMzBdToeRVGCYv/oCcwSF0a3kTmAaeRCT0/sRZm/kUMqWytIocpgXKF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mhOZ9qIx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhOZ9qIx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EFAC4CEF1;
	Tue, 26 Aug 2025 13:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214519;
	bh=AYSrZsJHqxZo8Yn9qg/JcPnMMzvp/jgBdnj30NCCeXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mhOZ9qIx8kJbpPZs4j1AXUKowE+MOh20eD8s8mKPnxEmntpv/eIvABQ6bkataKPY8
	 UJdZ2PjNOWOblQUL1L9Mztt3dyyp+vCjoRFZoREQySMwQdCn1uSq5/EozA9wTFULFf
	 uQLCg0Iw8MYZkvn65MgUsX9kly5BgUQenED4Ca9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/482] selftests/bpf: Fix a user_ringbuf failure with arm64 64KB page size
Date: Tue, 26 Aug 2025 13:07:01 +0200
Message-ID: <20250826110934.961902959@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit bbc7bd658ddc662083639b9e9a280b90225ecd9a ]

The ringbuf max_entries must be PAGE_ALIGNED. See kernel function
ringbuf_map_alloc(). So for arm64 64KB page size, adjust max_entries
properly.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20250607013626.1553001-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/user_ringbuf.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c b/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
index ca81d660eb96..5e88d37973c5 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
@@ -23,8 +23,7 @@
 static size_t log_buf_sz = 1 << 20; /* 1 MB */
 static char obj_log_buf[1048576];
 static const long c_sample_size = sizeof(struct sample) + BPF_RINGBUF_HDR_SZ;
-static const long c_ringbuf_size = 1 << 12; /* 1 small page */
-static const long c_max_entries = c_ringbuf_size / c_sample_size;
+static long c_ringbuf_size, c_max_entries;
 
 static void drain_current_samples(void)
 {
@@ -426,7 +425,9 @@ static void test_user_ringbuf_loop(void)
 	uint32_t remaining_samples = total_samples;
 	int err;
 
-	BUILD_BUG_ON(total_samples <= c_max_entries);
+	if (!ASSERT_LT(c_max_entries, total_samples, "compare_c_max_entries"))
+		return;
+
 	err = load_skel_create_user_ringbuf(&skel, &ringbuf);
 	if (err)
 		return;
@@ -739,6 +740,9 @@ void test_user_ringbuf(void)
 {
 	int i;
 
+	c_ringbuf_size = getpagesize(); /* 1 page */
+	c_max_entries = c_ringbuf_size / c_sample_size;
+
 	for (i = 0; i < ARRAY_SIZE(success_tests); i++) {
 		if (!test__start_subtest(success_tests[i].test_name))
 			continue;
-- 
2.39.5



