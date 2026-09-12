Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F6129B799;
	Sat, 12 Sep 2026 07:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199391; cv=none; b=XYGk1tP3+K7O8xbPKgEDYPOywMcporQWyu25mAS2AOWMsMnVEQPrdVYCKVag/kWDP04m1Y/c11RQorsHkGO1vTgpzNT94Hf4TtOLoPaTQE+9+RjRLi0Km0Co2cLH7cBx1IwykVHNKHvVnV9SeaMAIOQY1BwHcWSg3lp4AwnyBnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199391; c=relaxed/simple;
	bh=Pe5yQuh8pjWr9L+aVur51oBlcmBerv1Bf++HHiNDWX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W48e9ShjenGuaX/mT9+vgq8+GMEUdoKs4Sj+GpJ9Z0CLmfgOri2AqKieGCq/bTYp2K/3GklVRwRQWQ5Rv5QstRdJby6MIY3MRmvamc6Avi777su4kOnhUtuSdEX1qpXfLjtTZOt8Aex+m7EfZ39YF/eaF40Ld+BU4zB7r9L5YGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sw4rlQI1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sw4rlQI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCAE1F000FF;
	Sat, 12 Sep 2026 07:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199390;
	bh=Agc32GArbnofPQZ+JnBpa/DJpCsL0HeGGrXYOlwd+BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sw4rlQI1Ub32Umxe4GC+l3k+gkG+G6vs9AvejQxEjhATzg1rGJJlqLL5apBIT/0e9
	 lW7CNGEy8j6XvsLRG9eVOnyR65uxtZPnfWQGlUh91PN85n9i426Z02X+OzO91GrpTB
	 Vh6jZ0BNhLTvDwtQK7yANHENoauVof4cg99ED7o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0548/1815] selftests/bpf: Check malloc result with ASSERT_NEQ in test_loader
Date: Sat, 12 Sep 2026 08:38:18 +0200
Message-ID: <20260912065701.749032878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viktor Malik <vmalik@redhat.com>

[ Upstream commit 40f986aed81ff4d137ec101c6babbbc642690eac ]

Replace ASSERT_OK_PTR by ASSERT_NEQ(res, NULL, ...) when checking the
result of malloc. It is more accurate since malloc returns NULL, not an
error code, on failure and it also prevents the following false GCC
warning when compiling BPF selftests with -O2:

    In file included from test_loader.c:6:
    test_loader.c: In function ‘verify_stderr’:
    /bpf-next/tools/testing/selftests/bpf/test_progs.h:393:22: error: ‘buf’ may be used uninitialized [-Werror=maybe-uninitialized]
      393 |         int ___err = libbpf_get_error(___res);                          \
          |                      ^~~~~~~~~~~~~~~~~~~~~~~~
    test_loader.c:810:14: note: in expansion of macro ‘ASSERT_OK_PTR’
      810 |         if (!ASSERT_OK_PTR(buf, "malloc"))
          |              ^~~~~~~~~~~~~
    In file included from /bpf-next/tools/testing/selftests/bpf/tools/include/bpf/bpf.h:32,
                     from /bpf-next/tools/testing/selftests/bpf/test_progs.h:37:
    /bpf-next/tools/testing/selftests/bpf/tools/include/bpf/libbpf_legacy.h:113:17: note: by argument 1 of type ‘const void *’ to ‘libbpf_get_error’ declared here
      113 | LIBBPF_API long libbpf_get_error(const void *ptr);
          |                 ^~~~~~~~~~~~~~~~

Fixes: 554e4eb9e4b7 ("selftests/bpf: Reuse stderr parsing for libarena ASAN tests")
Signed-off-by: Viktor Malik <vmalik@redhat.com>
Link: https://lore.kernel.org/bpf/e25d50805fbcb3632f24b488568ab5ba49b82094.1784112948.git.vmalik@redhat.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_loader.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/test_loader.c b/tools/testing/selftests/bpf/test_loader.c
index 3ce32d134e2cc..07807757b518d 100644
--- a/tools/testing/selftests/bpf/test_loader.c
+++ b/tools/testing/selftests/bpf/test_loader.c
@@ -807,7 +807,7 @@ static void verify_stderr(int prog_fd, struct expected_msgs *msgs)
 		return;
 
 	buf = malloc(TEST_LOADER_LOG_BUF_SZ);
-	if (!ASSERT_OK_PTR(buf, "malloc"))
+	if (!ASSERT_NEQ(buf, NULL, "malloc"))
 		return;
 
 	ret = bpf_prog_stream_read(prog_fd, 2, buf, TEST_LOADER_LOG_BUF_SZ - 1,
-- 
2.53.0



