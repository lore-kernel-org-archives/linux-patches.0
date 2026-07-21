Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BC9399036;
	Tue, 21 Jul 2026 19:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660760; cv=none; b=Ic0rd9SBG4PjX1tbCOnW6DsC8NdfPzK9BP3O0oopxj9+/FN+PXWRT6dCFwLSlTqENM/O3H/ovMkZM+8a44XZlwEWRI1ibUNvRNC8I3uFWI0y3Dhd3vPf364jScbH7BwdPHhIG3w3mZPKJbLsFIPDUteNvKV6vE90jF9lE3IYtEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660760; c=relaxed/simple;
	bh=4Bcx7mENnalDcl9BLHN+OLIWT6kLkwVXIQeB1GNbpIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZIdY5X1VR2JetT9+Akirqc/D5+a3u8WfztHujVrJuwURwx6MwSRHh1Khx8X5woSHfoSHVckCLiZYyRkNEQJa0tGUWBLBMyhwvcYu/IQ5EeJ03zzfugcodyWdNvIwpUXpDXVWvYUH0JVQikJNf35mB9Bv0renjs1Q35xntFvQ3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EeNzFc2m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EeNzFc2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9211F000E9;
	Tue, 21 Jul 2026 19:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660758;
	bh=Fz3OHnrgS9GeK8BF1sly/XNJjirJeVt+YeZmKkDHGZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EeNzFc2mbSUvYYkO+CnHmyY/cS/AnY3Qbxq96gHrquHvenSFx5Qv/rsCsUxRKstHz
	 5ayRDNZIVbqo4tvxqMDvHqS1C54zGUlZBAtxCcm3lFczfhFoY0wVGY75pCYS2gUUkD
	 duS38GhS0UTqLSRAHDYVHICbAysMEfR60IVq3jTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1099/2077] perf c2c: Fix hist entry and format list leaks in c2c_he_free()
Date: Tue, 21 Jul 2026 17:12:52 +0200
Message-ID: <20260721152618.741354993@linuxfoundation.org>
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

[ Upstream commit fe68cf349fb343c0a7cb6c4fe6c3de4f4afe8d1c ]

c2c_he_free() calls hists__delete_entries() which only walks the
output-sorted entries tree.  During c2c resort, when cacheline entries
are merged and the redundant entry is freed, the inner hists have not
been output-resorted yet, so hists->entries is empty.  The actual inner
hist_entry objects live in entries_in_array[] and entries_collapsed,
which are never walked, leaking all inner hist_entry objects for every
merged cacheline.

Additionally, the dynamically allocated format entries on hists->list
are never unregistered or freed.

Fix both issues by switching to hists__delete_all_entries() which walks
all rb_root trees, and calling perf_hpp__reset_output_field() to clean
up format entries.

Fixes: bf0e0d407ea09ce5 ("perf c2c report: Add sample processing")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-c2c.c | 2 +-
 tools/perf/util/hist.c   | 2 +-
 tools/perf/util/hist.h   | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index 219de790c3766a..e7b9909e1ac247 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -180,7 +180,7 @@ static void c2c_he_free(void *he)
 
 	c2c_he = container_of(he, struct c2c_hist_entry, he);
 	if (c2c_he->hists) {
-		hists__delete_entries(&c2c_he->hists->hists);
+		hists__delete_all_entries(&c2c_he->hists->hists);
 		perf_hpp__reset_output_field(&c2c_he->hists->list);
 		zfree(&c2c_he->hists);
 	}
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 2038c1d20acffa..aca9ff15518a2b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -3041,7 +3041,7 @@ static void hists__delete_remaining_entries(struct rb_root_cached *root)
 	}
 }
 
-static void hists__delete_all_entries(struct hists *hists)
+void hists__delete_all_entries(struct hists *hists)
 {
 	hists__delete_entries(hists);
 	hists__delete_remaining_entries(&hists->entries_in_array[0]);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index d97a4efb925057..3a59200d2517e9 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -392,6 +392,7 @@ int hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
 void hists__delete_entries(struct hists *hists);
+void hists__delete_all_entries(struct hists *hists);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 struct hist_entry *hists__get_entry(struct hists *hists, int idx);
-- 
2.53.0



