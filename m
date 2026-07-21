Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD8A4189DA;
	Tue, 21 Jul 2026 22:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671823; cv=none; b=RCYHLyiHKepqt5J/0dz++IBYYH7z3Flxv8ttIxQ0qcPdgwJ/20M6IrHdfwKqOGzGDFuYkjKgAEiIRUowaApz/wRh3h1Dq5Ut5YhRzILOKWfvagF+hCEy5ZTh/BBftnClHwa/db8MPvMgxQsiaM6KgPC2m2thnSzOGN0pn4J8inA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671823; c=relaxed/simple;
	bh=/qnJIADV7BkBJzDR00pHCN+yfjhxuLpwYBS3fssEzc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FuJ1IOqxzQ2G8apk4Dn7dDiEVgaSKluI4cpnsP2bxk84SUlMzVHstZImrCM2bRtQOrZBc6i/oAjt/Teb6TH7kfarMhxyYR+8nXqInsguwVADtqOW6THOBJaOJBJcZq/eSZ4bE7RcrMRH4g3t6Y5dwu++T7feeP0irBDz3BcjtdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zUvJj7ux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zUvJj7ux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7ED31F000E9;
	Tue, 21 Jul 2026 22:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671822;
	bh=6a0/jsjR0xFQqRS7qPcdO5fCWJUdLrV/6CtXlRZUWcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zUvJj7uxGdCGRqM6uuaMJ1K+MzE7NPXPRTpy+GuXmdz0lbtgrn6XqPvQ99tqWt1VG
	 H8HSr8wyjFAZZnb5CGCpudC/fqeemQC0BYB44cLO49eV2a/YAUSrbNd7n7Rr0S172S
	 foVTOcGjH5TpwTEwu6N/Qw8d8TPwIAY7CT83x4po=
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
Subject: [PATCH 5.15 391/843] perf: Fix off-by-one stack buffer overflow in kallsyms__parse()
Date: Tue, 21 Jul 2026 17:20:26 +0200
Message-ID: <20260721152414.832364349@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



