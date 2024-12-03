Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0924C646;
	Tue,  3 Dec 2024 15:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239065; cv=none; b=f808eLIOxRkavFTu0oMtSKixPguf2imOp9mM/oLDesbzAk+GccuwvRt2N4fsUFoj3g6FIDouhWpl0PUv22ktr2deNYF20IYYAwzUmaQi2JTdZphqNVxYeGhvi2RqmsAQnfWgxBx4Pw3v7TYhBbz2cKRZQLMn3wA2045vT0VgrJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239065; c=relaxed/simple;
	bh=SQ2nWRdJAUv632xDzL7yh1UFKPvYc/nnHQlQLJJnblc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4znIkCocGVnUz8wAf/s4NcA7RjPYJ0mqOdzL7EPZinuq7Lcw/b/ffch75Z3G0fVOs3bZ0Am9RBjAU53sI9iVJa7ddLv+6nPsYqvX8N/WBUXDhegGSs3RC8B+urTQ1Gw0BgtCuhqG5C0BAdtBF4L6lCJUJL4Hmyb387NZUFgjIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gz4urRdH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gz4urRdH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8554CC4CECF;
	Tue,  3 Dec 2024 15:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239064;
	bh=SQ2nWRdJAUv632xDzL7yh1UFKPvYc/nnHQlQLJJnblc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gz4urRdHvg7oHYVDH+dzhLvwfhUuoXuvvJ+M4jCMQhoVBw55dimMmr9sWg6lmg2/k
	 F0b5EUkJrIUO9j2o+j0bD3ZM9r+789O4CUbA1eLBqWfIY7lkn9RHA1Pmhbskm+oeFA
	 jT8+yYQUQfxuGXNlK4SHSpJgrrgTwtfihdo9R5NM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Veronika Molnarova <vmolnaro@redhat.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 491/817] perf trace: Keep exited threads for summary
Date: Tue,  3 Dec 2024 15:41:03 +0100
Message-ID: <20241203144015.039364035@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Petlan <mpetlan@redhat.com>

[ Upstream commit d29d92df410e2fb523f640478b18f70c1823e55e ]

Since 9ffa6c7512ca ("perf machine thread: Remove exited threads by
default") perf cleans exited threads up, but as said, sometimes they
are necessary to be kept. The mentioned commit does not cover all the
cases, we also need the information to construct the summary table in
perf-trace.

Before:
    # perf trace -s true

     Summary of events:

After:
    # perf trace -s -- true

     Summary of events:

     true (383382), 64 events, 91.4%

       syscall            calls  errors  total       min       avg       max       stddev
                                         (msec)    (msec)    (msec)    (msec)        (%)
       --------------- --------  ------ -------- --------- --------- ---------     ------
       mmap                   8      0     0.150     0.013     0.019     0.031     11.90%
       mprotect               3      0     0.045     0.014     0.015     0.017      6.47%
       openat                 2      0     0.014     0.006     0.007     0.007      9.73%
       munmap                 1      0     0.009     0.009     0.009     0.009      0.00%
       access                 1      1     0.009     0.009     0.009     0.009      0.00%
       pread64                4      0     0.006     0.001     0.001     0.002      4.53%
       fstat                  2      0     0.005     0.001     0.002     0.003     37.59%
       arch_prctl             2      1     0.003     0.001     0.002     0.002     25.91%
       read                   1      0     0.003     0.003     0.003     0.003      0.00%
       close                  2      0     0.003     0.001     0.001     0.001      3.86%
       brk                    1      0     0.002     0.002     0.002     0.002      0.00%
       rseq                   1      0     0.001     0.001     0.001     0.001      0.00%
       prlimit64              1      0     0.001     0.001     0.001     0.001      0.00%
       set_robust_list        1      0     0.001     0.001     0.001     0.001      0.00%
       set_tid_address        1      0     0.001     0.001     0.001     0.001      0.00%
       execve                 1      0     0.000     0.000     0.000     0.000      0.00%

[namhyung: simplified the condition]

Fixes: 9ffa6c7512ca ("perf machine thread: Remove exited threads by default")
Reported-by: Veronika Molnarova <vmolnaro@redhat.com>
Signed-off-by: Michael Petlan <mpetlan@redhat.com>
Link: https://lore.kernel.org/r/20240927151926.399474-1-mpetlan@redhat.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-trace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8449f2beb54d7..19db23f78b199 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -5038,6 +5038,10 @@ int cmd_trace(int argc, const char **argv)
 	if (trace.summary_only)
 		trace.summary = trace.summary_only;
 
+	/* Keep exited threads, otherwise information might be lost for summary */
+	if (trace.summary)
+		symbol_conf.keep_exited_threads = true;
+
 	if (output_name != NULL) {
 		err = trace__open_output(&trace, output_name);
 		if (err < 0) {
-- 
2.43.0



