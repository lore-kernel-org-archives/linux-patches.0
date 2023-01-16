Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D9333EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF45C433EF;
	Mon, 16 Jan 2023 16:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884932;
	bh=WHn3s9hUbUG9BF6mjGX5g2GpCVXGlNgRB/gQrtcfDy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cDmW2yEjV5pT79AZyBu33UqwpDqDoPWEtvLBoWUPxcVNkyedrWvs2SRzPCxBZVUtq
	 IT4LVjOW1v+w+5v1/bTn81XJxIGPMYTI5IkknqSpOsYRyhGapDbO7QpjmmPD73F1xH
	 TO1sxYSbJMAUIHp4k7wkmni4XkaoHqLxnP3DhQVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitrii Dolgov <9erthalion6@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 11/86] perf auxtrace: Fix address filter duplicate symbol selection
Date: Mon, 16 Jan 2023 16:50:45 +0100
Message-Id: <20230116154747.538797308@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adrian Hunter <adrian.hunter@intel.com>

commit cf129830ee820f7fc90b98df193cd49d49344d09 upstream.

When a match has been made to the nth duplicate symbol, return
success not error.

Example:

  Before:

    $ cat file.c
    cat: file.c: No such file or directory
    $ cat file1.c
    #include <stdio.h>

    static void func(void)
    {
            printf("First func\n");
    }

    void other(void);

    int main()
    {
            func();
            other();
            return 0;
    }
    $ cat file2.c
    #include <stdio.h>

    static void func(void)
    {
            printf("Second func\n");
    }

    void other(void)
    {
            func();
    }

    $ gcc -Wall -Wextra -o test file1.c file2.c
    $ perf record -e intel_pt//u --filter 'filter func @ ./test' -- ./test
    Multiple symbols with name 'func'
    #1      0x1149  l       func
                    which is near           main
    #2      0x1179  l       func
                    which is near           other
    Disambiguate symbol name by inserting #n after the name e.g. func #2
    Or select a global symbol by inserting #0 or #g or #G
    Failed to parse address filter: 'filter func @ ./test'
    Filter format is: filter|start|stop|tracestop <start symbol or address> [/ <end symbol or size>] [@<file name>]
    Where multiple filters are separated by space or comma.
    $ perf record -e intel_pt//u --filter 'filter func #2 @ ./test' -- ./test
    Failed to parse address filter: 'filter func #2 @ ./test'
    Filter format is: filter|start|stop|tracestop <start symbol or address> [/ <end symbol or size>] [@<file name>]
    Where multiple filters are separated by space or comma.

  After:

    $ perf record -e intel_pt//u --filter 'filter func #2 @ ./test' -- ./test
    First func
    Second func
    [ perf record: Woken up 1 times to write data ]
    [ perf record: Captured and wrote 0.016 MB perf.data ]
    $ perf script --itrace=b -Ftime,flags,ip,sym,addr --ns
    1231062.526977619:   tr strt                               0 [unknown] =>     558495708179 func
    1231062.526977619:   tr end  call               558495708188 func =>     558495708050 _init
    1231062.526979286:   tr strt                               0 [unknown] =>     55849570818d func
    1231062.526979286:   tr end  return             55849570818f func =>     55849570819d other

Fixes: 1b36c03e356936d6 ("perf record: Add support for using symbols in address filters")
Reported-by: Dmitrii Dolgov <9erthalion6@gmail.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Dmitry Dolgov <9erthalion6@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230110185659.15979-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/auxtrace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -2545,7 +2545,7 @@ static int find_dso_sym(struct dso *dso,
 				*size = sym->start - *start;
 			if (idx > 0) {
 				if (*size)
-					return 1;
+					return 0;
 			} else if (dso_sym_match(sym, sym_name, &cnt, idx)) {
 				print_duplicate_syms(dso, sym_name);
 				return -EINVAL;


