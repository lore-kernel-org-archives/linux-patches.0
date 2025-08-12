Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCD72FE597;
	Tue, 12 Aug 2025 17:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021562; cv=none; b=a72QTiMfvzfxK9x+twgsTo/0erRS8lHEYwKHA1+1VLamp514KI7/DR/YoMlxKQYirri1S749Q1oUA5GTy2EMADlaht4j4AbPROGCM5+ZhrdmnZ9eRca0vOKY3DpAuFR+2+lAUup723PHfnKu2hnxj6Is10V6XouZCsP7qsOx088=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021562; c=relaxed/simple;
	bh=rXPVfAt6+yyC9ait8OhyKuY+q6YmEqTMc2QA/KD62jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cqw8PHAbpbv8A34fyMCkBpwiZu8YAOfz5PmxpoUFspsVmJZxO9EobJIKC5v0931R7i6Qr0jsPELOea3U9RsqAEdrHclGJ2k6xy/dB9T8GGlazgAwFqY2pI1F4V/bRbS3mwPX+UqdJ+Ga/z0Y2P1ti18mybBd9tb9LHgyq3m5HMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cCjp79j2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cCjp79j2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD45EC4AF17;
	Tue, 12 Aug 2025 17:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021562;
	bh=rXPVfAt6+yyC9ait8OhyKuY+q6YmEqTMc2QA/KD62jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cCjp79j2lSKLQ65bNURVcDBwNGJwNHSZS/p1TSC/n4ZnwsfgABajuqshOM3lhwE1L
	 zKh4oozONIJa67ralxtv0HzlWBz2/nQHs0DZtRL9eYQQqcr9gneXa28jw+D0bE8U+H
	 IHHOcyI6giA2K76IqnOppDfUwPRVxYUozdqerlp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/262] perf sched: Free thread->priv using priv_destructor
Date: Tue, 12 Aug 2025 19:28:33 +0200
Message-ID: <20250812172958.428693937@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ac9d94dbbeef..5f4fb1ce1ea9 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3678,6 +3678,8 @@ int cmd_sched(int argc, const char **argv)
 	if (!argc)
 		usage_with_options(sched_usage, sched_options);
 
+	thread__set_priv_destructor(free);
+
 	/*
 	 * Aliased to 'perf script' for now:
 	 */
-- 
2.39.5



