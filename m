Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD4E171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECCEC433C7;
	Wed,  9 Aug 2023 11:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578899;
	bh=Ye3ys9UcDM6pMksK+MRq0l+vVAWGIT5xFw4fgsIyerM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMPG19Oh8MAZ7loyjtan6BCjUI8r6FrLOZbwSl6V3I/8PUUKsk23ZeHPZjmm+DLd2
	 vhp4/oaIEHd344SqGoVJKqOPo53hsVll+rjaUC7LvTOktJPLo5iYnkDdG3rrGLPdkt
	 tMXy9gFd0Kr0kyHyhQxo7ezS7Bg/VY2cOE01mRsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Lewis <aaronlewis@google.com>,
	kvm@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 88/92] selftests/rseq: Play nice with binaries statically linked against glibc 2.35+
Date: Wed,  9 Aug 2023 12:42:04 +0200
Message-ID: <20230809103636.574162524@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 3bcbc20942db5d738221cca31a928efc09827069 ]

To allow running rseq and KVM's rseq selftests as statically linked
binaries, initialize the various "trampoline" pointers to point directly
at the expect glibc symbols, and skip the dlysm() lookups if the rseq
size is non-zero, i.e. the binary is statically linked *and* the libc
registered its own rseq.

Define weak versions of the symbols so as not to break linking against
libc versions that don't support rseq in any capacity.

The KVM selftests in particular are often statically linked so that they
can be run on targets with very limited runtime environments, i.e. test
machines.

Fixes: 233e667e1ae3 ("selftests/rseq: Uplift rseq selftests for compatibility with glibc-2.35")
Cc: Aaron Lewis <aaronlewis@google.com>
Cc: kvm@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230721223352.2333911-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rseq/rseq.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/rseq/rseq.c b/tools/testing/selftests/rseq/rseq.c
index 4177f9507bbee..b736a5169aad0 100644
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -32,9 +32,17 @@
 #include "../kselftest.h"
 #include "rseq.h"
 
-static const ptrdiff_t *libc_rseq_offset_p;
-static const unsigned int *libc_rseq_size_p;
-static const unsigned int *libc_rseq_flags_p;
+/*
+ * Define weak versions to play nice with binaries that are statically linked
+ * against a libc that doesn't support registering its own rseq.
+ */
+__weak ptrdiff_t __rseq_offset;
+__weak unsigned int __rseq_size;
+__weak unsigned int __rseq_flags;
+
+static const ptrdiff_t *libc_rseq_offset_p = &__rseq_offset;
+static const unsigned int *libc_rseq_size_p = &__rseq_size;
+static const unsigned int *libc_rseq_flags_p = &__rseq_flags;
 
 /* Offset from the thread pointer to the rseq area.  */
 ptrdiff_t rseq_offset;
@@ -108,9 +116,17 @@ int rseq_unregister_current_thread(void)
 static __attribute__((constructor))
 void rseq_init(void)
 {
-	libc_rseq_offset_p = dlsym(RTLD_NEXT, "__rseq_offset");
-	libc_rseq_size_p = dlsym(RTLD_NEXT, "__rseq_size");
-	libc_rseq_flags_p = dlsym(RTLD_NEXT, "__rseq_flags");
+	/*
+	 * If the libc's registered rseq size isn't already valid, it may be
+	 * because the binary is dynamically linked and not necessarily due to
+	 * libc not having registered a restartable sequence.  Try to find the
+	 * symbols if that's the case.
+	 */
+	if (!*libc_rseq_size_p) {
+		libc_rseq_offset_p = dlsym(RTLD_NEXT, "__rseq_offset");
+		libc_rseq_size_p = dlsym(RTLD_NEXT, "__rseq_size");
+		libc_rseq_flags_p = dlsym(RTLD_NEXT, "__rseq_flags");
+	}
 	if (libc_rseq_size_p && libc_rseq_offset_p && libc_rseq_flags_p &&
 			*libc_rseq_size_p != 0) {
 		/* rseq registration owned by glibc */
-- 
2.40.1



