Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0CF5285043;
	Tue, 12 Aug 2025 19:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025834; cv=none; b=Ygcdmf9g+HbuA+AI754+xSvuhzYtR2/EgI62vBFG1PGqI51PwOITCBJrYL/kVF6LxyleAU5Fm0doQmna+KkCBooYmSRdE8ywntYueRbRQ3j2GR5OSwkKAsSBTh/Kw3gyGdon1ltNhy3VD4qz2N03HLv/bnyzJFCawh4C1OAljH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025834; c=relaxed/simple;
	bh=mjYvJafi0/Bd/k3e1dEYLV2nguBfvKlEQuDPwJU6waA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E9pdcy5/v1EdOZRcPwGRbZdPq8JbuHVYBZZYBsZ7WLogjKXyS787LSebiDQ4kIPHy+Dd3Bd+kRDpK0AiJr+shX9v+DyylS8oWgkt6V/1dVhY0que/byaw2qGqQnUFkJhI7SJoTGJVZsRt2qsXqv5Dr+gd8Od/FJXt0U9QDc8Gms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RRpL4olb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RRpL4olb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D272C4CEF0;
	Tue, 12 Aug 2025 19:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025833;
	bh=mjYvJafi0/Bd/k3e1dEYLV2nguBfvKlEQuDPwJU6waA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RRpL4olbN+srdadtVNWw+I1m/s+9lbAfbajQrthsLcqRpVKoo8dHbQzb+CRQivnAS
	 y4qll947hJIUVxn4Qp53Gcpqp+1Lv1vkpjFbqFT9XkJnhrUrDfNgcgSLyIfQya/ijM
	 Bv+wWwSJBAOIc/INNKF8nTZiphOFENhz96JuOE1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcel Ziswiler <marcel.ziswiler@codethink.co.uk>,
	Juri Lelli <juri.lelli@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 158/480] sched/deadline: Reset extra_bw to max_bw when clearing root domains
Date: Tue, 12 Aug 2025 19:46:06 +0200
Message-ID: <20250812174404.037999753@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juri Lelli <juri.lelli@redhat.com>

[ Upstream commit fcc9276c4d331cd1fe9319d793e80b02e09727f5 ]

dl_clear_root_domain() doesn't take into account the fact that per-rq
extra_bw variables retain values computed before root domain changes,
resulting in broken accounting.

Fix it by resetting extra_bw to max_bw before restoring back dl-servers
contributions.

Fixes: 2ff899e351643 ("sched/deadline: Rebuild root domain accounting after every update")
Reported-by: Marcel Ziswiler <marcel.ziswiler@codethink.co.uk>
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Marcel Ziswiler <marcel.ziswiler@codethink.co.uk> # nuc & rock5b
Link: https://lore.kernel.org/r/20250627115118.438797-3-juri.lelli@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/deadline.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index ef5b5c045769..135580a41e14 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -3007,7 +3007,14 @@ void dl_clear_root_domain(struct root_domain *rd)
 	int i;
 
 	guard(raw_spinlock_irqsave)(&rd->dl_bw.lock);
+
+	/*
+	 * Reset total_bw to zero and extra_bw to max_bw so that next
+	 * loop will add dl-servers contributions back properly,
+	 */
 	rd->dl_bw.total_bw = 0;
+	for_each_cpu(i, rd->span)
+		cpu_rq(i)->dl.extra_bw = cpu_rq(i)->dl.max_bw;
 
 	/*
 	 * dl_servers are not tasks. Since dl_add_task_root_domain ignores
-- 
2.39.5



