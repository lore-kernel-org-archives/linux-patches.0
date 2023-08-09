Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDCB174EE
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:05:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E0DC433C8;
	Wed,  9 Aug 2023 11:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579107;
	bh=LBhUvZ99XV5cM7I+LeZjEc3eIbfK5mmjp3lAHlxwgig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xknkyPkuGl3U9qKe1M49Kv/S/ye41wMw7zWn0tbIJz6Nv6/scgvHLG1JWWfeuH/VI
	 9p2WgmmXNIJP7N7jT91TeIDi5e6IQKQ7GV8fpohXM3B6iA1q9qHdNjXigj7DsFk+A2
	 AB41AkbASAxzC6IffPK9PpeID833z2wJacp2snaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 048/204] perf dwarf-aux: Fix off-by-one in die_get_varname()
Date: Wed,  9 Aug 2023 12:39:46 +0200
Message-ID: <20230809103644.175364269@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 3abfcfd847717d232e36963f31a361747c388fe7 ]

The die_get_varname() returns "(unknown_type)" string if it failed to
find a type for the variable.  But it had a space before the opening
parenthesis and it made the closing parenthesis cut off due to the
off-by-one in the string length (14).

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Fixes: 88fd633cdfa19060 ("perf probe: No need to use formatting strbuf method")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230612234102.3909116-1-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 7514aa9c68c99..f95c3d43b5cbb 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -1033,7 +1033,7 @@ int die_get_varname(Dwarf_Die *vr_die, struct strbuf *buf)
 	ret = die_get_typename(vr_die, buf);
 	if (ret < 0) {
 		pr_debug("Failed to get type, make it unknown.\n");
-		ret = strbuf_add(buf, " (unknown_type)", 14);
+		ret = strbuf_add(buf, "(unknown_type)", 14);
 	}
 
 	return ret < 0 ? ret : strbuf_addf(buf, "\t%s", dwarf_diename(vr_die));
-- 
2.39.2



