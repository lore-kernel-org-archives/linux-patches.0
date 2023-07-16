Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678D08F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:14:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8DEC433C7;
	Sun, 16 Jul 2023 20:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538490;
	bh=DQUa3mqu3z7Z5tKHUw7Bosn1IPdmhPhPz8/aaKUR73Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kceLYowpnn1hyCJiLofxi4zo7bICelEQaHMRadoNQIR0Dc4oqqK8V2qkc5VFWIQUx
	 nnC//5+5NzCv+dv/QztO21Tk7OusIJua8SaS1vhAupkXEmpBgYCMMloMuS5gJhkLjl
	 IL9Nc1fYtdKCYY/fyWJJgZJbnvFfh5MpI67ZzyMU=
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
Subject: [PATCH 6.4 470/800] perf dwarf-aux: Fix off-by-one in die_get_varname()
Date: Sun, 16 Jul 2023 21:45:23 +0200
Message-ID: <20230716194959.998576885@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index b074144097710..3bff678745635 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -1103,7 +1103,7 @@ int die_get_varname(Dwarf_Die *vr_die, struct strbuf *buf)
 	ret = die_get_typename(vr_die, buf);
 	if (ret < 0) {
 		pr_debug("Failed to get type, make it unknown.\n");
-		ret = strbuf_add(buf, " (unknown_type)", 14);
+		ret = strbuf_add(buf, "(unknown_type)", 14);
 	}
 
 	return ret < 0 ? ret : strbuf_addf(buf, "\t%s", dwarf_diename(vr_die));
-- 
2.39.2



