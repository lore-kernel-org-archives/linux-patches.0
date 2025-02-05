Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88AB1917F1;
	Wed,  5 Feb 2025 14:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766569; cv=none; b=tEHb+1djsXdQCHNSD9fC4akPfTDR/igD8Jtful535WpkNoJg3QO2X7ap58vd+03DmcsNE7WMY5RiMFhysgskFlOkoEYctkbZjSyYyaZZU56KS5hCYUSwaNbqm106/FN0KE9cseECL81QrYxtuuybqbExv3EVYk0DpFMjfhEYS2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766569; c=relaxed/simple;
	bh=ghFPL9FRZ2U6Z0A4yUxlaC0fYMuAI1uehUVwiik0was=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNm8y01JG43LjHSxvrFkdPw0cNA0WsgNJTJ4rYbi4SZSDmNYK88T8BoQd4PiKlhb7xkBSy23L4jmg9yCMrKcXJtW4JA/osmhIaMN5tgpjQf8V59lO/oFU24vm7J6WSEtHgX/lBMBEds68aT3gAnu/fyetGl7U0u3nwZKnASj6kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wHfVPyae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wHfVPyae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B90C4CED1;
	Wed,  5 Feb 2025 14:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766569;
	bh=ghFPL9FRZ2U6Z0A4yUxlaC0fYMuAI1uehUVwiik0was=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wHfVPyaetF9glxkwcMdSWYOfsXmXZQcuTCCbdclh7JwEnbA1RWCgoTow68rECiPr5
	 hkerA1Mp7mYD7Vx45gegcCgtxTg/j59zY/wxPnQS/ff8XS7RxqT9bjBMWkdRyvpxmy
	 s5Int8j8/jE2MnUkzhn7p24cGnnWV5OZFJSAaAjE=
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
Subject: [PATCH 6.13 288/623] perf top: Dont complain about lack of vmlinux when not resolving some kernel samples
Date: Wed,  5 Feb 2025 14:40:30 +0100
Message-ID: <20250205134507.248883024@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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
index 724a793863212..ca3e8eca6610e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -809,7 +809,7 @@ static void perf_event__process_sample(const struct perf_tool *tool,
 		 * invalid --vmlinux ;-)
 		 */
 		if (!machine->kptr_restrict_warned && !top->vmlinux_warned &&
-		    __map__is_kernel(al.map) && map__has_symbols(al.map)) {
+		    __map__is_kernel(al.map) && !map__has_symbols(al.map)) {
 			if (symbol_conf.vmlinux_name) {
 				char serr[256];
 
-- 
2.39.5



