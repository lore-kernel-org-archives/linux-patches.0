Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33363A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gg5QNvIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3276C433CA;
	Wed, 15 Nov 2023 19:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077643;
	bh=NFsdwVICi3R/fZ+JJzbjpnfyd5nxHjZIsE1/KoRQBoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gg5QNvIRuF4Ptls6ihOxaLvvwvaumM9ZEEpGnMvjM1+SBerQOGQ3o8Hfsh99kRB8A
	 nH8OhKVhxEOKBbB7H43PnYIsIq8qPmQETnaYyWT71h79ARE4srxesA0FF8bxddQnht
	 1j3gptVhtr90KBzDz5Ey9Io3VfAA3iVCUA0NdCbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	He Kuang <hekuang@huawei.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 430/603] perf parse-events: Fix tracepoint name memory leak
Date: Wed, 15 Nov 2023 14:16:15 -0500
Message-ID: <20231115191642.592625493@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit ede72dca45b1893f3e9236b6ad6c4e790db232f6 ]

Fuzzing found that an invalid tracepoint name would create a memory
leak with an address sanitizer build:
```
$ perf stat -e '*:o/' true
event syntax error: '*:o/'
                       \___ parser error
Run 'perf list' for a list of valid events

 Usage: perf stat [<options>] [<command>]

    -e, --event <event>   event selector. use 'perf list' to list available events

=================================================================
==59380==ERROR: LeakSanitizer: detected memory leaks

Direct leak of 4 byte(s) in 2 object(s) allocated from:
    #0 0x7f38ac07077b in __interceptor_strdup ../../../../src/libsanitizer/asan/asan_interceptors.cpp:439
    #1 0x55f2f41be73b in str util/parse-events.l:49
    #2 0x55f2f41d08e8 in parse_events_lex util/parse-events.l:338
    #3 0x55f2f41dc3b1 in parse_events_parse util/parse-events-bison.c:1464
    #4 0x55f2f410b8b3 in parse_events__scanner util/parse-events.c:1822
    #5 0x55f2f410d1b9 in __parse_events util/parse-events.c:2094
    #6 0x55f2f410e57f in parse_events_option util/parse-events.c:2279
    #7 0x55f2f4427b56 in get_value tools/lib/subcmd/parse-options.c:251
    #8 0x55f2f4428d98 in parse_short_opt tools/lib/subcmd/parse-options.c:351
    #9 0x55f2f4429d80 in parse_options_step tools/lib/subcmd/parse-options.c:539
    #10 0x55f2f442acb9 in parse_options_subcommand tools/lib/subcmd/parse-options.c:654
    #11 0x55f2f3ec99fc in cmd_stat tools/perf/builtin-stat.c:2501
    #12 0x55f2f4093289 in run_builtin tools/perf/perf.c:322
    #13 0x55f2f40937f5 in handle_internal_command tools/perf/perf.c:375
    #14 0x55f2f4093bbd in run_argv tools/perf/perf.c:419
    #15 0x55f2f409412b in main tools/perf/perf.c:535

SUMMARY: AddressSanitizer: 4 byte(s) leaked in 2 allocation(s).
```
Fix by adding the missing destructor.

Fixes: 865582c3f48e ("perf tools: Adds the tracepoint name parsing support")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: He Kuang <hekuang@huawei.com>
Link: https://lore.kernel.org/r/20230914164028.363220-1-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.y | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 21bfe7e0d9444..da9aac47972c1 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -104,6 +104,7 @@ static void free_list_evsel(struct list_head* list_evsel)
 %type <list_evsel> groups
 %destructor { free_list_evsel ($$); } <list_evsel>
 %type <tracepoint_name> tracepoint_name
+%destructor { free ($$.sys); free ($$.event); } <tracepoint_name>
 %type <hardware_term> PE_TERM_HW
 %destructor { free ($$.str); } <hardware_term>
 
-- 
2.42.0



