Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B583D26B08D;
	Tue,  8 Apr 2025 12:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114692; cv=none; b=lQxejz71XDCS0stvBUQG5j7Jik/YH3yrYeYjISlu6MCPXpo+J3oc6FsqiyX7PvAu92nvsx+Gm608RX7c0GBXXQmbaXoxvNdWamahogyZNGfNf5DDIRWCRDPImaNbw+sgXXfrTLxrnRMUWmqR9r5yB30H+AlTNsgZrhcg0UIDd2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114692; c=relaxed/simple;
	bh=b/XdxDjw/YhFrSoSn+wAy5YMPKNZnVOBTElzwdXKAHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADByL3JhjM4UkTKDIKMWDIdypFiXqcE8wfzmwWd9pt3pm8o6p1CksB8NiJ6sxZONCDbr4bxPDhArVkp2Ktkd/l5lA4bF7fsMqhWo10GCz3ar5DEJFqMIBNwrbZVfU2kssEHxR+QJTVLOdLi7Zu9x8E3cENmT8mOFHzMVoE2M9ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJBqiJ3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJBqiJ3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44235C4CEE5;
	Tue,  8 Apr 2025 12:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114692;
	bh=b/XdxDjw/YhFrSoSn+wAy5YMPKNZnVOBTElzwdXKAHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJBqiJ3rJBNmpCaK8WnoUBUKfI/J+WMtAgPERsokuE0NoLpJRuYsVTEiquv+v2fRN
	 lL4qaCiBKmakvRQwnWgJ4dkpuvFqq24Kd5JyuN19aMlq28BWKBxRi0IrTVnLw59Flc
	 69BbRBH3pIAU8tuCyfcOj1o/jv6g77ouvz9Qd0lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Utku Selen <ali.utku.selen@arm.com>,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 199/499] perf: Always feature test reallocarray
Date: Tue,  8 Apr 2025 12:46:51 +0200
Message-ID: <20250408104856.156927331@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 0e4f6a860ae25..ff4366992e6ae 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -516,13 +516,14 @@ ifeq ($(feature-setns), 1)
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
@@ -1130,9 +1131,6 @@ ifndef NO_AUXTRACE
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



