Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA1128505A;
	Tue, 12 Aug 2025 19:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026303; cv=none; b=K8dF4ZkFAQ53vXc6R54GBp44//Z5OS7LfHGrlsJsbtoaQf3gQg6J9QBpjJqMDa9kPXeXxRGl7xVY0sjavwRLOz51Mz0XOjb7yWp8F5rdWT8Mr6I7L8nGeckr6iQsPD1s8skheluuiVbviHlZwFwB6vBNP5jVVwlE0cEzq7akBKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026303; c=relaxed/simple;
	bh=/XJJasrxZ91+EEkdbi6Qs8RBPDcdCJbGObwz1TOVFQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hzoupgOIV/5IAxo+D8qcBWqZih5kein8OVm/6+nZJU7F7XEDMzWCz7shwgqgjuGZfnaGWuEf4jdGPgLUdWhOf9ZAHGpVA18pfSH66oyNodntTv8/AUJUam6mbe7eC1XWtZb9fEfTr2idoACm6k1EoXKeJWNWZklZEeTTKTkA/jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E51AiGX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E51AiGX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3072C4CEF0;
	Tue, 12 Aug 2025 19:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026303;
	bh=/XJJasrxZ91+EEkdbi6Qs8RBPDcdCJbGObwz1TOVFQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E51AiGX0A9irb7xPgiLxLtG2v4YRXZ7vUdmaEysS7aCFu1bqRfS5umfkjxMIkYu3X
	 Uc4lJOu7bDkTSRZLlGBiqnHrXcrU4e21+TBPGkaIXbBKcoCjFx3q6zFw441iLQgDcG
	 TyaseNPBHStbxZPdKJgYUF7SaxAJ++e4ea3av8Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 264/480] perf sched: Fix memory leaks in perf sched latency
Date: Tue, 12 Aug 2025 19:47:52 +0200
Message-ID: <20250812174408.329400341@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 087d4eaba5f7..4bbebd6ef2e4 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1111,6 +1111,21 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
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
@@ -3426,13 +3441,13 @@ static void __merge_work_atoms(struct rb_root_cached *root, struct work_atoms *d
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
@@ -3511,7 +3526,6 @@ static int perf_sched__lat(struct perf_sched *sched)
 		work_list = rb_entry(next, struct work_atoms, node);
 		output_lat_thread(sched, work_list);
 		next = rb_next(next);
-		thread__zput(work_list->thread);
 	}
 
 	printf(" -----------------------------------------------------------------------------------------------------------------\n");
@@ -3525,6 +3539,13 @@ static int perf_sched__lat(struct perf_sched *sched)
 
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



