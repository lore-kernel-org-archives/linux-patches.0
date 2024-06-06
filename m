Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC76197550;
	Thu,  6 Jun 2024 14:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682990; cv=none; b=NuDqb0QNWgMV6+UUAZWdgdW0n6KET9hf1EKarnrIjlcuQUSjfAz3J0hViEXV73WjVw6VLqiZznsXGxAarA1tzAAjt2dXlP7tlIt6X5wGU2j3BJtrVd9FfoiuJvN6jLf3hgRedwQJDzb5NWl7FZQXRJIgiPoXqOiBKizh5L53dt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682990; c=relaxed/simple;
	bh=VTB6bOM3mPXfr7iZWF239gduhP719CXdACQL0CMiamw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIq5adMfb8p2ajAJigi+SMTJEg9HoZ0v13HUAFWa9vDIGqu1Y2+iyfaJv36quDTgkfrZ9uaO05fEaiJFE7Dxt3xb6XKXzZ29Zo3p6QedYFPtnj3OjaXrxXR3hdI0Ule/73LS7hpWIZeiEjQQ0SQ0IcTqrb+auLOc4IHIjUU+75E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYGGwGIX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYGGwGIX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5750C32782;
	Thu,  6 Jun 2024 14:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682990;
	bh=VTB6bOM3mPXfr7iZWF239gduhP719CXdACQL0CMiamw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYGGwGIXZ/iDbVXlGiRXEIeOgeKyaCS3ZxRwHT3EzkXJL0dXCZf2FWwdnoJndpgqi
	 sSGKFhdzOM5JCcZreU81AMzoTc4uEExDW0SDN0bi8OKxQfFRPqMTfchDnucPT/dSP/
	 QAF1Us+gV4p5pBDdNe6u3tI3Zao3X9V3d+r+regQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Su <tao1.su@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Bongsu Jeon <bongsu.jeon@samsung.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Edward Liaw <edliaw@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Mark Brown <broonie@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Takashi Iwai <tiwai@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 141/374] Revert "selftests/harness: remove use of LINE_MAX"
Date: Thu,  6 Jun 2024 16:02:00 +0200
Message-ID: <20240606131656.629491491@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Su <tao1.su@linux.intel.com>

[ Upstream commit 6bb955fce08cbc8495a72755130d2d220994faee ]

Patch series "Selftests: Fix compilation warnings due to missing
_GNU_SOURCE definition", v2.

Since kselftest_harness.h introduces asprintf()[1], many selftests have
compilation warnings or errors due to missing _GNU_SOURCE definitions.

The issue stems from a lack of a LINE_MAX definition in Android (see
commit 38c957f07038), which is the reason why asprintf() was introduced.
We tried adding _GNU_SOURCE definitions to more selftests to fix, but
asprintf() may continue to cause problems, and since it is quite late in
the 6.9 cycle, we would like to revert 809216233555 first to provide
testing for forks[2].

[1] https://lore.kernel.org/all/20240411231954.62156-1-edliaw@google.com
[2] https://lore.kernel.org/linux-kselftest/ZjuA3aY_iHkjP7bQ@google.com

This patch (of 2):

This reverts commit 8092162335554c8ef5e7f50eff68aa9cfbdbf865.

asprintf() is declared in stdio.h when defining _GNU_SOURCE, but stdio.h
is so common that many files don't define _GNU_SOURCE before including
stdio.h, and defining _GNU_SOURCE after including stdio.h will no longer
take effect, which causes warnings or even errors during compilation in
many selftests.

Revert 'commit 809216233555 ("selftests/harness: remove use of LINE_MAX")'
as that came in quite late in the 6.9 cycle.

Link: https://lkml.kernel.org/r/20240509053113.43462-1-tao1.su@linux.intel.com
Link: https://lore.kernel.org/linux-kselftest/ZjuA3aY_iHkjP7bQ@google.com/
Link: https://lkml.kernel.org/r/20240509053113.43462-2-tao1.su@linux.intel.com
Fixes: 809216233555 ("selftests/harness: remove use of LINE_MAX")
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Edward Liaw <edliaw@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 12 ++++--------
 tools/testing/selftests/mm/mdwe_test.c      |  1 -
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 3c8f2965c2850..e8d79e0210831 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -56,6 +56,7 @@
 #include <asm/types.h>
 #include <ctype.h>
 #include <errno.h>
+#include <limits.h>
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
@@ -1216,7 +1217,7 @@ void __run_test(struct __fixture_metadata *f,
 		struct __test_metadata *t)
 {
 	struct __test_xfail *xfail;
-	char *test_name;
+	char test_name[LINE_MAX];
 	const char *diagnostic;
 
 	/* reset test struct */
@@ -1227,12 +1228,8 @@ void __run_test(struct __fixture_metadata *f,
 	memset(t->env, 0, sizeof(t->env));
 	memset(t->results->reason, 0, sizeof(t->results->reason));
 
-	if (asprintf(&test_name, "%s%s%s.%s", f->name,
-		variant->name[0] ? "." : "", variant->name, t->name) == -1) {
-		ksft_print_msg("ERROR ALLOCATING MEMORY\n");
-		t->exit_code = KSFT_FAIL;
-		_exit(t->exit_code);
-	}
+	snprintf(test_name, sizeof(test_name), "%s%s%s.%s",
+		 f->name, variant->name[0] ? "." : "", variant->name, t->name);
 
 	ksft_print_msg(" RUN           %s ...\n", test_name);
 
@@ -1270,7 +1267,6 @@ void __run_test(struct __fixture_metadata *f,
 
 	ksft_test_result_code(t->exit_code, test_name,
 			      diagnostic ? "%s" : NULL, diagnostic);
-	free(test_name);
 }
 
 static int test_harness_run(int argc, char **argv)
diff --git a/tools/testing/selftests/mm/mdwe_test.c b/tools/testing/selftests/mm/mdwe_test.c
index 1e01d3ddc11c5..200bedcdc32e9 100644
--- a/tools/testing/selftests/mm/mdwe_test.c
+++ b/tools/testing/selftests/mm/mdwe_test.c
@@ -7,7 +7,6 @@
 #include <linux/mman.h>
 #include <linux/prctl.h>
 
-#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <sys/auxv.h>
-- 
2.43.0



