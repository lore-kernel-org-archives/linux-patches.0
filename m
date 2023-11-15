Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D8041A80
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzgGZ5rA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E9CC433C7;
	Wed, 15 Nov 2023 19:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076809;
	bh=+qpAMW+0IfjIHW0MJTsiJ0Q/86YVNoW4egzyePptyYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzgGZ5rAAmqPhMuLa56opKgBPaRYFgHNtNKxo6HINq7XTXttmLSflYtymYtZcvfGn
	 2uRKOrddVEjrYJ7zPhfJI2HewOjMr493MunFrGLCLqedmHIioSvV5J7kUF/0VuE9jz
	 DdTZtc8N+V3PfXmmjAcRv9Ek63oqGnZTWnQ1GPFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 425/550] perf parse-events: Fix for term values that are raw events
Date: Wed, 15 Nov 2023 14:16:49 -0500
Message-ID: <20231115191630.219192074@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit b20576fd7fe39554b212095c3c0d7a3dff512515 ]

Raw events can be strings like 'r0xead' but the 0x is optional so they
can also be 'read'. On IcelakeX uncore_imc_free_running has an event
called 'read' which may be programmed as:
```
$ perf stat -e 'uncore_imc_free_running/event=read/' -a sleep 1
```
However, the PE_RAW type isn't allowed on the right of a term, even
though in this case we just want to interpret it as a string. This
leads to the following error on IcelakeX:
```
$ perf stat -e 'uncore_imc_free_running/event=read/' -a sleep 1
event syntax error: '..nning/event=read/'
                                  \___ parser error
Run 'perf list' for a list of valid events

 Usage: perf stat [<options>] [<command>]

    -e, --event <event> event selector. use 'perf list' to list available events
```
Fix this by allowing raw types on the right of terms and treat them as
strings, just as is already done for PE_LEGACY_CACHE. Make this
consistent by just entirely removing name_or_legacy and always using
name_or_raw that covers all three cases.

Fixes: 6fd1e5191591 ("perf parse-events: Support PMUs for legacy cache events")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@arm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20230928004431.1926969-1-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.y | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index c4f675f15fa91..a049c577bae3d 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -81,7 +81,7 @@ static void free_list_evsel(struct list_head* list_evsel)
 %type <str> PE_MODIFIER_BP
 %type <str> PE_EVENT_NAME
 %type <str> PE_DRV_CFG_TERM
-%type <str> name_or_raw name_or_legacy
+%type <str> name_or_raw
 %destructor { free ($$); } <str>
 %type <term> event_term
 %destructor { parse_events_term__delete ($$); } <term>
@@ -721,8 +721,6 @@ event_term
 
 name_or_raw: PE_RAW | PE_NAME | PE_LEGACY_CACHE
 
-name_or_legacy: PE_NAME | PE_LEGACY_CACHE
-
 event_term:
 PE_RAW
 {
@@ -737,7 +735,7 @@ PE_RAW
 	$$ = term;
 }
 |
-name_or_raw '=' name_or_legacy
+name_or_raw '=' name_or_raw
 {
 	struct parse_events_term *term;
 	int err = parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_USER, $1, $3, &@1, &@3);
@@ -816,7 +814,7 @@ PE_TERM_HW
 	$$ = term;
 }
 |
-PE_TERM '=' name_or_legacy
+PE_TERM '=' name_or_raw
 {
 	struct parse_events_term *term;
 	int err = parse_events_term__str(&term, (int)$1, NULL, $3, &@1, &@3);
-- 
2.42.0



