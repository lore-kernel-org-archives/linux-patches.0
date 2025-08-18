Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15843203BA;
	Mon, 18 Aug 2025 13:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523947; cv=none; b=rJKW4dmeSo3jK8ffFLMXb2KX5Gh0Ne97HC2hPmUUKETueEKGLRX8P0XwKTxG+UAgFGzFoR4j4Vz6aggagqQnkH+6+8ocE0d1hEnRuBMz7d9o4t6KhF+swcwyKA0YzeLKol1S1TNRybagHRqdbgr4lAcWJ4Nszq0QtK/Hh8aiaz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523947; c=relaxed/simple;
	bh=6x1/9d9oEy8dU1gvI+iCk/q3eeGLr9Ra3tFtfT8Gn18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apTUg7a8TX8NfghVAEqk0s6zSgyeihfsr36R/eWMiU0L9b1jABIDjCFcYLlpX9o2NqScL4Ac0UM5TYK82mLlBp0EK5+qSlhnOcnvq1Diig2GcC9OcqCsuO3O5k7SvqVr21KAg03lJ4gP/rTyiUinel2Gl19lGqNRa1WmUkVJ8Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3Q56eeb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3Q56eeb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59343C4CEEB;
	Mon, 18 Aug 2025 13:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523947;
	bh=6x1/9d9oEy8dU1gvI+iCk/q3eeGLr9Ra3tFtfT8Gn18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3Q56eebnThrn019J/Bz0nlEN6E2zBowrTtd0ZykSZhmhx597LHwLzKDveflFw2Up
	 nazW8tyRO5XFQxuveC/V50jxSADX8DUZwroZ5nGmv8CqQNHbWHYP3WWhpeIsrmu78f
	 RTqzjCLDZfyov5JvUKmHbIFKtVXH7el9bk6pbKEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 320/515] selftests/bpf: Fix a user_ringbuf failure with arm64 64KB page size
Date: Mon, 18 Aug 2025 14:45:06 +0200
Message-ID: <20250818124510.748576046@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index d424e7ecbd12..9fd3ae987321 100644
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



