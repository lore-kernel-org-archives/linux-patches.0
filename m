Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8AD2D8363;
	Tue, 12 Aug 2025 18:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022645; cv=none; b=iD+vVubwXmtcU9jd+XeB1YIc1NDuV5XQ3Yi2jHXtTDWlTItRt4JSuF5aXE+Oz6uFVUtMjQvj80Rtz9EKvIbpnn3WpucFAVsjzfpAfJ+BYfFrs8b/4g6Ez65Jg74JdNRDDXpKC3s0HqHFR9axTRLm+im9g31QsdOWRLrtd9IJW9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022645; c=relaxed/simple;
	bh=F+q/to525DcxvCa2VhzH+jxKcYBF7CVh9qosBjakfAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGqqSHZ63rr2T9aaY80gY9m4DLzDvuaNmPnAaB2wzMsKzv0P2U052Rx6mdYYEJvryOlUuathAV36S4IrJIe2hjj5I1tqwx6fIu7KJ2fVQy0QHLNRyWo3FKoDrJPrigVrDKKQ3wJC69tGpoFHEDNFnLSaYswPsDvJ/If9DYOjPgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emR7BGbi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emR7BGbi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21C9C4CEF6;
	Tue, 12 Aug 2025 18:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022644;
	bh=F+q/to525DcxvCa2VhzH+jxKcYBF7CVh9qosBjakfAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=emR7BGbirlphqYuOhhdgM+0Qierqb1QGGtqFtH9Ykc90P8Ol6ulHVWaf6r7mnEDTM
	 JejKLoavkc2XJEdpbr9GIr6aBiFscpcXM+ZJXqzcgMpOf8nB/YV5kVS/m6AofxBJHb
	 y7We/w8XvgERd4OwV4Yg/ZH1f1UlfINB9rXlY0x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/369] perf sched: Fix memory leaks in perf sched latency
Date: Tue, 12 Aug 2025 19:28:00 +0200
Message-ID: <20250812173021.653725786@linuxfoundation.org>
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
index 6e9c22c1c29d..64bf3ac237f2 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1116,6 +1116,21 @@ add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
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
@@ -3390,13 +3405,13 @@ static void __merge_work_atoms(struct rb_root_cached *root, struct work_atoms *d
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
@@ -3475,7 +3490,6 @@ static int perf_sched__lat(struct perf_sched *sched)
 		work_list = rb_entry(next, struct work_atoms, node);
 		output_lat_thread(sched, work_list);
 		next = rb_next(next);
-		thread__zput(work_list->thread);
 	}
 
 	printf(" -----------------------------------------------------------------------------------------------------------------\n");
@@ -3489,6 +3503,13 @@ static int perf_sched__lat(struct perf_sched *sched)
 
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



