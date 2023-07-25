Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9F01EA72;
	Tue, 25 Jul 2023 10:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BB1C433C8;
	Tue, 25 Jul 2023 10:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282112;
	bh=1MRRFUNIGZi+W/2lb85NsHIk63UCDtRhcoWOEwMR2m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3qgJeWYUdsrFPGQ6vfSHEE5/YC9EWAPbKoZxbqAfj9M7ge5HWkO1WcmWZRqDlpZC
	 4RqWPiKhnhyKyg8bwNT6UnWJjzhwV0sfQm9FWOy0Klxu/1goHqNYxi8FNXOpj5HBHM
	 kG5+PyLnE+GKis9OcswaAL4xPPxHjg/5HI5ZCDz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Georg=20M=C3=BCller?= <georgmueller@gmx.net>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	regressions@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.4 013/227] perf probe: Read DWARF files from the correct CU
Date: Tue, 25 Jul 2023 12:43:00 +0200
Message-ID: <20230725104515.329193975@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Georg Müller <georgmueller@gmx.net>

commit c66e1c68c13b872505f25ab641c44b77313ee7fe upstream.

After switching from dwarf_decl_file() to die_get_decl_file(), it is not
possible to add probes for certain functions:

  $ perf probe -x /usr/lib/systemd/systemd-logind match_unit_removed
  A function DIE doesn't have decl_line. Maybe broken DWARF?
  A function DIE doesn't have decl_line. Maybe broken DWARF?
  Probe point 'match_unit_removed' not found.
     Error: Failed to add events.

The problem is that die_get_decl_file() uses the wrong CU to search for
the file. elfutils commit e1db5cdc9f has some good explanation for this:

    dwarf_decl_file uses dwarf_attr_integrate to get the DW_AT_decl_file
    attribute. This means the attribute might come from a different DIE
    in a different CU. If so, we need to use the CU associated with the
    attribute, not the original DIE, to resolve the file name.

This patch uses the same source of information as elfutils: use attribute
DW_AT_decl_file and use this CU to search for the file.

Fixes: dc9a5d2ccd5c823c ("perf probe: Fix to get declared file name from clang DWARF5")
Signed-off-by: Georg Müller <georgmueller@gmx.net>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: regressions@lists.linux.dev
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230628084551.1860532-6-georgmueller@gmx.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/dwarf-aux.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -478,8 +478,10 @@ static const char *die_get_file_name(Dwa
 {
 	Dwarf_Die cu_die;
 	Dwarf_Files *files;
+	Dwarf_Attribute attr_mem;
 
-	if (idx < 0 || !dwarf_diecu(dw_die, &cu_die, NULL, NULL) ||
+	if (idx < 0 || !dwarf_attr_integrate(dw_die, DW_AT_decl_file, &attr_mem) ||
+	    !dwarf_cu_die(attr_mem.cu, &cu_die, NULL, NULL, NULL, NULL, NULL, NULL) ||
 	    dwarf_getsrcfiles(&cu_die, &files, NULL) != 0)
 		return NULL;
 


