Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542B01A27D
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKc822TD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40986C433C7;
	Mon, 16 Oct 2023 08:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697445943;
	bh=Pp3Y0FnLckvBzveMfajO0zi/VguKIBimVVHQwaLCwFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKc822TDgpva1dqexEfP+bhr2rlWEaQMbHxRGUaHM/peTGKrj7M6t6/ofyG43qrfa
	 fmwnUeJ9cv0KFGoCSi0VrlzoMzyirtYtwscXBci90gI8lL1nppq0fd8nxAvROAyLD3
	 j2vKyoWTTT0v0Tqp560E2Xm/8/Xn810gzxbX/+a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Lieven Hey <lieven.hey@kdab.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/102] perf inject: Fix GEN_ELF_TEXT_OFFSET for jit
Date: Mon, 16 Oct 2023 10:40:41 +0200
Message-ID: <20231016083954.821877131@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 89b15d00527b7825ff19130ed83478e80e3fae99 ]

When a program header was added, it moved the text section but
GEN_ELF_TEXT_OFFSET was not updated.

Fix by adding the program header size and aligning.

Fixes: babd04386b1df8c3 ("perf jit: Include program header in ELF files")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Lieven Hey <lieven.hey@kdab.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20221014170905.64069-7-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/genelf.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/genelf.h b/tools/perf/util/genelf.h
index ac638945b4cb0..159c69bcc33e6 100644
--- a/tools/perf/util/genelf.h
+++ b/tools/perf/util/genelf.h
@@ -2,6 +2,8 @@
 #ifndef __GENELF_H__
 #define __GENELF_H__
 
+#include <linux/math.h>
+
 /* genelf.c */
 int jit_write_elf(int fd, uint64_t code_addr, const char *sym,
 		  const void *code, int csize, void *debug, int nr_debug_entries,
@@ -73,6 +75,6 @@ int jit_add_debug_info(Elf *e, uint64_t code_addr, void *debug, int nr_debug_ent
 #endif
 
 /* The .text section is directly after the ELF header */
-#define GEN_ELF_TEXT_OFFSET sizeof(Elf_Ehdr)
+#define GEN_ELF_TEXT_OFFSET round_up(sizeof(Elf_Ehdr) + sizeof(Elf_Phdr), 16)
 
 #endif
-- 
2.40.1



