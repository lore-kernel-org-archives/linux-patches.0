Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D01369D56;
	Sat, 12 Sep 2026 10:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207801; cv=none; b=tCbjKx/zZhhOPFXFqvKdh5r0AAVRuf8gl9COKr+4MHnUYXlE+QLXwEdVRWtqkRYbsxtEtxoZaEQP/6v+BBIXK+24PgL31ZgfJpZGrlQsrhkcaOpqFl7Ww1BRkje3ZnFKN7LFgerWnjiFtjRUow0E6BCjkb4N11EFBxSnvFE/Jao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207801; c=relaxed/simple;
	bh=Y/7i623vZj0m90FitjJE5OPhO9FbHbMJaRq+734nhRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+9VG/9afkAyYKMojaJPXkpyXwUge2vYNGnzadRvk/PKLAA0MQ7dj0CYX29KQKQ0ykNzn8bJPePYhoLw1txJEdVEeX5ijVgUGdImSPWleV40/DV2sKjeRiRpZUvBmPF5mBlK+HvQKMWhiBIG5sCeBWGSZoWzDx21KuHSUaL4X9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZ6Ljeqt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZ6Ljeqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EDC1F000FF;
	Sat, 12 Sep 2026 10:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207799;
	bh=exXh22GHiU0ULMaHohhrgYAQXFhF3MvnlIj4woE4ihE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZ6LjeqtEU1TM/Fgui0ousrxTXnd+/jaEHtyGa8Kj5PqKLB2hqdvUEHvieLskhUuF
	 xnfJKqJW0pvDLehmduf1sL2EjjERjuEBAG0ZG+Vi7gh5XSFZXUgjLZCSAOFAxq/RVq
	 nUgJfq+4Df1/MRW3DWCWRW7vjmA+3wRKTGOiJRXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0487/1518] selftests/bpf: Check malloc result with ASSERT_NEQ in test_sha256
Date: Sat, 12 Sep 2026 08:44:16 +0200
Message-ID: <20260912065634.464746129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



