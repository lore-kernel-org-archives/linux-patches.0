Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6647B1519AA;
	Wed,  5 Feb 2025 14:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764464; cv=none; b=sSX9JlxaHw5+N5LgdnKiVPhW9jmWMn89tOMH1Tktayq1pp7YljJyj0scqzvDRlQ81W20hHxYAql3x/RsWqN0HPA56TaP6wfg4DzD4c15wDhkN4eFUjutsqN4WkIAhjEP6g6zcFYC0KV8UJwaN/RTCUoy4s4WTfc7LOmWAl2ecHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764464; c=relaxed/simple;
	bh=3Edg0QUh7PusFh7nDkzXJ9eTDSJNDI4MD4iBjDV4LnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zb6SWmMsXjpV+cQpaZx52rwDIkw9UUfXc2uuSgZmpejwyxaqISzjRldSrIrrp1JvygK3ugn0mxo+M0Gg2t/mY43iOHVx0QCdRGVfvC7WopA6IjdSRIZ4hxLnQYnd3/jxMLkhXm2Rdj8XBo6rtBiY5h2eTMQZiLdFdWajyX90p0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AnQJCBBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AnQJCBBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A9EC4CED6;
	Wed,  5 Feb 2025 14:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764464;
	bh=3Edg0QUh7PusFh7nDkzXJ9eTDSJNDI4MD4iBjDV4LnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AnQJCBBQBNLY5ymFQKRrKv9EnHDL8jtpiaSYtlwRMCAV9fZcClmcPxwHJFfwVjIKV
	 iPfEnJlX3Pcf1r/EWpQp08O+/nNykofo9Tnx6r69+BepO41yTIwWKSkC7rejYnp/9O
	 Bt7glLLEEycdGJB32sxbHc+g51AeXuP2DCOC+Ars=
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
Subject: [PATCH 6.6 174/393] perf top: Dont complain about lack of vmlinux when not resolving some kernel samples
Date: Wed,  5 Feb 2025 14:41:33 +0100
Message-ID: <20250205134426.951186274@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1c1ec444d501e..381274c70a9af 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -809,7 +809,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		 * invalid --vmlinux ;-)
 		 */
 		if (!machine->kptr_restrict_warned && !top->vmlinux_warned &&
-		    __map__is_kernel(al.map) && map__has_symbols(al.map)) {
+		    __map__is_kernel(al.map) && !map__has_symbols(al.map)) {
 			if (symbol_conf.vmlinux_name) {
 				char serr[256];
 
-- 
2.39.5



