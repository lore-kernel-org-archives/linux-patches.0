Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDC733C511;
	Fri,  9 Jan 2026 11:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959698; cv=none; b=rQ/vRqGuhPhT8FLy+cIxu6zoQG0a796YuO/+fyxeypm5N+tp1PhzW/RceluQj142b6fxVvHBa5YugZk5OaChq18pVlaCvkTN4HJbbAr/6rId07AMfK3o9O+oCWchcHGI6kKeJDSPmTMdZ6j/BX49sie/B4jMUuUhcOF2o07L+MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959698; c=relaxed/simple;
	bh=dJY2yjVCQs79WWkDDrh1CtovdgPaVIOy7ATMVaOJ5Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DHpY1fFWMsSDWugIYsqI6UOLOGgbBctJTQGWA0Djyp5I+UMrgVSd+DGUPzQX9fwU/Sh3mPNLU9bBsIfMwleA8OxP9UjFLhYxQOMhY0VxiJZCTSOc/nYqEnRWZm/Fyf8SxvtgIffLyjtWK5J2hVkwc7C3Q13a8iOxwwd84JejeKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKjjlTi7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKjjlTi7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCDEC4CEF1;
	Fri,  9 Jan 2026 11:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959698;
	bh=dJY2yjVCQs79WWkDDrh1CtovdgPaVIOy7ATMVaOJ5Co=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gKjjlTi7H4BAtScQpWxi+tMwLq37Tx/nO2drDrnF7VD9mjq5i53r/pWeNlfP4p++r
	 +LHaVl+WhQrM0A+sWhG05TOg3k4OOdexUJkRpdGX0FvwDzsfgztJkZOR3dYqlWf6AH
	 J0n77HDj/YHTs8T4XOyzqt6Wxs84SUBA11mL2GlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/737] perf record: skip synthesize event when open evsel failed
Date: Fri,  9 Jan 2026 12:34:10 +0100
Message-ID: <20260109112138.180687738@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuai Xue <xueshuai@linux.alibaba.com>

[ Upstream commit 163e5f2b96632b7fb2eaa965562aca0dbdf9f996 ]

When using perf record with the `--overwrite` option, a segmentation fault
occurs if an event fails to open. For example:

  perf record -e cycles-ct -F 1000 -a --overwrite
  Error:
  cycles-ct:H: PMU Hardware doesn't support sampling/overflow-interrupts. Try 'perf stat'
  perf: Segmentation fault
      #0 0x6466b6 in dump_stack debug.c:366
      #1 0x646729 in sighandler_dump_stack debug.c:378
      #2 0x453fd1 in sigsegv_handler builtin-record.c:722
      #3 0x7f8454e65090 in __restore_rt libc-2.32.so[54090]
      #4 0x6c5671 in __perf_event__synthesize_id_index synthetic-events.c:1862
      #5 0x6c5ac0 in perf_event__synthesize_id_index synthetic-events.c:1943
      #6 0x458090 in record__synthesize builtin-record.c:2075
      #7 0x45a85a in __cmd_record builtin-record.c:2888
      #8 0x45deb6 in cmd_record builtin-record.c:4374
      #9 0x4e5e33 in run_builtin perf.c:349
      #10 0x4e60bf in handle_internal_command perf.c:401
      #11 0x4e6215 in run_argv perf.c:448
      #12 0x4e653a in main perf.c:555
      #13 0x7f8454e4fa72 in __libc_start_main libc-2.32.so[3ea72]
      #14 0x43a3ee in _start ??:0

The --overwrite option implies --tail-synthesize, which collects non-sample
events reflecting the system status when recording finishes. However, when
evsel opening fails (e.g., unsupported event 'cycles-ct'), session->evlist
is not initialized and remains NULL. The code unconditionally calls
record__synthesize() in the error path, which iterates through the NULL
evlist pointer and causes a segfault.

To fix it, move the record__synthesize() call inside the error check block, so
it's only called when there was no error during recording, ensuring that evlist
is properly initialized.

Fixes: 4ea648aec019 ("perf record: Add --tail-synthesize option")
Signed-off-by: Shuai Xue <xueshuai@linux.alibaba.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 81f77c0505fde..ddaf38f92898f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -2776,11 +2776,11 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
 		rec->bytes_written += off_cpu_write(rec->session);
 
 	record__read_lost_samples(rec);
-	record__synthesize(rec, true);
 	/* this will be recalculated during process_buildids() */
 	rec->samples = 0;
 
 	if (!err) {
+		record__synthesize(rec, true);
 		if (!rec->timestamp_filename) {
 			record__finish_output(rec);
 		} else {
-- 
2.51.0



