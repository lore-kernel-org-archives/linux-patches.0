Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D131D0E08;
	Wed,  2 Oct 2024 14:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878120; cv=none; b=WqgnW8aOyEhtyh3Ac/B3h8u8sHIANDjHJmlGFO+3Vbc7enq9VCzeupXQ0sb1DB9OPHE+hxBo0Z9kYz5FWuypMzY8TgH/rnAgYfs2I/8ivC9zMG0VP8HwWx2L+N8LmHxJiQWaTZbmvn26KjWpx4Rh/yPhWD2LFH37cnEwEsEK/rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878120; c=relaxed/simple;
	bh=E4RDpDdoQFXTvfg/oC1v5QY9NCbBYd5Ru68rrwCgHl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jc2O7UCpDNwTVr2TQE3b/m9KaKYDTY9XED/gIVf6bEljzaTUi5u1UrycfxwU2dqJiOkTwQhxBBdcR/izAQInKGJKnMV6Qd6Qx336TZHx/Zr+vd1yCnJm0TdAbkMSMRGuI5pDvK41m7Ai2+j0E4+/UzL/dWkZql2+SxX+IZ5hy54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2W4HYzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2W4HYzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAE7C4CECF;
	Wed,  2 Oct 2024 14:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878120;
	bh=E4RDpDdoQFXTvfg/oC1v5QY9NCbBYd5Ru68rrwCgHl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2W4HYzulmKhJ5mmN1VMW2vZbu+r6u5rvO7d6OLiiXmrSvIhsVRt5SUWGyU9YdZ0i
	 b/og62ay3HuXC0hWS4hfrIXOAEOwxGv4M4y/vf/6psKHcMtYJdbuYJy9nC/OkW45yo
	 +m06wb4hTAfWLVkZQh/cPZO5G03aao1xWvmOQ20s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 301/634] perf dwarf-aux: Check allowed location expressions when collecting variables
Date: Wed,  2 Oct 2024 14:56:41 +0200
Message-ID: <20241002125822.989811179@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit e8bb03ed6850c6ed4ce2f1600ea73401fc2ebd95 ]

It missed to call check_allowed_ops() in __die_collect_vars_cb() so it
can take variables with complex location expression incorrectly.

For example, I found some variable has this expression.

    015d8df8 ffffffff81aacfb3 (base address)
    015d8e01 v000000000000004 v000000000000000 views at 015d8df2 for:
             ffffffff81aacfb3 ffffffff81aacfd2 (DW_OP_fbreg: -176; DW_OP_deref;
						DW_OP_plus_uconst: 332; DW_OP_deref_size: 4;
						DW_OP_lit1; DW_OP_shra; DW_OP_const1u: 64;
						DW_OP_minus; DW_OP_stack_value)
    015d8e14 v000000000000000 v000000000000000 views at 015d8df4 for:
             ffffffff81aacfd2 ffffffff81aacfd7 (DW_OP_reg3 (rbx))
    015d8e19 v000000000000000 v000000000000000 views at 015d8df6 for:
             ffffffff81aacfd7 ffffffff81aad020 (DW_OP_fbreg: -176; DW_OP_deref;
						DW_OP_plus_uconst: 332; DW_OP_deref_size: 4;
						DW_OP_lit1; DW_OP_shra; DW_OP_const1u: 64;
						DW_OP_minus; DW_OP_stack_value)
    015d8e2c <End of list>

It looks like '((int *)(-176(%rbp) + 332) >> 1) - 64' but the current
code thought it's just -176(%rbp) and processed the variable incorrectly.
It should reject such a complex expression if check_allowed_ops()
doesn't like it. :)

Fixes: 932dcc2c39aedf54 ("perf dwarf-aux: Add die_collect_vars()")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240816235840.2754937-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 44ef968a7ad33..e7de5045c43a7 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -1598,6 +1598,9 @@ static int __die_collect_vars_cb(Dwarf_Die *die_mem, void *arg)
 	if (dwarf_getlocations(&attr, 0, &base, &start, &end, &ops, &nops) <= 0)
 		return DIE_FIND_CB_SIBLING;
 
+	if (!check_allowed_ops(ops, nops))
+		return DIE_FIND_CB_SIBLING;
+
 	if (die_get_real_type(die_mem, &type_die) == NULL)
 		return DIE_FIND_CB_SIBLING;
 
-- 
2.43.0



