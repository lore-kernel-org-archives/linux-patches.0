Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1A626561C;
	Tue,  8 Apr 2025 11:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111445; cv=none; b=uQ/bZKK3XU7dnDJz9EbTAxZRU5ujmXq/MtGRWM0EVlIzGr4W3TGqR/qBdgSFc/1FrDvC33/XWcMHLRwUEf7sbkprULlu5HSe/m099ueiZI8RjBEcJQZ15SHoJLAkhcGD3kEwv61LxjpnVQZ7lEtw5zbZ6ZcHgu9ZAQdPj/X16Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111445; c=relaxed/simple;
	bh=0o8yMFaeyxpmaKPUg6PBm/DcuW6dx2CKcFb10tOwi94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHxgovk3IeM+ujEjjqOd/MA0iNlaBvQYASxXxSPMvpMXyDJoIkEDDVw7XyFdtJK2YeVfk1UpRJXOXuFrYuSXwRNSfUCKO6H/YrGoiGf5gt0YatWgL7CFQ2tvqfjevoovrRCE58r+gj56Nknc4uus6QKwiisNqVwQ1QqWSt6KROA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oN+YMZ51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oN+YMZ51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21ED7C4CEE5;
	Tue,  8 Apr 2025 11:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111445;
	bh=0o8yMFaeyxpmaKPUg6PBm/DcuW6dx2CKcFb10tOwi94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oN+YMZ51MgXu5YGSieeUAbwcbkR/rb7Ps+uSIwLdOF/fzkG9uA7Np9LVa+snqilbd
	 CxoLcPApfAIK+EER6llP1QoV1ymCvrUwuuVKB4LL6Fohey5zB5zX1jzJ/TBU4xZcvR
	 YsI1FzUua2RilUR/4t3eTrf7rJTiamt08Y9zigRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Utku Selen <ali.utku.selen@arm.com>,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 434/731] perf: Always feature test reallocarray
Date: Tue,  8 Apr 2025 12:45:31 +0200
Message-ID: <20250408104924.368275271@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit 4c4c0724d6521a8092b7c16f8f210c5869d95b17 ]

This is also used in util/comm.c now, so instead of selectively doing
the feature test, always do it. If it's ever used anywhere else it's
less likely to cause another build failure.

This doesn't remove the need to manually include libc_compat.h, and
missing that will still cause an error for glibc < 2.26. There isn't a
way to fix that without poisoning reallocarray like libbpf did, but that
has other downsides like making memory debugging tools less useful. So
for Perf keep it like this and we'll have to fix up any missed includes.

Fixes the following build error:

  util/comm.c:152:31: error: implicit declaration of function
                      'reallocarray' [-Wimplicit-function-declaration]
  152 |                         tmp = reallocarray(comm_strs->strs,
      |                               ^~~~~~~~~~~~

Fixes: 13ca628716c6 ("perf comm: Add reference count checking to 'struct comm_str'")
Reported-by: Ali Utku Selen <ali.utku.selen@arm.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250129154405.777533-1-james.clark@linaro.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 10 ++++------
 tools/perf/util/comm.c     |  2 ++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index a148ca9efca91..23dbb6bb91cf8 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -497,13 +497,14 @@ ifeq ($(feature-setns), 1)
   $(call detected,CONFIG_SETNS)
 endif
 
+ifeq ($(feature-reallocarray), 0)
+  CFLAGS += -DCOMPAT_NEED_REALLOCARRAY
+endif
+
 ifdef CORESIGHT
   $(call feature_check,libopencsd)
   ifeq ($(feature-libopencsd), 1)
     CFLAGS += -DHAVE_CSTRACE_SUPPORT $(LIBOPENCSD_CFLAGS)
-    ifeq ($(feature-reallocarray), 0)
-      CFLAGS += -DCOMPAT_NEED_REALLOCARRAY
-    endif
     LDFLAGS += $(LIBOPENCSD_LDFLAGS)
     EXTLIBS += $(OPENCSDLIBS)
     $(call detected,CONFIG_LIBOPENCSD)
@@ -1103,9 +1104,6 @@ ifndef NO_AUXTRACE
   ifndef NO_AUXTRACE
     $(call detected,CONFIG_AUXTRACE)
     CFLAGS += -DHAVE_AUXTRACE_SUPPORT
-    ifeq ($(feature-reallocarray), 0)
-      CFLAGS += -DCOMPAT_NEED_REALLOCARRAY
-    endif
   endif
 endif
 
diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
index 49b79cf0c5cc5..8aa456d7c2cd2 100644
--- a/tools/perf/util/comm.c
+++ b/tools/perf/util/comm.c
@@ -5,6 +5,8 @@
 #include <internal/rc_check.h>
 #include <linux/refcount.h>
 #include <linux/zalloc.h>
+#include <tools/libc_compat.h> // reallocarray
+
 #include "rwsem.h"
 
 DECLARE_RC_STRUCT(comm_str) {
-- 
2.39.5



