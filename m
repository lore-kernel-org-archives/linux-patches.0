Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 636F3267F6D;
	Tue,  8 Apr 2025 11:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110396; cv=none; b=nLPOCj4/Khp28I/RyxD9Fqcdsn/2HBjBrY7Ci9Hj/OaF1SmKmI/8PJGyJ/51WWGBi1kdI5KmG+fVQTdk4IzaDIoxiHasEYliVRytpCHklp3NQQhWOUjo9OQfnRAX6Uhu4WeonSJxuat+JuYuZpkgn/wb3g5X+Wf7owT3EF4fs18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110396; c=relaxed/simple;
	bh=QgoHrLMPnn3N2IJZqxcn0+X5rMMf/f7lZGgkYf2g0k8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LNO+sO/FlCVBWE/3WJf4hNviRr3Om1y7NW4osjKFo0seF4rRCNV3oUkUY2PEmgWuYBNDUMVWHrGnJn5WiXIQGWwbIE3K0Lv/xOu/jwlGQUIqE+TLTi0dYGxcUZnVhCBYVTycwAYr4FTZjACOQurG70/okx7jvtjt7gf1wl5OnVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PeNNkSJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PeNNkSJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E603CC4CEE5;
	Tue,  8 Apr 2025 11:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110396;
	bh=QgoHrLMPnn3N2IJZqxcn0+X5rMMf/f7lZGgkYf2g0k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeNNkSJkmgHTMdR3nNuSecZIR28uF1UbsFOfORH2PEzrjH1ectLZHOLMost5O/D+1
	 wWZpNW/dmYONCg62cDc1RO/ec9MnU2x6nbeXdznZjDC+bvtqOOOJt0JgQ1LA6e/JC2
	 Jtm4nKOwK05WTK1HG8f0TS1HAiMkixWoljMKbv4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 049/731] sched/deadline: Ignore special tasks when rebuilding domains
Date: Tue,  8 Apr 2025 12:39:06 +0200
Message-ID: <20250408104915.417065902@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit f6147af176eaa4027b692fdbb1a0a60dfaa1e9b6 ]

SCHED_DEADLINE special tasks get a fake bandwidth that is only used to
make sure sleeping and priority inheritance 'work', but it is ignored
for runtime enforcement and admission control.

Be consistent with it also when rebuilding root domains.

Fixes: 53916d5fd3c0 ("sched/deadline: Check bandwidth overflow earlier for hotplug")
Reported-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Valentin Schneider <vschneid@redhat.com>
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Tested-by: Waiman Long <longman@redhat.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Tested-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Link: https://lore.kernel.org/r/20250313170011.357208-2-juri.lelli@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ff4df16b5186d..1a041c1fc0d1e 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2956,7 +2956,7 @@ void dl_add_task_root_domain(struct task_struct *p)
 	struct dl_bw *dl_b;
 
 	raw_spin_lock_irqsave(&p->pi_lock, rf.flags);
-	if (!dl_task(p)) {
+	if (!dl_task(p) || dl_entity_is_special(&p->dl)) {
 		raw_spin_unlock_irqrestore(&p->pi_lock, rf.flags);
 		return;
 	}
-- 
2.39.5



