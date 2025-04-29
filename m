Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D7324A067;
	Tue, 29 Apr 2025 17:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946209; cv=none; b=Xt+HALn2YqH0EvU+WI/gfXFNz+9ppVabv+2ItF3STw8kyclP0Bg0N46CrB6eYorFuDS1lqzp3LveSJcOclpqc7TFxZfmJ8eXWBimEiN+WE7iP43Ss/+4vNVNMNBTLU3/byq0+00+EHPKoGPZ+gqwVqaNQtz1dtmhALEIFTiGuWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946209; c=relaxed/simple;
	bh=iC5NHaktYZXz3m3MWgW+V27BmjZ4D65YrPmJJI0xl4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7gfWOsG0gTxTLuToK8JIB8MskCzz+uaNkrXVudjujk+1eyIy23JjCtu1jBmbNjoB5e7sGO6CnX7Wy9/e8jleFS+743Cg9EnKNfZRUOfXqmp5Tlc1mzaCCRfrrmF/eHSpbU8+oaFYHEKpXD9K+JnDOO6dkphAt9Dh1DtWig1U/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6bFDvzN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6bFDvzN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632B8C4CEE3;
	Tue, 29 Apr 2025 17:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946209;
	bh=iC5NHaktYZXz3m3MWgW+V27BmjZ4D65YrPmJJI0xl4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6bFDvzNXBMetHXAB+n2OXTpHGKVgZa345FB8aWURJ/2mC/w/kgJALiD82WF0IXjH
	 hqXO8P9X+29lrhEO6D/ddCuwPLoMm8ddoIFb9WLK7kz+whajW5ByexdPmaYT72hzAq
	 MPBLD9A1ddGo7IWjvx7xegsOMAQzGAz6bCSIxvtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 192/311] selftests/bpf: Fix cap_enable_effective() return code
Date: Tue, 29 Apr 2025 18:40:29 +0200
Message-ID: <20250429161128.877900046@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Yang <yangfeng@kylinos.cn>

[ Upstream commit 339c1f8ea11cc042c30c315c1a8f61e4b8a90117 ]

The caller of cap_enable_effective() expects negative error code.
Fix it.

Before:
  failed to restore CAP_SYS_ADMIN: -1, Unknown error -1

After:
  failed to restore CAP_SYS_ADMIN: -3, No such process
  failed to restore CAP_SYS_ADMIN: -22, Invalid argument

Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20250305022234.44932-1-yangfeng59949@163.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/cap_helpers.c         | 8 ++++----
 tools/testing/selftests/bpf/cap_helpers.h         | 1 +
 tools/testing/selftests/bpf/prog_tests/verifier.c | 4 ++--
 tools/testing/selftests/bpf/test_loader.c         | 6 +++---
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/cap_helpers.c b/tools/testing/selftests/bpf/cap_helpers.c
index d5ac507401d7c..98f840c3a38f7 100644
--- a/tools/testing/selftests/bpf/cap_helpers.c
+++ b/tools/testing/selftests/bpf/cap_helpers.c
@@ -19,7 +19,7 @@ int cap_enable_effective(__u64 caps, __u64 *old_caps)
 
 	err = capget(&hdr, data);
 	if (err)
-		return err;
+		return -errno;
 
 	if (old_caps)
 		*old_caps = (__u64)(data[1].effective) << 32 | data[0].effective;
@@ -32,7 +32,7 @@ int cap_enable_effective(__u64 caps, __u64 *old_caps)
 	data[1].effective |= cap1;
 	err = capset(&hdr, data);
 	if (err)
-		return err;
+		return -errno;
 
 	return 0;
 }
@@ -49,7 +49,7 @@ int cap_disable_effective(__u64 caps, __u64 *old_caps)
 
 	err = capget(&hdr, data);
 	if (err)
-		return err;
+		return -errno;
 
 	if (old_caps)
 		*old_caps = (__u64)(data[1].effective) << 32 | data[0].effective;
