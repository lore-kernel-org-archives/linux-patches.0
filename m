Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C81315D49;
	Sat, 12 Sep 2026 13:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218076; cv=none; b=kpP/19f+lVQmqXrQtcavMftLMukfgPkp9eo3AgrWEOdNX29yr6Qi1oBGyjc2qM1G3g+nA4H6hfWokxAdpO2sVXdP/qXuyoR+1SW1kIGcIyTA5aBCpXdYrKiq6SrA7SbtTQ7kqWkm8b7V/gcxayLEuCI4dLVDuwpSdV6dktkuPCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218076; c=relaxed/simple;
	bh=BNS0hMRk3M1YfLds6RrvSuFOD98IQjss4RFN7TAoa5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBCkB0Gsj9ftEY68NK/aTXW2+j5hNYq52Io5FhF9g5Mh+WBzEspcd8nOb0MmcIM/sKeHOIVpgMiq2B27enqdcqdSDKuON80RXJ45bqyfJq55HqT9Z2Dw+5O61RoiqGIb8zEwxpBT+tOSjjGps/eSYTc7GIgiKPG7v3wHT4kUOq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRjC2XWG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRjC2XWG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C771F000FF;
	Sat, 12 Sep 2026 13:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218074;
	bh=zOjTOiOW2/qmbXddH7PAYXniSLFRGam7osO6lSVgDX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRjC2XWGoM9CO25gm+N9wKgP7ihSg2lR9/1qS0rekG4Krhs7K54Ecv5t26C/5LPvw
	 s1R/lnN4aBpu6joj9CruraarcO3Lu+MGPsxcX6jf0BNt0awnVD8s6h7N6aeq/XNujh
	 Q0T1FFlCSPemy8noJ3Zu31on9VEVOFQXDFQ8MvP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1017/1376] perf test: Fix skiplist leak in cmd_test
Date: Sat, 12 Sep 2026 08:57:23 +0200
Message-ID: <20260912065630.230095495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 122f82e495ae7..17f723f04926b 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -756,9 +756,14 @@ int cmd_test(int argc, const char **argv)
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



