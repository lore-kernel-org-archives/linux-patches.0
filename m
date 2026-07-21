Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71FCC46D088;
	Tue, 21 Jul 2026 18:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660296; cv=none; b=lkmpza+AXJmO0XtE3sqLAQomsqZf3/5JG1qzWFdNjuSwYLSp17fGLePrLiC1zS5TcYLZjFbXxYASWfigvh0tDpvFoSyAZwkz/COfIdVJIaC4iDdMtW3xd2CUX8KJ6j/TXS7TYpNLl/BsdTZGZBfS97KxW4Di1lSmPvly6VrZY6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660296; c=relaxed/simple;
	bh=+en/mnWm2Oe1KchYEg6jJDabHboHbP6fm40L3rdGn0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5v9g/ZpD1t2Bo1q7yp53Ohcc68RLseR3Dvc2HQcKgXKzMqcead3sQwMq80q+aMh6M8O3bFZvMd9nldwRS/4hd6Ty4Zdm2v4uh4nVhvRwttSCwxybpshKlO00AeKBQ5hG4+uZEZlj0pOpF8530yUTyjSg25nviW0Pn78ntXr+90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MvCSaacS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MvCSaacS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE70E1F000E9;
	Tue, 21 Jul 2026 18:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660295;
	bh=yDHoP6JzA0i8JqYh+drwY8IPd7RMg9yqrnLyIIRfpLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MvCSaacScTCgHMI3PbwFUqC+ZmxU5x8R3v4RRPWf24tb9hWGTY+H9E1IWLjU49G7t
	 Qx26iPLTF1+/hX05CRpgL1CjxI3RNKqmlLwRCS+FzkY8oTdo8doYHNoJ4Z9iAbLgrf
	 mz5WBFfKohUdmWF/tkIu5moMk8F2Sa6W7ksvY9d8=
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
Subject: [PATCH 7.1 0927/2077] perf: Fix off-by-one stack buffer overflow in kallsyms__parse()
Date: Tue, 21 Jul 2026 17:10:00 +0200
Message-ID: <20260721152614.678418401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



