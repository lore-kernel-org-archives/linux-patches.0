Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5418922912F;
	Thu, 12 Dec 2024 16:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022451; cv=none; b=JoN9Nggyq+6cd6+RXIsbvLrriI9+Y2xhoADBDDmOsZt5+V+H6Bqp1Gf78/PV3nIrHAtHFtft4Of1Ra0qioqdJ5/Yarzm1swDpivbrfJ9oSePS5SJbOLDGmENdpGZPKRcggPNHHIKRFk6NuKNu4pcgyncnkHcS39KtiZb4+fK2iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022451; c=relaxed/simple;
	bh=H3XB7QHcEUv5gh6L9mZbD0G0BH1UPAvcmVGcT8UFqKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkF3yAnmnwDImwetkG/NisIUWb/2PiU6dHtj1cR8DxzCr20BvMcTTHwyzYllmYq5UNqsjHiL7SOjp0DKP5Mmb3oWTr+bXcqQtFuEb35lw8HQsZu60rF3t6yH0Q47yCXFk53UrdRwHzV26bvZgHL+stw2rbRv40+IcUODMEf0vzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fk+Sqt7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fk+Sqt7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ABDC4CECE;
	Thu, 12 Dec 2024 16:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022451;
	bh=H3XB7QHcEUv5gh6L9mZbD0G0BH1UPAvcmVGcT8UFqKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fk+Sqt7siwYCWxJhRFmjXttdWMrvZadcBpot5Nctiy0aIKyEtCSByT8NgCeFkwL4a
	 rWdx4Q9r09cJlDdk6Kj00mr2QmLrmI80EE8iCgrFy2l2dCx4svwZSWLr8EVuamp7p7
	 YcmBAqYIWWVmm/i80o07A0G7yDoZyF8PvkcjgN/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 244/565] perf probe: Correct demangled symbols in C++ program
Date: Thu, 12 Dec 2024 15:57:19 +0100
Message-ID: <20241212144321.122972527@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 314909f13cc12d47c468602c37dace512d225eeb ]

An issue can be observed when probe C++ demangled symbol with steps:

  # nm test_cpp_mangle | grep print_data
    0000000000000c94 t _GLOBAL__sub_I__Z10print_datai
    0000000000000afc T _Z10print_datai
    0000000000000b38 T _Z10print_dataR5Point

  # perf probe -x /home/niayan01/test_cpp_mangle -F --demangle
    ...
    print_data(Point&)
    print_data(int)
    ...

  # perf --debug verbose=3 probe -x test_cpp_mangle --add "test=print_data(int)"
    probe-definition(0): test=print_data(int)
    symbol:print_data(int) file:(null) line:0 offset:0 return:0 lazy:(null)
    0 arguments
    Open Debuginfo file: /home/niayan01/test_cpp_mangle
    Try to find probe point from debuginfo.
    Symbol print_data(int) address found : afc
    Matched function: print_data [2ccf]
    Probe point found: print_data+0
    Found 1 probe_trace_events.
    Opening /sys/kernel/tracing//uprobe_events write=1
    Opening /sys/kernel/tracing//README write=0
    Writing event: p:probe_test_cpp_mangle/test /home/niayan01/test_cpp_mangle:0xb38
    ...

When tried to probe symbol "print_data(int)", the log shows:

    Symbol print_data(int) address found : afc

The found address is 0xafc - which is right with verifying the output
result from nm. Afterwards when write event, the command uses offset
0xb38 in the last log, which is a wrong address.

The dwarf_diename() gets a common function name, in above case, it
returns string "print_data". As a result, the tool parses the offset
based on the common name. This leads to probe at the wrong symbol
"print_data(Point&)".

To fix the issue, use the die_get_linkage_name() function to retrieve
the distinct linkage name - this is the mangled name for the C++ case.
Based on this unique name, the tool can get a correct offset for
probing. Based on DWARF doc, it is possible the linkage name is missed
in the DIE, it rolls back to use dwarf_diename().

After:

  # perf --debug verbose=3 probe -x test_cpp_mangle --add "test=print_data(int)"
    probe-definition(0): test=print_data(int)
    symbol:print_data(int) file:(null) line:0 offset:0 return:0 lazy:(null)
    0 arguments
    Open Debuginfo file: /home/niayan01/test_cpp_mangle
    Try to find probe point from debuginfo.
    Symbol print_data(int) address found : afc
    Matched function: print_data [2d06]
    Probe point found: print_data+0
    Found 1 probe_trace_events.
    Opening /sys/kernel/tracing//uprobe_events write=1
    Opening /sys/kernel/tracing//README write=0
    Writing event: p:probe_test_cpp_mangle/test /home/niayan01/test_cpp_mangle:0xafc
    Added new event:
      probe_test_cpp_mangle:test (on print_data(int) in /home/niayan01/test_cpp_mangle)

    You can now use it in all perf tools, such as:

            perf record -e probe_test_cpp_mangle:test -aR sleep 1

  # perf --debug verbose=3 probe -x test_cpp_mangle --add "test2=print_data(Point&)"
    probe-definition(0): test2=print_data(Point&)
    symbol:print_data(Point&) file:(null) line:0 offset:0 return:0 lazy:(null)
    0 arguments
    Open Debuginfo file: /home/niayan01/test_cpp_mangle
    Try to find probe point from debuginfo.
    Symbol print_data(Point&) address found : b38
    Matched function: print_data [2ccf]
    Probe point found: print_data+0
    Found 1 probe_trace_events.
    Opening /sys/kernel/tracing//uprobe_events write=1
    Parsing probe_events: p:probe_test_cpp_mangle/test /home/niayan01/test_cpp_mangle:0x0000000000000afc
    Group:probe_test_cpp_mangle Event:test probe:p
    Opening /sys/kernel/tracing//README write=0
    Writing event: p:probe_test_cpp_mangle/test2 /home/niayan01/test_cpp_mangle:0xb38
    Added new event:
      probe_test_cpp_mangle:test2 (on print_data(Point&) in /home/niayan01/test_cpp_mangle)

    You can now use it in all perf tools, such as:

            perf record -e probe_test_cpp_mangle:test2 -aR sleep 1

Fixes: fb1587d869a3 ("perf probe: List probes with line number and file name")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Link: https://lore.kernel.org/r/20241012141432.877894-1-leo.yan@arm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/probe-finder.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 2f86103761ab2..3c13597d0a0db 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1736,8 +1736,21 @@ int debuginfo__find_probe_point(struct debuginfo *dbg, u64 addr,
 
 	/* Find a corresponding function (name, baseline and baseaddr) */
 	if (die_find_realfunc(&cudie, (Dwarf_Addr)addr, &spdie)) {
-		/* Get function entry information */
-		func = basefunc = dwarf_diename(&spdie);
+		/*
+		 * Get function entry information.
+		 *
+		 * As described in the document DWARF Debugging Information
+		 * Format Version 5, section 2.22 Linkage Names, "mangled names,
+		 * are used in various ways, ... to distinguish multiple
+		 * entities that have the same name".
+		 *
+		 * Firstly try to get distinct linkage name, if fail then
+		 * rollback to get associated name in DIE.
+		 */
+		func = basefunc = die_get_linkage_name(&spdie);
+		if (!func)
+			func = basefunc = dwarf_diename(&spdie);
+
 		if (!func ||
 		    die_entrypc(&spdie, &baseaddr) != 0 ||
 		    dwarf_decl_line(&spdie, &baseline) != 0) {
-- 
2.43.0



