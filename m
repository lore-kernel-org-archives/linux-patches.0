Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE43332913;
	Tue, 21 Jul 2026 18:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660362; cv=none; b=bkMBya+0RJPEk/wLORIb3rjbpUfoBohy5qK0yTYsCuSkiefrq2vOh1ubCYq9umr9sMVVHW+Wlc48ORjA8Jp2sDQmxXM2cWca6OVs5qDMrAg3N5r8dzKCQwVF+U+QThbfv99tmLXblXvRc8mttm+22hZYhXL8/2VOktLhUiwkODw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660362; c=relaxed/simple;
	bh=dt0mXJtHQb0rVDB9LCTP67RGQvTpqcqeLVC6A0/flZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmsMcArOG8NOopW0egLSiN2V5dJiJqWlBKFVd2z3irfFdeBo7uRFdKkF3jaCrVoewRVKfFReL948cMRT/+/CfD5+82tZwFTSHheFtvxjzUKu+I/d3E7CvEpUGQqeNc00wSku+IHaA8YXM/6H6jcgA/dADTGVhzDLFKZldclnom8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5p69Zvi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5p69Zvi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFD11F000E9;
	Tue, 21 Jul 2026 18:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660361;
	bh=QqIMvidvlfCNWhvSVueGcsig799B3Ad1rbUKGhwlRd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5p69ZvisWf/fJK7ybwEYbTRfZapv/40E0A03rgNvFAAwXdJwTvjtbTJCaQP/jg4O
	 qatsIO5IQYPOhTn7ntEhZPSRjX5MOBX7xpLSKSbFeq9KyavDspEuZp+cJiQLOZ7YQC
	 qopmK35XsDrehIhLXNyVjhp2/a8wBpxa5JeF5W6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0950/2077] perf c2c: Fix use-after-free in he__get_c2c_hists() error path
Date: Tue, 21 Jul 2026 17:10:23 +0200
Message-ID: <20260721152615.224322704@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 5e5e6196d737c5be03d20647428316b36621608d ]

he__get_c2c_hists() assigns c2c_he->hists before calling
c2c_hists__init().  If init fails, the error path calls free(hists)
but leaves c2c_he->hists pointing to freed memory.  On teardown,
c2c_he_free() finds the non-NULL pointer and calls
hists__delete_entries() on it, causing a use-after-free.

Set c2c_he->hists to NULL before freeing so teardown skips the
already-freed allocation.

Fixes: b2252ae67b687d2b ("perf c2c report: Decode c2c_stats for hist entries")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 8296ec85e8595c..74ded7d238c800 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -221,6 +221,7 @@ he__get_c2c_hists(struct hist_entry *he,
 
 	ret = c2c_hists__init(hists, sort, nr_header_lines, env);
 	if (ret) {
+		c2c_he->hists = NULL;
 		free(hists);
 		return NULL;
 	}
-- 
2.53.0



