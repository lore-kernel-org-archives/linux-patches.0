Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCD161FFE;
	Tue, 12 Aug 2025 18:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022631; cv=none; b=BnUJEPw+Nl0gVXMDzT/A4bFOQFqUD0kqQZ6amhV1FKaYQHoep9ia46qZvktgb7qwkk6fQWyfSU9orrtJDbUWOOpP2psyrhU9yvJouSkmpd0P+nQn4jWq2iIyiPIdxIK2SsSl/EJc3vFf6WjFszeA+U8cGyyjrq7fAJCEpFypSfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022631; c=relaxed/simple;
	bh=Ra2QsLhymIjXESY7aSXKpeWfIfUtKDDtb4TPEaAiyLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJ7+S1KuT5CH0dr2k0OUc0lz0+ic8pLKnxITRjBTV8zK1U1xQz63K0/ICGJ7D4XeTWXhLwsLOvQLXz/cGfFOSxvcLRHe2LtgDnNhY6T9/YgrpEAQwsfIheH6Kks/yM5qQ9Fj18BKIrMmqmMCMbEOi6UDjFg6gAWBF3H/mW4rqgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QG3EPD1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QG3EPD1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF081C4CEF0;
	Tue, 12 Aug 2025 18:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022631;
	bh=Ra2QsLhymIjXESY7aSXKpeWfIfUtKDDtb4TPEaAiyLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QG3EPD1tma4jO93z6YEalD021i5HPWdLonPX1SvDFz/wavrCW/jQjQiafOH2Dn8lG
	 x1a3PGRw2huc3k9WL9CtS9DUm96DBIn9whDR1trFaP9wwLYPDtZSnpDXcgkHexP92s
	 S9/fEmW4ZQU8SFoVW4mKAJWXt4fpmIMUVR7vVH7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/369] perf sched: Free thread->priv using priv_destructor
Date: Tue, 12 Aug 2025 19:27:56 +0200
Message-ID: <20250812173021.509664250@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 864fcb76e758..c55388b36ac5 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3887,6 +3887,8 @@ int cmd_sched(int argc, const char **argv)
 	if (!argc)
 		usage_with_options(sched_usage, sched_options);
 
+	thread__set_priv_destructor(free);
+
 	/*
 	 * Aliased to 'perf script' for now:
 	 */
-- 
2.39.5



