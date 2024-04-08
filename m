Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F02512838E;
	Mon,  8 Apr 2024 13:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583401; cv=none; b=DVMayu08nYLbKIcrR2QsXHc7msVGP7QJTXgUYH1Ox0kvwByZWPMElf95vkdFFTNKNVSPwu+ZBygs0usCw6/Y3/wMHN6Tbp0BTY9q2AJF+lVi6Cm/rQSQ7QG0lx+yeiPr+yhAwogCVnVP3lEcjmxy+MreHQnDyGVkqEZ80C4ynqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583401; c=relaxed/simple;
	bh=64zU8QVoUJESKRbPvAA++R1pkGaAP3Q2sxfbADK1NjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GOVTv0uHwSt5VpyEB6BgmxEHeLz8euGPgMLl1u2Aiy0nWmtb/EnyGQuPBIJlcbwEc7wxm77LQRnGYE8EuDW3qAqAEXGhxHjRn4t+jNS2ssMGuXdWBQOyDlw72gqD23g+VCcpKsFkkYMKCQdK2qCK5apM4fqWa8BFuN0myBRNSBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oGEqzJDZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oGEqzJDZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16489C433F1;
	Mon,  8 Apr 2024 13:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583401;
	bh=64zU8QVoUJESKRbPvAA++R1pkGaAP3Q2sxfbADK1NjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oGEqzJDZ3ww2Xn5plIUZBTlB2Ffo3RE787AKcCYCO/YbfEpqpksyEXeIbU0dhgKJG
	 T7nfHQw2QCidYXlG8vqy9AuL32mDmnvWSGufaQ9vWa9psY5T1Db2wXvD/tXMK2KsEq
	 ZKa4GU1GS9Kb1CTaJje/QNAkNGg3MHLuGcVtRcpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/252] s390/pai: cleanup event initialization
Date: Mon,  8 Apr 2024 14:58:11 +0200
Message-ID: <20240408125312.616073754@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1ac74333a78dc..270255acacb02 100644
--- a/arch/s390/kernel/perf_pai_crypto.c
+++ b/arch/s390/kernel/perf_pai_crypto.c
@@ -210,12 +210,6 @@ static int paicrypt_event_init(struct perf_event *event)
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
@@ -249,6 +243,11 @@ static void paicrypt_start(struct perf_event *event, int flags)
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
index ac32107167eac..8fddde11cfb1f 100644
--- a/arch/s390/kernel/perf_pai_ext.c
+++ b/arch/s390/kernel/perf_pai_ext.c
@@ -261,7 +261,6 @@ static int paiext_event_init(struct perf_event *event)
 	rc = paiext_alloc(a, event);
 	if (rc)
 		return rc;
-	event->hw.last_tag = 0;
 	event->destroy = paiext_event_destroy;
 
 	if (a->sample_period) {
-- 
2.43.0



