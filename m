Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1321C8621;
	Tue, 12 Aug 2025 18:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021694; cv=none; b=Z9fU364ZxDpM3PfJ0hYUGbbiz1PRyZYqP6wLjK3sK/OM1/92RtkIiX42pUk9JGx6lOCsDaR6w1LZIkATxqVKxmPagt4yydqUYfRmeqs7kXV8j+xnERrPj2q4enviP+d9AACgt476d5g3Kyt/1qgvuyB1E7bIqoODc000ZdZ727w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021694; c=relaxed/simple;
	bh=WQzn+u5HlIIaYxmoBov+wYSg1UUafnoMp9feVJMbpg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peUNaZ6RsEd1Bg5rkdeBNTNFPrRMBKlp7TSSKEOFH6WjO9IFZBheMFXxO3qQWtT+IPWfQCZgAeXtakM/oVsYr93kReneTJM18LGBjUPn0r5F3LlrCX6MCxbu0B2QElTiwx4qPpykE3HdeK2NsiubRIqWfS9T6AVOe56JDZ5thiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaabmPki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaabmPki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FB0C4CEF0;
	Tue, 12 Aug 2025 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021694;
	bh=WQzn+u5HlIIaYxmoBov+wYSg1UUafnoMp9feVJMbpg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HaabmPkiFX4iikGQcTVmAQyC/pIX5DszDW99PCiotB/AWztkPCeNjcM0VE0IACMm7
	 orBB2dLORqEaH3WPfsiTt90Z5+O2Dlr7yJmOGIxyrBubDSaX16nirZFFuzSYz3PQLZ
	 9rpFN7qt1bwLfnGI1AYyOdkJqMDFQyayKiZxtkoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Beata Michalska <beata.michalska@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/262] sched/psi: Fix psi_seq initialization
Date: Tue, 12 Aug 2025 19:29:38 +0200
Message-ID: <20250812173001.221535001@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 99b773d720aeea1ef2170dce5fcfa80649e26b78 ]

With the seqcount moved out of the group into a global psi_seq,
re-initializing the seqcount on group creation is causing seqcount
corruption.

Fixes: 570c8efd5eb7 ("sched/psi: Optimize psi_group_change() cpu_clock() usage")
Reported-by: Chris Mason <clm@meta.com>
Suggested-by: Beata Michalska <beata.michalska@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/psi.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 837b065749ce..08a9a9f909d5 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -172,7 +172,7 @@ struct psi_group psi_system = {
 	.pcpu = &system_group_pcpu,
 };
 
-static DEFINE_PER_CPU(seqcount_t, psi_seq);
+static DEFINE_PER_CPU(seqcount_t, psi_seq) = SEQCNT_ZERO(psi_seq);
 
 static inline void psi_write_begin(int cpu)
 {
@@ -200,11 +200,7 @@ static void poll_timer_fn(struct timer_list *t);
 
 static void group_init(struct psi_group *group)
 {
-	int cpu;
-
 	group->enabled = true;
-	for_each_possible_cpu(cpu)
-		seqcount_init(per_cpu_ptr(&psi_seq, cpu));
 	group->avg_last_update = sched_clock();
 	group->avg_next_update = group->avg_last_update + psi_period;
 	mutex_init(&group->avgs_lock);
-- 
2.39.5



