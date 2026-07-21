Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A4D35C6AC;
	Tue, 21 Jul 2026 22:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673786; cv=none; b=IMoUF4gjlJKWr8oT5SwAwcO8O3Ep2+SkDL1tZ4u2YjjFVBEnzRQSGCihT38rpYMc0Nh1Ui0jhAqkqcS1DtfN2uF8BRMXiZKhsSIfEN3YSs4r13AfLAh82dE7FHKlct+R0evwv27OF8Jm3uDp+wZTOVspd270RNfSczt7fqTDz9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673786; c=relaxed/simple;
	bh=0UrSFajf815GFGRa28FXTJONXqZAocjocp/cmImlRHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzEveO4+Kr78T5hkbmGfNUw+jOHLZKaFgBZ5zIzOQo89fiTzqsWdvAHm1lYp4/2jgWfrIpSwLvQ7eP1zQw0jjcUYdNdM5zeElvtfv1vfJjrnifn6teU4bJa30K6HuXwEsk1A+uBqc51CdQ2gTF+NzVeswbJQvzFGkgt7hP2N+98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghkA3gfI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghkA3gfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA311F000E9;
	Tue, 21 Jul 2026 22:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673785;
	bh=N1QlIkh3AwzCqa3mfmqU9aV0YeQ9APJP/5c+2UeAamk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghkA3gfIMVK621fEWCyuh+x93MUSRxHxrd+0w5mWmuONo+E0Iic5roUxMPZ7xK0Lx
	 TxeJLXzCy0ndnt16O2JQeDzx/TeAE8d2p3W6QlD+qPfVSX6h1PrxI7ygl9kxB3cy3A
	 pHj60FmGFOnALsXcOZGg73OWwjeJKtxKmf/8XYjw=
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
Subject: [PATCH 5.10 294/699] perf: Fix off-by-one stack buffer overflow in kallsyms__parse()
Date: Tue, 21 Jul 2026 17:20:53 +0200
Message-ID: <20260721152402.328189275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



