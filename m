Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208426;
	b=0RLqJI6SqLwsS2OYrlbC+GoKH/G5wCrfzO57uaCXSHBcVuicyDmr8It2AN4QoWbm8tlE
	 g41gmQFy4LXradb6TtLW/u3278fhw5swA/wRMVCE8cEnXr+nb+UpKbLP1hNMqkLixFl/B
	 DnKGZixGPRz7frg88uwTul08ZBSsUhHvloDliuD3ojX3ypmsj7Vyqb+t0ndg0D3s1TKvn
	 +u1J6XXN7v6/bJ7DaV4Rs1v+ilpt0wF6b9Ct+s/15ciyUIMwBg+FTA8KYghYrj/gyoEvz
	 HSmf7YjAlj8F4VY5la8Te8f4X2F9dJL9i9wfqvpN5OJ0BNfRJ6jIL4qr+T1QJiF9eOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208426;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FWhL2ifnKuTlwSVzB1dEyxzWjexGaYrmusaYcD/j8Yg=;
	b=GM47ADb/NwidnwmXfb3Lgd9meVBF9V8hsNCkdAl3x2nDfom+o/1XSKqroa1uuhvcNovL
	 qLDQyAqV4y+xtL7dLodMAvHBBCVKTfUJh9Cz8VrL0KKzf0kcp1bDxj7AoOQ8L7qnJ8Fgq
	 GC5t1ZEYDgW84t8r6MEMqwfFC3Q/1dZx/KMAwSC7ePrEtscAtn/eLal1CFb+I5SMTGFv8
	 8uA56nrSw1F9dsmFeewHeXukKDPNBR0O0F+5tLdWldTfOdIfv8MyFxY5VMv8AXOdUcWXO
	 VhYHzRgruDZbabCozVbc/EpKpZHxiXp6idZPQHO0oXGJHN1yome2jc4Y3R307a6bV6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2oJnNyNN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF05E606A31C;
	Wed, 28 Oct 2026 17:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2oJnNyNN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BBE1F01825;
	Wed, 28 Oct 2026 17:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208425;
	bh=FWhL2ifnKuTlwSVzB1dEyxzWjexGaYrmusaYcD/j8Yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2oJnNyNNk4zPAuXIeqwzFKWSmd4vb9WIiAZjHz3OQO9Ec1T/S/klz8mdI7kqyzQgM
	 VP21fkzfDbNT42LjXTIMIjP6ZZ6+ZiIn2SgeVS434X7ohPHzW1X0KaKW1QKFmmQ2gR
	 H8K23/es5rrLW2RmHYKn4/R8zDixKFZ+wjsZ8ZME=
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
Subject: [PATCH 5.10 115/516] perf tools: Fix a asan issue in parse_events_multi_pmu_add()
Date: Wed, 28 Oct 2026 17:54:27 +0100
Message-ID: <20261028170006.242579914@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

commit 66c9598bd8916c6c1319d0100ac916cac89d4b0e upstream.

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
 initialization is located inside the PMU scan loop in 5.10.y]
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index c56a4d9c3be94..28a4588c18089 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1593,7 +1593,7 @@ int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
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



