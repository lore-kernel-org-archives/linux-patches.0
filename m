Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE7C1DC184;
	Wed, 19 Feb 2025 09:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956346; cv=none; b=GGoXt4H2Vr223K4HxLNF/S3w3n+EhBQAMpJjaysSLlJdTmnEiPrT2nr2hxnEKR6AWKbkAupXiHWsdhXuWSLwbsdfRUk5D44ZhesIAGl8mG4xHvabu1E3rSVdg8W0SWyZErrLLiCccKNmmIv3wv2BKu50gak2yabBaOIT4NbCCwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956346; c=relaxed/simple;
	bh=YONoKE2Smrs4wy8/iKtQ6EwCnYnNtRfs9OgSebwyjvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tavgGgf3MWZe+vayxSulZXyR8r2kHseUBvIQlfExfyBbPFvjTOP5sMiVCSi1CVn+5D6pZyNvDd0lfSsLHbRpZflk2LAqdofQWe3SoQtFLZ+00e5v4CB+DnL3rNX+70QCPNZahtvJ1WmeGVMuLE+0iZG/O636BzwAzxwfIXBzXxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TfKQhDYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TfKQhDYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433DFC4CED1;
	Wed, 19 Feb 2025 09:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956345;
	bh=YONoKE2Smrs4wy8/iKtQ6EwCnYnNtRfs9OgSebwyjvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfKQhDYAq8oOfmct7nxvuWZn3mnxhQWPk8BDRbvkJFCsjcJKMjBhAPz7jt6HwwG08
	 C34EKan4rf4VNbDK1y3p09Nm5LnBbdzdOg8rvuy6z6wcWWB6tjvkZ1PWrTzg+lgZyI
	 GOmRp2rYPmuUXPPlOSFRdDbgb8i6s5/uagDLP87U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/578] perf top: Dont complain about lack of vmlinux when not resolving some kernel samples
Date: Wed, 19 Feb 2025 09:22:00 +0100
Message-ID: <20250219082657.543508647@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 058b38ccd2af9e5c95590b018e8425fa148d7aca ]

Recently we got a case where a kernel sample wasn't being resolved due
to a bug that was not setting the end address on kernel functions
implemented in assembly (see Link: tag), and then those were not being
found by machine__resolve() -> map__find_symbol().

So we ended up with:

  # perf top --stdio
  PerfTop: 0 irqs/s  kernel: 0%  exact: 0% lost: 0/0 drop: 0/0 [cycles/P]
  -----------------------------------------------------------------------

  Warning:
  A vmlinux file was not found.
  Kernel samples will not be resolved.
  ^Z
  [1]+  Stopped                 perf top --stdio
  #

But then resolving all other kernel symbols.

So just fixup the logic to only print that warning when there are no
symbols in the kernel map.

Fixes: d88205db9caa0e9d ("perf dso: Add dso__has_symbols() method")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/lkml/Z3buKhcCsZi3_aGb@x1
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-top.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f9917848cdad0..d24e495062a84 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -807,7 +807,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		 * invalid --vmlinux ;-)
 		 */
 		if (!machine->kptr_restrict_warned && !top->vmlinux_warned &&
-		    __map__is_kernel(al.map) && map__has_symbols(al.map)) {
+		    __map__is_kernel(al.map) && !map__has_symbols(al.map)) {
 			if (symbol_conf.vmlinux_name) {
 				char serr[256];
 				dso__strerror_load(al.map->dso, serr, sizeof(serr));
-- 
2.39.5



