Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A38C1C54A9;
	Tue, 26 Aug 2025 12:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213072; cv=none; b=I2ql74wP7g/5Bchm6Yg1XjpR/8EFFavUdDTwn90PHyeq9tfRHl4TiDcYWczEnqLDnAcbyA/+lKzwzTJKZORoRfBrxywhcgSDgXyCfZS57TdbAGreOaN1/Et7vbEMf/0l0spVZDFYuP2/Lsrtm/VTqHWOhlbGfe1AVy8fsMHB7G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213072; c=relaxed/simple;
	bh=hOkVl3HO0QM8p+sQ6QA1vaU0spbDdcnc7dua39ZNEWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGG4tUUZVBKHi5MRZiep+aUlsGLrS/WK2k/yxIhbhij31BKttXo7JDZVTUz2f3p24eFputm+OhyhdqOYRHrU5Tnh6PYbT+eDnGM8a+afSEiSsL3wHvMntdLIPUUy1D91IHr2h17Ri/HcakPlsIvpC4cW2Hy4aCYBFPekEiRc+aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mt+7tXHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mt+7tXHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814F0C4CEF1;
	Tue, 26 Aug 2025 12:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213071;
	bh=hOkVl3HO0QM8p+sQ6QA1vaU0spbDdcnc7dua39ZNEWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mt+7tXHv9I23kIV4PkRdh8CNMCo3a0jcF4VLjYJTneplXaFV5iTHIB71K0ns1jc5Y
	 FN2Ic9vlAIeBdu6zqjH7YqHpbUvYkUdC/wxaWY1oBt6s9he/OmcocjBG9puVZUTCWQ
	 7xrYwkNhJr230FKHvSeXBE/1rbwhCZkKF9U+O9aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 210/587] selftests/bpf: Fix a user_ringbuf failure with arm64 64KB page size
Date: Tue, 26 Aug 2025 13:05:59 +0200
Message-ID: <20250826110958.279756911@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index dfff6feac12c..7e9a508c1571 100644
--- a/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/user_ringbuf.c
@@ -21,8 +21,7 @@
 #include "../progs/test_user_ringbuf.h"
 
 static const long c_sample_size = sizeof(struct sample) + BPF_RINGBUF_HDR_SZ;
-static const long c_ringbuf_size = 1 << 12; /* 1 small page */
-static const long c_max_entries = c_ringbuf_size / c_sample_size;
+static long c_ringbuf_size, c_max_entries;
 
 static void drain_current_samples(void)
 {
@@ -424,7 +423,9 @@ static void test_user_ringbuf_loop(void)
 	uint32_t remaining_samples = total_samples;
 	int err;
 
-	BUILD_BUG_ON(total_samples <= c_max_entries);
+	if (!ASSERT_LT(c_max_entries, total_samples, "compare_c_max_entries"))
+		return;
+
 	err = load_skel_create_user_ringbuf(&skel, &ringbuf);
 	if (err)
 		return;
@@ -686,6 +687,9 @@ void test_user_ringbuf(void)
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



