Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866CE366555;
	Tue, 16 Dec 2025 12:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887942; cv=none; b=GAOUBSjclNqFGhcPuCvJNoWoc45aO13RJ9O8010EnKzXiGQ2euOjFb/uIx/PU8flOH7LNpbriDR3lSZRiQNqfQvGyi2AgeBHmrgZiOksd29Q1rvLL8b72CcffkX14hxpwhdVAeA2m0m4eC3JtqvvTm+rvbb/fG7A7S2qfDYWGgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887942; c=relaxed/simple;
	bh=eyXZHeLc3lX9/TjVSqW/g8NwTGiCofEMmEtTDlCyLsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tw6hDJXEktR5aoBgrd2Y3cBZrifrrC3bnj6dl2l1J2cSp1HC34tF2Vn+/T7YxcVGWzv40MsUankvQsLR8SbuwDbSu1N3VUuUM2q/7/QwWbA1x2Rp4Av4PqxQagqtgzYKJtiaLLogd9uhw+obHC9QuIqTiJH/cqu9PldQe0MjCn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCIzDCRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCIzDCRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75EAC16AAE;
	Tue, 16 Dec 2025 12:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887942;
	bh=eyXZHeLc3lX9/TjVSqW/g8NwTGiCofEMmEtTDlCyLsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCIzDCRO28NCQcc1cuWFo7dTJjBLPYQd/N+iSv2YgNjz+PV9yMf81WGJjFvi3fkcd
	 eqSOFFksyG6bYmFFB4FiqzBITEmqei2fxYoiZQMLCgT08D3sTBzORfhL3pQdPKYpn0
	 Km0zNsheWsxfzHgqSi4pWDE7IxGhYe+rcyza+S1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Bobrowski <mattbobrowski@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 352/614] selftests/bpf: Use ASSERT_STRNEQ to factor in long slab cache names
Date: Tue, 16 Dec 2025 12:11:59 +0100
Message-ID: <20251216111414.116567450@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



