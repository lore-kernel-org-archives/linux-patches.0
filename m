Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB784CF461;
	Sat, 17 Oct 2026 18:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260372; cv=none; b=sFpm3Q/EvX+DCXKZnVWuh3WPHAbsPvphzfFy+YWD2k/B0V5BBCKs3pwrtSURaFFHTbZMnaLIV/kL1K3feyZVRSnxKtEpCkhUgPCMzHOJwUkAa9w8Ea/KUX4MAJaNBTK59yNXfm5MWREzaN9kwc99k940dbiWuJnXKfW0IvNGEAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260372; c=relaxed/simple;
	bh=Sxva5zWc5UCYCmPM18Cpfq0Mlpof1Y/7m0PKJMH/lU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CVW/HYIY+cxq+HyyZbn9sNbsOiWPhCkFN4Rmfo7I+zTS22mwrFBaBan65Hslm3Q0DxST6+2g7dplTfaXsoRyd7IZvU7cfWK7u+vUz8C9rHoNt80XcbFVZQjYSYgm1iA/OdUg9q02S0bJKs7YustbZr2TyqJJ3hmSTLP7rbGPhCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsRgUboT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsRgUboT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B4D1F000C4;
	Sat, 17 Oct 2026 18:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260371;
	bh=m/h+xCZNB3KVvcHAc+oCmuOdt/uea+aHHzWt6f7ITL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xsRgUboTayDt34VO6KzJNJYfoidBA5LTntAIKtdh4sPF02wwu5i6ZG1wZD88JqIB2
	 K3AhsWSSjScpbEd/yHy14QgV7YZCH2pCED93iTyFJPLmk688koBm8+PLF9wPiEiAKs
	 4iJVCotjDipjTOvvoiSDp0NN/uhp5LOCpH3i7xcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jia Jie <jiajie.lee@starlabs.sg>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1523/1674] perf: Fix addr_filter_ranges lifetime
Date: Sat, 17 Oct 2026 18:03:15 +0200
Message-ID: <20261017160510.212515605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit e62d4192e593630f355094adc467058a05bdc935 ]

Lee Jia Jie reported that since event::addr_filter_ranges is used
under RCU, it should be RCU freed.

Reported-by: Lee Jia Jie <jiajie.lee@starlabs.sg>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ad0e04e3e5777..a226f908490f0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5022,6 +5022,7 @@ static void free_event_rcu(struct rcu_head *head)
 	if (event->ns)
 		put_pid_ns(event->ns);
 	perf_event_free_filter(event);
+	kfree(event->addr_filter_ranges);
 	kmem_cache_free(perf_event_cache, event);
 }
 
@@ -5257,7 +5258,6 @@ static void _free_event(struct perf_event *event)
 
 	perf_event_free_bpf_prog(event);
 	perf_addr_filters_splice(event, NULL);
-	kfree(event->addr_filter_ranges);
 
 	if (event->destroy)
 		event->destroy(event);
@@ -12276,8 +12276,6 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 			put_callchain_buffers();
 	}
 err_addr_filters:
-	kfree(event->addr_filter_ranges);
-
 err_per_task:
 	exclusive_event_destroy(event);
 
-- 
2.53.0



