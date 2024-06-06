Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F611C2246;
	Thu,  6 Jun 2024 14:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683639; cv=none; b=ZfLJvNqEwBDuDdRh5xv21rctgzG3Zl5NWsQS0jhulUFJ3RptxJlp5AFYl6a1D92L+k869q8dO+J/9kMoMtwKkVXunYI144yvrUG+Z8T+O8tcts1KhMst1E4QTA5rlG8h5wo0Pn2uENsbCFa1E1PFl7F8V8PZZdXQT6PMD+3nkJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683639; c=relaxed/simple;
	bh=/YZzABjZm23baOs8OvHxPZKE9vDn/dmvxLTmZQZFL94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lML2pirXYxXV5sgYWansQPce7CK1ii1UAHAotUyh6JYDHOY444pHBKodMZl85Vlc/B6OTT45R0AQsmXz/fgDXVJMel/89BrHumGqCLWMQGVfo9HyvO9h9F/Ph+AwLrAY8EwFPgCHKuQ3fakWz0LC5ijNuZrK012C6cxtvunKeVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fRcIpQg9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fRcIpQg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A8CC2BD10;
	Thu,  6 Jun 2024 14:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683639;
	bh=/YZzABjZm23baOs8OvHxPZKE9vDn/dmvxLTmZQZFL94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fRcIpQg9kWcr0XkbUSYJgNROuwtDiGqLDGMTb4/zfpPGNIGYRnVb2T8U4Zf/nGnHV
	 jOzMw/KOr2/+zC8YauQePLAmil0xJ5oX/yfHKkRbiBc6DyA0oRJ64gD2McJjQFSheP
	 vpi5x7fc+0mKdrBnS/l2/IgLVGw0+VLGiCUj85B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 511/744] perf symbols: Fix ownership of string in dso__load_vmlinux()
Date: Thu,  6 Jun 2024 16:03:03 +0200
Message-ID: <20240606131748.841746225@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@arm.com>

[ Upstream commit 25626e19ae6df34f336f235b6b3dbd1b566d2738 ]

The linked commit updated dso__load_vmlinux() to call
dso__set_long_name() before loading the symbols. Loading the symbols may
not succeed but dso__set_long_name() takes ownership of the string. The
two callers of this function free the string themselves on failure
cases, resulting in the following error:

  $ perf record -- ls
  $ perf report

  free(): double free detected in tcache 2

Fix it by always taking ownership of the string, even on failure. This
means the string is either freed at the very first early exit condition,
or later when the dso is deleted or the long name is replaced. Now no
special return value is needed to signify that the caller needs to
free the string.

Fixes: e59fea47f83e8a9a ("perf symbols: Fix DSO kernel load and symbol process to correctly map DSO to its long_name, type and adjust_symbols")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240507141210.195939-5-james.clark@arm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1976af974a371..ea24f21aafc3e 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1935,6 +1935,10 @@ int dso__load(struct dso *dso, struct map *map)
 	return ret;
 }
 
+/*
+ * Always takes ownership of vmlinux when vmlinux_allocated == true, even if
+ * it returns an error.
+ */
 int dso__load_vmlinux(struct dso *dso, struct map *map,
 		      const char *vmlinux, bool vmlinux_allocated)
 {
@@ -1953,8 +1957,11 @@ int dso__load_vmlinux(struct dso *dso, struct map *map,
 	else
 		symtab_type = DSO_BINARY_TYPE__VMLINUX;
 
-	if (symsrc__init(&ss, dso, symfs_vmlinux, symtab_type))
+	if (symsrc__init(&ss, dso, symfs_vmlinux, symtab_type)) {
+		if (vmlinux_allocated)
+			free((char *) vmlinux);
 		return -1;
+	}
 
 	/*
 	 * dso__load_sym() may copy 'dso' which will result in the copies having
@@ -1997,7 +2004,6 @@ int dso__load_vmlinux_path(struct dso *dso, struct map *map)
 		err = dso__load_vmlinux(dso, map, filename, true);
 		if (err > 0)
 			goto out;
-		free(filename);
 	}
 out:
 	return err;
@@ -2149,7 +2155,6 @@ static int dso__load_kernel_sym(struct dso *dso, struct map *map)
 		err = dso__load_vmlinux(dso, map, filename, true);
 		if (err > 0)
 			return err;
-		free(filename);
 	}
 
 	if (!symbol_conf.ignore_vmlinux && vmlinux_path != NULL) {
-- 
2.43.0



