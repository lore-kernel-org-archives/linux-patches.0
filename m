Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7381ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31F9C433CB;
	Tue, 25 Jul 2023 11:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285150;
	bh=YQhqM64LZvOrIh9SjsYJj94vGIQqktyjKozj+oT1SMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJN7anibmv6TkTO6sOa2Qj7On++6jbBNnQUYRMBE52HzNnLkPGF140S8rshWLbbki
	 fciLhzIDmfv+S+HnPnZigrNgMAdVTCQZfAvqcUkt2JBW5skXnNT1u7rDj9HJnHBSVC
	 UkQKRRiU1DOT9tIuDnBnlVHRx09MsUvSNO3mpDMQ=
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
Subject: [PATCH 5.4 102/313] perf dwarf-aux: Fix off-by-one in die_get_varname()
Date: Tue, 25 Jul 2023 12:44:15 +0200
Message-ID: <20230725104525.383692754@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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
index f1e2f566ce6fc..1d51aa88f4cb6 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -1007,7 +1007,7 @@ int die_get_varname(Dwarf_Die *vr_die, struct strbuf *buf)
 	ret = die_get_typename(vr_die, buf);
 	if (ret < 0) {
 		pr_debug("Failed to get type, make it unknown.\n");
-		ret = strbuf_add(buf, " (unknown_type)", 14);
+		ret = strbuf_add(buf, "(unknown_type)", 14);
 	}
 
 	return ret < 0 ? ret : strbuf_addf(buf, "\t%s", dwarf_diename(vr_die));
-- 
2.39.2



