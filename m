Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073DA42AF9A;
	Sat, 12 Sep 2026 10:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209501; cv=none; b=esxW6b6FGSTVKFWNQusqeAU+aUujVKViKE2HgKWJvfBVjU804TE5txjAJyzzeIFOem/pHUUDVAMv30aM4ZZvuIMLuSZcVaNZD8mwHfR+Dtl+Y6RdGTT73ILeLiwn5SPaLOaIUfgv3wLTZ6kzF7lV7x3EY67QpRjrX2zVb72bfmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209501; c=relaxed/simple;
	bh=h4y3QdXagiKTEG2cm2+mbIcYnXN3Z1CV310qOXfnaHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKhwCLoI8Y8wT+egsOcGlTQqRNC1t2dkhYmizMVkIkYKziSxpJZy22EuI43eeUSxm6M+Fac3ObdQvwlcs2HTfQhtao77Asq248ZsVbAyS+DTO/VCKnQpDr1vq4NfNpFWZ87hHG3IsVQ3SL5TQiXxEEqE3YNhSRDXU2QfK+PveWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ef16dVgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ef16dVgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAE61F000FF;
	Sat, 12 Sep 2026 10:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209498;
	bh=bGs6ErsAKXEaa0/rmZC5ZeRptTPfyDOLYFff0gEXeBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ef16dVgf3H8TELEjVwoJ7t7rQGKnhyvXBUgpun2cm/bma0nodykSM8XRM8OC2GpE9
	 AEIeF49coLfLpmc8Hd+8qOMCnFas9dOpWdh1i465gPxGsNDNRzT7ewDQaPRhqVe3Re
	 8oOtscaG1+PI9tp1aNa9aypRnxec2WFYSgauu8Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0780/1518] perf machine: Fix NULL parent dereference in fork event processing
Date: Sat, 12 Sep 2026 08:49:09 +0200
Message-ID: <20260912065641.082027297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 73ac546bd6ba8ed4dc8d7a90fcb9bb8236de1568 ]

machine__process_fork_event() calls machine__findnew_thread() for the
parent thread, which can return NULL on allocation failure.  The code
then dereferences parent via thread__pid(parent) without a NULL check
when validating whether the parent PID matches.  The later NULL check
at thread__fork() does not prevent this earlier dereference.

Add a NULL guard before accessing the parent thread.

Fixes: 5cb73340d92a ("perf tools: Make fork event processing more resilient")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/machine.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a2f5ca35141bb..8b6869582b076 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1880,7 +1880,8 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
 	 * (fork) event that would have removed the thread was lost. Assume the
 	 * latter case and continue on as best we can.
 	 */
-	if (thread__pid(parent) != (pid_t)event->fork.ppid) {
+	if (parent != NULL &&
+	    thread__pid(parent) != (pid_t)event->fork.ppid) {
 		dump_printf("removing erroneous parent thread %d/%d\n",
 			    thread__pid(parent), thread__tid(parent));
 		machine__remove_thread(machine, parent);
-- 
2.53.0



