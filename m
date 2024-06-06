Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F53419644F;
	Thu,  6 Jun 2024 14:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682970; cv=none; b=bkLFMeHEaZqPNZR93S2USEf/aEdWUYi5a1l/86TFuCKFkB2aUvWj7hnMakitGiioAi57qR0jfHcuCA9sRSpjW+F6D2uFckhqmt8n5rAaOzYopw/zqeLAHRirm6sl9rNh1tJeo3mAXmK0n2pw4sMeYviFDajdRPKkJOIiylWvHb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682970; c=relaxed/simple;
	bh=F62nWxBsaAZVANirRTzIFD44ouBX10/lsfEftKdI4qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j08IrJpsCz5h95H4ctsbi0P5GxcJ5JC1P48+R0+cvTMFsFbjVFgfSKJTHrPuz+Mmo7Svq+3Ugo9t1CoX/v0BF57oTjmrkFB7TzmANVLcuHw3X4hyrFHIPjZ25CLjSYOMSrFpuiitPF43b5sBvMh16KVbis9aA7swgHFEpKVgpEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHkL18g9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHkL18g9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEB9DC2BD10;
	Thu,  6 Jun 2024 14:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682970;
	bh=F62nWxBsaAZVANirRTzIFD44ouBX10/lsfEftKdI4qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHkL18g931VeRldxLLXuEWvp+at7lKwN8AoyIKm4ttMom1hz4yx22RT6lgGdUV//2
	 /RPJVLo8FvK42mrIvT61mhzKh+ArqsCnPj8o5r/+g4WYmE6G7ZXOz8w+eMI8xvcCxn
	 tzZD+sd+igRIxiPQwcye6QDL5loP2EIT7uCkuuIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Leo Yan <leo.yan@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 101/374] perf thread: Fixes to thread__new() related to initializing comm
Date: Thu,  6 Jun 2024 16:01:20 +0200
Message-ID: <20240606131655.302693983@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 3536c2575e88a890cf696b4ccd3da36bc937853b ]

Freeing the thread on failure won't work with reference count checking,
use thread__delete().

Don't allocate the comm_str, use a stack allocation instead.

Fixes: f6005cafebab72f8 ("perf thread: Add reference count checking")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Leo Yan <leo.yan@linux.dev>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240508035301.1554434-5-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/thread.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 1aa8962dcf52c..515726489e36a 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -39,12 +39,13 @@ int thread__init_maps(struct thread *thread, struct machine *machine)
 
 struct thread *thread__new(pid_t pid, pid_t tid)
 {
-	char *comm_str;
-	struct comm *comm;
 	RC_STRUCT(thread) *_thread = zalloc(sizeof(*_thread));
 	struct thread *thread;
 
 	if (ADD_RC_CHK(thread, _thread) != NULL) {
+		struct comm *comm;
+		char comm_str[32];
+
 		thread__set_pid(thread, pid);
 		thread__set_tid(thread, tid);
 		thread__set_ppid(thread, -1);
@@ -56,13 +57,8 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		init_rwsem(thread__namespaces_lock(thread));
 		init_rwsem(thread__comm_lock(thread));
 
-		comm_str = malloc(32);
-		if (!comm_str)
-			goto err_thread;
-
-		snprintf(comm_str, 32, ":%d", tid);
+		snprintf(comm_str, sizeof(comm_str), ":%d", tid);
 		comm = comm__new(comm_str, 0, false);
-		free(comm_str);
 		if (!comm)
 			goto err_thread;
 
@@ -76,7 +72,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 	return thread;
 
 err_thread:
-	free(thread);
+	thread__delete(thread);
 	return NULL;
 }
 
-- 
2.43.0



