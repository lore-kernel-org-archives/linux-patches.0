Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90DD70CCB;
	Mon,  8 Apr 2024 13:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582611; cv=none; b=Fn6nsKvT2RVk/0K545qnw8UhdVVC+/TL1ZFBMS6edNXe0pZx6al2bKOp3EVM8633l90aQa9pKN1JbVpHtJHGuPVwqyuQ/fAa29bIjN8AwKNcQcw742iG0KSxASQGaY9W23g3zHDB0Msz0EBuLLY4jQWfdZo2fQSIV87uINZ55vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582611; c=relaxed/simple;
	bh=OWzyGGVeWqMyWdr8xljKVR4waN5OKGzmjmSuznnexVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nO4hfW7cbWgBYixdthe8UvfOCQd7rzORfXuXqwTkbuAqqoYq3NHJ1F+RDNRd+/hqxthJiUQGfiyZsEwxwEyVW1m5xeeoa6kv04vH+LF2NW29peijFsd98KgUiKcF6C1d/WihZVV757jhZGc1NzCKovNkR+tsKoaL9GljdwJ87fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUd0Kt9N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUd0Kt9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E53C433F1;
	Mon,  8 Apr 2024 13:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582611;
	bh=OWzyGGVeWqMyWdr8xljKVR4waN5OKGzmjmSuznnexVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUd0Kt9Nc7Po63f0A3d0jm3fivtze5oO8l3hJILGre+X+0wmQekKH2p6CfCh/E9sP
	 YCZ0V0oZmdoUsrOplGYC2arwG6Yvf+rBGZ5NKihMAba7dLUcrtImeTv4mGsyVxevkf
	 6iJ7+yAYSVTzAcAyz+UpDDWgwUhcwChFKAQyqQEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/138] s390/pai: cleanup event initialization
Date: Mon,  8 Apr 2024 14:58:40 +0200
Message-ID: <20240408125259.527373484@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 4711b7b8f99583f6105a33e91f106125134beacb ]

Setting event::hw.last_tag to zero is not necessary. The memory
for each event is dynamically allocated by the kernel common code and
initialized to zero already.  Remove this unnecessary assignment.
Move the comment to function paicrypt_start() for clarification.

Suggested-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Acked-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Stable-dep-of: e9f3af02f639 ("s390/pai: fix sampling event removal for PMU device driver")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_pai_crypto.c | 11 +++++------
 arch/s390/kernel/perf_pai_ext.c    |  1 -
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/s390/kernel/perf_pai_crypto.c b/arch/s390/kernel/perf_pai_crypto.c
index 4b773653a951b..3758e972bb5f9 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -207,12 +207,6 @@ static int paicrypt_event_init(struct perf_event *event)
 	if (rc)
 		return rc;
 
-	/* Event initialization sets last_tag to 0. When later on the events
-	 * are deleted and re-added, do not reset the event count value to zero.
-	 * Events are added, deleted and re-added when 2 or more events
-	 * are active at the same time.
-	 */
-	event->hw.last_tag = 0;
 	event->destroy = paicrypt_event_destroy;
 
 	if (a->sample_period) {
@@ -246,6 +240,11 @@ static void paicrypt_start(struct perf_event *event, int flags)
 {
 	u64 sum;
 
+	/* Event initialization sets last_tag to 0. When later on the events
+	 * are deleted and re-added, do not reset the event count value to zero.
+	 * Events are added, deleted and re-added when 2 or more events
+	 * are active at the same time.
+	 */
 	if (!event->hw.last_tag) {
 		event->hw.last_tag = 1;
 		sum = paicrypt_getall(event);		/* Get current value */
diff --git a/arch/s390/kernel/perf_pai_ext.c b/arch/s390/kernel/perf_pai_ext.c
index 663cd37f8b293..53915401c3f63 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -267,7 +267,6 @@ static int paiext_event_init(struct perf_event *event)
 	rc = paiext_alloc(a, event);
 	if (rc)
 		return rc;
-	event->hw.last_tag = 0;
 	event->destroy = paiext_event_destroy;
 
 	if (a->sample_period) {
-- 
2.43.0



