Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ACC33A3E90;
	Wed, 20 May 2026 16:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295981; cv=none; b=VeJLHUAl9PM+6p1KW5yZ/SOZR/ZzyVqBLyCuUBs5Iyyl0hcEGN9Sg29GtBepXE/EXTdM2kqHVsBzgeS6MmoX3/xaSuuPpvTFTbxJpQzIE7kUukqYDAXyPOO09IOx5TLPBcwfVzkaCg++ihvA1eCi+zQHZwkEQM9fMP12W187igc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295981; c=relaxed/simple;
	bh=lkKOAUIaMZLg9R4DnfUpy1lq5c+l17ZFYI+/41sotw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgX73GW3p1KKR7nlOuVWvmZZa6p/1YU90fMnvSEkp4ZKtp1T5XQtHmgckVikmswlEIEN6dKaKr7iVdQ0vGFpKax0UZyCyutKuL8gzv/Z3EradvMU9RS3sb8Xcoptjxt9phAbYZYZqxrKWsT91pKRML3kA+s3rBpX05Q4bQixYa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tQ3BFy1z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQ3BFy1z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3545F1F00894;
	Wed, 20 May 2026 16:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295978;
	bh=gq8OkOyXSdQuewQS+OjAmZUmZQW8mFA2U9hKcJW6aBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tQ3BFy1zriUpF6Jh2OdmtWLxDiiPknKTVCDXdbT53UTe8sNPE8brhnuEGt9v3x7Q9
	 YsMmLUb8CzlPt2+EfaZVTmZwulsBm6ys6rtQOdS/EYUnvn7ZhWQbgU64mf6BX4E+wt
	 gcWm7BWggVK48PTfJ9urnvzmNMplKgGapp+69dho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0625/1146] perf trace: Avoid an ERR_PTR in syscall_stats
Date: Wed, 20 May 2026 18:14:35 +0200
Message-ID: <20260520162202.327796329@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit d05073adda0f047e9b2115a2932bcb2797eab238 ]

hashmap__new may return an ERR_PTR and previously this would be
assigned to syscall_stats meaning all use of syscall_stats needs to
test for NULL (uninitialized) or an ERR_PTR. Given the only reason
hashmap__new can fail is ENOMEM, just use NULL to indicate the
allocation failure and avoid the code having to test for NULL and
IS_ERR.

Fixes: 96f202eab813 (perf trace: Fix IS_ERR() vs NULL check bug)
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 295b272c6c299..7ff85fa90d988 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1565,7 +1565,9 @@ static bool syscall_id_equal(long key1, long key2, void *ctx __maybe_unused)
 
 static struct hashmap *alloc_syscall_stats(void)
 {
-	return hashmap__new(syscall_id_hash, syscall_id_equal, NULL);
+	struct hashmap *result = hashmap__new(syscall_id_hash, syscall_id_equal, NULL);
+
+	return IS_ERR(result) ? NULL : result;
 }
 
 static void delete_syscall_stats(struct hashmap *syscall_stats)
@@ -1573,7 +1575,7 @@ static void delete_syscall_stats(struct hashmap *syscall_stats)
 	struct hashmap_entry *pos;
 	size_t bkt;
 
-	if (IS_ERR(syscall_stats))
+	if (!syscall_stats)
 		return;
 
 	hashmap__for_each_entry(syscall_stats, pos, bkt)
@@ -1589,7 +1591,7 @@ static struct thread_trace *thread_trace__new(struct trace *trace)
 		ttrace->files.max = -1;
 		if (trace->summary) {
 			ttrace->syscall_stats = alloc_syscall_stats();
-			if (IS_ERR(ttrace->syscall_stats))
+			if (!ttrace->syscall_stats)
 				zfree(&ttrace);
 		}
 	}
@@ -4464,7 +4466,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	if (trace->summary_mode == SUMMARY__BY_TOTAL && !trace->summary_bpf) {
 		trace->syscall_stats = alloc_syscall_stats();
-		if (IS_ERR(trace->syscall_stats))
+		if (!trace->syscall_stats)
 			goto out_delete_evlist;
 	}
 
@@ -4771,7 +4773,7 @@ static int trace__replay(struct trace *trace)
 
 	if (trace->summary_mode == SUMMARY__BY_TOTAL) {
 		trace->syscall_stats = alloc_syscall_stats();
-		if (IS_ERR(trace->syscall_stats))
+		if (!trace->syscall_stats)
 			goto out;
 	}
 
-- 
2.53.0



