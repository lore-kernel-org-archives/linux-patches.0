Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB5038F259;
	Sat, 12 Sep 2026 08:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201088; cv=none; b=ld+9byOkUl109A47jSJXyi/ZK0JhHm71ZFhdUwfvTdKYxr82qG1+c5uCkfksoFOAwLIWoq6g52Yr82He9C3P/b3rPYD9zDcNLWZ/ai4FKZdi+iRLBFvbQO1dyJsryQnPnt2Owgu+KUCeV24Pn/xqJRvI2PJ+KIDqWYW+oUC3jGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201088; c=relaxed/simple;
	bh=CdJWZVmKXtohK25M+q59VWJLuJy3DjbIinkkeLtk8jI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DP2eritmyJ31+XlkKAGaG+U/BIENDMajV0q/V/Asps48xPk6XuHrNLTsJYfFEr1en3/dtiR5WIBXAXwBH8TvSIHCod5WOMaaM2SImG2msPaahCjT5s+e1X/+HS0tBwTgR1UHbyQcWZ2zVqlY16pScjyxjvTxVOaqVshg8KCvE/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNWJ21TU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNWJ21TU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE4B1F000FF;
	Sat, 12 Sep 2026 08:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201087;
	bh=1sJshjL3voC1nWvuF65yLPc/urxqWHEr93oz1e6WejM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNWJ21TU7iMFFcn/rlDwt5reYq6p8gVLlG+ZEeXtVay/WAaETikp3whfNxgwQfJhV
	 oUmUTNrNBCLhfaIHpltzD39lt30g0tdo7FCnxoojVA393vZIdf8HTnBzgcIBtYCgDr
	 KCxoI3oGNosAPD2WtbvBlTKbBIhUxwcsHmtzh7nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0925/1815] perf machine: Fix NULL parent dereference in fork event processing
Date: Sat, 12 Sep 2026 08:44:35 +0200
Message-ID: <20260912065710.656306403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 503f5a65e0cca..8b213482e5648 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1923,7 +1923,8 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
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



