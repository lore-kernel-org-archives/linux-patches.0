Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA4C2FA0DB;
	Tue, 12 Aug 2025 17:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021450; cv=none; b=jxIQY2jeZkiI7J6U8/Kh0ZNxpYltaYKwGrvbyGl4pfZhhf2o+x9uX+1HgIYF2kvZnSo63lRyKtRGk1j/m0TzEeyEXM+wKjvpxYSkEGZKvWPKS2XzAnWU+oxe+Asm9cPlRajoqDsr827aLU0C68VFIcRGGe8HwpSTRFI3vc2plR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021450; c=relaxed/simple;
	bh=t0Vqmw/yfEq/osVKqZXHBtJL/EzLxLnqeX/z9SQK5V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQnAQ+L7nr/sPLC7PTBdUZ8g2ANubnap2uYY5AjVvFmuO/dqSlLy+MNkooTtzfPi4z9kIh7gcvAq03gN1K6D/G2oxcc1ZlUKd4Q7tEd5M52Ng98Km8xF764pzdBCzr8piQ4b3WrC1mP4YETLNto+XrFsBUo9j26JdcD+txfREMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kxEgNL5t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kxEgNL5t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E10EC4CEF0;
	Tue, 12 Aug 2025 17:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021450;
	bh=t0Vqmw/yfEq/osVKqZXHBtJL/EzLxLnqeX/z9SQK5V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kxEgNL5t9DPqUfyFWhK3kZKBaFQJx1UQ0K23GhpagRwsFuvGOXQtueT9uC5EQjXXd
	 CRpPgJFx2pwutWLZsSCs5AKNTkRCIDH0w3dUOcTr911BchgXsmh92ZY7LGZiJnljSA
	 9UgbkAxQIHeposAPWdEqLBKX5lM1b+77pi7d3LFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/262] perf sched: Fix memory leaks in perf sched latency
Date: Tue, 12 Aug 2025 19:28:35 +0200
Message-ID: <20250812172958.514922124@linuxfoundation.org>
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

[ Upstream commit e68b1c0098b959cb88afce5c93dd6a9324e6da78 ]

The work_atoms should be freed after use.  Add free_work_atoms() to
make sure to release all.  It should use list_splice_init() when merging
atoms to prevent accessing invalid pointers.

Fixes: b1ffe8f3e0c96f552 ("perf sched: Finish latency => atom rename and misc cleanups")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250703014942.1369397-8-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a1fab1a52b6a..16cb7278faba 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1125,6 +1125,21 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
 	atoms->nb_atoms++;
 }
 
+static void free_work_atoms(struct work_atoms *atoms)
+{
+	struct work_atom *atom, *tmp;
+
+	if (atoms == NULL)
+		return;
+
+	list_for_each_entry_safe(atom, tmp, &atoms->work_list, list) {
+		list_del(&atom->list);
+		free(atom);
+	}
+	thread__zput(atoms->thread);
+	free(atoms);
+}
+
 static int latency_switch_event(struct perf_sched *sched,
 				struct evsel *evsel,
 				struct perf_sample *sample,
@@ -3192,13 +3207,13 @@ static void __merge_work_atoms(struct rb_root_cached *root, struct work_atoms *d
 			this->total_runtime += data->total_runtime;
 			this->nb_atoms += data->nb_atoms;
 			this->total_lat += data->total_lat;
-			list_splice(&data->work_list, &this->work_list);
+			list_splice_init(&data->work_list, &this->work_list);
 			if (this->max_lat < data->max_lat) {
 				this->max_lat = data->max_lat;
 				this->max_lat_start = data->max_lat_start;
 				this->max_lat_end = data->max_lat_end;
 			}
-			zfree(&data);
+			free_work_atoms(data);
 			return;
 		}
 	}
@@ -3277,7 +3292,6 @@ static int perf_sched__lat(struct perf_sched *sched)
 		work_list = rb_entry(next, struct work_atoms, node);
 		output_lat_thread(sched, work_list);
 		next = rb_next(next);
-		thread__zput(work_list->thread);
 	}
 
 	printf(" -----------------------------------------------------------------------------------------------------------------\n");
@@ -3291,6 +3305,13 @@ static int perf_sched__lat(struct perf_sched *sched)
 
 	rc = 0;
 
+	while ((next = rb_first_cached(&sched->sorted_atom_root))) {
+		struct work_atoms *data;
+
+		data = rb_entry(next, struct work_atoms, node);
+		rb_erase_cached(next, &sched->sorted_atom_root);
+		free_work_atoms(data);
+	}
 out_free_cpus_switch_event:
 	free_cpus_switch_event(sched);
 	return rc;
-- 
2.39.5



