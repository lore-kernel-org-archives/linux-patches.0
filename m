Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972613033E7;
	Wed, 20 May 2026 16:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294718; cv=none; b=a2hKEop5UebabxMKxAridrOYEi4sTkOWhkCZETIFDjsgosJGgVARamIkeUzYdGJbfp71j1+abQ4Pl7m5aQbd9yLfYZtHencx+vNrX0IMiFq6E6axNNTtSt/rIz3vsHKae6mnwXTlYpNrIBy53FWfE8E5YBZpZNjXSI2/IApiG/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294718; c=relaxed/simple;
	bh=EQ9OF0R/ftZCMD03X0cN0u4AbIC3ODZvEoFHVc+IDwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QpJyvpGNuRJ3sfYc1dUjJMGs3Nud5P6Y8L3Dgqciwcgsrj/u8E9KuT1oamzHJ5SvMtlTxhdKWMKKhXVecNLe7Foj1RVMiK5p/LHXJVBwpMjTfj+/OyBG6x+t2Urqe38hr9lW8CTwNYhNRE1QSElj93WHeylr9t+9Q2wRoq+Dqdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f91Co+hv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f91Co+hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D200A1F00894;
	Wed, 20 May 2026 16:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294716;
	bh=j2qk4OByQJduUt1n2R2E1m9/pWBWQIz440MZ4DY9F5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f91Co+hv+zEdhNBTg7AZYIn9L3ky7qSZIxQak22uOd07opCZ85EC5mbcP1jQi58Dw
	 HptigzWMCpXBcGme0oYEC4cGYES/Ga/GLX8GolqOzN6wOIP63NHxRxohMcQbmAzu2L
	 ZQ03kcZ5R4G4lkVPjVr2Zjo5LK8yCz7ifC6pkAkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0145/1146] selftests/powerpc: Suppress -Wmaybe-uninitialized with GCC 15
Date: Wed, 20 May 2026 18:06:35 +0200
Message-ID: <20260520162151.589606442@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



