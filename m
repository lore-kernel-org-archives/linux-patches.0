Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054630;
	b=UP0oEXvRMDjiA170H3cpjxQWHNbRNU3445zpjxsYlMXap4wRqEQMwaOIA4zbrGdNJcFG
	 GUEHXis3v96ad5ogHUl3gaFQqzpCSYV+QZoUva7PoHbyjW1V+mkVT4wsoIWV9BR9oASbS
	 Tu7RKUz/Jd3A8Y2BIlURqlcbKMHZCMa6DBQe1/7O42mZ3c6bjkY3/40i8V/zSnfnlo1Fe
	 QMVJrT2h4IzHaHlFPnAs9CKQQ0mNb9QVqgpt9cwRZh6XFmwZ7lgqUsbm0MXx+FNGHA3Dl
	 45T2dDcKlFqDuW6ujUcyxzlFMoOwtvBJGJ2WZsZemc8AjBVWRNzZiHADOFbV3pH3wvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tvGlKjYe6MEstCnd9PHa+/gQFhflOUMrt/eUakRBM9U=;
	b=yao/hPwJrMC2z3QDkeISmZHwweKDVPDIE/FH2U/gPugnxenPEWcoC6k7npkA86R6EkK3
	 iilkvHVQL2TezzfoAfLeY7ndb22rS27DG4PXlSdsvND3DskdBD9T9WF0fNe/d3blHaIPw
	 3s48aup28lvivo7btUzj8Liv2Xc8e66RHwa2O6lLPVjJdVe7KyHQys4eLCbYflYt42ZWw
	 sDsvVTiAsa5YQQK+XCn+D5QhIWSNrZAdUzfnyZywKq3uyKY5zS6WeeXCM5Pj14jZJ1oeb
	 8xwNoUF44MoDrIYloQO98U7318xycCVVMHn8sz5NFTncwD2HkeTVTMJTDSXVYN0aRHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q6G2X0f+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DBC606A320;
	Thu, 19 Nov 2026 02:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q6G2X0f+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915BF1F000C4;
	Thu, 19 Nov 2026 02:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054630;
	bh=tvGlKjYe6MEstCnd9PHa+/gQFhflOUMrt/eUakRBM9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6G2X0f+fUQx0XQCgKQzodV6+0VTJOndDictiNXzT0YXSbguNO79rq9ZtFGHAlJyV
	 jAH0+m93iYBDThkkdf2ScOQA4s0Jn6ZKhks3ItlitEdS/Eu2dzFtEMdP3oGiimBBaB
	 8mJdXLTGzRhwRPY8ryEjh0pTCmnDWuvClSedKM3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1344/2214] perf jitdump: Validate code_size against total_size in code load
Date: Wed, 18 Nov 2026 15:50:20 +0100
Message-ID: <20261118150105.214669131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 06c7cf7a072fcd52e68471628c56630d2bdcc650 ]

jit_repipe_code_load() reads code_size from the jitdump record and uses
it to compute a pointer to the code blob:

  code = (unsigned long)jr + jr->load.p.total_size - csize;

An oversized code_size underflows the pointer arithmetic, causing OOB
reads into earlier heap memory.  Validate that code_size fits within the
record (total_size - sizeof(jr->load)) before the pointer computation.

code_size is uint64_t but csize is int; values above INT_MAX wrap
negative when narrowed into csize, which defeats the bounds check and
sends the code pointer past the end of the record.  Reject those too.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 8157d0c295cf6..4ba0a87f5facd 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -9,6 +9,7 @@
 #include <fcntl.h>
 #include <unistd.h>
 #include <inttypes.h>
+#include <limits.h>
 #include <byteswap.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
@@ -455,6 +456,16 @@ static int jit_repipe_code_load(struct jit_buf_desc *jd, union jr_entry *jr)
 	csize = jr->load.code_size;
 	usize = jd->unwinding_mapped_size;
 	addr  = jr->load.code_addr;
+
+	/* code blob lives at the end of the record, validate it fits */
+	if (jr->load.p.total_size < sizeof(jr->load) ||
+	    jr->load.code_size > jr->load.p.total_size - sizeof(jr->load) ||
+	    jr->load.code_size > INT_MAX) {
+		pr_warning("jitdump: invalid code_size %" PRIu64 " (total_size=%u) in code_load record\n",
+			   (uint64_t)jr->load.code_size, jr->load.p.total_size);
+		return -1;
+	}
+
 	sym   = (void *)((unsigned long)jr + sizeof(jr->load));
 	code  = (unsigned long)jr + jr->load.p.total_size - csize;
 	count = jr->load.code_index;
-- 
2.53.0