@@ -61,7 +61,7 @@ int cap_disable_effective(__u64 caps, __u64 *old_caps)
 	data[1].effective &= ~cap1;
 	err = capset(&hdr, data);
 	if (err)
-		return err;
+		return -errno;
 
 	return 0;
 }
diff --git a/tools/testing/selftests/bpf/cap_helpers.h b/tools/testing/selftests/bpf/cap_helpers.h
index 6d163530cb0fd..8dcb28557f762 100644
--- a/tools/testing/selftests/bpf/cap_helpers.h
+++ b/tools/testing/selftests/bpf/cap_helpers.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/capability.h>
+#include <errno.h>
 
 #ifndef CAP_PERFMON
 #define CAP_PERFMON		38
diff --git a/tools/testing/selftests/bpf/prog_tests/verifier.c b/tools/testing/selftests/bpf/prog_tests/verifier.c
index 8a0e1ff8a2dc6..ecc320e045513 100644
--- a/tools/testing/selftests/bpf/prog_tests/verifier.c
+++ b/tools/testing/selftests/bpf/prog_tests/verifier.c
@@ -121,7 +121,7 @@ static void run_tests_aux(const char *skel_name,
 	/* test_verifier tests are executed w/o CAP_SYS_ADMIN, do the same here */
 	err = cap_disable_effective(1ULL << CAP_SYS_ADMIN, &old_caps);
 	if (err) {
-		PRINT_FAIL("failed to drop CAP_SYS_ADMIN: %i, %s\n", err, strerror(err));
+		PRINT_FAIL("failed to drop CAP_SYS_ADMIN: %i, %s\n", err, strerror(-err));
 		return;
 	}
 
@@ -131,7 +131,7 @@ static void run_tests_aux(const char *skel_name,
 
 	err = cap_enable_effective(old_caps, NULL);
 	if (err)
-		PRINT_FAIL("failed to restore CAP_SYS_ADMIN: %i, %s\n", err, strerror(err));
+		PRINT_FAIL("failed to restore CAP_SYS_ADMIN: %i, %s\n", err, strerror(-err));
 }
 
 #define RUN(skel) run_tests_aux(#skel, skel##__elf_bytes, NULL)
diff --git a/tools/testing/selftests/bpf/test_loader.c b/tools/testing/selftests/bpf/test_loader.c
index 53b06647cf57d..8a403e5aa3145 100644
--- a/tools/testing/selftests/bpf/test_loader.c
+++ b/tools/testing/selftests/bpf/test_loader.c
@@ -773,7 +773,7 @@ static int drop_capabilities(struct cap_state *caps)
 
 	err = cap_disable_effective(caps_to_drop, &caps->old_caps);
 	if (err) {
-		PRINT_FAIL("failed to drop capabilities: %i, %s\n", err, strerror(err));
+		PRINT_FAIL("failed to drop capabilities: %i, %s\n", err, strerror(-err));
 		return err;
 	}
 
@@ -790,7 +790,7 @@ static int restore_capabilities(struct cap_state *caps)
 
 	err = cap_enable_effective(caps->old_caps, NULL);
 	if (err)
-		PRINT_FAIL("failed to restore capabilities: %i, %s\n", err, strerror(err));
+		PRINT_FAIL("failed to restore capabilities: %i, %s\n", err, strerror(-err));
 	caps->initialized = false;
 	return err;
 }
@@ -959,7 +959,7 @@ void run_subtest(struct test_loader *tester,
 		if (subspec->caps) {
 			err = cap_enable_effective(subspec->caps, NULL);
 			if (err) {
-				PRINT_FAIL("failed to set capabilities: %i, %s\n", err, strerror(err));
+				PRINT_FAIL("failed to set capabilities: %i, %s\n", err, strerror(-err));
 				goto subtest_cleanup;
 			}
 		}
-- 
2.39.5



