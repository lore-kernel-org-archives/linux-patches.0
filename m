Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49461C461D;
	Tue, 27 Aug 2024 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770995; cv=none; b=W8dFlqqz71crUrshoSQ6WlZu2TiqTBkVNJqM+nLx+qSmyCh7URc0qqCaVwRQTu5SugYZ54BKyC/Uo0hy7JE4OOnCvDl+BaLk/9uIhhTJEbVZUHGPyxUWRGPvScs1UE9Jx/dfeABV0IQNfjcmkfjfxb7qsSOfqRCG4oHBB3ezjFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770995; c=relaxed/simple;
	bh=7CSw1BxQgaWjO9gs5/GqguSNbhNk2n1qavc8j34PIFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mt2zqeAcUmgUh8mnsGntPiqjTfiyiat2hiAtwgv+1V1X/YmDUcTP/ySSZE7n2KQ/vb3htSuO+J0UdT342eX/AkgdFdjw9UyPhiaj+qIJhdfk/XJ53dpdoaBXjXh/gpIWN4OHlyQAJLhe/ltd98/mTpVQyQbK2bChptCb9vZ9uiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7PP5r8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7PP5r8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF62C61049;
	Tue, 27 Aug 2024 15:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770995;
	bh=7CSw1BxQgaWjO9gs5/GqguSNbhNk2n1qavc8j34PIFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7PP5r8y9dyl7fRknuubnq6HjvuVG+Vinbxc/dYZ4HfvysjISGAvn5zhihY63T6Ct
	 7vRzAl9GnsC4TJJbpkPL98uf3dL/sMMmJZZY0LLWKl9zqkiL5jzZa4h0Sk6QFDTKTn
	 aQdo3MTaANUETLeyeQANQGM2YIzWzgFYtODpxUr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 055/273] selftests: memfd_secret: dont build memfd_secret test on unsupported arches
Date: Tue, 27 Aug 2024 16:36:19 +0200
Message-ID: <20240827143835.495019465@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit 7c5e8d212d7d81991a580e7de3904ea213d9a852 upstream.

[1] mentions that memfd_secret is only supported on arm64, riscv, x86 and
x86_64 for now.  It doesn't support other architectures.  I found the
build error on arm and decided to send the fix as it was creating noise on
KernelCI:

memfd_secret.c: In function 'memfd_secret':
memfd_secret.c:42:24: error: '__NR_memfd_secret' undeclared (first use in this function);
did you mean 'memfd_secret'?
   42 |         return syscall(__NR_memfd_secret, flags);
      |                        ^~~~~~~~~~~~~~~~~
      |                        memfd_secret

Hence I'm adding condition that memfd_secret should only be compiled on
supported architectures.

Also check in run_vmtests script if memfd_secret binary is present before
executing it.

Link: https://lkml.kernel.org/r/20240812061522.1933054-1-usama.anjum@collabora.com
Link: https://lore.kernel.org/all/20210518072034.31572-7-rppt@kernel.org/ [1]
Link: https://lkml.kernel.org/r/20240809075642.403247-1-usama.anjum@collabora.com
Fixes: 76fe17ef588a ("secretmem: test: add basic selftest for memfd_secret(2)")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/mm/Makefile       |    2 ++
 tools/testing/selftests/mm/run_vmtests.sh |    3 +++
 2 files changed, 5 insertions(+)

--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -51,7 +51,9 @@ TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_hugetlb
 TEST_GEN_FILES += map_populate
+ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64))
 TEST_GEN_FILES += memfd_secret
+endif
 TEST_GEN_FILES += migration
 TEST_GEN_FILES += mkdirty
 TEST_GEN_FILES += mlock-random-test
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -367,8 +367,11 @@ CATEGORY="hmm" run_test bash ./test_hmm.
 # MADV_POPULATE_READ and MADV_POPULATE_WRITE tests
 CATEGORY="madv_populate" run_test ./madv_populate
 
+if [ -x ./memfd_secret ]
+then
 (echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope 2>&1) | tap_prefix
 CATEGORY="memfd_secret" run_test ./memfd_secret
+fi
 
 # KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
 CATEGORY="ksm" run_test ./ksm_tests -H -s 100


