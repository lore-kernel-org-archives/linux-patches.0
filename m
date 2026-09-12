Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0524BEE2A;
	Sat, 12 Sep 2026 10:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210581; cv=none; b=Fh7hHrnZSX5SCNH9LizR2AXT2aEBPQWnn9DFYWOoHK58Zj05+PF3cb5kC5wVZy25Uox/oKcF2l7IEiCNmFyFPWU/ivLRtPwzAg5YJcyBHylUHg0RNpCnt/o8bEAy6uPNUxQKPyLzgizlFYW+vJA6rFPhB5FUyWCWgIS+wZm3t6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210581; c=relaxed/simple;
	bh=UZa9oO33+Zotdr2HDRy/jURne+2HW4rnO2Up9sc7hzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CM6TYryjRMp6QAI/a11D797aYAraTnHHTHa5BRxxiKAfvfm2Gs0sOfhiYWja9KGgmX5BiFlnk9qISXsaLcsINDrN4bJTaO682MdvnApkaIU53qHWXY9rf+R8x2451zDefefQdeC6cFn9/2wpS76kynknyo8L4TDpOImN5D4GUJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTc3Ux8h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTc3Ux8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63601F000FF;
	Sat, 12 Sep 2026 10:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210579;
	bh=s5lrgdBVolr93v3V1+x2B9VtIWlmSPgEz6J43n/VkGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tTc3Ux8h004LdWMzL3oMjVsUzN9BgkbERzgH0bxCSngh5xgkzw09C9cSZqAvVIZjP
	 wMCcBrVmEk+Vcrhu8T0U8hPaGby2tbwH7hcxMOc5FP4Qq8oLuGpUF4X0Iq5Bv0q7oZ
	 AQA2CDvoKk+4QaI6m8pkRSVqz/XKZHfnEVrSwFCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1053/1518] perf test: Fix skiplist leak in cmd_test
Date: Sat, 12 Sep 2026 08:53:42 +0200
Message-ID: <20260912065647.271645307@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 44e82c4d2ff37f073946b594840fd549ab6b9fb8 ]

Fix a memory leak in cmd_test() where skiplist was not freed on
exit paths.

Assisted-by: Antigravity:gemini-3.1-pro
Fixes: 2ae828786c65 ("perf test: Allow skipping tests")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 814cd7d922c12..a4ee849ad8646 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -1605,9 +1605,14 @@ int cmd_test(int argc, const char **argv)
 	rlimit__bump_memlock();
 
 	suites = build_suites();
-	if (!suites)
-		return errno ? -errno : -ENOMEM;
+	if (!suites) {
+		int err = errno;
+
+		intlist__delete(skiplist);
+		return err ? -err : -ENOMEM;
+	}
 	ret = __cmd_test(suites, argc, argv, skiplist);
 	free(suites);
+	intlist__delete(skiplist);
 	return ret;
 }
-- 
2.53.0



