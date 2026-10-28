Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210484;
	b=IUWWErnWu6bsQ4Av//a5Xe9JQBcpumgEX5nFHP7rKNGBpTbsXhD3OFxe2k4nvw6bATbp
	 Fjs4JjWtvAWfrF8yWctiPjRxY0L3XrwgsOeamwdPyAsnpFlC8Wzvcbg8EgRnwO+GquiQf
	 CFKZMI3RPz4n4kDusGj0jzp8dljAgc/AGKQyTQVsmd4xuW9sNVoP69phLAtOLS86KVoC6
	 SlF5tfLX3MGucwrI/kucZbOlAGHNtW0E/0CUqvcuOhvO+RcZJesDiEI6tsdlvKX3mq+Qk
	 Ly+jOdJqnC/vNiyOUTQsIPYzlr+tXqzP5wtsvDDRz+0yVkDG0tLZXYiq2A7HjHdW51Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WKfDgVhn0IOtxe6nQCit1YKQX/7ffyM3KvgnNbVkX+E=;
	b=gKa95Rg3evFTUXcimDUKj/2OzDXFrQZcrDk+ifFihew+1H3eWe7rLcehMwwozjTMt3PJ
	 JBvot0T+jrrCpSZC6qeNVE0+jrOKb6UFPG6Pkc1Mokyq7mFqbTmS+0G2+sxHHEcH2u7e5
	 wuT5K1gwnt+ursug40zJdJe+z6RHjWSCCTt7R92nj37gUb8c/4QGCYcTDSdHQaxz4IQNR
	 ABz6FXMLFRsQ5ETreSn9H1cU5qj8FcDqRrjZODQ9vXy6Tn92OFy2S3Laade/zcAuHIj0s
	 Ww2kSzvyOS4xbXKBBJdAnJ1/uE6HcHvCzM8LhjMKUM6SfbcmqkYXPeYnCA/PnE4u51g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uzl2myLv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DC2606A332;
	Wed, 28 Oct 2026 18:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uzl2myLv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F861F01825;
	Wed, 28 Oct 2026 18:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210483;
	bh=WKfDgVhn0IOtxe6nQCit1YKQX/7ffyM3KvgnNbVkX+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uzl2myLvUwH+9AlMN3u7UMWoL+jq6IGAbjL3BRQGaAZc58TYdZlgdnYPt/u3Eo973
	 gzOAmdNvbk2gu1Ykodc/tx4dJgAvIG60vxpStsK1siYGmRkSFKU20A1oFifAAtrZ8t
	 /2V3hQhqd3HchAzrO0bDUks18/Zq2dwgrL/mMWZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 043/571] perf tools: Fix a asan issue in parse_events_multi_pmu_add()
Date: Wed, 28 Oct 2026 17:53:10 +0100
Message-ID: <20261028170009.047769800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

commit 66c9598bd8916c6c1319d0100ac916cac89d4b0e upstream

In the parse_events_multi_pmu_add() it passes the 'config' variable
twice to parse_events_term__num() - one for config and another for
loc_term.  I'm not sure about the second one as it's converted to
YYLTYPE variable.  Asan reports it like below:

  In function ‘parse_events_term__num’,
      inlined from ‘parse_events_multi_pmu_add’ at util/parse-events.c:1602:6:
  util/parse-events.c:2653:64: error: array subscript ‘YYLTYPE[0]’ is partly outside
                                      array bounds of ‘char[8]’ [-Werror=array-bounds]
   2653 |                 .err_term  = loc_term ? loc_term->first_column : 0,
        |                              ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~
  util/parse-events.c: In function ‘parse_events_multi_pmu_add’:
  util/parse-events.c:1587:15: note: object ‘config’ of size 8
   1587 |         char *config;
        |               ^~~~~~
  cc1: all warnings being treated as errors

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20230331202949.810326-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[florian: Resolve conflict in parse_events_multi_pmu_add() where term
 initialization is located inside the PMU scan loop in 5.15.y]
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 7e4939640196b..f0750b8bf66c8 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1686,7 +1686,7 @@ int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
 					return -1;
 				if (parse_events_term__num(&term,
 						   PARSE_EVENTS__TERM_TYPE_USER,
-						   config, 1, false, &config,
+						   config, 1, false, NULL,
 						   NULL) < 0) {
 					free(list);
 					free(config);
-- 
2.53.0



