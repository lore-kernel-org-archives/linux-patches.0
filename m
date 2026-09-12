Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2474639A4AA;
	Sat, 12 Sep 2026 08:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202811; cv=none; b=PV1HeaWduJh0HF1nPXrKmuHceziQwI5JY/G1A6f3ZAKHyCFn0xS2uk7knmgtcqK21Zu36sbMyHHg22Mso1iu78O4Z6DCrbgeX0Dhr025YUGjIjzWtt/s4K9N3keh6oDVxoufYsKDMj9yIIcjwzeKWEIcOUwSeZaQJ5Mku4HVrM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202811; c=relaxed/simple;
	bh=TaZVmnuCi2TW7lQfQxhGpOZSM0KV5U+MR9FIx82ZrkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioRLJiH+WCiZYNEX2wF0JpGkegcl1HYFQ078Ta9chD7PHOxrLSS6PQZyNkel74AWj4AmgTuDhaJ1t6lH/Ripg4qH0wmgGmMjS/6J6S6QstLfF+UAwQbJo8nP6gBPr2DI5qlgswHipq0EbZfndEG0rarRUWQhSCbTiFutHSI2N80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tOsIE9u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tOsIE9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FAA1F000FF;
	Sat, 12 Sep 2026 08:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202806;
	bh=zhP4A6gct5lVqUpbYrSsBvqfVLDag+BtmKKLPRsrSE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0tOsIE9u01iEW7cFA9u9KxxhbbKKheJ0bR65hE4xm1EsJ0y82ZiuLYMdJDt+NBmJL
	 3yWHHiJHWi/EOeCfsDBnJEiUHfzZQp5KEaz/FOsGx4xe73UZAi1O4aAkg6lrj5/1hk
	 nkd6ETu2MnDqltlQ7jukXgebCD8Y4VNf+Nk/qE2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1277/1815] perf test: Fix skiplist leak in cmd_test
Date: Sat, 12 Sep 2026 08:50:27 +0200
Message-ID: <20260912065718.994191584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 8b8f63f706d93..9662223274325 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -1796,9 +1796,14 @@ int cmd_test(int argc, const char **argv)
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



