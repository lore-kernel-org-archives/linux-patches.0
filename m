Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C69F3B52E2;
	Tue, 21 Jul 2026 21:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669310; cv=none; b=dorvuttPRLHeEsMmA8HyZSK55imG+zQW7Amx3J43zDuZvyKi276wfYhu8gSbIh83y4ZEfzZTUaOVu5Erpn0lQkcCn0nCljlX4Iw6mx9gF3qYuOdcfuY7W7XVHvOMvTa30SKhh376CHq8jotlulx4wmf7FxUd3efNOd0Vl8adtjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669310; c=relaxed/simple;
	bh=CoRSn2ohzjqez7/SJsKIS3Aob5VVYoar/FjkFVT3N6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndH9OmMOSKtFuPLnVnR6nvOp4pclX7yTXU4rHLzJ8HfQLe8VrFafEwfiyBid7b2m6qBldlo9R4eEWc23sSpfGm+XBMCiODHNUjSVuuD07wAtbD6hY+kyrv7W7KN/+XrZWKiGrzgDg//g8dm4SyxE8TNt5LtP5dLtSXMED/WarRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9gC+82P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9gC+82P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DC21F00A3A;
	Tue, 21 Jul 2026 21:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669295;
	bh=lfXrW0FbhMKls7r3r8ga2aWVAfIIwatNFyUQNvqYuRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9gC+82PiFQv+OjL+VS589XJhSiiS4qddu3sNCJ+Gwm70bbqWg0YLPJFmYfRBmjRc
	 Rfnp/On65fZ4LUBn6q6iijXSOMlVUahIjLuWtab1q/eMbWeeZ6eSrLZnxnYUFzS9pA
	 15X2WtAuM0TrZOVZR9hnxYH4yDT9Q1N9VtaszSu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Qi <qirui.001@bytedance.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0500/1067] perf: Fix off-by-one stack buffer overflow in kallsyms__parse()
Date: Tue, 21 Jul 2026 17:18:21 +0200
Message-ID: <20260721152435.798857253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rui Qi <qirui.001@bytedance.com>

[ Upstream commit 68018df3f55eba96a20dd703f5f276a6518f4963 ]

In kallsyms__parse(), the loop reading symbol names iterates with i <
sizeof(symbol_name), which allows i to reach sizeof(symbol_name) upon
loop exit. The subsequent symbol_name[i] = '\0' then writes one byte
past the end of the stack-allocated symbol_name[] array.

Fix this by changing the loop bound to KSYM_NAME_LEN, so the null
terminator always lands within the array. The overflow is triggerable by
a kallsyms entry with a symbol name of KSYM_NAME_LEN+1 or more
characters (e.g., long Rust mangled names or a malicious
/proc/kallsyms).

Fixes: 53df2b9344128984 ("libsymbols kallsyms: Parse using io api")
Signed-off-by: Rui Qi <qirui.001@bytedance.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/symbol/kallsyms.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/symbol/kallsyms.c b/tools/lib/symbol/kallsyms.c
index e335ac2b9e1972..d64bd9cc82a90e 100644
--- a/tools/lib/symbol/kallsyms.c
+++ b/tools/lib/symbol/kallsyms.c
@@ -60,7 +60,7 @@ int kallsyms__parse(const char *filename, void *arg,
 			read_to_eol(&io);
 			continue;
 		}
-		for (i = 0; i < sizeof(symbol_name); i++) {
+		for (i = 0; i < KSYM_NAME_LEN; i++) {
 			ch = io__get_char(&io);
 			if (ch < 0 || ch == '\n')
 				break;
@@ -68,6 +68,9 @@ int kallsyms__parse(const char *filename, void *arg,
 		}
 		symbol_name[i]  = '\0';
 
+		if (i == KSYM_NAME_LEN)
+			read_to_eol(&io);
+
 		err = process_symbol(arg, symbol_name, symbol_type, start);
 		if (err)
 			break;
-- 
2.53.0



