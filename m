Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D31369999;
	Wed, 20 May 2026 17:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297670; cv=none; b=OhmPn7MT41KTrmCQkLc86v1im7v8yEpeoiyhcN76eYd44Xy9XXlTPbv3xUFFiqUuC9DLQt8C+z1ZLRMF1DeazRv99yN9xc20PHo4hoDjG3oihygEQb88DVlqX8HBmvUKIAkjH8l60yipgjx5xlB3btQBPAF+m8vZuY5ixIMMLog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297670; c=relaxed/simple;
	bh=+L8af0L9BDKgrfU8BX5Bag88NIKpoGEGxIXvJ3Bxcjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nRWIpplHskrdt7V5EyGzpmC40tQYztTIzJdACZ0AhYkSk/4aPH4JLAMDeNifryp1dEIdeKwq6gixW5OmCMMyty/nn4QX5Ot2d5qAXVViI/moAFfAFkjAlcC7n+aKuEiktvsdd5bAhLY0WAUCMO0gR4jcDqmYIB+uYjRrgJpPiYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dvgqE2Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dvgqE2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2B81F000E9;
	Wed, 20 May 2026 17:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297669;
	bh=uEd2KCp5WH6AVJ1uMETXbgZ5FKHCsIudCjv62mTvVHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0dvgqE2QGe6FfNNEoGg5iYge6ooZE3t8rve8Ed68sej+4y6pp+ZtL0WtMYF6fmI4R
	 ihFDLtoysRQRmyOv+2zR5E+YQCUQi5UdCzZXcfV4fAEUV5of7WSnetUMfTmPYVzZcz
	 TEJ7MZitqRa9sUpKyMwtY0/fmG6rz53fQUj5FGFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 118/957] selftests/powerpc: Suppress -Wmaybe-uninitialized with GCC 15
Date: Wed, 20 May 2026 18:10:01 +0200
Message-ID: <20260520162137.119427196@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Amit Machhiwal <amachhiw@linux.ibm.com>

[ Upstream commit 6e65886fceb23605eff952d6b1975737b4c4b154 ]

GCC 15 reports the below false positive '-Wmaybe-uninitialized' warning
in vphn_unpack_associativity() when building the powerpc selftests.

  # make -C tools/testing/selftests TARGETS="powerpc"
  [...]
    CC       test-vphn
  In file included from test-vphn.c:3:
  In function ‘vphn_unpack_associativity’,
      inlined from ‘test_one’ at test-vphn.c:371:2,
      inlined from ‘test_vphn’ at test-vphn.c:399:9:
  test-vphn.c:10:33: error: ‘be_packed’ may be used uninitialized [-Werror=maybe-uninitialized]
     10 | #define be16_to_cpup(x)         bswap_16(*x)
        |                                 ^~~~~~~~
  vphn.c:42:27: note: in expansion of macro ‘be16_to_cpup’
     42 |                 u16 new = be16_to_cpup(field++);
        |                           ^~~~~~~~~~~~
  In file included from test-vphn.c:19:
  vphn.c: In function ‘test_vphn’:
  vphn.c:27:16: note: ‘be_packed’ declared here
     27 |         __be64 be_packed[VPHN_REGISTER_COUNT];
        |                ^~~~~~~~~
  cc1: all warnings being treated as errors

When vphn_unpack_associativity() is called from hcall_vphn() in kernel
the error is not seen while building vphn.c during kernel compilation.
This is because the top level Makefile includes '-fno-strict-aliasing'
flag always.

The issue here is that GCC 15 emits '-Wmaybe-uninitialized' due to type
punning between __be64[] and __b16* when accessing the buffer via
be16_to_cpup(). The underlying object is fully initialized but GCC 15
fails to track the aliasing due to the strict aliasing violation here.
Please refer [1] and [2]. This results in a false positive warning which
is promoted to an error under '-Werror'. This problem is not seen when
the compilation is performed with GCC 13 and 14. An issue [1] has also
been created on GCC bugzilla.

The selftest compiles fine with '-fno-strict-aliasing'. Since this GCC
flag is used to compile vphn.c in kernel too, the same flag should be
used to build vphn tests when compiling vphn.c in the selftest as well.

Fix this by including '-fno-strict-aliasing' during vphn.c compilation
in the selftest. This keeps the build working while limiting the scope
of the suppression to building vphn tests.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124427
[2] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99768

Fixes: 58dae82843f5 ("selftests/powerpc: Add test for VPHN")
Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260313165426.43259-1-amachhiw@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/vphn/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/vphn/Makefile b/tools/testing/selftests/powerpc/vphn/Makefile
index 61d519a076c6f..778fc396340db 100644
--- a/tools/testing/selftests/powerpc/vphn/Makefile
+++ b/tools/testing/selftests/powerpc/vphn/Makefile
@@ -5,7 +5,7 @@ top_srcdir = ../../../../..
 include ../../lib.mk
 include ../flags.mk
 
-CFLAGS += -m64 -I$(CURDIR)
+CFLAGS += -m64 -I$(CURDIR) -fno-strict-aliasing
 
 $(TEST_GEN_PROGS): ../harness.c
 
-- 
2.53.0



