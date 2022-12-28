Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD86E1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360ACC433EF;
	Wed, 28 Dec 2022 15:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240780;
	bh=1yXF612/I0D0I/N193mVms18DBk1JUiGuTpVj6eFxAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p592+9l/ij4SEJs2a4Ll6wuR5Xol4tiwFvTME309lVxPhkrMfx4VxNZROvS1v9Lua
	 q3Oo1s53pCXN8xDmrJ1Y1cz9xvdvxi2ztTcegjruV8/sdKMAFIDduO76iHIggnqgyY
	 +pJmqrQio3yXD5MZ44S6/8lvfQfYz+f3uEKaQ4Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0202/1073] selftests/bpf: Fix memory leak caused by not destroying skeleton
Date: Wed, 28 Dec 2022 15:29:50 +0100
Message-Id: <20221228144333.505642544@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 6e8280b958c5d7edc514cf347a800b23b7732b2b ]

Some test cases does not destroy skeleton object correctly, causing ASAN
to report memory leak warning. Fix it.

Fixes: 0ef6740e9777 ("selftests/bpf: Add tests for kptr_ref refcounting")
Fixes: 1642a3945e22 ("selftests/bpf: Add struct argument tests with fentry/fexit programs.")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/bpf/20221011120108.782373-4-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/map_kptr.c       | 3 ++-
 tools/testing/selftests/bpf/prog_tests/tracing_struct.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/map_kptr.c b/tools/testing/selftests/bpf/prog_tests/map_kptr.c
index fdcea7a61491..0d66b1524208 100644
--- a/tools/testing/selftests/bpf/prog_tests/map_kptr.c
+++ b/tools/testing/selftests/bpf/prog_tests/map_kptr.c
@@ -105,7 +105,7 @@ static void test_map_kptr_success(bool test_run)
 	ASSERT_OK(opts.retval, "test_map_kptr_ref2 retval");
 
 	if (test_run)
-		return;
+		goto exit;
 
 	ret = bpf_map__update_elem(skel->maps.array_map,
 				   &key, sizeof(key), buf, sizeof(buf), 0);
@@ -132,6 +132,7 @@ static void test_map_kptr_success(bool test_run)
 	ret = bpf_map__delete_elem(skel->maps.lru_hash_map, &key, sizeof(key), 0);
 	ASSERT_OK(ret, "lru_hash_map delete");
 
+exit:
 	map_kptr__destroy(skel);
 }
 
diff --git a/tools/testing/selftests/bpf/prog_tests/tracing_struct.c b/tools/testing/selftests/bpf/prog_tests/tracing_struct.c
index d5022b91d1e4..48dc9472e160 100644
--- a/tools/testing/selftests/bpf/prog_tests/tracing_struct.c
+++ b/tools/testing/selftests/bpf/prog_tests/tracing_struct.c
@@ -15,7 +15,7 @@ static void test_fentry(void)
 
 	err = tracing_struct__attach(skel);
 	if (!ASSERT_OK(err, "tracing_struct__attach"))
-		return;
+		goto destroy_skel;
 
 	ASSERT_OK(trigger_module_test_read(256), "trigger_read");
 
@@ -54,6 +54,7 @@ static void test_fentry(void)
 	ASSERT_EQ(skel->bss->t5_ret, 1, "t5 ret");
 
 	tracing_struct__detach(skel);
+destroy_skel:
 	tracing_struct__destroy(skel);
 }
 
-- 
2.35.1



