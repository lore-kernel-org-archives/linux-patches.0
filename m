Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61538168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF568C433EF;
	Mon,  8 May 2023 11:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544215;
	bh=bFLPWJG1iddR68PlSNkrAEu0mLkwZG2UW6Axsa9gRHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N33uGZ8wy/8e2oWvHvtW6VMpO5nrbiL5dufUcQwZG5SzWFIYW4t8MGqJwGlfI/1AH
	 fqp3wvacPZqJ5KoI4VS6RjNdKhicslG8rW1EtaupCVsySPb0KAYeOTzOQdNGBf6IaF
	 fqlzBqxScDMb1JuxCgacNvfvbCn54eKvJPXeqVGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Vernet <void@manifault.com>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 338/694] selftests/bpf: Fix IMA test
Date: Mon,  8 May 2023 11:42:53 +0200
Message-Id: <20230508094443.455571664@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit 12fabae03ca6474fd571bf6ddb37d009533305d6 ]

Commit 62622dab0a28 ("ima: return IMA digest value only when IMA_COLLECTED
flag is set") caused bpf_ima_inode_hash() to refuse to give non-fresh
digests. IMA test #3 assumed the old behavior, that bpf_ima_inode_hash()
still returned also non-fresh digests.

Correct the test by accepting both cases. If the samples returned are 1,
assume that the commit above is applied and that the returned digest is
fresh. If the samples returned are 2, assume that the commit above is not
applied, and check both the non-fresh and fresh digest.

Fixes: 62622dab0a28 ("ima: return IMA digest value only when IMA_COLLECTED flag is set")
Reported-by: David Vernet <void@manifault.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Matt Bobrowski <mattbobrowski@google.com>
Link: https://lore.kernel.org/bpf/20230308103713.1681200-1-roberto.sassu@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/test_ima.c       | 29 ++++++++++++++-----
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index b13feceb38f1a..810b14981c2eb 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -70,7 +70,7 @@ void test_test_ima(void)
 	u64 bin_true_sample;
 	char cmd[256];
 
-	int err, duration = 0;
+	int err, duration = 0, fresh_digest_idx = 0;
 	struct ima *skel = NULL;
 
 	skel = ima__open_and_load();
@@ -129,7 +129,15 @@ void test_test_ima(void)
 	/*
 	 * Test #3
 	 * - Goal: confirm that bpf_ima_inode_hash() returns a non-fresh digest
-	 * - Expected result: 2 samples (/bin/true: non-fresh, fresh)
+	 * - Expected result:
+	 *   1 sample (/bin/true: fresh) if commit 62622dab0a28 applied
+	 *   2 samples (/bin/true: non-fresh, fresh) if commit 62622dab0a28 is
+	 *     not applied
+	 *
+	 * If commit 62622dab0a28 ("ima: return IMA digest value only when
+	 * IMA_COLLECTED flag is set") is applied, bpf_ima_inode_hash() refuses
+	 * to give a non-fresh digest, hence the correct result is 1 instead of
+	 * 2.
 	 */
 	test_init(skel->bss);
 
@@ -144,13 +152,18 @@ void test_test_ima(void)
 		goto close_clean;
 
 	err = ring_buffer__consume(ringbuf);
-	ASSERT_EQ(err, 2, "num_samples_or_err");
-	ASSERT_NEQ(ima_hash_from_bpf[0], 0, "ima_hash");
-	ASSERT_NEQ(ima_hash_from_bpf[1], 0, "ima_hash");
-	ASSERT_EQ(ima_hash_from_bpf[0], bin_true_sample, "sample_equal_or_err");
+	ASSERT_GE(err, 1, "num_samples_or_err");
+	if (err == 2) {
+		ASSERT_NEQ(ima_hash_from_bpf[0], 0, "ima_hash");
+		ASSERT_EQ(ima_hash_from_bpf[0], bin_true_sample,
+			  "sample_equal_or_err");
+		fresh_digest_idx = 1;
+	}
+
+	ASSERT_NEQ(ima_hash_from_bpf[fresh_digest_idx], 0, "ima_hash");
 	/* IMA refreshed the digest. */
-	ASSERT_NEQ(ima_hash_from_bpf[1], bin_true_sample,
-		   "sample_different_or_err");
+	ASSERT_NEQ(ima_hash_from_bpf[fresh_digest_idx], bin_true_sample,
+		   "sample_equal_or_err");
 
 	/*
 	 * Test #4
-- 
2.39.2



