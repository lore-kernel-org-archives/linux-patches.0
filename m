Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73D322B8DF;
	Tue, 21 Jul 2026 18:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660314; cv=none; b=jYNI9LvTiT3jWqy+yD1ls/yxfPUUPmsQnCzAD5pMtz27qOqsewkBlrS4s9sBIKjdw+mb8cyzYRqL3yCE698X2BlLJneSfsXEJkVpcjPMLXBCyedXpLlNSj+Z7pLclXoDIOCXJ+165ofYZk7cqcQr1XLTwA3oJX9CUctGc3kdVpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660314; c=relaxed/simple;
	bh=a/NazKmViO+9jBgmysGgXsD8/ExHYZaYBIfepbkFtO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tc0L58urH5s4Dk7hkU5vmUqUKySvgpEuUBStQkqgcy8LgLGASYJ3tl1LadJ9SM5c9AjMmYaTuJtZXf+NMGepbRhvUaSYMQqNtrdnw65L/51Fw+DiTfoz07fyif4M09akGF38EZQbQ2gfAVbGn+TKNCYl/jD0wwYwquzW2zonDOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EaHhcu+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EaHhcu+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7C71F000E9;
	Tue, 21 Jul 2026 18:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660313;
	bh=QAgkJN/o8HWZCWpD1/RSDEw38en84+YC2wqOmxuT/54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaHhcu+YrRPxvG0xp6p4bRb15wPdilRND7XbtHbhbJJrCTcTyIEVd/VF0h9+JwXEV
	 sCHsIxTWc/+q8eHdOnxsj2Zc9O1bOjFo8V9qQRxRWxGLnKx5GBDk0hCLcd9TcbqXGk
	 Ghdt0PvroO1Tyle63xbapzfHJhEwgxzYq7pp/5h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Anton Blanchard <anton@samba.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0934/2077] perf tools: Guard remaining test_bit calls from OOB sample CPU
Date: Tue, 21 Jul 2026 17:10:07 +0200
Message-ID: <20260721152614.846781512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 7ccd2e6cecd5bb02a5a15f0dd7199d1e81380bda ]

auxtrace.c:filter_cpu() and builtin-script.c:filter_cpu() call
test_bit(cpu, cpu_bitmap) where cpu_bitmap is declared with
MAX_NR_CPUS bits.  When the CPU value from a perf.data event is
corrupt or absent (e.g. negative or >= MAX_NR_CPUS), test_bit reads
out of bounds.

Add bounds checks before test_bit(): >= 0 for the int16_t cpu.cpu in
auxtrace (which also covers the -1 sentinel), and < MAX_NR_CPUS for
both sites.  Matches the pattern applied in the previous series for
builtin-annotate.c, builtin-diff.c, builtin-report.c, and
builtin-sched.c.

Fixes: 644e0840ad46 ("perf auxtrace: Add CPU filter support")
Fixes: 5d67be97f890 ("perf report/annotate/script: Add option to specify a CPU range")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Anton Blanchard <anton@samba.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 2 +-
 tools/perf/util/auxtrace.c  | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index fd0b4609516b3e..ed372762276bce 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -2638,7 +2638,7 @@ static int cleanup_scripting(void)
 
 static bool filter_cpu(struct perf_sample *sample)
 {
-	if (cpu_list && sample->cpu != (u32)-1)
+	if (cpu_list && sample->cpu != (u32)-1 && sample->cpu < MAX_NR_CPUS)
 		return !test_bit(sample->cpu, cpu_bitmap);
 	return false;
 }
diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index a224687ffbc1b5..47e2004b91d739 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -372,7 +372,8 @@ static bool filter_cpu(struct perf_session *session, struct perf_cpu cpu)
 {
 	unsigned long *cpu_bitmap = session->itrace_synth_opts->cpu_bitmap;
 
-	return cpu_bitmap && cpu.cpu != -1 && !test_bit(cpu.cpu, cpu_bitmap);
+	return cpu_bitmap && cpu.cpu >= 0 && cpu.cpu < MAX_NR_CPUS &&
+	       !test_bit(cpu.cpu, cpu_bitmap);
 }
 
 static int auxtrace_queues__add_buffer(struct auxtrace_queues *queues,
-- 
2.53.0



