Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CDB35FF5D;
	Tue, 16 Dec 2025 12:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887361; cv=none; b=EN2mHcw5qF4I0a1IKmctaFn/udMvBeBGvYMj/E70KLV8busF7H4r/tO47pDHM7fBXBYtawsPEiYnLoVpfTCkE5Shxz4+qlcAiAlTJNinr5QYGrfzgjWGdushe+ksg2gcbsCXJeyjWX/uY2Wz2NZ4IZdyYxM7yFsGgcm+uPeq0DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887361; c=relaxed/simple;
	bh=cWOupyvQP4C/W1HzxsTMRzyqORU0xfkl8b9awPmv3jc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ki7X+VarSpZmEnLqiJYOLouNiKnLhwK85kVDebm3pYjqhLzVUhhQ+0iEwqwf5rK8LBqpUb5/QZfv+Cd5rIjUa/HLEvR3BvrRaQflmS0AkawzzUjXt5k/NKywpZXsQCmG3ajHZnylGckpSq1TgA7s+KlE92UvcPxB3KLqXPk1eqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/Jji7Gz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/Jji7Gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2782C4CEF1;
	Tue, 16 Dec 2025 12:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887361;
	bh=cWOupyvQP4C/W1HzxsTMRzyqORU0xfkl8b9awPmv3jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/Jji7GzRy++7rRRKN5179qxTzCIXxTI1EdF6OyrFQSstYiHXFeOnb30gXleDdNL5
	 EOKUft/EVT55ywraOa12yZJamgKfUSZ1xE3cL3QKz5Jh0CBSOsShkiHRUCmm1DovoR
	 CUWreNm2bz/80QElzTnkfr/PnBLR3cZMEoIVZZVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 173/614] perf record: skip synthesize event when open evsel failed
Date: Tue, 16 Dec 2025 12:09:00 +0100
Message-ID: <20251216111407.623905533@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d76f01956e33b..b1fb87016d5aa 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -2883,11 +2883,11 @@ static int __cmd_record(struct record *rec, int argc, const char **argv)
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



