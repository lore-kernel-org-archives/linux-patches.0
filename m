Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9CB3BB2C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qq89emIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11029C433C9;
	Wed, 15 Nov 2023 19:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078010;
	bh=GDf/xT+GuaxmY78M16knoxq1AhJk9i0cbEoRhSqY+Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qq89emIq08CfOhO248MRK5Eu6RVZXYJSb4Qx0XNZVF3r5ZHyS0tf16LrVb7QKaqCf
	 QuD+5paqaB1ptQPlFFJr8k95wH5tNQvRCYgs7GW2o1FisBGu8pTdnOPhUaQyOnqaVV
	 EVZNlQUP26+cSpksG+uHkhZScnmI1h5Nc/8UR7bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <hffilwlqm@gmail.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/379] selftests/bpf: Correct map_fd to data_fd in tailcalls
Date: Wed, 15 Nov 2023 14:21:44 -0500
Message-ID: <20231115192646.884465105@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <hffilwlqm@gmail.com>

[ Upstream commit 96daa9874211d5497aa70fa409b67afc29f0cb86 ]

Get and check data_fd. It should not check map_fd again.

Meanwhile, correct some 'return' to 'goto out'.

Thank the suggestion from Maciej in "bpf, x64: Fix tailcall infinite
loop"[0] discussions.

[0] https://lore.kernel.org/bpf/e496aef8-1f80-0f8e-dcdd-25a8c300319a@gmail.com/T/#m7d3b601066ba66400d436b7e7579b2df4a101033

Fixes: 79d49ba048ec ("bpf, testing: Add various tail call test cases")
Fixes: 3b0379111197 ("selftests/bpf: Add tailcall_bpf2bpf tests")
Fixes: 5e0b0a4c52d3 ("selftests/bpf: Test tail call counting with bpf2bpf and data on stack")
Signed-off-by: Leon Hwang <hffilwlqm@gmail.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20230906154256.95461-1-hffilwlqm@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/tailcalls.c      | 32 +++++++++----------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/tailcalls.c b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
index 58fe2c586ed76..09c189761926c 100644
--- a/tools/testing/selftests/bpf/prog_tests/tailcalls.c
+++ b/tools/testing/selftests/bpf/prog_tests/tailcalls.c
@@ -271,11 +271,11 @@ static void test_tailcall_count(const char *which)
 
 	data_map = bpf_object__find_map_by_name(obj, "tailcall.bss");
 	if (CHECK_FAIL(!data_map || !bpf_map__is_internal(data_map)))
-		return;
+		goto out;
 
 	data_fd = bpf_map__fd(data_map);
-	if (CHECK_FAIL(map_fd < 0))
-		return;
+	if (CHECK_FAIL(data_fd < 0))
+		goto out;
 
 	i = 0;
 	err = bpf_map_lookup_elem(data_fd, &i, &val);
@@ -352,11 +352,11 @@ static void test_tailcall_4(void)
 
 	data_map = bpf_object__find_map_by_name(obj, "tailcall.bss");
 	if (CHECK_FAIL(!data_map || !bpf_map__is_internal(data_map)))
-		return;
+		goto out;
 
 	data_fd = bpf_map__fd(data_map);
-	if (CHECK_FAIL(map_fd < 0))
-		return;
+	if (CHECK_FAIL(data_fd < 0))
+		goto out;
 
 	for (i = 0; i < bpf_map__max_entries(prog_array); i++) {
 		snprintf(prog_name, sizeof(prog_name), "classifier_%d", i);
@@ -442,11 +442,11 @@ static void test_tailcall_5(void)
 
 	data_map = bpf_object__find_map_by_name(obj, "tailcall.bss");
 	if (CHECK_FAIL(!data_map || !bpf_map__is_internal(data_map)))
-		return;
+		goto out;
 
 	data_fd = bpf_map__fd(data_map);
-	if (CHECK_FAIL(map_fd < 0))
-		return;
+	if (CHECK_FAIL(data_fd < 0))
+		goto out;
 
 	for (i = 0; i < bpf_map__max_entries(prog_array); i++) {
 		snprintf(prog_name, sizeof(prog_name), "classifier_%d", i);
@@ -631,11 +631,11 @@ static void test_tailcall_bpf2bpf_2(void)
 
 	data_map = bpf_object__find_map_by_name(obj, "tailcall.bss");
 	if (CHECK_FAIL(!data_map || !bpf_map__is_internal(data_map)))
-		return;
+		goto out;
 
 	data_fd = bpf_map__fd(data_map);
-	if (CHECK_FAIL(map_fd < 0))
-		return;
+	if (CHECK_FAIL(data_fd < 0))
+		goto out;
 
 	i = 0;
 	err = bpf_map_lookup_elem(data_fd, &i, &val);
@@ -805,11 +805,11 @@ static void test_tailcall_bpf2bpf_4(bool noise)
 
 	data_map = bpf_object__find_map_by_name(obj, "tailcall.bss");
 	if (CHECK_FAIL(!data_map || !bpf_map__is_internal(data_map)))
-		return;
+		goto out;
 
 	data_fd = bpf_map__fd(data_map);
-	if (CHECK_FAIL(map_fd < 0))
-		return;
+	if (CHECK_FAIL(data_fd < 0))
+		goto out;
 
 	i = 0;
 	val.noise = noise;
@@ -872,7 +872,7 @@ static void test_tailcall_bpf2bpf_6(void)
 	ASSERT_EQ(topts.retval, 0, "tailcall retval");
 
 	data_fd = bpf_map__fd(obj->maps.bss);
-	if (!ASSERT_GE(map_fd, 0, "bss map fd"))
+	if (!ASSERT_GE(data_fd, 0, "bss map fd"))
 		goto out;
 
 	i = 0;
-- 
2.42.0



