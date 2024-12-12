Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B352213CA93;
	Thu, 12 Dec 2024 17:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024208; cv=none; b=crMNNLZpxrj2zaVgv9009asEJc7T23lJ9yObreGGoJNoOMH468pN6Uc1TKRyHvarbjXNah+YD8CXWBVgJ7s7zTAei/FyTLOUFgnAzOhK4Murdh2MzErOBlK84PBQXwf886336IopXAEsgf6SRdmnjEDiOulYHySfuI6FAUPZwms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024208; c=relaxed/simple;
	bh=DWCRGQGZUWGCaSyqk5o1Q6T4c5uJPdXywRHiMVYbsHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e93cNyiAZyKma9A/cyub+asAr/8eILHrkcc9Qr89W4JYP8pTN+GiXLPOiohwDiY9SK5kd1Dl17I3M6DEWbX9WyhSYu3x6UspWLPqDrG8NIG3b1fOs4biiDTPtTRrBYTQKPUXJZGWWVebWOSQjid2JiVlKp+NQmxEMr3HJb4ZRgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MdVy6YEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MdVy6YEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D491C4CECE;
	Thu, 12 Dec 2024 17:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024206;
	bh=DWCRGQGZUWGCaSyqk5o1Q6T4c5uJPdXywRHiMVYbsHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MdVy6YEUbBjxdgIz9ZlBJV6OmGSTootRisW+RUm/jCqfnNu0qiaykP+mtd+xc/p/4
	 fEGlyGAD41Z1asfB3RYjI9VIh3NZH39o9QvnTz+1OzuvPDhx4lbKWyke0AJQ6Vhmjh
	 3mM4+n1fCG2mfgAcej3KUHY7zqwIpDkgfOMmO2Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Steinar H. Gunderson" <sesse@google.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Hemant Kumar <hemant@linux.vnet.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 191/459] perf probe: Fix libdw memory leak
Date: Thu, 12 Dec 2024 15:58:49 +0100
Message-ID: <20241212144301.111803176@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 4585038b8e186252141ef86e9f0d8e97f11dce8d ]

Add missing dwarf_cfi_end to free memory associated with probe_finder
cfi_eh which is allocated and owned via a call to
dwarf_getcfi_elf. Confusingly cfi_dbg shouldn't be freed as its memory
is owned by the passed in debuginfo struct. Add comments to highlight
this.

This addresses leak sanitizer issues seen in:
tools/perf/tests/shell/test_uprobe_from_different_cu.sh

Fixes: 270bde1e76f4 ("perf probe: Search both .eh_frame and .debug_frame sections for probe location")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Steinar H. Gunderson <sesse@google.com>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>
Link: https://lore.kernel.org/r/20241016235622.52166-3-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/probe-finder.c | 4 ++++
 tools/perf/util/probe-finder.h | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index fdafbfcef6871..31c779ce029db 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1483,6 +1483,10 @@ int debuginfo__find_trace_events(struct debuginfo *dbg,
 	if (ret >= 0 && tf.pf.skip_empty_arg)
 		ret = fill_empty_trace_arg(pev, tf.tevs, tf.ntevs);
 
+#if _ELFUTILS_PREREQ(0, 142)
+	dwarf_cfi_end(tf.pf.cfi_eh);
+#endif
+
 	if (ret < 0 || tf.ntevs == 0) {
 		for (i = 0; i < tf.ntevs; i++)
 			clear_probe_trace_event(&tf.tevs[i]);
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 2febb58756789..35eae263ffe74 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -81,9 +81,9 @@ struct probe_finder {
 
 	/* For variable searching */
 #if _ELFUTILS_PREREQ(0, 142)
-	/* Call Frame Information from .eh_frame */
+	/* Call Frame Information from .eh_frame. Owned by this struct. */
 	Dwarf_CFI		*cfi_eh;
-	/* Call Frame Information from .debug_frame */
+	/* Call Frame Information from .debug_frame. Not owned. */
 	Dwarf_CFI		*cfi_dbg;
 #endif
 	Dwarf_Op		*fb_ops;	/* Frame base attribute */
-- 
2.43.0



