Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E47132ED24;
	Sat, 12 Sep 2026 19:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240191; cv=none; b=TR3sgAkTUNkUrUmBuuQOO/kZ9qXpnbOyujJ561uv/nx+IfKuZfoPHikcc0KlLTmEvk8Cxb6wfvbvJQGzziNuP4n5Fs0KlYuiPMJReAErurV42Re9VfRliKTs0Oif4cX0sW4a8qvl8EjxO1ukrChOw4zebRFbxQuGnnAOtTxFEqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240191; c=relaxed/simple;
	bh=lCqOz8AwZtbow41nioJHftduG1wbDrDlilai2UNmJX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIWq0PbrA11we7oGO91FSldDayBUN4IHfYUrinuWHXBLRx3xLiSvBcG6vGuozJKDA8dJoP9MjGz8rRF9c5r6BGwHO+apyxSGDqKCoCBOZoE/MDl2+m8+wc3E96URTKvrhi8DYmLi1RS/95alEji2Qc8kKsgrFMtxBoARp6TLYtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jlUtrZEU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jlUtrZEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229BB1F000FF;
	Sat, 12 Sep 2026 19:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240190;
	bh=nXnkbDru6E2ayS/Ye0cz5lOdA67XPzFWsRG3GeY4LEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jlUtrZEUKu0D/4Ghrdv9J7MYb83drd+5eTbJteIXtnJIct0CfQcGiN8guHBzmoQNm
	 jf0pXWkmljxgDTVixQtSEjCh4byjSDp/eCK0s0sv6x0JbURiFwFQOy9TQ+iEBx+RwZ
	 QC3HlF8edGijkKTee0aUv0MelJHwpbYukLxP2e+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 764/935] perf synthetic-events: Fix uninitialized pthread_join
Date: Sat, 12 Sep 2026 09:03:14 +0200
Message-ID: <20260912065544.357044550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 54ba44db4dddc4ca06b49bae0f9d6c5861430b18 ]

In perf_event__synthesize_threads(), fix an uninitialized pthread_join()
call when thread creation fails by only joining the successfully
created threads.

Assisted-by: Antigravity:gemini-3.1-pro
Fixes: 340b47f510bb ("perf top: Implement multithreading for perf_event__synthesize_threads")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/synthetic-events.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index c69ad7a1a6a78..66ba0fa1e3835 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -1047,8 +1047,8 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
 	}
 	err = 0;
 out_join:
-	for (i = 0; i < thread_nr; i++)
-		pthread_join(synthesize_threads[i], NULL);
+	for (j = 0; j < i; j++)
+		pthread_join(synthesize_threads[j], NULL);
 	free(args);
 free_threads:
 	free(synthesize_threads);
-- 
2.53.0



