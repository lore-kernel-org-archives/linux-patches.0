Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A44B2745E;
	Fri, 17 Oct 2025 15:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715190; cv=none; b=RICNOFv6ES2rWPJHTsJQt3M6vkCX4kC6iWCiPdWf/XnvQ8FMWGs/zPFVIn8Zqp40Mn4rdXygTr6qdt49GZ8DcJr+2Ise9RPiy9rcuthMiN0vhKoYYQdeCm0O35vwdrQVyHSa0lMG0XI+uwIvg0kM6e4rNZ3Spu/SIodWDxsLHGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715190; c=relaxed/simple;
	bh=iu8fcFo2tPu44R+hm7aNJFVNMhne7iClZZCj73upYVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sagcU+UB73k+PjdkukRQ3vaDWQ9yWcYAAQE1kb9d3kiBpVnDDP1iysQa9dwzVu4riuDJsY+/ZgaBdg2bFK1oarnuOeCmuF0xyE10nGUj3comNAlBG/sn6yIdWFKHxfJ5OPSVApinLWGP7qaZcvACctIpJupACF2shoqYQPfwypQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHnkF0yx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHnkF0yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14015C4CEE7;
	Fri, 17 Oct 2025 15:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715190;
	bh=iu8fcFo2tPu44R+hm7aNJFVNMhne7iClZZCj73upYVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHnkF0yxAKIR74FmHMwnhYITQrm0V9qoFgFt4D+ghrnfe8txlbmLtstY1S7szMk8B
	 fFeRp43gsmZXLxE5Nnbw5YWi+e8r9UxMv9UfXquMX/ndpHsMa0uH4NV2g+PTmqO9B0
	 yR5MU3XD311gAiVh1M+ImoCJ8Yf7lhLRTcu8YiyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Vincent Minet <v.minet@criteo.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 097/371] perf tools: Fix arm64 libjvmti build by generating unistd_64.h
Date: Fri, 17 Oct 2025 16:51:12 +0200
Message-ID: <20251017145205.451062252@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vincent Minet <v.minet@criteo.com>

[ Upstream commit f3b601f900902ab80902c44f820a8985384ac021 ]

Since commit 22f72088ffe6 ("tools headers: Update the syscall table with
the kernel sources") the arm64 syscall header is generated at build
time. Later, commit bfb713ea53c7 ("perf tools: Fix arm64 build by
generating unistd_64.h") added a dependency to libperf to guarantee that
this header was created before building libperf or perf itself.

However, libjvmti also requires this header but does not depend on
libperf, leading to build failures such as:

  In file included from /usr/include/sys/syscall.h:24,
                   from /usr/include/syscall.h:1,
                   from jvmti/jvmti_agent.c:36:
  tools/arch/arm64/include/uapi/asm/unistd.h:2:10: fatal error: asm/unistd_64.h: No such file or directory
      2 | #include <asm/unistd_64.h>

Fix this by ensuring that libperf is built before libjvmti, so that
unistd_64.h is always available.

Fixes: 22f72088ffe69a37 ("tools headers: Update the syscall table with the kernel sources")
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Vincent Minet <v.minet@criteo.com>
Link: https://lore.kernel.org/r/20250922053702.2688374-1-v.minet@criteo.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.perf | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index e2150acc2c133..f561025d4085e 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -941,7 +941,7 @@ $(OUTPUT)dlfilters/%.so: $(OUTPUT)dlfilters/%.o
 ifndef NO_JVMTI
 LIBJVMTI_IN := $(OUTPUT)jvmti/jvmti-in.o
 
-$(LIBJVMTI_IN): FORCE
+$(LIBJVMTI_IN): prepare FORCE
 	$(Q)$(MAKE) -f $(srctree)/tools/build/Makefile.build dir=jvmti obj=jvmti
 
 $(OUTPUT)$(LIBJVMTI): $(LIBJVMTI_IN)
-- 
2.51.0



