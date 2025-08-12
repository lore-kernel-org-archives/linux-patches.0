Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1A52CA9;
	Tue, 12 Aug 2025 18:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024384; cv=none; b=PqLOJUQzeHQt6wMYPMx3Y/4bHAKLWKmr2WGO87bE7gUwmtjT8RkzZxkryeivtq4KS4K0Rk+srzZdl+uQ4pAJgDgutROzu1u69FS5PGNQSvJwbYjOppv+9VCCVhqiT+8x845PWwO0Mj8vGK2vwDqWpwFHRb3YAZ3uOGJCHY/jMnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024384; c=relaxed/simple;
	bh=kyDP+a1q74YEnlMXSAHjTlmvMkbgkW412jP3ykJDdZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppjkaLCZKGetCMwtj77CPP0Eb3BcF8prWMiYmFeCLkcxuiMip7MLTP/oRjg0Y5+xpJ5Rf0d7nZlhWLNyE1PoK6LF1wJ3K1DxGGUU86YoIv/X9O9xHKLIdnq2tqedHr9QS+pFCRZSxHaAMrTozNjqz8nJVnloYKleRBGPEGaYTQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCiXh9bu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCiXh9bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BFBC4CEF0;
	Tue, 12 Aug 2025 18:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024384;
	bh=kyDP+a1q74YEnlMXSAHjTlmvMkbgkW412jP3ykJDdZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dCiXh9buJ3tjiCWMai3xw+vOeOsybQx/UVYwg9vDFSMjkjG9HzFwFHqjMirbsFXAi
	 LWEB9EsyOswODIET9DvxmGmmAPoAKd1hkkE1kkAxeyZG3p9SQnopC84Qos54OusAMo
	 8/gRi1peG6gjUPvFIe4ZibBGdhIbwwR2lMBOQQ0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 358/627] perf sched: Free thread->priv using priv_destructor
Date: Tue, 12 Aug 2025 19:30:53 +0200
Message-ID: <20250812173432.917035573@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit aa9fdd106bab8c478d37eba5703c0950ad5c0d4f ]

In many perf sched subcommand saves priv data structure in the thread
but it forgot to free them.  As it's an opaque type with 'void *', it
needs to register that knows how to free the data.  In this case, just
regular 'free()' is fine.

Fixes: 04cb4fc4d40a5bf1 ("perf thread: Allow tools to register a thread->priv destructor")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250703014942.1369397-3-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index b7bbfad0ed60..fa4052e04020 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3898,6 +3898,8 @@ int cmd_sched(int argc, const char **argv)
 	if (!argc)
 		usage_with_options(sched_usage, sched_options);
 
+	thread__set_priv_destructor(free);
+
 	/*
 	 * Aliased to 'perf script' for now:
 	 */
-- 
2.39.5



