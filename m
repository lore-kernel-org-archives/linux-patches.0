Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDB61D0782;
	Wed,  2 Oct 2024 13:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876121; cv=none; b=gmOczid4xZez1UiMxk58btG1r0uCXaZha8sT3XA3l4oXUg7jkFDtrukTmbRLybJis+ceAsNn3ehKhhygfzMmRga8HgfmyDfy1abjxEUJW9E9RKdr/R/j+eRjf+6mpbWG4dP1xDY2R9QgCkDWEau8WR4CWq2kpkcpgm3DjesSz64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876121; c=relaxed/simple;
	bh=8bFyOJXVrHDpLnYM4yv67bXpFAFj8WfEXbRSXIO2TPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8wofzfWOWZTwlp4I7I2nTxTF2K6PALafSbWDzofdjYF6qh5oHGV6WNK88M6K8PeosJVMk+zxOi1dcv7kafBdrSjlyENqics37j1b2qajtIHjUM9n27HtOZnuMe9+qbVQvLKr2Q/Jzje4mMyzSl8tMAMTNm7NqvUEUbmkgYGyUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EWaF42lZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EWaF42lZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F38C4CEC5;
	Wed,  2 Oct 2024 13:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876121;
	bh=8bFyOJXVrHDpLnYM4yv67bXpFAFj8WfEXbRSXIO2TPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EWaF42lZ6rseR0tnR3kVhipAnPci1+AQH7tJvExBaEBKTanA4dm5gU7csc940JezC
	 Zpy5xY3LRpYIxAo+pDrI7jrbgZoU0AO978t1GA02J+70MU66Ju94xrbQetK6HtPlD3
	 87E0P9hjnbbUE/bW4caOZnOIWI86h7q2SRZFTsc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 336/695] perf dwarf-aux: Handle bitfield members from pointer access
Date: Wed,  2 Oct 2024 14:55:34 +0200
Message-ID: <20241002125835.863162586@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit a11b4222bb579dcf9646f3c4ecd2212ae762a2c8 ]

The __die_find_member_offset_cb() missed to handle bitfield members
which don't have DW_AT_data_member_location.  Like in adding member
types in __add_member_cb() it should fallback to check the bit offset
when it resolves the member type for an offset.

Fixes: 437683a9941891c1 ("perf dwarf-aux: Handle type transfer for memory access")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240821232628.353177-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 0e7d2060740df..1b0e59f4d8e93 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -1977,8 +1977,15 @@ static int __die_find_member_offset_cb(Dwarf_Die *die_mem, void *arg)
 		return DIE_FIND_CB_SIBLING;
 
 	/* Unions might not have location */
-	if (die_get_data_member_location(die_mem, &loc) < 0)
-		loc = 0;
+	if (die_get_data_member_location(die_mem, &loc) < 0) {
+		Dwarf_Attribute attr;
+
+		if (dwarf_attr_integrate(die_mem, DW_AT_data_bit_offset, &attr) &&
+		    dwarf_formudata(&attr, &loc) == 0)
+			loc /= 8;
+		else
+			loc = 0;
+	}
 
 	if (offset == loc)
 		return DIE_FIND_CB_END;
-- 
2.43.0



