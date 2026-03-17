Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EBB3EDABD;
	Tue, 17 Mar 2026 16:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765822; cv=none; b=t604zw19SIsY9ocJkvmUwJIUypljg75Y6LA79THMyAn1VhSBt+Eri7H+sMyJLDoZyK6XN9RAh2ElbN4vc1Q65vkOlrC4VyoYG40l+4fXieEJOSr4VkcBTsI2vABmG2h6gYlp0Jlp47lyBr2ry0ChPRfZFINFk24OsjFrwuuF9dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765822; c=relaxed/simple;
	bh=kb316HFTGjzmDSKUUOMjg8dFS+9DcTAxq0mj7TXIJLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmPuogvE3QvQIXnHoSjywVncVQ5dqvCIaSvo7wvyAEixTpAcwD9q+6wDGP7wMwaLaRg+Ry+ycZJTBQRnzEAzr/2cU+9KrIqsAqOmJCvpdLk2Vw51yjWafVBWd3u5Kbj9WWBA+3sh/GRLBgVmhUZT8J/u24aNTeNT2jqFGvwNC0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3qUrTJV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3qUrTJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2741C4CEF7;
	Tue, 17 Mar 2026 16:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765822;
	bh=kb316HFTGjzmDSKUUOMjg8dFS+9DcTAxq0mj7TXIJLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m3qUrTJV5IK4Ya7kLvSjgAs9w34CWB52UJDy2Uize2HeTP90l+CpHHTxtPHPwYyvc
	 l8bx+2KPREVnhk9bocrbO29wb5Ha5J+d6g1ddSXhQF1yWb6HAiibSTJ4SmGCrhCc/2
	 EbQ20hO0hALWrHExmPI7OC1tAsogaf/MXC1Y1V+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 103/378] perf synthetic-events: Fix stale build ID in module MMAP2 records
Date: Tue, 17 Mar 2026 17:31:00 +0100
Message-ID: <20260317163010.806922814@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 35b16a7a2c4fc458304447128b86514ce9f70f3c ]

perf_event__synthesize_modules() allocates a single union perf_event and
reuses it across every kernel module callback.

After the first module is processed, perf_record_mmap2__read_build_id()
sets PERF_RECORD_MISC_MMAP_BUILD_ID in header.misc and writes that
module's build ID into the event.

On subsequent iterations the callback overwrites start, len, pid, and
filename for the next module but never clears the stale build ID fields
or the MMAP_BUILD_ID flag.

When perf_record_mmap2__read_build_id() runs for the second module it
sees the flag, reads the stale build ID into a dso_id, and
__dso__improve_id() permanently poisons the DSO with the wrong build ID.

Every module after the first therefore receives the first module's build
ID in its MMAP2 record.

On a system with the sunrpc and nfsd modules loaded, this causes perf
script and perf report to show [unknown] for all module symbols.

The latent bug has existed since commit d9f2ecbc5e47fca7 ("perf dso:
Move build_id to dso_id") introduced the PERF_RECORD_MISC_MMAP_BUILD_ID
check in perf_record_mmap2__read_build_id().

Commit 53b00ff358dc75b1 ("perf record: Make --buildid-mmap the default")
then exposed it to all users by making the MMAP2-with-build-ID path the
default.  Both commits were merged in the same series.

Clear the MMAP_BUILD_ID flag and zero the build_id union before each
call to perf_record_mmap2__read_build_id() so that every module starts
with a clean slate.

Fixes: d9f2ecbc5e47fca7 ("perf dso: Move build_id to dso_id")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/synthetic-events.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/util/synthetic-events.c b/tools/perf/util/synthetic-events.c
index 2ba9fa25e00a6..7a47e21c6704f 100644
--- a/tools/perf/util/synthetic-events.c
+++ b/tools/perf/util/synthetic-events.c
@@ -703,6 +703,11 @@ static int perf_event__synthesize_modules_maps_cb(struct map *map, void *data)
 
 		memcpy(event->mmap2.filename, dso__long_name(dso), dso__long_name_len(dso) + 1);
 
+		/* Clear stale build ID from previous module iteration */
+		event->mmap2.header.misc &= ~PERF_RECORD_MISC_MMAP_BUILD_ID;
+		memset(event->mmap2.build_id, 0, sizeof(event->mmap2.build_id));
+		event->mmap2.build_id_size = 0;
+
 		perf_record_mmap2__read_build_id(&event->mmap2, args->machine, false);
 	} else {
 		size = PERF_ALIGN(dso__long_name_len(dso) + 1, sizeof(u64));
-- 
2.51.0



