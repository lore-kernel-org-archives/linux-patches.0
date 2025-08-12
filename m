Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4382D2FD1B2;
	Tue, 12 Aug 2025 17:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020687; cv=none; b=o/t9SZuxoVxYGoUD4H5ucy7kwRRlfz5lLl4h7IrE93f4Bku0pHYoIwia8UatE7J91FPe47zyrgavLUhmRE6y4/jswkIB/VTyhGNhIwCCuY1DYcwL3DxyIRNsQxvXEfmZwBXex+aHXSGtJEvCoGQ09gpmaVGETiTHm3nenr+H3xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020687; c=relaxed/simple;
	bh=VYz0UpScIK9brFKBRZsOQsbxoSo3qyGTkSnik7KjksM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7MSQF1FCwd4kdrFUtaYsIyA2eXHkNZjeCD7QxXoCzTMpZxY08gZl6Xg/m455seCsVLzp7z5XNZ5aJofSEFExcV4LX9ePGeypljMzOg2XtIu1vq6Lws3Ch4PgRVozr3Oe4SnvgBPpMCz1RmnmLbpUkEB0xzH+Pti5+5TY+hVOP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNNZx2Z9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNNZx2Z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3C8C4CEF0;
	Tue, 12 Aug 2025 17:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020687;
	bh=VYz0UpScIK9brFKBRZsOQsbxoSo3qyGTkSnik7KjksM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNNZx2Z9W7YnqPQz9fMtVNfJDOpeu6566NkWFIANrMp09T9KOeanT4vi+fG4a+ZMc
	 rT9lyve8LL8N3j4qXmtUeY4ipXEQQ0fG64yeCJDjjhhWDtAYS71kGldXEZTslo21jH
	 rO+CaaD+8XmzCk5Chk8CugVbVrO9BeQLpV7cuOrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/253] perf sched: Fix memory leaks in perf sched latency
Date: Tue, 12 Aug 2025 19:29:01 +0200
Message-ID: <20250812172955.223667316@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 244f9c6f61ae..3ffb41fa82b8 100644
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
@@ -3180,13 +3195,13 @@ static void __merge_work_atoms(struct rb_root_cached *root, struct work_atoms *d
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
@@ -3265,7 +3280,6 @@ static int perf_sched__lat(struct perf_sched *sched)
 		work_list = rb_entry(next, struct work_atoms, node);
 		output_lat_thread(sched, work_list);
 		next = rb_next(next);
-		thread__zput(work_list->thread);
 	}
 
 	printf(" -----------------------------------------------------------------------------------------------------------------\n");
@@ -3279,6 +3293,13 @@ static int perf_sched__lat(struct perf_sched *sched)
 
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



