Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34939346ADC;
	Sat, 12 Sep 2026 07:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199445; cv=none; b=Deagv5DBMoTzbvOlxDo5eD4qCcHSC8pN0JObKLjzzPf8buTDaxzgx0hIHSRA67XaeSHDHhB8f70G9B224gf+AIVAcOVFYUDVyKGHnyfAbMTbRi9trOTVmSwDh1oxUOckxSP2U8zXcgPYniaMBIvLzBb5UYzEysGdjXUukJStr/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199445; c=relaxed/simple;
	bh=m9SxQ2/Hbqp4TXc3ZB6d3C7vyGm0xNNZgtS+HK/yNT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GQn2rMe8W03kb17kvyUNJI1awR9eN2G9rc6RCrOrhu1e7Ewo1Y4NSPmI1wyi3K51P/lxN33o6BdZIr4srDBcbKF/nfATlMp49KgUEvp/l2uO01CJ9uJhx+ilktncr/TOY7jF9ZN0FJhhr3IZ6ZTOyQ9GpYWL+FPw0CTui/2AduA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZ8/2WON; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZ8/2WON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09EF1F000FF;
	Sat, 12 Sep 2026 07:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199443;
	bh=8m8QWkERbJEZM+vl7oQx2YpJx6/+Hv+uo9gGRGlbDRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SZ8/2WONVoTqax/CvOrwkXrYi/sq37XDI65qWAK0ZYjevNMU+6cTtq78M+J4CXift
	 8pHykoPip/A52jVcUBWKVJUabToq/DFuC9x1teHfnYdWDqvkDIgDEJTSOAi4OYKigJ
	 gyeQ/vPHHZ4uOiDfLBjmkOog2O6+G/cM+/VVx2Yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0549/1815] selftests/bpf: Check malloc result with ASSERT_NEQ in test_sha256
Date: Sat, 12 Sep 2026 08:38:19 +0200
Message-ID: <20260912065701.772131739@linuxfoundation.org>
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

[ Upstream commit eb5cd154f174f42079a45f4bd7ee8bc20f2ba6f3 ]

Replace ASSERT_OK_PTR by ASSERT_NEQ(res, NULL, ...) when checking the
result of malloc. It is more accurate since malloc returns NULL, not an
error code, on failure and it also prevents the following false GCC
warning when compiling BPF selftests with -O2:

    In file included from /bpf-next/tools/testing/selftests/bpf/prog_tests/sha256.c:4:
    /bpf-next/tools/testing/selftests/bpf/prog_tests/sha256.c: In function ‘test_sha256’:
    ./test_progs.h:393:22: error: ‘data’ may be used uninitialized [-Werror=maybe-uninitialized]
      393 |         int ___err = libbpf_get_error(___res);                          \
          |                      ^~~~~~~~~~~~~~~~~~~~~~~~
    /bpf-next/tools/testing/selftests/bpf/prog_tests/sha256.c:28:14: note: in expansion of macro ‘ASSERT_OK_PTR’
       28 |         if (!ASSERT_OK_PTR(data, "malloc"))
          |              ^~~~~~~~~~~~~
    In file included from /bpf-next/tools/testing/selftests/bpf/tools/include/bpf/bpf.h:32,
                     from ./test_progs.h:37:
    /bpf-next/tools/testing/selftests/bpf/tools/include/bpf/libbpf_legacy.h:113:17: note: by argument 1 of type ‘const void *’ to ‘libbpf_get_error’ declared here
      113 | LIBBPF_API long libbpf_get_error(const void *ptr);
          |                 ^~~~~~~~~~~~~~~~

Fixes: f09f57c74677 ("selftests/bpf: Add test for libbpf_sha256()")
Signed-off-by: Viktor Malik <vmalik@redhat.com>
Link: https://lore.kernel.org/bpf/f9dec09cca0c2aa5eeb4fdcd400a13aa19e2c073.1784112948.git.vmalik@redhat.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/sha256.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sha256.c b/tools/testing/selftests/bpf/prog_tests/sha256.c
index 604a0b1423d55..5edbc6194b071 100644
--- a/tools/testing/selftests/bpf/prog_tests/sha256.c
+++ b/tools/testing/selftests/bpf/prog_tests/sha256.c
@@ -25,10 +25,10 @@ void test_sha256(void)
 	size_t i;
 
 	data = malloc(MAX_LEN);
-	if (!ASSERT_OK_PTR(data, "malloc"))
+	if (!ASSERT_NEQ(data, NULL, "malloc"))
 		goto out;
 	digests = malloc((MAX_LEN + 1) * SHA256_DIGEST_LENGTH);
-	if (!ASSERT_OK_PTR(digests, "malloc"))
+	if (!ASSERT_NEQ(digests, NULL, "malloc"))
 		goto out;
 
 	/* Generate MAX_LEN bytes of "random" data deterministically. */
-- 
2.53.0



