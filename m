Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A22D355029;
	Tue, 16 Dec 2025 11:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885965; cv=none; b=WcT8vzPC8M8eo6iFILROGb4z/gtiTbWESRLw1wwxFE09TCRsQUCvnuJZL2y8RvbxzV2lPVbsn3SDrIXAWCKZahNpJB8U0ERmdPd1JI0hUJ5kS+KNw8QRUd+fZG4rSO32p11u7Od2/WZVryqF7cYmk9+dIX6Uiz/Dd9mrIhNYLRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885965; c=relaxed/simple;
	bh=ChMDFcXmvF0Jl2CrPKnAlgCg99M8ZxBpp2CFh6x7cMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgQrRD3yw2bOmq8Q/R2R6vTaMWM9feF11++vDbRlp0p4pEa39GE7Rp/9DX89dfN+gRMe2rXIaHYZPu6KVTt1Ax/C3hXi66smYE7ngLPWOXP+p5cdPytvmsztEq5Bpu2nT9QZdxhwJOsUjDEcT9yoVHkHPLg6sQFcT8Ki01Vhfe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9bPsiwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9bPsiwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D97C4CEF1;
	Tue, 16 Dec 2025 11:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885965;
	bh=ChMDFcXmvF0Jl2CrPKnAlgCg99M8ZxBpp2CFh6x7cMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9bPsiwQuML+gxiNS5KHcSVpgDDQzBU+xC8fmdmbbh1yE5zxbgPCBhsGUQxKBeKL8
	 L5OGhwaBy4aB9n3ynRfEEwsAHboNIP2MoW5I3TkNNujq4XFdGhvDqUj3t3wM7ca30G
	 2TgA4EG3MQGkeS2pWiFJgF5ZB39DvOEsYf0ewrPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Bobrowski <mattbobrowski@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 297/507] selftests/bpf: Use ASSERT_STRNEQ to factor in long slab cache names
Date: Tue, 16 Dec 2025 12:12:18 +0100
Message-ID: <20251216111356.235070218@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Bobrowski <mattbobrowski@google.com>

[ Upstream commit d088da904223e8f5e19c6d156cf372d5baec1a7c ]

subtest_kmem_cache_iter_check_slabinfo() fundamentally compares slab
cache names parsed out from /proc/slabinfo against those stored within
struct kmem_cache_result. The current problem is that the slab cache
name within struct kmem_cache_result is stored within a bounded
fixed-length array (sized to SLAB_NAME_MAX(32)), whereas the name
parsed out from /proc/slabinfo is not. Meaning, using ASSERT_STREQ()
can certainly lead to test failures, particularly when dealing with
slab cache names that are longer than SLAB_NAME_MAX(32)
bytes. Notably, kmem_cache_create() allows callers to create slab
caches with somewhat arbitrarily sized names via its __name identifier
argument, so exceeding the SLAB_NAME_MAX(32) limit that is in place
now can certainly happen.

Make subtest_kmem_cache_iter_check_slabinfo() more reliable by only
checking up to sizeof(struct kmem_cache_result.name) - 1 using
ASSERT_STRNEQ().

Fixes: a496d0cdc84d ("selftests/bpf: Add a test for kmem_cache_iter")
Signed-off-by: Matt Bobrowski <mattbobrowski@google.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Song Liu <song@kernel.org>
Link: https://patch.msgid.link/20251118073734.4188710-1-mattbobrowski@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/kmem_cache_iter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/kmem_cache_iter.c b/tools/testing/selftests/bpf/prog_tests/kmem_cache_iter.c
index 1de14b111931a..6e35e13c20220 100644
--- a/tools/testing/selftests/bpf/prog_tests/kmem_cache_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/kmem_cache_iter.c
@@ -57,7 +57,8 @@ static void subtest_kmem_cache_iter_check_slabinfo(struct kmem_cache_iter *skel)
 		if (!ASSERT_OK(ret, "kmem_cache_lookup"))
 			break;
 
-		ASSERT_STREQ(r.name, name, "kmem_cache_name");
+		ASSERT_STRNEQ(r.name, name, sizeof(r.name) - 1,
+			      "kmem_cache_name");
 		ASSERT_EQ(r.obj_size, objsize, "kmem_cache_objsize");
 
 		seen++;
-- 
2.51.0



