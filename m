Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A27AA153800;
	Tue,  3 Dec 2024 16:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241758; cv=none; b=i1IlCzQLLOfkLCN1zwvje8j6OmtgZ1e6xd81hRFD3z5nbtYGpL2mg/mDpR0wuC+5xhw2u3gaM5DzKXfV3zhqSnh/AXkgGUimNXNCSBIotKUwUjQ2aXRQQtOZLmwGS68FOwxykFb3QuCxGIqT8sjcBwXQsDq6quKR4llNJ4YGTFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241758; c=relaxed/simple;
	bh=jK71MPsxSoIpJ2AGEUzq8m43sTmfiO73Mhzc50GtsuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVIiXZkYKiItF1L6P9OElD6rdaaLLB0eOuhrz8X6U4sjpHrJlaGP791lepfPE2lTW+ipU2m8kW7OiKbnMZlwjAS3XI0VBxw23pFhcG1rbJVMfVDp8HURkIYcPcMYaCORm3ZX3sE6YgZ1qkNIRf0eq3Ech27va/pPccis+ht/3us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVDnQ6+C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVDnQ6+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266FFC4CECF;
	Tue,  3 Dec 2024 16:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241758;
	bh=jK71MPsxSoIpJ2AGEUzq8m43sTmfiO73Mhzc50GtsuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVDnQ6+CThOjkuWktWFiTstH4DKhydQgPU5dCW6jiaGd+yFQ4SPe6jGloAKOrEPxO
	 dZNzrATnqHa1JmwckZrSy3NP/PiVVixdgbUgRfAxq/Icql70IjIQgR5jpeCc5czXxu
	 +PqCViNxacQ1macMspUCb6NB9AgbtW3Tar/aE3qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Yang <yangyicong@hisilicon.com>,
	Leo Yan <leo.yan@arm.com>,
	Guilherme Amadio <amadio@gentoo.org>,
	linuxarm@huawei.com,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 506/826] perf build: Add missing cflags when building with custom libtraceevent
Date: Tue,  3 Dec 2024 15:43:53 +0100
Message-ID: <20241203144803.495952910@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit d5a0a4ab4af4c27de097b78d6f1b7e7f7e31908f ]

When building with custom libtraceevent, below errors occur:

  $ make -C tools/perf NO_LIBPYTHON=1 PKG_CONFIG_PATH=<custom libtraceevent>
  In file included from util/session.h:5,
                   from builtin-buildid-list.c:17:
  util/trace-event.h:153:10: fatal error: traceevent/event-parse.h: No such file or directory
    153 | #include <traceevent/event-parse.h>
        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~
  <snip similar errors of missing headers>

This is because the include path is missed in the cflags. Add it.

Fixes: 0f0e1f445690 ("perf build: Use pkg-config for feature check for libtrace{event,fs}")
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Guilherme Amadio <amadio@gentoo.org>
Cc: linuxarm@huawei.com
Link: https://lore.kernel.org/r/20241024133236.31016-1-yangyicong@huawei.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index d4332675babb7..2ce71d2e5fae0 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -1194,7 +1194,7 @@ endif
 ifneq ($(NO_LIBTRACEEVENT),1)
   $(call feature_check,libtraceevent)
   ifeq ($(feature-libtraceevent), 1)
-    CFLAGS += -DHAVE_LIBTRACEEVENT
+    CFLAGS += -DHAVE_LIBTRACEEVENT $(shell $(PKG_CONFIG) --cflags libtraceevent)
     LDFLAGS += $(shell $(PKG_CONFIG) --libs-only-L libtraceevent)
     EXTLIBS += $(shell $(PKG_CONFIG) --libs-only-l libtraceevent)
     LIBTRACEEVENT_VERSION := $(shell $(PKG_CONFIG) --modversion libtraceevent).0.0
-- 
2.43.0



