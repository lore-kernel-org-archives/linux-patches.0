Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9041A2ED868;
	Tue, 17 Jun 2025 16:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178275; cv=none; b=KJrF6MvNq/hDuLdPGmI0W0dp79SnOFbLi5DHbVt4I7OWjgeHmuqADJYB1NX1LYUaoUl1eV9VESd4dt/uk3D03hvvl31CRYydycsb/ebrncCJWUMUFWfSmBT0SZAr5EFK411TW3Ap7zgSu/+melVgFYHOiahtVFqnnYRX+yv/2xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178275; c=relaxed/simple;
	bh=8zMtpQq+ygZonZaB7Or0iy+Gciy5EW68pZweEzfPI5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ihy1IUJckJGaVSoRp2Zf4uESg7t2OSms6aGAAx4AHMiGru89ZnDhYY9kVKRhp0xx5PbFlEK2gD7ZQJgE+15fJ5wQAQlEF+PG8hTZ0iVxNY9/kp+00Vqq6SeL87zxB6FBL043Y8o6vQv1WSOVDczK9+Uutaxf8AbmsmTgr/WuZvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=acbsBqX8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="acbsBqX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2628C4CEE3;
	Tue, 17 Jun 2025 16:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178275;
	bh=8zMtpQq+ygZonZaB7Or0iy+Gciy5EW68pZweEzfPI5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acbsBqX8Vte1ZD2Hqg9ap/8WRPMXRhfcUInTT1PCA+nVoChEUbFFyJOj70OWlrbVg
	 2y3ZCmZBRklIIlpwri82s2Op7xdfG9tZuyK7hptVvx8UX1QwuGzZPxgZ5Oa7JkSEJt
	 kYmFTvIesCJD2lfmMqLT6MCxPFUrTaZoVi4yxzFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung.kim@lge.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 437/780] perf symbol-minimal: Fix double free in filename__read_build_id
Date: Tue, 17 Jun 2025 17:22:25 +0200
Message-ID: <20250617152509.259678393@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit fa9c4977fbfbca182f9e410d57b3f98356a9d917 ]

Running the "perf script task-analyzer tests" with address sanitizer
showed a double free:
```
FAIL: "test_csv_extended_times" Error message: "Failed to find required string:'Out-Out;'."
=================================================================
==19190==ERROR: AddressSanitizer: attempting double-free on 0x50b000017b10 in thread T0:
    #0 0x55da9601c78a in free (perf+0x26078a) (BuildId: e7ef50e08970f017a96fde6101c5e2491acc674a)
    #1 0x55da96640c63 in filename__read_build_id tools/perf/util/symbol-minimal.c:221:2

0x50b000017b10 is located 0 bytes inside of 112-byte region [0x50b000017b10,0x50b000017b80)
freed by thread T0 here:
    #0 0x55da9601ce40 in realloc (perf+0x260e40) (BuildId: e7ef50e08970f017a96fde6101c5e2491acc674a)
    #1 0x55da96640ad6 in filename__read_build_id tools/perf/util/symbol-minimal.c:204:10

previously allocated by thread T0 here:
    #0 0x55da9601ca23 in malloc (perf+0x260a23) (BuildId: e7ef50e08970f017a96fde6101c5e2491acc674a)
    #1 0x55da966407e7 in filename__read_build_id tools/perf/util/symbol-minimal.c:181:9

SUMMARY: AddressSanitizer: double-free (perf+0x26078a) (BuildId: e7ef50e08970f017a96fde6101c5e2491acc674a) in free
==19190==ABORTING
FAIL: "invocation of perf script report task-analyzer --csv-summary csvsummary --summary-extended command failed" Error message: ""
FAIL: "test_csvsummary_extended" Error message: "Failed to find required string:'Out-Out;'."
---- end(-1) ----
132: perf script task-analyzer tests                                 : FAILED!
```

The buf_size if always set to phdr->p_filesz, but that may be 0
causing a free and realloc to return NULL. This is treated in
filename__read_build_id like a failure and the buffer is freed again.

To avoid this problem only grow buf, meaning the buf_size will never
be 0. This also reduces the number of memory (re)allocations.

Fixes: b691f64360ecec49 ("perf symbols: Implement poor man's ELF parser")
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250501070003.22251-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-minimal.c | 34 +++++++++++++++++---------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index c6f369b5d893f..d8da3da01fe6b 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -147,18 +147,19 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 			if (phdr->p_type != PT_NOTE)
 				continue;
 
-			buf_size = phdr->p_filesz;
 			offset = phdr->p_offset;
-			tmp = realloc(buf, buf_size);
-			if (tmp == NULL)
-				goto out_free;
-
-			buf = tmp;
+			if (phdr->p_filesz > buf_size) {
+				buf_size = phdr->p_filesz;
+				tmp = realloc(buf, buf_size);
+				if (tmp == NULL)
+					goto out_free;
+				buf = tmp;
+			}
 			fseek(fp, offset, SEEK_SET);
-			if (fread(buf, buf_size, 1, fp) != 1)
+			if (fread(buf, phdr->p_filesz, 1, fp) != 1)
 				goto out_free;
 
-			ret = read_build_id(buf, buf_size, bid, need_swap);
+			ret = read_build_id(buf, phdr->p_filesz, bid, need_swap);
 			if (ret == 0) {
 				ret = bid->size;
 				break;
@@ -199,18 +200,19 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 			if (phdr->p_type != PT_NOTE)
 				continue;
 
-			buf_size = phdr->p_filesz;
 			offset = phdr->p_offset;
-			tmp = realloc(buf, buf_size);
-			if (tmp == NULL)
-				goto out_free;
-
-			buf = tmp;
+			if (phdr->p_filesz > buf_size) {
+				buf_size = phdr->p_filesz;
+				tmp = realloc(buf, buf_size);
+				if (tmp == NULL)
+					goto out_free;
+				buf = tmp;
+			}
 			fseek(fp, offset, SEEK_SET);
-			if (fread(buf, buf_size, 1, fp) != 1)
+			if (fread(buf, phdr->p_filesz, 1, fp) != 1)
 				goto out_free;
 
-			ret = read_build_id(buf, buf_size, bid, need_swap);
+			ret = read_build_id(buf, phdr->p_filesz, bid, need_swap);
 			if (ret == 0) {
 				ret = bid->size;
 				break;
-- 
2.39.5



