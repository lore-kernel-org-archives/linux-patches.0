Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A3F2E06E4;
	Sat, 12 Sep 2026 12:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216901; cv=none; b=Cv82esPD75u4oGfNt6rsMJ6Pb55Y+lOclkVCzZn8VLNNxK/23ZZJ3Y2eI2fUfa7ogLLQo1AWy7qdHqJQCOfS52yzquBTza1KW9vgbOLvEe4D0Y1ur6aJEbORVZQbLBJI2YfbUdkY3rYArWiPenA+uelJzLDaIuzrZxv4cZW8aUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216901; c=relaxed/simple;
	bh=qht5cJ+V88YE0ee/UU7mEgrZc1YyfjIP3Wu/aIgb4uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bw7Qhf+8O9CjPP9LQNtigi7A/kU2xdElzHS6EeeBSEXkluUeZu5EYqRYBNSoeIznCJD+OrTl/1Unscjo55U295yjVggKFjWyyqAkZX33DWA9cYZhonS3ELzbUuWBCa18qEy9DB9C4WHf83IZMSCTESOH1y/M+Rpv0WBBTNapORg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=siH7Tu+c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="siH7Tu+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814751F000FF;
	Sat, 12 Sep 2026 12:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216900;
	bh=8EvTYEWjHkEvG0btIfKETJdDri55GuAnkE9FopNC624=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=siH7Tu+cmm3chQJVXKnxiAcdBXEieQcSHR7kKy+NChiZp++qjX7gUJJL65aWKdciD
	 o6zJd3tjbb4ql3qOxM9vV21fFKtzls1UE7wVCpyP27x6Swk7Cu9+fXgoYCrOkD5681
	 CwvBhWsEmcK/vt81roGGmxC5BZq9h/81HpgvHTWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0829/1376] perf machine: Fix NULL parent dereference in fork event processing
Date: Sat, 12 Sep 2026 08:54:15 +0200
Message-ID: <20260912065626.020479657@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 20fd742984e3c..8341737172279 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1843,7 +1843,8 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
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



