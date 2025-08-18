Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F65340DA9;
	Mon, 18 Aug 2025 14:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525832; cv=none; b=qbBsO6Tkz235ybgGraW+8Rf+da5Q7kcdUESbQKE2EaP41tPDIP74R4VI/UTqjn2Rzy1f4SZCavn/UFd1e508Kwo1L9eFkZw+3ZfqIIc9uV/3SKm7S++fHSYnBQGAtCq4Q4ahzWDEI5HBcYG9HuUrvdaDIFms9XKbA2lNwXCJ0qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525832; c=relaxed/simple;
	bh=p1Tr0QwoFIJ1LmMi2NnaTrw0HlJqt8A6GO/gcOjaFZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrwNPdRPmhsg4VI2GSjDqINMtxOLgabxPsbXChGvwSQrJNYsO08IGr95GGKTgBhIjwYRNpB1CRDioUw12kW8+slzDIuXLa5ORwcXBfQG1AwEzOOiq7c+/xnu7bz3AVWUHCCMWIaEgqef+PIp14We/rz4nhsGITfQRHVaf6Qy34Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CsW9ViVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CsW9ViVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64115C4CEEB;
	Mon, 18 Aug 2025 14:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525832;
	bh=p1Tr0QwoFIJ1LmMi2NnaTrw0HlJqt8A6GO/gcOjaFZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CsW9ViVijGFCr+I32laLggDPu/YLhNoaRcJlVhFoZ/EkeMVNwLM98MgPnQXf/6Lf8
	 UZGDEIC11IErHPVFarW1cwFQ7IEo5MFgfCTEMarxDybpc3ObQxlG9GsFrf+oAa85Jk
	 K9gqOTWBNAI4GaHuCBfDcoX7VxpBUlObz7quFcHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 347/570] selftests/bpf: Fix ringbuf/ringbuf_write test failure with arm64 64KB page size
Date: Mon, 18 Aug 2025 14:45:34 +0200
Message-ID: <20250818124519.225549259@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 8c8c5e3c854a2593ec90dacd868f3066b67de1c4 ]

The ringbuf max_entries must be PAGE_ALIGNED. See kernel function
ringbuf_map_alloc(). So for arm64 64KB page size, adjust max_entries
and other related metrics properly.

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20250607013621.1552332-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/ringbuf.c       | 4 ++--
 tools/testing/selftests/bpf/progs/test_ringbuf_write.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/ringbuf.c b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
index da430df45aa4..d1e4cb28a72c 100644
--- a/tools/testing/selftests/bpf/prog_tests/ringbuf.c
+++ b/tools/testing/selftests/bpf/prog_tests/ringbuf.c
@@ -97,7 +97,7 @@ static void ringbuf_write_subtest(void)
 	if (!ASSERT_OK_PTR(skel, "skel_open"))
 		return;
 
-	skel->maps.ringbuf.max_entries = 0x4000;
+	skel->maps.ringbuf.max_entries = 0x40000;
 
 	err = test_ringbuf_write_lskel__load(skel);
 	if (!ASSERT_OK(err, "skel_load"))
@@ -108,7 +108,7 @@ static void ringbuf_write_subtest(void)
 	mmap_ptr = mmap(NULL, page_size, PROT_READ | PROT_WRITE, MAP_SHARED, rb_fd, 0);
 	if (!ASSERT_OK_PTR(mmap_ptr, "rw_cons_pos"))
 		goto cleanup;
-	*mmap_ptr = 0x3000;
+	*mmap_ptr = 0x30000;
 	ASSERT_OK(munmap(mmap_ptr, page_size), "unmap_rw");
 
 	skel->bss->pid = getpid();
diff --git a/tools/testing/selftests/bpf/progs/test_ringbuf_write.c b/tools/testing/selftests/bpf/progs/test_ringbuf_write.c
index 350513c0e4c9..f063a0013f85 100644
--- a/tools/testing/selftests/bpf/progs/test_ringbuf_write.c
+++ b/tools/testing/selftests/bpf/progs/test_ringbuf_write.c
@@ -26,11 +26,11 @@ int test_ringbuf_write(void *ctx)
 	if (cur_pid != pid)
 		return 0;
 
-	sample1 = bpf_ringbuf_reserve(&ringbuf, 0x3000, 0);
+	sample1 = bpf_ringbuf_reserve(&ringbuf, 0x30000, 0);
 	if (!sample1)
 		return 0;
 	/* first one can pass */
-	sample2 = bpf_ringbuf_reserve(&ringbuf, 0x3000, 0);
+	sample2 = bpf_ringbuf_reserve(&ringbuf, 0x30000, 0);
 	if (!sample2) {
 		bpf_ringbuf_discard(sample1, 0);
 		__sync_fetch_and_add(&discarded, 1);
-- 
2.39.5



