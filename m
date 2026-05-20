Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE063F4DC0;
	Wed, 20 May 2026 18:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300144; cv=none; b=Lf+np0uuOsGW8poRIl9WIzK1m3iKSWP9dcu6qi0Iz/3c5SYHQ4TO4OW+if5/ZHKW9r1VpPDpd0zpIvlU5dEEEnyIOyMGWE6CAJf1t/7bpEScIjORJSrl9HjD364rquPfPvXJejzAAHN4TaG8IS7WXG/6md5wtX84I+xlrkPNHYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300144; c=relaxed/simple;
	bh=C2WaCv4IOKoZN5bH7+udHP0ZmNzK1iMw+G0GHQX3JwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r4jnirakiLtAmJmLPob8jwT8dJ7i7Ax6ciG4sLrDBEzK5zKzwYVF++KCNjHmn9fwVQD8jyZRgIwTgltatQMZj4pXpSgRPQG1VrazJQpiF7G/0RyTpHCJQyv1MSa3mWOiPQYiyehzeFX7TbkAwjFa0YVM4qVNQ2W7ChpOEQSbfW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHH7xEok; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHH7xEok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5152D1F000E9;
	Wed, 20 May 2026 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300142;
	bh=TJarv0OIExnFpAQIi/KrMTytw1+P/NgYD/zCOFYO91g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHH7xEokAt/N4vwIcnjTV67LFoyRkhx4plYU+ELVbF3LY9jsSobuVMCfT7ESNcajG
	 NsqjR/sLBbl+BFfr3r8Vo3Ikq2aE4w6PXdCoaf8LECGOBDG5JPn+q4VtR/dzMLhHDW
	 rGVdAITdAX0imzZzY4zTIBoQr9Opf4f3va/eJQHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/666] selftests/powerpc: Suppress -Wmaybe-uninitialized with GCC 15
Date: Wed, 20 May 2026 18:14:33 +0200
Message-ID: <20260520162112.577246742@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



